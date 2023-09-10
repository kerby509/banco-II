CREATE TABLE historico_salarios (
    id serial PRIMARY KEY,
    emp_id int NOT NULL,
    data_alteracao timestamp DEFAULT current_timestamp,
    usuario_alteracao varchar(255) NOT NULL,
    salario_antigo int NOT NULL,
    salario_novo int NOT NULL
);

CREATE OR REPLACE FUNCTION registrar_historico_salario()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.salario <> NEW.salario THEN
        INSERT INTO historico_salarios (emp_id, usuario_alteracao, salario_antigo, salario_novo)
        VALUES (NEW.emp_id, current_user, OLD.salario, NEW.salario);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER salario_alterado
AFTER UPDATE ON empregados
FOR EACH ROW
EXECUTE FUNCTION registrar_historico_salario();
