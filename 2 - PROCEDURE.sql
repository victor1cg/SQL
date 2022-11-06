/* 
-------- PROCEDURES --------
Procedimento Armazenado, � uma conjunto de comandos em SQL que podem ser executados 
de uma s� vez, como em uma fun��o. 
*/

CREATE PROCEDURE BuscaProduto
		@nome_produto VARCHAR(20)
AS 

SET @nome_produto = '%' + @nome_produto + '%'

SELECT v.*, s.SALDO_FINAL 
	FROM TESTE_tbVendas v
	INNER JOIN TESTE_tbSaldos s ON(v.PRODUTO = s.PRODUTO)

	WHERE v.PRODUTO like @nome_produto

---- Teste da procedure
exec BuscaProduto 'Produto C'
exec BuscaProduto '%'			--trazer todos os produtos