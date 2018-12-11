DROP DATABASE IF EXISTS asoc_taxis;
CREATE DATABASE asoc_taxis;

\c asoc_taxis;

CREATE TABLE Chofer (
    num_licencia VARCHAR (9),
    nombre VARCHAR (30),
    paterno VARCHAR (30),
    materno VARCHAR (30),
    email VARCHAR (254),
    f_ingreso TIMESTAMP,
    foto BYTEA,
    es_dueño BOOLEAN,
    rfc CHARACTER (13),
    CONSTRAINT pk_chofer PRIMARY KEY (num_licencia)
);


CREATE TABLE Celular (
    numero DECIMAL (10),
    licencia DECIMAL(2) NOT NULL,
    CONSTRAINT pk_dist PRIMARY KEY (numero));
