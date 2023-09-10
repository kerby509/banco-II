-- // revisão sql
--1
SELECT e.nome AS nome_empregado,e.salario AS Salario_maior
FROM empregados e
JOIN empregados chefe ON e.supervisor_id = chefe.emp_id
WHERE e.salario > chefe.salario;
-- 2
select d1.nome, max(e1.salario) from empregados e1 join 
departamentos d1 on e1.emp_id=d1.dep_id group by d1.nome;
--1
-- Horas--
--Planning Time: 445.974 ms
 --Execution Time: 0.286 ms
--(10 rows)
--2)
--Planning Time: 0.329 ms
 --Execution Time: 0.196 ms
--(10 rows)




-- 3
SELECT * FROM programa_bolsa.departamentos;
SELECT d.dep_id,e.nome,e.salario from programa_bolsa.departamentos d join programa_bolsa.empregados e on 
d.dep_id= e.emp_id order by salario desc ;

-- 3
select d.dep_id, e.nome, max(salario) from departamentos d inner join
empregados e on d.dep_id=e.dep_id group by
 salario, d.dep_id,e.nome order by salario desc limit 4 ;
 
--  4
select d.nome ,count(e.nome) from departamentos d  join empregados e on d.dep_id=e.dep_id group by d.nome 
 order by count(e.nome) asc limit 3;

 --5
 SELECT 
    d.nome AS nome_departamento,
    COUNT(e.emp_id) AS numero_colaboradores
FROM 
    departamentos d
LEFT JOIN 
    empregados e ON d.dep_id = e.dep_id
GROUP BY 
    d.nome, d.dep_id
ORDER BY 
    d.dep_id;
 
 -- 6
select d.nome,count(e.nome) from departamentos d join
empregados e  on d.dep_id=e.dep_id  group by d.nome;

-- 7
select * from departamentos d where not exists(select e.emp_id from empregados e
 where d.dep_id=e.emp_id) ;
 

-- 8
select d.nome, sum(salario) as "salarios pagos" from departamentos d join
empregados e  on d.dep_id=e.dep_id group by d.nome  ;

--9
SELECT 
    d.dep_id,
    e.nome AS nome,
    e.salario AS salario,
    AVG(e.salario) AS media_salario
FROM 
    departamentos d
JOIN 
    empregados e ON d.dep_id = e.dep_id
GROUP BY 
    d.dep_id, e.nome, e.salario;



-- 10
 select e.emp_id,e.nome, d.dep_id,e.salario,AVG(e.salario) as "AVG" from departamentos d join
empregados e on d.dep_id= e.dep_id group by d.dep_id,e.emp_id,e.nome,e.salario ;

-- 11 

select e.nome, d.dep_id,e.salario,AVG(e.salario) as "AVG" from departamentos d join
empregados e on d.dep_id= e.dep_id group by d.dep_id,e.emp_id,e.nome,e.salario ;