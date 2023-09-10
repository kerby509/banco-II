CREATE OR REPLACE FUNCTION  apaga_Product()
RETURNS TRIGGER
AS 
$$

BEGIN

if NEW.eid =0 THEN

    DELETE eid from product WHERE eid = NEW.eid;

if(SELECT eid FROM product ) <= ('0') THEN
    DELETE FROM product WHERE eid=0;

END IF;
if NEW.quantity = 0 THEN
DELETE FROM stock WHERE quantity = NEW.quantity ;

if(SELECT quantity FROM stock) <=('0') THEN
    DELETE FROM stock WHERE quantity =0;

END IF;

 RETURN NEW;


	
END;
$$ 

LANGUAGE plpgsql;

