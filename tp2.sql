CREATE TABLE control_de_compras (
    compras_data DATE NOT NULL,
    compras_usuario CHARACTER VARYING (50) NOT NULL,
    eid INTEGER NOT NULL
);
CREATE OR REPLACE FUNCTION armazenar()
RETURN TRIGGER AS $$
BEGIN
    insert into control_de_compras values (current_date, current_user, new.eid);
    return new;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_armazenar after update on stock for EACH ROW EXECUTE PROCEDURE armazenar();
    
