DROP DATABASE IF EXISTS asoc_taxis;
CREATE DATABASE asoc_taxis;

\c asoc_taxis;

CREATE TABLE Direccion (
id_direccion SERIAL,
estado VARCHAR (30) NOT NULL,
delegacion VARCHAR (30) NOT NULL,
calle VARCHAR (30) NOT NULL,
numero DECIMAL (10),
cp INTEGER,
CONSTRAINT pk_direccion PRIMARY KEY (id_direccion)
);

COMMENT ON TABLE Direccion IS 'Tabla que contiene la direccion de los choferes y dueños rgistrados';
COMMENT ON COLUMN Direccion.id_direccion IS 'Llave primaria de la tabla direccion';
COMMENT ON COLUMN Direccion.estado IS 'Estado donde se encutra la casa';
COMMENT ON COLUMN Direccion.delegacion IS 'Delegacion donde se encuentra la casa';
COMMENT ON COLUMN Direccion.calle IS 'Calle donde se encutra la casa';
COMMENT ON COLUMN Direccion.numero IS 'Numero de la casa';
COMMENT ON COLUMN Direccion.cp IS 'Codigo postal de la casa';

CREATE TABLE Chofer (
num_licencia VARCHAR (9),
id_direccion INTEGER,
nombre VARCHAR (30) NOT NULL,
paterno VARCHAR (30) NOT NULL,
materno VARCHAR (30) NOT NULL,
celular DECIMAL (10) NOT NULL,
email VARCHAR (254) NOT NULL,
f_ingreso TIMESTAMP NOT NULL,
foto BYTEA,
rfc CHARACTER (13) UNIQUE,
CONSTRAINT pk_chofer PRIMARY KEY (num_licencia),
CONSTRAINT FK1_chofer FOREIGN KEY (id_direccion) REFERENCES Direccion(id_direccion) ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE Chofer IS 'Tabla que contiene a todos los choferes y dueños rgistrados';
COMMENT ON COLUMN Chofer.num_licencia IS 'Numero de licencia de la persona';
COMMENT ON COLUMN Chofer.id_direccion IS 'Llave foranea que hace rferencia a la direccion de la persona';
COMMENT ON COLUMN Chofer.nombre IS 'Nombre de la persona';
COMMENT ON COLUMN Chofer.paterno IS 'Apellido paterno de la persona';
COMMENT ON COLUMN Chofer.materno IS 'Apellido materno de la persona';
COMMENT ON COLUMN Chofer.celular IS 'Celular de la persona';
COMMENT ON COLUMN Chofer.email IS 'email de la persona registrada';
COMMENT ON COLUMN Chofer.f_ingreso IS 'Fecha en la que se registro la persona';
COMMENT ON COLUMN Chofer.foto IS 'Foto de la persona';
COMMENT ON COLUMN Chofer.rfc IS 'Si acaso la persona es dueño se pone su rfc, en otro caso se deja como null';

CREATE TABLE Cliente (
id_cliente SERIAL,
id_direccion INTEGER,
nombre VARCHAR (30),
paterno VARCHAR (30),
materno VARCHAR (30),
telefono_de_casa DECIMAL (10),
celular DECIMAL (10),
email VARCHAR (254),
num_viajes DECIMAL(10),
hora_entrada time,
hora_salida time,
foto BYTEA,
facultad VARCHAR (50),
instituto VARCHAR (50),
unidad VARCHAR (50),
CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
CONSTRAINT FK1_cliente FOREIGN KEY (id_direccion) REFERENCES Direccion(id_direccion) ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE Cliente IS 'Tabla que contiene a todos los clientes registrados';
COMMENT ON COLUMN Cliente.id_cliente IS 'Llave primaria de la tabla cliente';
COMMENT ON COLUMN Cliente.id_direccion IS 'Llave foranea que hace referencia a la direccion del cliente';
COMMENT ON COLUMN Cliente.nombre IS 'Nombre del cliente';
COMMENT ON COLUMN Cliente.paterno IS 'Apellido paterno del cliente';
COMMENT ON COLUMN Cliente.materno IS 'Apellido materno del cliente';
COMMENT ON COLUMN Cliente.telefono_de_casa IS 'Telefono del cliente';
COMMENT ON COLUMN Cliente.celular IS 'celular del cliente';
COMMENT ON COLUMN Cliente.email IS 'email del cliente';
COMMENT ON COLUMN Cliente.num_viajes IS 'Numero total de viajes';
COMMENT ON COLUMN Cliente.hora_entrada IS 'Hora de entrada del cliente';
COMMENT ON COLUMN Cliente.hora_salida IS 'Hora de salida del cliente';
COMMENT ON COLUMN Cliente.foto IS 'Foto del cliente';
COMMENT ON COLUMN Cliente.facultad IS 'Si el cliente es un alumno se pone el dato,null en otro caso';
COMMENT ON COLUMN Cliente.instituto IS 'Si el cliente es un academico se pone el dato,null en otro caso';
COMMENT ON COLUMN Cliente.unidad IS 'Si el cliente es un tabajador se pone el dato,null en otro caso';


CREATE TABLE Aseguradora (
id_aseguradora SERIAL,
id_direccion INTEGER,
razon_social VARCHAR (50) NOT NULL,
email VARCHAR (254),
telefono DECIMAL (10),
tipo_de_seguro VARCHAR (245) NOT NULL,
que_cubre VARCHAR (245) NOT NULL,
CONSTRAINT pk_aseguradora PRIMARY KEY (id_aseguradora),
CONSTRAINT FK1_aseguradora FOREIGN KEY (id_direccion) REFERENCES Direccion(id_direccion) ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE Aseguradora IS 'Tabla que contiene a los seguros de cada vehiculo';
COMMENT ON COLUMN Aseguradora.id_aseguradora IS 'Llave primaria de la tabla aseguradora';
COMMENT ON COLUMN Aseguradora.id_direccion IS 'Llave foranea que hace referencia a la direccion de la aseguradora';
COMMENT ON COLUMN Aseguradora.razon_social IS 'Nombre de la aseguradora';
COMMENT ON COLUMN Aseguradora.email IS 'email de la aseguradora';
COMMENT ON COLUMN Aseguradora.telefono IS 'Telefono de la aseguradora';
COMMENT ON COLUMN Aseguradora.tipo_de_seguro IS 'Tipo del segro del carro';
COMMENT ON COLUMN Aseguradora.que_cubre IS 'Que cosa cubre el seguro';

CREATE TABLE Vehiculo (
numero_economico SERIAL,
rfc CHARACTER (13),
id_aseguradora INTEGER,
numero_de_pasajeros DECIMAL NOT NULL,
marca VARCHAR (30) NOT NULL,
modelo VARCHAR (30) NOT NULL,
año_vehiculo DECIMAL (5) NOT NULL,
llantas_refaccion BOOLEAN NOT NULL,
estandar_o_automatico CHAR(1) NOT NULL,
num_cilindros DECIMAL NOT NULL,
capacidad_tanque INTEGER NOT NULL,
gasolina_o_hibrido CHAR(1) NOT NULL,
num_puertas DECIMAL NOT NULL,
fecha_de_alta date NOT NULL,
fecha_de_baja date,
razon_de_baja varchar(50),
CONSTRAINT pk_vehiculo PRIMARY KEY (numero_economico),
CONSTRAINT fk1_vehiculo FOREIGN KEY (id_aseguradora) REFERENCES Aseguradora(id_aseguradora) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk2_vehiculo FOREIGN KEY (rfc) REFERENCES Chofer(rfc) ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE vehiculo IS 'Tabla que contiene a todos los vehiculos registrados';
COMMENT ON COLUMN vehiculo.numero_economico IS 'Llave primaria de la tabla vehiculo';
COMMENT ON COLUMN vehiculo.rfc IS 'Llave foranea que hace referencia al dueño del vehiculo';
COMMENT ON COLUMN vehiculo.id_aseguradora IS 'Llave foranea a la aseguradora que esta registrado el vehiculo';
COMMENT ON COLUMN vehiculo.numero_de_pasajeros IS 'Numero de pasajeros del vehiculo';
COMMENT ON COLUMN vehiculo.marca IS 'Marca del vehiculo';
COMMENT ON COLUMN vehiculo.modelo IS 'Modelo del vehiculo';
COMMENT ON COLUMN vehiculo.año_vehiculo IS 'Año del vehiculo';
COMMENT ON COLUMN vehiculo.llantas_refaccion IS 'True si acaso el carro tiene llantas de refaccion, False en otro caso';
COMMENT ON COLUMN vehiculo.estandar_o_automatico IS '"E" si acaso el carro es estandar, "A" si el carro es automatico';
COMMENT ON COLUMN vehiculo.num_cilindros IS 'Numero de cilindros del vehiculo';
COMMENT ON COLUMN vehiculo.capacidad_tanque IS 'Capacidad del tanque del vehiculo';
COMMENT ON COLUMN vehiculo.gasolina_o_hibrido IS '"G" si el carro usa gasolina, "H" si el carro es hibrido';
COMMENT ON COLUMN vehiculo.num_puertas IS 'Numero de puertas del vehiculo';
COMMENT ON COLUMN vehiculo.fecha_de_alta IS 'Fecha de alta del vehiculo';
COMMENT ON COLUMN vehiculo.fecha_de_baja IS 'Fecha de baja del vehiculo';
COMMENT ON COLUMN vehiculo.razon_de_baja IS 'Razon de baja del vehiculo';


CREATE TABLE Viaje (
id_viaje SERIAL,
num_licencia VARCHAR (9),
numero_economico INTEGER,
dentro_CU BOOLEAN NOT NULL,
fecha DATE NOT NULL,
tiempo INTERVAL,
distancia INTEGER NOT NULL,
costo INTEGER,
CONSTRAINT pk_viajes PRIMARY KEY (id_viaje),
CONSTRAINT fk1_viajes FOREIGN KEY (num_licencia) REFERENCES Chofer(num_licencia) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk2_viejes FOREIGN KEY (numero_economico) REFERENCES Vehiculo(numero_economico) ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE viajes IS 'Tabla que contiene a todos los viajes';
COMMENT ON COLUMN viajes.id_viaje IS 'Llave primaria de la tabla viajes';
COMMENT ON COLUMN viajes.num_licencia IS 'Numero de la licencia del chofer';
COMMENT ON COLUMN viajes.numero_economico IS 'Llave foranea que hace referencia al vehiculo';
COMMENT ON COLUMN viajes.dentro_CU IS 'True si el viaje fue dentro de CU, False en otro caso';
COMMENT ON COLUMN viajes.fecha IS 'Fecha en la que se realizo el viaje';
COMMENT ON COLUMN viajes.tiempo IS 'Duracion del viajes';
COMMENT ON COLUMN viajes.distancia IS 'Distancia en kilometros del viaje';
COMMENT ON COLUMN viajes.costo IS 'Costo del viaje';


CREATE TABLE Solicitar (
id_cliente INTEGER,
id_viaje INTEGER,
origen VARCHAR(50),
destino VARCHAR(50),
CONSTRAINT fk1_solicitar FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk2_solicitar FOREIGN KEY (id_viaje) REFERENCES viajes(id_viaje) ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE solicitar IS 'Tabla que contiene a todas las solicitudes de viaje';
COMMENT ON COLUMN solicitar.id_cliente IS 'Llave foranea que hace referencia al cliente que solicito el viaje';
COMMENT ON COLUMN solicitar.id_viaje IS 'Llave foranea que hace referencia al viaje';
COMMENT ON COLUMN solicitar.origen IS 'Lugar donde se solicito el viaje';
COMMENT ON COLUMN solicitar.destino IS 'Destino del viaje';

CREATE TABLE Manejar (
num_licencia VARCHAR (9),
numero_economico INTEGER,
CONSTRAINT fk1_maneja FOREIGN KEY (num_licencia) REFERENCES Chofer(num_licencia) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk2_maneja FOREIGN KEY (numero_economico) REFERENCES vehiculo(numero_economico) ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE maneja IS 'Tabla que contiene los choferes que manejan los carros';
COMMENT ON COLUMN maneja.num_licencia IS 'Llave foranea que hace referencia al chofer';
COMMENT ON COLUMN maneja.numero_economico IS 'Llave foranea que hace referencia al vehiculo';

CREATE TABLE Infraccion (
id_infraccion SERIAL,
num_licencia VARCHAR (9),
numero_economico INTEGER,
monto_a_pagar INTEGER,
placa_del_agente VARCHAR(20),
lugar VARCHAR(200),
hora DATE,
razon VARCHAR(200),
CONSTRAINT fk1_infracciones FOREIGN KEY (num_licencia) REFERENCES Chofer(num_licencia) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk2_infracciones FOREIGN KEY (numero_economico) REFERENCES vehiculo(numero_economico) ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE infracciones IS 'Tabla que contiene todas las infracciones puestas a un vehiculo';
COMMENT ON COLUMN infracciones.id_infraccion IS 'Llave primaria de la tabla infracciones';
COMMENT ON COLUMN infracciones.num_licencia IS 'Llave foranea que hace referencia al chofer que se le puso la infraccion';
COMMENT ON COLUMN infracciones.numero_economico IS 'Llave foranea que hace referencia al vehiculo que se le puso la infraccion';
COMMENT ON COLUMN infracciones.monto_a_pagar IS 'Cantidad a pagar por la infraccion';
COMMENT ON COLUMN infracciones.placa_del_agente IS 'Placa del agente que puso la infraccion';
COMMENT ON COLUMN infracciones.lugar IS 'Lugar donde se cometio la infraccion';
COMMENT ON COLUMN infracciones.hora IS 'Hora cuando se cometio la infraccion';
COMMENT ON COLUMN infracciones.razon IS 'Razon de la infraccion';

CREATE TABLE Llave(
id_cliente SERIAL,
id_viaje SERIAL,
id_infraccion SERIAL,
CONSTRAINT fk_llaveCliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_llaveViaje FOREIGN KEY (id_viaje) REFERENCES Viaje(id_viaje) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_llaveInfraccion FOREIGN KEY (id_infraccion) REFERENCES Infraccion(id_infraccion) ON DELETE RESTRICT ON UPDATE CASCADE
);
