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
CREATE TRIGGER validar_c BEFORE INSERT ON Cliente FOR EACH ROW EXECUTE PROCEDURE validar_email();
CREATE TRIGGER validar_c BEFORE INSERT ON Aseguradora FOR EACH ROW EXECUTE PROCEDURE validar_email();

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

--Funcion que valida que los datos insertados en viaje sean correctos
CREATE OR REPLACE FUNCTION valida_viaje() RETURNS TRIGGER AS $$
BEGIN
	IF new.distancia > 100 THEN
		RAISE EXCEPTION 'No se pueden hacer viajes de mas de 100km';
	END IF;
	RETURN null;
END;
$$ LANGUAGE plpgsql;

create trigger valida_viaje after insert or update on viaje
for each row execute procedure valida_viaje();
