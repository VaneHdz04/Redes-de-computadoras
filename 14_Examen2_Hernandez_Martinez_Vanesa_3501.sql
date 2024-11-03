-- Creacion de la tabla 
CREATE DATABASE hernandez_martinez_vanesa_examen;
USE hernandez_martinez_vanesa_examen;

-- Tabla TIENDA
CREATE TABLE tienda(
	id_tienda INT PRIMARY KEY AUTO_INCREMENT,
	nombre_tienda VARCHAR(70) NOT NULL,
	direccion VARCHAR(255) NOT NULL,
	telefono VARCHAR(10) NOT NULL
);

-- Tabla CLIENTE
CREATE TABLE cliente(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
	nombre_cliente VARCHAR(50) NOT NULL,
	email VARCHAR(255) NOT NULL,
	telefono VARCHAR(10) NOT NULL
);

-- Tabla TARJETA PUNTOS
CREATE TABLE tarjeta_puntos(
	id_tarjeta INT PRIMARY KEY,
	id_tienda INT NOT NULL,
	id_cliente INT NOT NULL,
	puntos_acumulados DOUBLE(10,2) NOT NULL,
	fecha_ultima_creacion DATE NOT NULL,
	FOREIGN KEY (id_tienda) REFERENCES tienda (id_tienda),
	FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Tabla TRANSACCIONES 
CREATE TABLE transacciones(
	id_transaccion INT PRIMARY KEY AUTO_INCREMENT,
	id_tarjeta INT NOT NULL,
	monto_compra DOUBLE(10,2) NOT NULL,
	puntos_obtenidos DOUBLE(10,2) NOT NULL,
	fecha_transaccion DATE NOT NULL,
	FOREIGN KEY (id_tarjeta) REFERENCES tarjeta_puntos(id_tarjeta)
);

-- EJERCICIOS 
-- 1 Crea una consulta que muestre los nombres de las tiendas y la cantidad de clientes que tiene cada una.
	SELECT
		t.nombre_tienda AS nombre_tienda,
		(SELECT COUNT(DISTINCT tp.id_cliente)
		 FROM tarjeta_puntos AS tp
		 WHERE tp.id_tienda = t.id_tienda) AS cantidad_clientes
	FROM tienda AS t;
    
    
-- 2 Crea una consulta que muestre el nombre de cada cliente y el monto total de sus compras realizadas en el ultimo mes (30 dias)
	SELECT
		c.nombre_cliente AS nombre_cliente,
		(SELECT SUM(t.monto_compra)
		 FROM transacciones AS t
		 JOIN tarjeta_puntos AS tp ON tp.id_tarjeta = t.id_tarjeta
		 WHERE tp.id_cliente = c.id_cliente 
		   AND t.fecha_transaccion >= CURDATE() - INTERVAL 30 DAY) AS monto_total_compras
	FROM
		cliente AS c;

-- 3 Crea una consulta que muestre el nombre de cada tienda y el monto de ventas generadas en ellas.

SELECT
    ti.nombre_tienda AS nombre_tienda,
    (SELECT SUM(t.monto_compra)
     FROM transacciones AS t
     JOIN tarjeta_puntos AS tp ON tp.id_tarjeta = t.id_tarjeta
     WHERE tp.id_tienda = ti.id_tienda) AS monto_total_ventas
FROM 
    tienda AS ti;


