/****** QUERY PARA VERIFICAR O STATUS DOS DADOS MEDICOS  ******/
SELECT 
	   [cd_Time]
      ,[cd_Regional]
      ,[cd_Setor]
      ,[nr_CRM]
      ,[nm_Medico]
      ,[ds_Email]
      ,[nr_DDD]
      ,[nr_Telefone1]
      ,CAST([CELULAR] AS BIGINT)		AS CELULAR

-- STATUS TELEFONE --
,	CASE	
	WHEN LEN(nr_Telefone1) = 0 THEN 'Vazio'
	WHEN LEN(nr_Telefone1) IN (1,2,3,4,5,6,7) THEN 'Incorreto'
	WHEN LEN(nr_Telefone1) > 7 AND
		nr_Telefone1 LIKE ('%0000000%') OR
		nr_Telefone1 LIKE ('%1111111%') OR  --7 NUMEROS IGUAIS É INCORRETO
		nr_Telefone1 LIKE ('%2222222%') OR
		nr_Telefone1 LIKE ('%3333333%') OR
		nr_Telefone1 LIKE ('%4444444%') OR
		nr_Telefone1 LIKE ('%5555555%') OR
		nr_Telefone1 LIKE ('%6666666%') OR
		nr_Telefone1 LIKE ('%7777777%') OR
		nr_Telefone1 LIKE ('%8888888%') OR
		nr_Telefone1 LIKE ('%9999999%') OR
		nr_Telefone1 LIKE ('%1234567%') OR
		nr_Telefone1 LIKE ('%9090909%') OR
		nr_Telefone1 LIKE ('00%')			  -- add numero que começa com 0
		THEN 'Incorreto'
		ELSE 'Correto'
		END AS STATUS_TELEFONE

-- STATUS EMAIL --
, CASE
		WHEN LEN (ds_email) = 0 OR ds_Email = 'sd'	THEN 'Vazio'
		WHEN ds_email not like ('%@%')				THEN 'Incorreto'
		ELSE 'Correto'
		END AS STATUS_EMAIL

-- STATUS CELULAR --
, CASE 
		WHEN LEN(CELULAR) = 0 THEN 'Vazio'
		WHEN LEN(CELULAR) IN (1,2,3,4,5,6,7)	THEN 'Incorreto'
		WHEN LEN(CELULAR) > 7 AND
		CELULAR LIKE ('%9999999%')	 OR 
		CELULAR LIKE ('00%')		 OR 
		CELULAR LIKE ('%9090909%')				THEN 'Incorreto'
		ELSE 'Correto'
		END AS STATUS_CELULAR
FROM running_farma..tb_FARMA_Cadastro
WHERE CD_Setor NOT IN ('444444','777777') 
-- and CD_Setor LIKE ('5%')
-- into na tmp_USR +  criar tabela tempoaraia e ligar no Excel;
