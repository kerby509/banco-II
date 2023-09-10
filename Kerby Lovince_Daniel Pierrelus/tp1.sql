CREATE OR REPLACE FUNCTION  apaga_Product()
RETURNS TRIGGER
AS 
$$

BEGIN

if NEW.eid = 0 THEN

    DELETE eid from product WHERE eid = NEW.eid;


END IF;

if NEW.quantity = 0 THEN
    DELETE FROM stock WHERE quantity = NEW.quantity ;

END IF;

 RETURN NEW;


	
END;
$$ 

LANGUAGE plpgsql;

CREATE TRIGGER apaga_Product AFTER UPDATE ON stock 
    FOR EACH ROW EXECUTE PROCEDURE apaga_Product();  

