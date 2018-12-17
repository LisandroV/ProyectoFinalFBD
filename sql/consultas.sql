--Número de choferes que son dueños de su propio vehículo
SELECT num_licencia choferes, rfc rfc_chofer, numero_economico vehiculos
FROM Chofer NATURAL JOIN Manejar
WHERE rfc IS NOT NULL;

--Promedio de personas que están en un mismo viaje
SELECT AVG(pasajeros) prom_personas_x_viaje
FROM (SELECT id_viaje, COUNT(id_viaje) pasajeros
FROM Solicitar
GROUP BY id_viaje) AS num_pasajeros;

--Vehículo con el mayor número de infracciones
SELECT numero_economico, rfc, id_aseguradora, fecha_de_alta
FROM (SELECT numero_economico, COUNT(numero_economico) infracc
FROM Infraccion
GROUP BY numero_economico) AS infracciones NATURAL JOIN Vehiculo 
ORDER BY infracc DESC
LIMIT 1;

--Número de viajes realizados en cada mes de diciembre de los últimos dos años

SELECT 2018 anio, COUNT(id_viaje) viajes_en_diciembre
FROM Viaje
WHERE (fecha >= '2018/12/01') AND (fecha <= '2018/12/31')
UNION 
SELECT 2017,COUNT(id_viaje) 
FROM Viaje
WHERE (fecha >= '2017/12/01') AND (fecha <= '2017/12/31');

--Motivo por el cuál se cometen más infracciones de todos los conductores multados
SELECT razon AS razon_mas_comun
FROM 
(SELECT razon, COUNT(razon) ocurrencias
FROM Infraccion
GROUP BY razon) AS razones
GROUP BY razon, ocurrencias
HAVING ocurrencias = (SELECT MAX(ocurrencias) FROM (SELECT razon, COUNT(razon) ocurrencias
FROM Infraccion
GROUP BY razon) AS razones);

--Cantidad de gente que ha usado este servicio, agrupandola por tipo de cliente
SELECT tipo_cliente(id_cliente),COUNT(id_cliente) num_clientes
FROM Cliente
GROUP BY tipo_cliente(id_cliente);

--Ganancias totales del año 2018
SELECT SUM(cargo) ganancias_totales_2018
FROM Solicitar NATURAL JOIN Viaje
WHERE (EXTRACT(year FROM fecha))= 2018;

--Número de vehículos dados de baja agrupados por año
SELECT (EXTRACT (year FROM fecha_de_baja)) año, COUNT(numero_economico) bajas
FROM (SELECT * FROM Vehiculo WHERE fecha_de_baja IS NOT NULL) AS inactivos
GROUP BY (EXTRACT (year FROM fecha_de_baja));

--Regresa los 5 vehículos más viejos de la flotilla
SELECT numero_economico, rfc rfc_dueño, fecha_de_alta
FROM Vehiculo
ORDER BY año_vehiculo ASC
LIMIT 5;

--Información de los clientes a los que se les aplicará tarifa de cliente frecuente en su siguiente viaje
SELECT id_cliente, id_direccion, num_viajes
FROM Cliente
WHERE num_viajes % 5 = 0;

--Aseguradora en la que están registrados la mayoría de los vehículos
SELECT id_aseguradora, razon_social, tipo_de_seguro
FROM
(SELECT id_aseguradora, COUNT(numero_economico) asegurados
FROM Vehiculo
GROUP BY id_aseguradora) seguros NATURAL JOIN Aseguradora
ORDER BY asegurados DESC
LIMIT 1;

--Distancia promedio recorrida en los viajes fuera de Ciudad Universitaria
SELECT AVG(distancia) distancia_promedio
FROM Viaje
WHERE dentro_CU = FALSE;

--Choferes que conducen más de dos vehículos
SELECT num_licencia,COUNT(numero_economico) vehículos_conducidos
FROM Manejar
GROUP BY num_licencia
HAVING COUNT(numero_economico) > 2;

--Historial del cliente que ha utilizado más la aplicación 
SELECT *
FROM Solicitar NATURAL JOIN (SELECT id_cliente
FROM Solicitar
GROUP BY id_cliente
ORDER BY COUNT(id_viaje) DESC
LIMIT 1) AS mejor_cliente;

--Cantidad de hombres y cantidad de mujeres que son dueños de vehículos en la aplicación
SELECT RIGHT(rfc,1) genero, COUNT(rfc) cantidad
FROM Chofer
WHERE RIGHT(rfc,1) = 'M'
GROUP BY RIGHT(rfc,1)
UNION
SELECT RIGHT(rfc,1) genero, COUNT(rfc) cantidad
FROM Chofer
WHERE RIGHT(rfc,1) = 'H'
GROUP BY RIGHT(rfc,1);
