

---------------- CRIAR CICLOS ------------

IF OBJECT_ID('tempdb.dbo.#ciclos') IS NOT NULL DROP TABLE #ciclos

SELECT 

  nm_ciclo                                 AS CICLO
, CAST(dt_Inicio AS DATE)                  AS INICIO
, CAST(dt_Fim AS DATE)                     AS FIM
, qt_Dias                                  AS DIAS_UTEIS
, LEFT(CONVERT(VARCHAR,dt_Inicio,112),4)   AS ANO
, dt_ciclo AS COD_CICLO

INTO #ciclos
FROM RUNNING_FARMA..tb_FARMA_Ciclo

WHERE LEFT(CONVERT(VARCHAR,dt_Inicio,112),4) IN ('2021')
AND dt_ciclo IN ('202101')
-- select * from #ciclos	-- CONFERIR O CICLO



---------------- CRIAR BASE DE AMOSTRAS (Gera a base convertendo a data afim de cruzar)------------

IF OBJECT_ID('tempdb.dbo.#base_amostras') IS NOT NULL DROP TABLE #base_amostras

SELECT 

  cd_Time
, cd_Regional
, cd_Setor
, cd_Amostra
, nr_CRM
, uf_CRM
, nm_Medico
, CAST(RIGHT(dt_visita, 4) + '-' + SUBSTRING(dt_visita, 4,2) + '-' + LEFT(dt_visita, 2) AS DATE) AS dt_Visita
, cd_MaterialAmostra
, nm_MaterialAmostra
, cd_Lote
, CONVERT(NUMERIC(10,2),qt_Amostra) AS qt_Amostra

INTO #base_amostras
FROM running_farma..tb_FARMA_Amostras
WHERE RIGHT(dt_visita, 4) IN ('2021')

-- select top 10 * from #base_amostras
-- select top 10 * from running_farma..tb_FARMA_Amostras



-------------------------------- CRIAR AMOSTRAS  ---------------------------------------

IF OBJECT_ID('tmp_usr..amostras') IS NOT NULL DROP TABLE tmp_usr..amostras

SELECT

  cl.COD_CICLO AS CICLO

, CASE
  WHEN LEFT(amt.cd_Setor,1) = '2' THEN 'REGULAR'
  WHEN LEFT(amt.cd_Setor,1) = '3' THEN 'REGULAR'
  WHEN LEFT(amt.cd_Setor,1) = '4' THEN 'SKIN'
  END AS LINHA

, CASE
  WHEN LEFT(amt.cd_Setor,2) = '21' THEN '21-SUL'
  WHEN LEFT(amt.cd_Setor,2) = '22' THEN '22-SPC'
  WHEN LEFT(amt.cd_Setor,2) = '23' THEN '23-SPI-CO'
  WHEN LEFT(amt.cd_Setor,2) = '24' THEN '24-RJ-MG-ES'
  WHEN LEFT(amt.cd_Setor,2) = '25' THEN '25-NO-NE'
  WHEN LEFT(amt.cd_Setor,2) = '31' THEN '31-SUL'
  WHEN LEFT(amt.cd_Setor,2) = '32' THEN '32-SPC'
  WHEN LEFT(amt.cd_Setor,2) = '33' THEN '33-SPI-CO'
  WHEN LEFT(amt.cd_Setor,2) = '34' THEN '34-RJ-MG-ES'
  WHEN LEFT(amt.cd_Setor,2) = '35' THEN '35-NO-NE' 
  WHEN LEFT(amt.cd_Setor,2) = '41' THEN '41-SP GAMA'
  WHEN LEFT(amt.cd_Setor,2) = '42' THEN '42-RJ GAMA'
  END AS REGIONAL  
  
, LEFT(amt.cd_setor,4) AS DISTRITO

, amt.cd_Setor AS SETOR

, CASE
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '1' THEN 'ALFA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '2' THEN 'BETA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '3' THEN 'OMEGA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '4' THEN 'DELTA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '5' THEN 'GAMA 1'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '6' THEN 'GAMA 2'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '7' THEN 'GAMA 3'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '8' THEN 'GAMA 4'
  END AS EQUIPE

, CASE
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '1' THEN 'ALFA&DELTA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '2' THEN 'BETA&OMEGA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '3' THEN 'BETA&OMEGA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '4' THEN 'ALFA&DELTA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '5' THEN 'GAMA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '6' THEN 'GAMA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '7' THEN 'GAMA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '8' THEN 'GAMA'
  END AS TIPO

, amt.uf_Crm + RIGHT('0000000000000' + CONVERT(VARCHAR, amt.nr_Crm), 7) AS UFCRM
, amt.nm_Medico AS MEDICO

, amt.cd_MaterialAmostra AS COD_MATERIAL
, amt.cd_Amostra AS COD_AMOSTRA
, amt.nm_MaterialAmostra AS PRODUTO
, amt.cd_Lote AS LOTE


, SUM(amt.qt_Amostra) AS TOTAL_AMOSTRAS

INTO tmp_usr..amostras
FROM #base_amostras amt

INNER JOIN #ciclos AS cl 
ON amt.dt_Visita BETWEEN cl.INICIO AND cl.FIM


WHERE amt.nm_MaterialAmostra NOT IN (' ')


GROUP BY

  cl.COD_CICLO

, CASE
  WHEN LEFT(amt.cd_Setor,1) = '2' THEN 'REGULAR'
  WHEN LEFT(amt.cd_Setor,1) = '3' THEN 'REGULAR'
  WHEN LEFT(amt.cd_Setor,1) = '4' THEN 'SKIN'
  END

, CASE
  WHEN LEFT(amt.cd_Setor,2) = '21' THEN '21-SUL'
  WHEN LEFT(amt.cd_Setor,2) = '22' THEN '22-SPC'
  WHEN LEFT(amt.cd_Setor,2) = '23' THEN '23-SPI-CO'
  WHEN LEFT(amt.cd_Setor,2) = '24' THEN '24-RJ-MG-ES'
  WHEN LEFT(amt.cd_Setor,2) = '25' THEN '25-NO-NE'
  WHEN LEFT(amt.cd_Setor,2) = '31' THEN '31-SUL'
  WHEN LEFT(amt.cd_Setor,2) = '32' THEN '32-SPC'
  WHEN LEFT(amt.cd_Setor,2) = '33' THEN '33-SPI-CO'
  WHEN LEFT(amt.cd_Setor,2) = '34' THEN '34-RJ-MG-ES'
  WHEN LEFT(amt.cd_Setor,2) = '35' THEN '35-NO-NE' 
  WHEN LEFT(amt.cd_Setor,2) = '41' THEN '41-SP GAMA'
  WHEN LEFT(amt.cd_Setor,2) = '42' THEN '42-RJ GAMA'
  END
  
, LEFT(amt.cd_setor,4)

, amt.cd_Setor

, CASE
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '1' THEN 'ALFA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '2' THEN 'BETA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '3' THEN 'OMEGA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '4' THEN 'DELTA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '5' THEN 'GAMA 1'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '6' THEN 'GAMA 2'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '7' THEN 'GAMA 3'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '8' THEN 'GAMA 4'
  END

, CASE
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '1' THEN 'ALFA&DELTA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '2' THEN 'BETA&OMEGA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '3' THEN 'BETA&OMEGA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '4' THEN 'ALFA&DELTA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '5' THEN 'GAMA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '6' THEN 'GAMA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '7' THEN 'GAMA'
  WHEN LEFT(RIGHT(amt.cd_Setor,2),1) = '8' THEN 'GAMA'
  END

, amt.uf_Crm + RIGHT('0000000000000' + CONVERT(VARCHAR, amt.nr_Crm), 7)
, amt.nm_Medico

, amt.cd_MaterialAmostra
, amt.cd_Amostra
, amt.nm_MaterialAmostra
, amt.cd_Lote




-- select top 10 * from tmp_usr..amostras
-- WHERE  setor in ('410643')
select top 10 * from #base_amostras
WHERE  cd_setor in ('410643')
