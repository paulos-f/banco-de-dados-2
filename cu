/*Questão 01

Dada a consulta abaixo, altere o cod_cliente para informar o nome do cliente. Para isso, utilize subconsulta
na lista de select.

SELECT cod_apolice
 ,cod_cliente
 ,data_inicio_vigencia
 ,data_fim_vigencia
 ,valor_cobertura
 ,valor_franquia
 ,placa
 FROM apolice
ORDER BY data_fim_vigencia ASC
GO

RESPOSTA:

SELECT cod_apolice
 ,(SELECT nome FROM cliente where cliente.cod_cliente = apolice.cod_cliente)
 ,data_inicio_vigencia
 ,data_fim_vigencia
 ,valor_cobertura
 ,valor_franquia
 ,placa
 FROM apolice
 ORDER BY data_fim_vigencia ASC
*/



/*Questão 02

Dada a consulta abaixo, altere o cod_cliente para informar o nome do cliente. Para isso, utilize Join (escolha
o tipo de JOIN mais edequado).
SELECT cod_apolice
 ,cod_cliente
 ,data_inicio_vigencia
 ,data_fim_vigencia
 ,valor_cobertura
 ,valor_franquia
 ,placa
 FROM apolice
ORDER BY data_fim_vigencia ASC
GO

RESPOSTA:

SELECT cod_apolice,
       nome,
       data_inicio_vigencia,
       data_fim_vigencia,
       valor_cobertura,
       valor_franquia,
       placa
FROM apolice as a
INNER JOIN cliente as c ON a.cod_cliente = c.cod_cliente
ORDER BY a.data_fim_vigencia ASC;
*/



/*Questão 03

Faça uma consulta na tabela sinistro (com todas as colunas) adicionando uma nova coluna chamada ordem
ao final do select list, (não é para criar uma coluna com ALTER TABLE, usar somente SELECT), com um
contador do número da linha, ORDENADO pelo campo local_sinistro. Nota: Utilize uma função de janela
ROW_NUMBER.

RESPOSTA:
select *,
row_number() over(order by local_sinistro) as ordem
from sinistro
*/


/*Questão 04

Faça uma consulta na tabela sinistro (com todas as colunas) adicionando uma nova coluna chamada ordem
ao final do select list, (não é para criar uma coluna com ALTER TABLE, usar somente SELECT), com um
contador do número da linha, ORDENADO pelo campo local_sinistro. Nota: Utilize uma função de janela
RANK.

RESPOSTA:
select *,
rank() over(order by local_sinistro) as ordem
from sinistro
*/

/*Questão 05

Faça uma consulta na tabela sinistro (com todas as colunas) adicionando uma nova coluna chamada ordem
ao final do select list, (não é para criar uma coluna com ALTER TABLE, usar somente SELECT), com um
contador do número da linha, ORDENADO pelo campo local_sinistro. Nota: Utilize uma função de janela
DENSE_RANK.

RESPOSTA:
select *,
dense_rank() over(order by local_sinistro) as ordem
from sinistro
*/

/*Questão 06

Faça uma consulta que mostre quais carros (listar todos os dados dos carros – todas as colunas da tabela
carro) possuem mais de (1) um sinistro. Nota: O resultado da consulta deve mostrar todos os dados dos
carros e mais uma coluna ao final com a quantidade de sinistros por cada carro.

RESPOSTA:
with cte as 
(select distinct carro.*,
count(carro.placa) over (partition by carro.placa order by carro.placa) as qtdade
from carro inner join sinistro on carro.placa = sinistro.placa
)

select * from cte
where qtdade > 1
*/

/*QUESTÃO 07

Com base na consulta anterior, adicione uma coluna ao final do select list informando quando ocorreu o
primeiro sinistro (menor data).

RESPOSTA:
with cte as 
(select distinct carro.*,
count(carro.placa) over (partition by carro.placa order by carro.placa) as qtdade,
first_value(data_sinistro) over (partition by carro.placa order by carro.placa, data_sinistro) as datas
from carro inner join sinistro
on carro.placa = sinistro.placa
)

select * from cte
*/

/*Questão 08

Altere a consulta anterior, adicionando uma outra coluna ao final do select list (preservar a coluna criada
pela questão 7) informando quando ocorreu o último sinistro (menor data).

with cte as 
(select distinct carro.*,
count(carro.placa) over (partition by carro.placa order by carro.placa) as qtdade,
first_value(data_sinistro) over (partition by carro.placa order by carro.placa, data_sinistro) as datas,
LAST_VALUE(data_sinistro) over (partition by carro.placa order by carro.placa, data_sinistro ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as ultimo
from carro inner join sinistro
on carro.placa = sinistro.placa
)

select * from cte
*/

/*Questão 09

Gere uma consulta listando o nome da região e o nome dos estados vinculados a cada região (resultado com
2 colunas) ordenados pelo nome da região e pelo nome do estado respectivamente. Gerar duas opções de
consulta. Uma com JOIN e a outra com subconsultas no select list.

RESPOSTA:

JOIN:

SELECT r.nm_regiao, e.nm_estado
FROM regiao r
JOIN estado e ON r.cd_regiao = e.cd_regiao
ORDER BY r.nm_regiao, e.nm_estado


SUBCONSULTA:

SELECT 
    (SELECT nm_regiao FROM regiao WHERE cd_regiao = e.cd_regiao) AS nm_regiao,
    e.nm_estado
FROM estado e
ORDER BY nm_regiao, nm_estado;
*/


/*Questões 10

Utilizando a consulta gerada na questão anterior, faça as alterações necessárias na consulta para informar o
nome do estado que está na 5a posição do ranking

RESPOSTA:
with cte as(
SELECT r.nm_regiao, e.nm_estado,
 DENSE_RANK() OVER(ORDER BY e.nm_estado) as ranking
FROM regiao r
JOIN estado e ON r.cd_regiao = e.cd_regiao

)

select * from cte where ranking = 5
*/

/*Questão 11

Desafio: Gere uma consulta na tabela apolice (listas todas as colunas), alterando a coluna cod_cliente
Informando o nome do cliente (usar uma subconsulta no select list para isso).
Utilizando essa consulta como base, faça as alterações necessárias para adicionar uma nova coluna ao final
do select list com o valor acumulado da coluna valor_franquia, particionado por nome do cliente, e
ordenado pelo nome do cliente e pelo código da apólice respectivamente.

RESPOSTA:
with cte as(
	select cod_apolice,
		   (select nome from cliente where cliente.cod_cliente = apolice.cod_cliente) as nome,
		   data_inicio_vigencia,
		   data_fim_vigencia,
		   valor_cobertura,
		   valor_franquia,
		   placa
	FROM apolice
)

select *,
	sum(valor_franquia) over (partition by nome order by nome, cod_apolice) as valor_acumulado
from cte
*/
