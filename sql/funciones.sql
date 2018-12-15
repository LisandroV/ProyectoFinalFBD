/*función: recibe el identificador de un viaje y regresa en una tabla el id de cada cliente,
    su nombre y el monto que tiene que pagar. para calcular el monto a pagar es necesario considerar
    las reglas de negocio del caso de uso definidas para el cobro del viaje
*/
DROP IF EXISTS FUNCTION regresa_CURP;

CREATE OR REPLACE FUNCTION cobro(viaje INTEGER) RETURNS SET OF "record" AS $$
    DECLARE r record;
    DECLARE journey INTEGER;
    DECLARE num_pasajeros INTEGER;
    BEGIN
        SELECT id_viaje FROM viajes WHERE id_viaje=viaje INTO elector;
        IF journey IS NOT NULL THEN
            SELECT COUNT(id_cliente)--se cuenta el numero de pasajeros en el viaje en num_pasajeros
                FROM solicitar
                WHERE id_viaje=viaje
                GROUP BY id_viaje
                INTO num_pasajeros;
            for r in SELECT id_cliente FROM solicitar WHERE id_viaje = viaje
                LOOP
                    
                    return next r;
                END LOOP;
            RETURN n_oper;
        ELSE
            RAISE EXCEPTION 'No existe el viaje #%', viaje;
        END IF;
    END;
$$ LANGUAGE plpgsql;


para cada cliente:
