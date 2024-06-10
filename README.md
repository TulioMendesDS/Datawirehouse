# Modelagem Dimensional em Data Warehousing

A modelagem dimensional é uma técnica essencial em data warehousing para organizar e estruturar os dados de forma eficiente para análise. Duas abordagens comuns de modelagem dimensional são o Star Schema e o Snowflake Schema.

## Star Schema

O Star Schema é uma técnica simples e eficaz de modelagem dimensional, composta por uma tabela de fatos central e várias tabelas de dimensões conectadas a ela.

### Componentes do Star Schema:

- **Tabela de fatos**: Armazena as métricas numéricas ou quantitativas que são o foco da análise. Geralmente contém chaves estrangeiras para se conectar às tabelas de dimensões.
- **Tabelas de dimensões**: Contêm atributos descritivos relacionados aos dados na tabela de fatos. Cada dimensão é representada por uma única tabela.



## Snowflake Schema

O Snowflake Schema é uma extensão do Star Schema, onde as tabelas de dimensão são normalizadas em várias tabelas, resultando em uma estrutura de árvore ou "flocos de neve".

### Componentes do Snowflake Schema:

- **Tabela de fatos**: Similar ao Star Schema, armazena métricas numéricas.
- **Tabelas de dimensões normalizadas**: As dimensões são divididas em várias tabelas normalizadas, reduzindo a redundância e otimizando o armazenamento.



## Comparação entre Star Schema e Snowflake Schema

|         | Star Schema                                       | Snowflake Schema                                      |
|----------------|---------------------------------------------------|-------------------------------------------------------|
| Desempenho     | Geralmente oferece melhor desempenho devido à sua estrutura simplificada e menos junções necessárias. | Pode ter um desempenho ligeiramente inferior devido ao potencial aumento do número de junções necessárias para recuperar dados normalizados. |
| Manutenção     | Mais fácil de entender e manter devido à sua simplicidade estrutural. | Pode ser mais complexo de manter devido à necessidade de gerenciar múltiplas camadas de tabelas dimensionais normalizadas. |
| Escalabilidade | Geralmente menos escalável para grandes volumes de dados devido à sua estrutura fixa. | Pode ser mais escalável devido à normalização das tabelas de dimensão, que pode ajudar na redução da redundância de dados e melhorar o desempenho em casos de grande volume de dados. |




## Cubos OLAP

Neste documento, exploraremos conceitos fundamentais da modelagem de dados voltada para Business Intelligence (BI) e Data Warehousing, utilizando um dataset de ecommerce como base. Vamos abordar a construção de cubos OLAP (Online Analytical Processing), bem como as técnicas de modelagem dimensional através dos esquemas estrela (Star Schema) e floco de neve (Snowflake Schema).

> [Cubos OLAP - Star Schema e Snow Flake.pdf](https://github.com/user-attachments/files/15778119/Cubos.OLAP.-.Star.Schema.e.Snow.Flake.pdf)

## Modelo Proposto de um Star Schema - Modelo Lógico
> ![Star Schema](https://private-user-images.githubusercontent.com/167912036/338316328-bea45b03-4cf5-4e15-a948-74f1248e9392.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MTgwNDc4MjQsIm5iZiI6MTcxODA0NzUyNCwicGF0aCI6Ii8xNjc5MTIwMzYvMzM4MzE2MzI4LWJlYTQ1YjAzLTRjZjUtNGUxNS1hOTQ4LTc0ZjEyNDhlOTM5Mi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwNjEwJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDYxMFQxOTI1MjRaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1mYzJiNWFjYmM2NTExZDdhYWZiZTYyYzVlZDhhZjlmZmQ3ZjIwMjkyYWMwYjljOTM3YzkwZWM5ZDJhOWNkZDViJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.IbmXTuWn_f2u4SJKmFgUjZzPL1LVWzjnmM7q77ubrjU)



## Implementação - Modelo Físico

```sql
CREATE DATABASE db_starschema /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE db_starschema;

-- Tabela de Dimensão de Clientes (Dim_Cliente)
CREATE TABLE dim_cliente (
  id_cliente INT NOT NULL AUTO_INCREMENT,
  cpf_cliente VARCHAR(14) NOT NULL,
  nome_cliente VARCHAR(150) NOT NULL,
  email_cliente VARCHAR(45) DEFAULT NULL,
  telefone_cliente VARCHAR(45) DEFAULT NULL,
  PRIMARY KEY (id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Dimensão de Data (Dim_Tempo)
CREATE TABLE dim_tempo (
  id_tempo INT NOT NULL AUTO_INCREMENT,
  data DATE NOT NULL,
  dia INT NOT NULL,
  mes INT NOT NULL,
  ano INT NOT NULL,
  dia_semana VARCHAR(10),
  PRIMARY KEY (id_tempo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Dimensão de Tipo de Prato (Dim_Tipo_Prato)
CREATE TABLE dim_tipo_prato (
  codigo_tipo_prato INT NOT NULL AUTO_INCREMENT,
  nome_tipo_prato VARCHAR(45) NOT NULL,
  PRIMARY KEY (codigo_tipo_prato)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Dimensão de Pratos (Dim_Prato)
CREATE TABLE dim_prato (
  codigo_prato INT NOT NULL AUTO_INCREMENT,
  codigo_tipo_prato INT NOT NULL,
  nome_prato VARCHAR(45) NOT NULL,
  preco_unitario_prato DOUBLE NOT NULL,
  PRIMARY KEY (codigo_prato),
  FOREIGN KEY (codigo_tipo_prato) REFERENCES dim_tipo_prato (codigo_tipo_prato)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Dimensão de Situação do Pedido (Dim_Situacao_Pedido)
CREATE TABLE dim_situacao_pedido (
  codigo_situacao_pedido INT NOT NULL AUTO_INCREMENT,
  nome_situacao_pedido VARCHAR(45) NOT NULL,
  PRIMARY KEY (codigo_situacao_pedido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Fatos de Pedidos (Fato_Pedido)
CREATE TABLE fato_pedido (
  id_pedido INT NOT NULL AUTO_INCREMENT,
  id_tempo INT NOT NULL,
  id_cliente INT NOT NULL,
  codigo_prato INT NOT NULL,
  codigo_tipo_prato INT NOT NULL,
  quantidade_pedido INT NOT NULL,
  preco_unitario_prato DOUBLE NOT NULL,
  valor_total_pedido DOUBLE NOT NULL,
  codigo_situacao_pedido INT NOT NULL,
  PRIMARY KEY (id_pedido),
  FOREIGN KEY (id_tempo) REFERENCES dim_tempo (id_tempo),
  FOREIGN KEY (id_cliente) REFERENCES dim_cliente (id_cliente),
  FOREIGN KEY (codigo_prato) REFERENCES dim_prato (codigo_prato),
  FOREIGN KEY (codigo_tipo_prato) REFERENCES dim_tipo_prato (codigo_tipo_prato),
  FOREIGN KEY (codigo_situacao_pedido) REFERENCES dim_situacao_pedido (codigo_situacao_pedido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## Data Explore
O Data Exploration Query Language (DQL) é uma ferramenta poderosa para explorar conjuntos de dados por meio de consultas estruturadas. Com o DQL, podemos formular perguntas específicas e extrair insights valiosos dos dados disponíveis. Nas consultas abaixo, abordaremos uma variedade de perguntas relacionadas aos clientes do restaurante e às empresas associadas a eles. Vamos explorar quem são os clientes mais ativos, quem gasta mais, quais empresas têm mais funcionários como clientes do restaurante e outras análises relevantes.

## Qual o cliente que mais fez pedidos por ano?
```sql
select * 
from (
  (select year(ms.data_hora_entrada) as ano, cl.nome_cliente as cliente, sum(pd.quantidade_pedido) as qtd_pedido 
  from tb_mesa ms
  left join tb_cliente cl
  on ms.id_cliente = cl.id_cliente
  left join tb_pedido pd
  on ms.codigo_mesa = pd.codigo_mesa
  where year(ms.data_hora_entrada) = 2022
  group by 1, 2
  order by 3 desc
  limit 1)
  union
  (select year(ms.data_hora_entrada) as ano, cl.nome_cliente as cliente, sum(pd.quantidade_pedido) as qtd_pedido 
  from tb_mesa ms
  left join tb_cliente cl
  on ms.id_cliente = cl.id_cliente
  left join tb_pedido pd
  on ms.codigo_mesa = pd.codigo_mesa
  where year(ms.data_hora_entrada) = 2023
  group by 1, 2
  order by 3 desc
  limit 1)
  union
  (select year(ms.data_hora_entrada) as ano, cl.nome_cliente as cliente, sum(pd.quantidade_pedido) as qtd_pedido 
  from tb_mesa ms
  left join tb_cliente cl
  on ms.id_cliente = cl.id_cliente
  left join tb_pedido pd
  on ms.codigo_mesa = pd.codigo_mesa
  where year(ms.data_hora_entrada) = 2024
  group by 1, 2
  order by 3 desc
  limit 1)
) as tb_major_consumer_per_year;
```

## Qual o cliente que mais gastou em todos os anos?
```sql
select * 
from (
  (select year(ms.data_hora_entrada) as ano, cl.nome_cliente as cliente, sum(pr.preco_unitario_prato * pd.quantidade_pedido) as valor_pedido
  from tb_mesa ms
  left join tb_cliente cl
  on ms.id_cliente = cl.id_cliente
  left join tb_pedido pd
  on ms.codigo_mesa = pd.codigo_mesa
  left join tb_prato pr
  on pd.codigo_prato = pr.codigo_prato
  where year(ms.data_hora_entrada) = 2022
  group by 1, 2
  order by 3 desc
  limit 1)
  union
  (select year(ms.data_hora_entrada) as ano, cl.nome_cliente as cliente, sum(pr.preco_unitario_prato * pd.quantidade_pedido) as valor_pedido
  from tb_mesa ms
  left join tb_cliente cl
  on ms.id_cliente = cl.id_cliente
  left join tb_pedido pd
  on ms.codigo_mesa = pd.codigo_mesa
  left join tb_prato pr
  on pd.codigo_prato = pr.codigo_prato
  where year(ms.data_hora_entrada) = 2023
  group by 1, 2
  order by 3 desc
  limit 1)
  union
  (select year(ms.data_hora_entrada) as ano, cl.nome_cliente as cliente, sum(pr.preco_unitario_prato * pd.quantidade_pedido) as valor_pedido
  from tb_mesa ms
  left join tb_cliente cl
  on ms.id_cliente = cl.id_cliente
  left join tb_pedido pd
  on ms.codigo_mesa = pd.codigo_mesa
  left join tb_prato pr
  on pd.codigo_prato = pr.codigo_prato
  where year(ms.data_hora_entrada) = 2024
  group by 1, 2
  order by 3 desc
  limit 1)
) as tb_mais_gastou_por_ano;
```

## Qual(is) o(s) cliente(s) que trouxe(ram) mais pessoas por ano
```sql
select distinct year(data_hora_entrada)
from tb_mesa;

select year(ms.data_hora_entrada) as ano, cl.nome_cliente as cliente, sum(ms.num_pessoa_mesa) as qtd_pessoas 
from tb_mesa ms
left join tb_cliente cl
on ms.id_cliente = cl.id_cliente
where year(ms.data_hora_entrada) = 2022
group by 1, 2
order by 3 desc
limit 10;

select * 
from (
  (select year(ms.data_hora_entrada) as ano, cl.nome_cliente as cliente, sum(ms.num_pessoa_mesa) as qtd_pessoas 
  from tb_mesa ms
  left join tb_cliente cl
  on ms.id_cliente = cl.id_cliente
  where year(ms.data_hora_entrada) = 2022
  group by 1, 2
  order by 3 desc
  limit 10)
  union
  (select year(ms.data_hora_entrada) as ano, cl.nome_cliente as cliente, sum(ms.num_pessoa_mesa) as qtd_pessoas 
  from tb_mesa ms
  left join tb_cliente cl
  on ms.id_cliente = cl.id_cliente
  where year(ms.data_hora_entrada) = 2023
  group by 1, 2
  order by 3 desc
  limit 10)
  union
  (select year(ms.data_hora_entrada) as ano, cl.nome_cliente as cliente, sum(ms.num_pessoa_mesa) as qtd_pessoas 
  from tb_mesa ms
  left join tb_cliente cl
  on ms.id_cliente = cl.id_cliente
  where year(ms.data_hora_entrada) = 2024
  group by 1, 2
  order by 3 desc
  limit 10)
) as tb_top10_major_consumer_per_year;
```

## Qual a empresa que tem mais funcionarios como clientes do restaurante
```sql
select * from tb_empresa;

select em.nome_empresa as empresa, count(bn.email_funcionario) as qtd_funcionarios
from tb_empresa em
left join tb_beneficio bn
on bn.codigo_empresa = em.codigo_empresa
left join tb_cliente cl
on bn.email_funcionario = cl.email_cliente
group by em.nome_empresa
order by qtd_funcionarios desc
limit 3;
```

## Qual empresa que tem mais funcionarios que consomem sobremesas no restaurante por ano
```sql
select tp.nome_tipo_prato, count(p.nome_prato)
from tb_prato p
left join tb_tipo_prato tp
on p.codigo_tipo_prato = tp.codigo_tipo_prato
left join tb_pedido pd
on pd.codigo_prato = p.codigo_prato
where tp.codigo_tipo_prato = 3
group by tp.nome_tipo_prato
order by count(p.nome_prato) desc;

select em.nome_empresa as empresa, cl.nome_cliente, sum(pd.quantidade_pedido) as qtd_pedido_func
from tb_empresa em
left join tb_beneficio bn
on bn.codigo_empresa = em.codigo_empresa
left join tb_cliente cl
on bn.email_funcionario = cl.email_cliente
left join tb_mesa ms
on ms.id_cliente = cl.id_cliente
left join tb_pedido pd
on pd.codigo_mesa = ms.codigo_mesa
group by em.nome_empresa, cl.nome_cliente
order by qtd_pedido_func desc;

select em.nome_empresa as empresa, count(bn.email_funcionario) as qtd_ped_sobremesa
from tb_empresa em
left join tb_beneficio bn
on bn.codigo_empresa = em.codigo_empresa
left join tb_cliente cl
on bn.email_funcionario = cl.email_cliente
left join tb_mesa ms
on ms.id_cliente = cl.id_cliente
left join tb_pedido pd
on pd.codigo_mesa = ms.codigo_mesa
left join tb_prato pr
on pr.codigo_prato = pd.codigo_prato
left join tb_tipo_prato tp
on tp.codigo_tipo_prato = pr.codigo_tipo_prato
where pr.codigo_tipo_prato = 3
group by em.nome_empresa
order by qtd_ped_sobremesa desc
limit 1;
```

Quantos clientes o restaurante teve desde a abertura?
```sql
select count(*) from tb_cliente;
```

Quantas vezes estes clientes estiveram no restaurante?
```sql
select count(*) from tb_mesa;
```

Quantas vezes estes clientes estiveram no restaurante acompanhados?
```sql
describe tb_mesa;

select count(*) from tb_mesa where num_pessoa_mesa > 1;
```

Qual o período do ano em que o restaurante tem maior movimento?
```sql
select month(data_hora_entrada) as mes, count(*) as total_visitas
from tb_mesa
group by month(data_hora_entrada)
order by total_visitas desc
limit 1;
```

Quantas mesas estão em dupla no dia dos namorados?
```sql
select count(*), year(data_hora_entrada)
from tb_mesa
where num_pessoa_mesa = 2
and day(data_hora_entrada) = 12
and month(data_hora_entrada) = 06
group by 2
order by 2;
```
