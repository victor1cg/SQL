### --- PRINT THE THIRD TRANSACTION OF EACH USER --

`with t1 as (
SELECT user_id ,
created_date,
row_number() OVER (
PARTITION by user_id ORDER by created_date) rn  -- CREATING A COLUMN OF ROWS
FROM transactions)
SELECT * from t1
WHERE t1.rn = 3 `

### --- HOW MANY COUNTRIES TRANSACTION AND DON'T --

`with t1 as (
SELECT t.user_id,u.id_country
from transactions t
JOIN users u
on t.user_id = u.id)
SELECT DISTINCT c.Country
from countries c
JOIN t1
on t1.id_country = c.id
WHERE EXISTS (SELECT * FROM users u WHERE t1.id_country =  c.id)`

### --- PRINT NAMES DONT HAS neighborhoods (EXISTS) --						
USANDO EXISTS						 

`SELECT n.name						
FROM neighborhoods AS n						
WHERE NOT EXISTS (SELECT * FROM users AS u 						
WHERE n.id = u.neighborhood_id) `						
						
 **SECOND WAY**

`SELECT n.name"						
from neighborhoods n						
LEFT JOIN user u						
on n.id = u.neighborhoods_id						
WHERE u.id IS NULL`

### --- COMPARE ALL x ALL, DO THE DIFFERENCE AND PRINT THE LOWEST --			

`SELECT 			
t1.student as student_one,			
t2.student as student_two,			
abs(t1.score-t2.score) as score_diff			
from student t1			
join student t2			
on t1.id < t2.id		--OR CROSS JOIN	
order by 3,1,2			
LIMIT 1`

### --- Write a query to find the difference between the total number of 
cities and the unique number of cities in the table STATION ---	

-- SUBTRACT TWO SELECTS	--
	
`SELECT ( 			
SELECT count(city) from station) - (SELECT count(distinct city) from station)			
FROM STATION`

-- JOIN ON Between --

`SELECT IIF (g.Grade < 8, null , s.Name) as Name,
Marks
FROM Students s JOIN Grades g
ON s.Marks BETWEEN Min_Mark and Max_Mark
ORDER BY Grade DESC, Name`


### **--- TEMP TABLES  ---**

`with t1 as (SELECT
    s.hacker_id, 
    s.challenge_id,
    s.score as s_score,
    d.score as d_score
    FROM submissions s
JOIN Challenges c
on s.challenge_id = c.challenge_id
JOIN Difficulty d
on c.difficulty_level = d.difficulty_level)`

`SELECT 
    h.hacker_id, h.name
FROM Hackers h
JOIN t1
on h.hacker_id = t1.hacker_id
WHERE t1.s_score >= t1.d_score`

--- CASE (TRIANGLES) ---

`SELECT *,
CASE
    WHEN (A + B < C) OR (B+C < A) OR (C+A < B) THEN "Not A Triangle"
    WHEN A = B AND B = C THEN "Equilateral"
    WHEN (A = B AND B !=C) OR (A=C AND B!=A) THEN "Isosceles" 
    WHEN A!= B AND B!= C AND C!=A THEN "Scalene"
END
FROM TRIANGLES`

--- **USING DATE (from_unixtime)** ---

--- Buscar o primeiro e o ultimo dia | So Funciona com time stamp.

`SELECT
from_unixtime(min(first_timestamp), "d MMMM y") First_Date,
from_unixtime(max(last_timestamp), "d MMMM y") Last_Date
FROM
intro_to_databricks_sql_gym_logs;`

---  Buscar a media de tempo na academia

`SELECT
from_unixtime(first_timestamp, "dd") as day,`  
`avg((last_timestamp - first_timestamp) / 60) as avg_time
FROM
intro_to_databricks_sql_gym_logs` 
`group by
day
ORDER BY
from_unixtime(first_timestamp, "dd");`


### **---  SUBQUERIES ---** 
Recurso que permite criar queries otimizadas, reaproveitando o resultado de uma querie.

Podem ser utilizadas em 3 situações:
- Dentro da clausula    WHERE, como filtro;
- Dentro da clausula SELECT, como nova coluna;
- Dentro da FROM, como nova tabela;

### **---  VIEWS ---** 
Pode ser definida como uma tabela virtual, aonde armazenamos a consulta.

**Reuso**: as views são objetos de caráter permanente. 

`CREATE VIEW name_view AS`  
`SELECT * FROM TABLE WHERE customer = 'Person'`

`CREATE OR ALTER VIEW name_view AS  
 SELECT * FROM TABLE WHERE customer = 'Company'`

`DELETE VIEW name_view`

### **---  TRIGGER ---** 
Fiscal do SQL, e sempre sera disparado a depender do evento;

```
CREATE OR REPLACE TRIGGER nome_tg
BEFORE INSERT OR UPDATE OR DELETE
ON Tabela
*codigo*
```
> Ex: Trigger disparada antes de Insert na tabela Employees, caso seja SAB ou DOM a query deverá ser abortada.

```

CREATE OR ALTER TRIGGER TG_EMPLYEES_BEFORE_INSERT_ALTER
ON [dbo].[TABLE_TEST_VICTOR]
FOR INSERT, UPDATE
AS
BEGIN
    IF TRIM(DATENAME(WEEKDAY,GETDATE())) = 'Wednesday'
        RAISERROR('NAO PERMITIDO HOJE',0,1)
END
```
### **---  SEQUENCE ---** 
São objetos usado para gerar valores de auto numeração, onde podemos definir os valores iniciais e seus incrementos.  
`SELECT current_value FROM sys.sequences WHERE name = 'OrderNumberSequence' ;`