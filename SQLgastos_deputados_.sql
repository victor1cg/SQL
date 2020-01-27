/*
1)Quanto cada deputado gastou de 2016 a 2018, separado por ano?
2)Qual é o valor médio da nota fiscal de cada deputado, para cada
categoria de despesa, de 2016 a 2018?
3)No ano de 2019, qual mês teve maior gasto? E por categoria e mês?
4)Quais os cinco CPFs ou CNPJs que mais receberam valores em 2019?
*/

-- 1)
SELECT 	nm_deputado as NOME 
		,nr_ano     AS ANO   
		,sum(nr_valor) AS VALOR_TOTAL_GASTO
FROM gastos
WHERE ANO IN(2016,2017,2018)
group by nm_deputado,nr_ano
order by NOME,ANO

--2)
SELECT 	nm_deputado as NOME 
		,tp_categoria  AS CATEGORIA   
		,avg(nr_valor) AS VALOR_MEDIO_GASTO
FROM gastos
WHERE nr_ano(2016,2017,2018)
group by nm_deputado,CATEGORIA
order by NOME,CATEGORIA

--3/1) categoria
SELECT 	nr_mes as MES
		,sum(nr_valor) as VALOR_TOTAL_GASTO
from gastos
where nr_ano = 2019
group by nr_mes
order by VALOR_TOTAL_GASTO DESC

--3/2) categoria e mes
SELECT 	tp_categoria as CATEGORIA
		,nr_mes as MES
		,sum(nr_valor) as VALOR_TOTAL_GASTO
from gastos
where nr_ano = 2019
group by CATEGORIA,MES
order by CATEGORIA,MES

--4)
SELECT 	nr_cnpj 		AS CNPJ
		,nm_deputado	AS NOME
		,sum(nr_valor) 	AS VALOR_TOTAL_GASTO
FROM gastos 
WHERE nr_ano= 2019
GROUP BY CNPJ
ORDER BY VALOR_TOTAL_GASTO DESC LIMIT 5
