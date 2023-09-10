CREATE OR REPLACE FUNCTION apagar_produto () RETURNS TRIGGER
$$
begin
    if NEW.id = 0 THEN

        DELETE from produto WHERE id = NEW.id;

END IF;

    if NEW.quantity = 0 THEN

         DELETE  from estoque WHERE quantity=NEW.quantity;

END IF;

    RETURNS NEW;

END;
$$

LANGUAGE Plpgsql;
CREATE TRIGGER apaga_Product AFTER UPDATE ON stock 
    FOR EACH ROW EXECUTE PROCEDURE apagar_produto(); 



--2----------------------------- 
CREATE OR REPLACE FUNCTION armazena_dados()
RETURN TRIGGER AS $$
BEGIN
    insert into control_medica values (current_date, current_user, new.eid);
    return new;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_armazena_dados after update on stock for EACH ROW EXECUTE PROCEDURE armazena_dados();
