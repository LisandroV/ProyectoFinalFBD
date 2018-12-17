--Función que determina si una cadena representa a una email válido o no
CREATE OR REPLACE FUNCTION email_valido(cadena VARCHAR) RETURNS BOOLEAN AS $$
BEGIN
	RETURN textregexeq(cadena,'^[^@\s]+@[^@\s]+(\.[^@\s]+)+$');
END;
$$ LANGUAGE plpgsql;

--Trigger que valida un email que será introducido como dato de un chofer
CREATE OR REPLACE FUNCTION validar_email() RETURNS TRIGGER AS $$
BEGIN

IF email_valido(NEW.email) = FALSE THEN
	RAISE EXCEPTION 'Email no válido :(';
END IF;

RETURN NEW;

END; 
$$ LANGUAGE plpgsql;


CREATE TRIGGER validar_c BEFORE INSERT ON Chofer FOR EACH ROW EXECUTE PROCEDURE validar_email();


--Función que calcula el costo de un viaje dado su identificador y el cliente
CREATE OR REPLACE FUNCTION calcular_costo(num_viaje INTEGER, ident_cliente INTEGER) RETURNS DECIMAL AS $$
DECLARE
      dentro BOOLEAN;
      cant_viajes INTEGER;
      costo_total DECIMAL;
      kms DECIMAL;
BEGIN

	SELECT dentro_CU INTO dentro FROM Viaje WHERE Viaje.id_viaje = num_viaje;
	SELECT num_viajes INTO cant_viajes FROM Cliente WHERE id_cliente = ident_cliente;

	IF dentro = TRUE THEN --dentro CU
		IF cant_viajes % 5 = 0 THEN --viajero frecuente?
			costo_total = 10;
		ELSE
			costo_total = 15;
		END IF;
	ELSE --fuera CU
		SELECT distancia INTO kms FROM Viaje WHERE Viaje.id_viaje = num_viaje;
		IF cant_viajes % 5 = 0 THEN --viajero frecuente?
			costo_total = 15 + (kms * 6);
		ELSE
			costo_total = 15 + (kms * 8);
		END IF;
	END IF;

	costo_total = descuento(costo_total,num_viaje,ident_cliente);
	RETURN costo_total;
END;
$$ LANGUAGE plpgsql;

--Función auxiliar que hace los descuentos al costo actual
CREATE OR REPLACE FUNCTION descuento(costo DECIMAL, num_viaje INTEGER, cliente INTEGER) RETURNS DECIMAL AS $$
DECLARE
	tipo_cl VARCHAR := tipo_cliente(cliente);
	pasajeros INTEGER;
	descuento DECIMAL;
BEGIN
	IF tipo_cl = 'E' THEN
		costo = costo * 0.85;
	ELSE 
		costo = costo * 0.90;
	END IF;

	SELECT count(id_viaje) INTO pasajeros
	FROM Solicitar
	WHERE Solicitar.id_viaje = num_viaje;

	IF pasajeros > 1 THEN 
		descuento = 0.10 * (pasajeros -1);
		costo = costo - (costo * descuento);
	END IF;

	RETURN costo;

	
END;
$$ LANGUAGE plpgsql;

--Función auxiliar para conocer el tipo de cliente dado
CREATE OR REPLACE FUNCTION tipo_cliente(cl INTEGER) RETURNS VARCHAR AS $$
DECLARE
	tipo VARCHAR;
BEGIN
	IF (SELECT facultad FROM Cliente WHERE Cliente.id_cliente = cl) IS NULL THEN
		IF (SELECT instituto FROM Cliente WHERE Cliente.id_cliente = cl) IS NULL THEN
			tipo := 'T';
		ELSE
			tipo := 'A';
		END IF;
	ELSE
	 tipo := 'E';
	END IF;

	RETURN tipo;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION actualiza_cargo() RETURNS trigger as $$
BEGIN
	update solicitar set cargo = calcular_costo(id_viaje,id_cliente);
	return null;
END;
$$ 
LANGUAGE plpgsql;

create trigger actualiza_cargo after insert or delete on solicitar
for each row execute procedure actualiza_cargo();

insert into solicitar values(163,211,'8 Delaware','9 Larry Street',null);

--Método que obtiene la ganancia de un chofer de acuerda a una fecha de consulta
CREATE OR REPLACE FUNCTION obtener_ganancia(id_chofer VARCHAR, fecha_consulta DATE) RETURNS DECIMAL AS $$
DECLARE ganancia DECIMAL := 0;
	fecha_final DATE;
BEGIN

	IF fecha_consulta >= current_date THEN
		RAISE EXCEPTION 'fecha invalida';
	END IF;

	SELECT get_fecha_final(fecha_consulta) INTO fecha_final;
	SELECT ganancia + ganancia_viajes(id_chofer,fecha_consulta,fecha_final) INTO ganancia;
	SELECT ganancia + ganancia_mes(id_chofer,fecha_consulta, fecha_final) INTO ganancia;
	RETURN ganancia;

	
END;
$$ LANGUAGE plpgsql;

--Calcula el bono del 10% sobre el total de viajes realizados
CREATE OR REPLACE FUNCTION ganancia_mes(licencia VARCHAR, fecha_inicio DATE, fecha_final DATE)
RETURNS DECIMAL AS $$
DECLARE ganancia DECIMAL;
BEGIN
	SELECT costo * 0.10 INTO ganancia FROM 
	(SELECT id_viaje,dentro_CU, SUM(cargo) costo FROM
	(SELECT id_viaje,fecha,dentro_CU,cargo
	FROM Viaje NATURAL JOIN Solicitar
	WHERE num_licencia = licencia AND fecha >= fecha_inicio
			AND fecha <= fecha_final) AS tbl
	GROUP BY id_viaje, dentro_CU) AS tbl;
	RETURN ganancia;
END;
$$ LANGUAGE plpgsql;

--Calcula la ganancia por viaje de los realizados por el chofer
CREATE OR REPLACE FUNCTION ganancia_viajes(licencia VARCHAR, fecha_inicio DATE, fecha_final DATE, OUT ganancia DECIMAL) AS $$
BEGIN
	SELECT SUM(ganancia_viaje(tbl.costo, tbl.dentro_CU)) INTO ganancia FROM 
	(SELECT id_viaje,dentro_CU, SUM(cargo) costo FROM
	(SELECT id_viaje,fecha,dentro_CU,cargo
	FROM Viaje NATURAL JOIN Solicitar
	WHERE num_licencia = licencia AND fecha >= fecha_inicio
			AND fecha <= fecha_final) AS tbl
	GROUP BY id_viaje, dentro_CU) AS tbl;
END;
$$ LANGUAGE plpgsql;

--Regresa el día en que se va a terminar el mes de la fecha dada
DROP FUNCTION get_fecha_final(fecha DATE);
CREATE OR REPLACE FUNCTION get_fecha_final(fecha DATE) RETURNS DATE AS $$
DECLARE mes VARCHAR := EXTRACT (MONTH FROM fecha);
	año DECIMAL := EXTRACT (YEAR FROM fecha);
	dia_final DECIMAL;
	final DATE;
BEGIN
	IF char_length(mes) < 2 THEN
		mes := '0' || mes;
	END IF;
	
	IF (mes = '02') THEN
		IF (EXTRACT (YEAR FROM fecha))::int % 4 = 0 THEN
			dia_final = 29;
		ELSE 
			dia_final = 28;
		END IF;
	ELSE
		IF (mes = '01' OR mes = '03' 
			OR mes = '05' OR mes = '07'
			OR mes = '08' OR mes = '10'
			OR mes = '12') THEN
			dia_final = 31;
		ELSE
			dia_final = 30; 
		END IF;
	END IF;
	final := to_date(año || '-' || mes || '-' || dia_final, 'YYYY-MM-DD');

	RETURN final;
END;
$$ LANGUAGE plpgsql;

--Regresa el 8% o 12% del costo de un viaje dependiendo de si tuvo dentro o fuera de CU
CREATE OR REPLACE FUNCTION ganancia_viaje(precio DECIMAL, dentro BOOLEAN) RETURNS DECIMAL AS $$
BEGIN
	IF dentro = TRUE THEN
		RETURN precio * 0.08;
	ELSE
		RETURN precio * 0.12;
	END IF;
END;
$$ LANGUAGE plpgsql;