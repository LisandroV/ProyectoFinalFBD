#!/bin/bash
#crea o resetea (elimina y crea) la base de datos
psql -U "postgres" -f ../sql/DDL.sql
psql -U "postgres" -d asoc_taxis -f ../sql/actualiza_viajes.sql
psql -U "postgres" -d asoc_taxis -f ../sql/funciones_pos.sql

#hace los copy para cada tabla
psql -U "postgres" -d asoc_taxis -c "\copy Direccion(estado,delegacion,calle,numero,cp) FROM '$PWD/../listas/direccion.csv' DELIMITER ',' CSV HEADER;"
psql -U "postgres" -d asoc_taxis -c "\copy Chofer FROM '$PWD/../listas/choferes.csv' DELIMITER ',' CSV HEADER;"
psql -U "postgres" -d asoc_taxis -c "\copy Cliente(id_direccion,nombre,paterno,materno,telefono_de_casa,celular,email,num_viajes,hora_entrada,hora_salida,foto,facultad,instituto,unidad) FROM '$PWD/../listas/clientes.csv' DELIMITER ',' CSV HEADER;"
psql -U "postgres" -d asoc_taxis -c "\copy aseguradora(id_direccion,razon_social,email,telefono,tipo_de_seguro,que_cubre) FROM '$PWD/../listas/seguros.csv' DELIMITER ',' CSV HEADER;"
psql -U "postgres" -d asoc_taxis -c "\copy vehiculo(rfc,id_aseguradora,numero_de_pasajeros,marca,modelo,año_vehiculo,llantas_refaccion,estandar_o_automatico,num_cilindros,capacidad_tanque,gasolina_o_hibrido,num_puertas,fecha_de_alta,fecha_de_baja,razon_de_baja) FROM '$PWD/../listas/vehiculo.csv' DELIMITER ',' CSV HEADER;"
psql -U "postgres" -d asoc_taxis -c "\copy viaje(num_licencia,numero_economico,dentro_CU,fecha,tiempo,distancia) FROM '$PWD/../listas/viajes.csv' DELIMITER ',' CSV HEADER;"
psql -U "postgres" -d asoc_taxis -c "\copy Solicitar(id_cliente,id_viaje,origen,destino,cargo) FROM '$PWD/../listas/solicitar.csv' DELIMITER ',' CSV HEADER;"
psql -U "postgres" -d asoc_taxis -c "\copy Manejar FROM '$PWD/../listas/maneja.csv' DELIMITER ',' CSV HEADER;"
psql -U "postgres" -d asoc_taxis -c "\copy infraccion(num_licencia,numero_economico,monto_a_pagar,placa_del_agente,lugar,hora,razon) FROM '$PWD/../listas/infracciones.csv' DELIMITER ',' CSV HEADER;"

psql -U "postgres" -d asoc_taxis -f ../sql/despues_de_poblar.sql
