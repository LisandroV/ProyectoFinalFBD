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

--Triggers para validar los correos en las tabla Chofer, Cliente y Aseguradora
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

--Trigger que aplica la funcion valida_vehiculo en la tabla vehiculo
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

--Trigger que aplica la funcion valida_viaje en la tabla viaje
create trigger valida_viaje after insert or update on viaje
for each row execute procedure valida_viaje();


--Funcion que regresa el id de la direccion depues de agrega la tupla en la tabla direccion
CREATE OR REPLACE FUNCTION inserta_direccion(estad VARCHAR(30), delegacio VARCHAR(30), cal varchar(30),numer DECIMAL(10),c INTEGER) RETURNS INTEGER AS $$
DECLARE
	mi_id INTEGER;
BEGIN
	INSERT INTO direccion (estado,delegacion,calle,numero,cp) values(estad,delegacio,cal,numer,c) returning id_direccion into mi_id;
return mi_id;
END;
$$ LANGUAGE plpgsql;

--Funcion que recibe los datos de chofer y de viaje para en primer lugar
--aplicar la funcion inserta_direccion() y despues insertar la tupla chofer en la tabla chofer con el nuevo
--id direccion
CREATE OR REPLACE FUNCTION inserta_chofer(lic VARCHAR(9),nom varchar(30),pat varchar(30),
										  mat varchar(30),cel DECIMAL(10),email varchar(254),f_ingreso timestamp,
										 foto varchar(1000),rfc CHARACTER(13),
										 estad VARCHAR(30), delegacio VARCHAR(30), cal varchar(30),numer DECIMAL(10),c INTEGER) RETURNS varchar AS $$
DECLARE
	id_direccion INTEGER;
	lol varchar;
BEGIN
	select inserta_direccion(estad,delegacio,cal,numer,c) into id_direccion;
	INSERT INTO chofer values (lic,id_direccion,nom,pat,mat,cel,email,f_ingreso,foto,rfc) returning lic into lol;
return lol;
END;
$$ LANGUAGE plpgsql;

--Funcion que recibe los datos de cliente y de viaje para en primer lugar
--aplicar la funcion inserta_direccion() y despues insertar la tupla cliente en la tabla cliente con el nuevo
--id direccion
CREATE OR REPLACE FUNCTION inserta_cliente(nom varchar(30),pat varchar(30),
										  mat varchar(30),tel DECIMAL(10),cel DECIMAL(10),email varchar(254),num_vi DECIMAL(10),
										 ent time,sal time,foto varchar(1000),fac varchar(500),
										 ins VARCHAR(500), un VARCHAR(500),
										  estad VARCHAR(30), delegacio VARCHAR(30), cal varchar(30),numer DECIMAL(10),c INTEGER) RETURNS varchar AS $$
DECLARE
	id_direccion INTEGER;
	lol varchar;
BEGIN
	select inserta_direccion(estad,delegacio,cal,numer,c) into id_direccion;
	INSERT INTO cliente values (default,id_direccion,nom,pat,mat,tel,cel,email,num_vi,ent,sal,foto,fac,ins,un) returning nom into lol;
return lol;
END;
$$ LANGUAGE plpgsql;
