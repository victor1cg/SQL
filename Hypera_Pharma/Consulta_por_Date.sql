DECLARE @DataRel	AS	DATETIME
SET @DataRel = '2020-01-01'

SELECT	cd_Time			  ,
		cd_Regional		  ,
		cd_Setor		  ,
		cd_Amostra		  ,
		nr_CRM			  ,
		uf_CRM			  ,
		nm_Medico		  ,
		dt_Visita		  ,
		cd_MaterialAmostra,
		nm_MaterialAmostra,
		cd_Lote			  ,	
		qt_Amostra
FROM running_farma..tb_farma_amostras
WHERE CONVERT(DATE, dt_Visita, 103) >= @DataRel