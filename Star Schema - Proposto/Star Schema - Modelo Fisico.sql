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
