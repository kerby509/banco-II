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

//----------------------------------------------------------------------------

CREATE TABLE historico_departamentos (
    id serial PRIMARY KEY,
    dep_id int NOT NULL,
    data_alteracao timestamp DEFAULT current_timestamp,
    usuario_alteracao varchar(255) NOT NULL,
    nome_antigo varchar(255) NOT NULL,
    nome_novo varchar(255) NOT NULL
);

CREATE OR REPLACE FUNCTION registrar_historico_departamento()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.nome <> NEW.nome THEN
        INSERT INTO historico_departamentos (dep_id, usuario_alteracao, nome_antigo, nome_novo)
        VALUES (NEW.dep_id, current_user, OLD.nome, NEW.nome);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER departamento_alterado
AFTER UPDATE ON departamentos
FOR EACH ROW
EXECUTE FUNCTION registrar_historico_departamento();

//3------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION verificar_salario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salario > (SELECT salario FROM empregados WHERE emp_id = NEW.supervisor_id) THEN
        RAISE EXCEPTION 'O salário não pode ser maior que o do chefe.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER salario_menor_que_chefe
BEFORE INSERT OR UPDATE ON empregados
FOR EACH ROW
EXECUTE FUNCTION verificar_salario();



CREATE TABLE total_salarios_departamento (
    dep_id int PRIMARY KEY,
    total_salario int
);


//------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION calcular_total_salario_departamento()
RETURNS TRIGGER AS $$
BEGIN
    -- 85 Calcula o total de salários para o departamento do novo empregado

    UPDATE total_salarios_departamento
    SET total_salario = (
        SELECT SUM(salario)
        FROM empregados
        WHERE dep_id = NEW.dep_id
    )
    WHERE dep_id = NEW.dep_id;

    -- Se o departamento não tiver um registro na tabela total_salarios_departamento, insira um novo

    IF NOT FOUND THEN
        INSERT INTO total_salarios_departamento (dep_id, total_salario)
        VALUES (NEW.dep_id, NEW.salario);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER atualizar_total_salario_departamento
AFTER INSERT OR UPDATE ON empregados
FOR EACH ROW
EXECUTE FUNCTION calcular_total_salario_departamento();
