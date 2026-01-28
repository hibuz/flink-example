-- Enable streaming execution mode
SET 'execution.runtime-mode' = 'streaming';
SET 'execution.checkpointing.interval' = '60s';

-- Iceberg JDBC catalog on MySQL; data in MinIO via S3FileIO
CREATE CATALOG lake WITH (
  'type' = 'iceberg',
  'catalog-impl' = 'org.apache.iceberg.jdbc.JdbcCatalog',
  'uri' = 'jdbc:mysql://mysql:3306/iceberg_catalog',
  'jdbc.user' = 'root',
  'jdbc.password' = 'root_pw123!',
  'warehouse' = 's3://iceberg/warehouse',
  'io-impl' = 'org.apache.iceberg.aws.s3.S3FileIO',
  's3.endpoint' = 'http://minio:9000',
  's3.path-style-access' = 'true',
  's3.access-key-id' = 'admin',
  's3.secret-access-key' = 'password!',
  'client.region' = 'us-east-1'
);

USE CATALOG lake;

CREATE DATABASE IF NOT EXISTS demo;

USE demo;

-- CDC sources with streaming configuration
CREATE TABLE mysql_products (
  id INT,
  sku STRING,
  name STRING,
  price DECIMAL(10,3),
  PRIMARY KEY (id) NOT ENFORCED
) WITH (
  'connector' = 'mysql-cdc',
  'hostname' = 'mysql',
  'port' = '3306',
  'username' = 'myuser',
  'password' = 'myuser_pw123!',
  'database-name' = 'mysqldb',
  'table-name' = 'products',
  'scan.incremental.snapshot.enabled' = 'true',
  'scan.startup.mode' = 'initial'
);

CREATE TABLE mysql_orders (
  order_number BIGINT,
  product_id INT,
  quantity INT,
  order_date TIMESTAMP(3),
  PRIMARY KEY (order_number) NOT ENFORCED
) WITH (
  'connector' = 'mysql-cdc',
  'hostname' = 'mysql',
  'port' = '3306',
  'username' = 'myuser',
  'password' = 'myuser_pw123!',
  'database-name' = 'mysqldb',
  'table-name' = 'orders',
  'scan.incremental.snapshot.enabled' = 'true',
  'scan.startup.mode' = 'initial'
);

-- Iceberg targets
CREATE TABLE IF NOT EXISTS products (
  id INT,
  sku STRING,
  name STRING,
  price DECIMAL(10,3),
  PRIMARY KEY (id) NOT ENFORCED
);

CREATE TABLE IF NOT EXISTS orders (
  id BIGINT,
  product_id INT,
  qty INT,
  order_ts TIMESTAMP(3),
  PRIMARY KEY (id) NOT ENFORCED
);

-- Stream into Iceberg
INSERT INTO products SELECT id, sku, name, price FROM mysql_products;
INSERT INTO orders   SELECT order_number, product_id, quantity, order_date FROM mysql_orders;