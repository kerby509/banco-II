CREATE TABLE historico_salarios (
    id serial PRIMARY KEY,
    emp_id int NOT NULL,
    data_alteracao timestamp DEFAULT current_timestamp,
    usuario_alteracao varchar(255) NOT NULL,
    salario_antigo int NOT NULL,
    salario_novo int NOT NULL
);
