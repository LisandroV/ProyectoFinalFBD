--Funcion que actualiza el numero de viajes de un cliente cada vez que se inserta una tupla en la tabla solicitar
create or replace function actualiza_viajes() returns trigger as $$
begin
if (TG_OP = 'INSERT') then
	update Cliente set num_viajes = num_viajes+1 where Cliente.id_cliente=new.id_cliente;
end if;
return null; end; $$ Language plpgsql;

--Trigger que ejecuta la funcion actualiza_viajes() en la tabla solicitar
create trigger actualiza_viajes after insert on solicitar
for each row execute procedure actualiza_viajes();
