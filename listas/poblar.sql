--Funcion que actualiza el numero de viajes de un cliente cada vez que se inserta una tupla en la tabla solicitar
create or replace function actualiaza_viajes() returns trigger as $$
begin
if (TG_OP = 'INSERT') then 
	update Cliente set num_viajes = num_viajes+1 where Cliente.id_cliente=new.id_cliente;
end if;
return null; end; $$ Language plpgsql;

create trigger actualiaza_viajes after insert on solicitar
for each row execute procedure actualiaza_viajes();

COPY Direccion(estado,delegacion,calle,numero,cp) FROM '/tmp/listas/direccion.csv' DELIMITER ',' CSV HEADER;
COPY Chofer FROM '/tmp/listas/choferes.csv' DELIMITER ',' CSV HEADER;
COPY Cliente(id_direccion,nombre,paterno,materno,telefono_de_casa,celular,email,num_viajes,hora_entrada,hora_salida,foto,facultad,instituto,unidad) FROM '/tmp/listas/clientes.csv' DELIMITER ',' CSV HEADER;
COPY aseguradora(id_direccion,razon_social,email,telefono,tipo_de_seguro,que_cubre) FROM '/tmp/listas/seguros.csv' DELIMITER ',' CSV HEADER;
COPY vehiculo(rfc,id_aseguradora,numero_de_pasajeros,marca,modelo,año_vehiculo,llantas_refaccion,estandar_o_automatico,num_cilindros,capacidad_tanque,gasolina_o_hibrido,num_puertas,fecha_de_alta,fecha_de_baja,razon_de_baja) FROM '/tmp/listas/vehiculo.csv' DELIMITER ',' CSV HEADER;
COPY viaje(num_licencia,numero_economico,dentro_CU,fecha,tiempo,distancia) FROM '/tmp/listas/viajes.csv' DELIMITER ',' CSV HEADER;
COPY Solicitar(id_cliente,id_viaje,origen,destino,cargo) FROM '/tmp/listas/solicitar.csv' DELIMITER ',' CSV HEADER;
COPY Manejar FROM '/tmp/listas/maneja.csv' DELIMITER ',' CSV HEADER;
COPY infraccion(num_licencia,numero_economico,monto_a_pagar,placa_del_agente,lugar,hora,razon) FROM '/tmp/listas/infracciones.csv' DELIMITER ',' CSV HEADER;