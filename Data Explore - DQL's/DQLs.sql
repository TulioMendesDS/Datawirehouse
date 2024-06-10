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
