DECLARE @DataRel	AS	DATETIME
SET @DataRel = '2020-01-01'

SELECT	cd_Time			  ,
		cd_Regional		  ,
		cd_Setor		  ,	
		qt_Amostra
FROM running_farma..tb_farma_amostras
WHERE CONVERT(DATE, dt_Visita, 103) >= @DataRel
----------------
############ OVER - Partition

SELECT Customercity, 
       CustomerName, 
       OrderAmount, 
       AVG(Orderamount) OVER(PARTITION BY Customercity) AS AvgOrderAmount, 
       MIN(OrderAmount) OVER(PARTITION BY Customercity) AS MinOrderAmount, 
       SUM(Orderamount) OVER(PARTITION BY Customercity) TotalOrderAmount
FROM Orders;

return  to us the average by city:

CITY	NAME 	ORDER	AvgOrderAmount	MinOrderAmount	TotalOrderAmount
Austin	Joe	$950	$1000		$250		$80000
Chicago	jose	$300	$600		$100		$7000

#### PARTITION BY clause with ROW_NUMBER()
We can use the SQL PARTITION BY clause with ROW_NUMBER() function to have a row number of each row. 
We define the following parameters to use ROW_NUMBER with the SQL PARTITION BY clause.

SELECT Customercity, 
       CustomerName, 
       ROW_NUMBER() OVER(PARTITION BY Customercity ORDER BY OrderAmount DESC) AS "Row Number", 
       OrderAmount, 
       COUNT(OrderID) OVER(PARTITION BY Customercity) AS CountOfOrders, 
       AVG(Orderamount) OVER(PARTITION BY Customercity) AS AvgOrderAmount, 
       MIN(OrderAmount) OVER(PARTITION BY Customercity) AS MinOrderAmount, 
       SUM(Orderamount) OVER(PARTITION BY Customercity) TotalOrderAmount
FROM [dbo].[Orders];

CITY	NAME 	Row Number	ORDER	AvgOrderAmount	MinOrderAmount	TotalOrderAmount
Austin	Joe	1		$950	$800		$600		$2250
Austin  Marvin	2		$700	$800		$600		$2250
Austin	John	3		$600	$800		$600		$2250	

Chicago	jose			$300	$600		$100		$7000

# Creating a CUMULATIVE SUM
SELECT Customercity, 
       CustomerName, 
       OrderAmount, 
       ROW_NUMBER() OVER(PARTITION BY Customercity
       ORDER BY OrderAmount DESC) AS "Row Number", 
       CONVERT(VARCHAR(20), SUM(orderamount) OVER(PARTITION BY Customercity
       ORDER BY OrderAmount DESC ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING), 1) AS CumulativeTotal,
      
CITY	NAME 	Row Number	ORDER	CumulativeTotal	
Austin	Joe	1		$950	$2250		
Austin  Marvin	2		$700	$1300		
Austin	John	3		$600	$600			

Chicago	jose	1		$300	$600		

---------- Insert

Create Table #temp_employees (
Name varchar(30),
Age int,
Role varchar (30))

Insert into #temp_Employees (
('Zack', 24, 'Analyst'),
('Joe' , 55, 'Director'),
('Melissa', 30, 'Doctor - Fired')

Select TRIM(Name) - ltrim - 
Select replace(name, '- Fired','')
Select substring( value , 1,3) 		- START EM 1 AND FINISH 3

------------- PROCEDURE

CREATE PROCEDURE Test
AS
Select * from Employee_HR  		- Simple as that

EXEC Test				- Run the PROCEDURE

-- GOOD EXAMPLE - I can run a procedure using a filter, example with jobtitle

ALTER PROCEDURE Find_Role
@JobTitle nvarchar(100)
AS 
.... commands
WHERE job_title = @JobTitle

EXEC Find_Role @Job_Title = 'Salesman'





