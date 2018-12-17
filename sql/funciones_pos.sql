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

--Funcion que valida que los datos insertados en vehiculo sean correctos
CREATE OR REPLACE FUNCTION valida_vehiculo() RETURNS TRIGGER AS $$
BEGIN
	IF new.numero_de_pasajeros NOT IN (1,2,3,4,5,6) THEN
		RAISE EXCEPTION 'No se pueden meter mas de 6 pasajeros'
		USING HINT = 'Solo se pueden llevar de 1 a 6 pasajeros';
	END IF;
	IF new.año_vehiculo > 2019 THEN
		RAISE EXCEPTION 'No se puede tener un auto de ese año';
	END IF;
	IF new.estandar_o_automatico NOT IN ('E','A') THEN
		RAISE EXCEPTION 'Cracter no valido'
		USING HINT = 'Solo se puede poner "E" para esandar y "A" para automatico';
	END IF;
	IF new.num_cilindros > 8 THEN
		RAISE EXCEPTION 'No se pueden tener mas de 8 cilindros';
	END IF;
	IF new.capacidad_tanque > 120 THEN
		RAISE EXCEPTION 'No se pueden tener mas de 120 de capacidad';
	END IF;
	IF new.gasolina_o_hibrido NOT IN ('G','H') THEN
		RAISE EXCEPTION 'Caracter no valido'
		USING HINT = '"G" para gasolina y "H" para hibrido';
	END IF;
	IF new.num_puertas > 5 or new.num_puertas < 2 THEN
		RAISE EXCEPTION 'No se pueden tener mas de 6 puertas y menos de 2'
		USING HINT = '2 a 5 puertas';
	END IF;
	RETURN null;
END;
$$ LANGUAGE plpgsql;

create trigger valida_vehiculo after insert or update on vehiculo
for each row execute procedure valida_vehiculo();
