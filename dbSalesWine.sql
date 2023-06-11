-- Base de datos
/* Poner en uso base de datos master */
USE master;

/* Si la base de datos ya existe la eliminamos */
DROP DATABASE dbSalesWine;

/* Crear base de datos SalesWine */
CREATE DATABASE dbSalesWine;

/* Poner en uso la base de datos */
USE dbSalesWine;

/* Configurar el formato de fecha */
SET DATEFORMAT dmy
GO

/* Crear tabla persons */
CREATE TABLE persons (
    id int identity(100,1) NOT NULL,
    number_dni char(8) NOT NULL UNIQUE CHECK (number_dni like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    names varchar(60)  NOT NULL,
    last_name varchar(80)  NOT NULL,
    cell_phone char(9) NOT NULL UNIQUE CHECK (cell_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'), 
    email varchar(70) NOT NULL UNIQUE CHECK (email LIKE '%_@%_._%'),
    birthday date NOT NULL CHECK (birthday <= DATEADD(year, -18, GETDATE())), 
    type_person char(1)  NOT NULL CHECK (type_person IN ('C', 'V','J')),
    active char(1) NOT NULL DEFAULT('A') ,
    CONSTRAINT persons_pk PRIMARY KEY  (id),
    CONSTRAINT persons_type_person_allowed CHECK (type_person IN ('C', 'V','J'))
);

-- Insertar datos de estudiantes
INSERT INTO persons (number_dni, names, last_name,cell_phone,email,birthday,type_person)
VALUES
	('15288111','Adriana','Vaquez Carranza','991548789','adriana.vasquez@saleswine.com','18/03/1985','V'),
	('45781236','Carlos','Guerra Tasayco','987845123','carlos.guerra@saleswine.com','28/10/1980','J'),
	('15263698','Daniel','Lombardi Perez','998523641','daniel.lombardig@saleswine.com','06/06/1982','J'),
	('45123698','Roberto','Palacios Castillo','985236417','roberto.palacios@saleswine.com ','15/10/1988','V'),
	('15264477','Carlos','Palomino Fernandez','984512557','carlos.palomino@saleswine.com','30/06/1989','V'),
	('45127966','Fabricio','Rosales Zegarra','974815231','Fabricio@yahoo.com','02/03/1975','C'),
	('15487865','Rosaura','Davila Sanchez','974815254','rosaurao@gmail.com','16/06/1979','C'),
	('46632157','Noemi','Juarez Martinez','984525741','noemi.Juarez@gmail.com','25/07/1979','C'),
	('47258533','Issac','Sanchez Jobs','953625147','issac.sanchez@outlook.com','30/10/1995','C'),
	('15258544','Fabiana','Carrizales Campos','951144235','fabiana.carrizales@outlook.com','05/04/1997','C'),
	('44712214','Valeria','Mendoza Solano','972544681','valeria.mendoza@yahoo.com','06/06/1997','C');

-- Obtener registros ordenados
SELECT 
	id as 'ID',
	number_dni as 'DNI',
	CONCAT(UPPER(last_name), ', ', names) AS 'PERSONA',
	cell_phone as 'CELULAR',
	email as 'EMAIL',
    FORMAT(birthday, 'dd - MMM - yyyy') AS 'FEC. NACIMIENTO',
    CASE 
    WHEN type_person = 'V' THEN 'Vendedor' 
    WHEN type_person = 'C' THEN 'Cliente'
	WHEN type_person = 'J' THEN 'Jefe'
    END AS 'Tipo'
INTO listado_persons
FROM persons;

-- Obtener todos los registros
SELECT * FROM listado_persons;

/* Crear tabla product */
CREATE TABLE product (
    code char(3)  NOT NULL CHECK (code LIKE 'P[0-9][0-9]'),
    names varchar(70)  NOT NULL,
    type char(1)  NOT NULL CHECK (type IN ('V', 'P', 'T', 'W')),
    volume int  NOT NULL CHECK (volume IN (250, 500, 750)),
    country char(1)  NOT NULL CHECK (country IN ('P', 'A', 'C', 'E', 'M')),
    price decimal(6,2)  NOT NULL,
    stock int  NOT NULL,
    status char(1)  NOT NULL CHECK (status IN ('A', 'I')),
    CONSTRAINT product_pk PRIMARY KEY  (code)
);

-- Insertar datos de productos
INSERT INTO dbo.product (code, names, type, volume, country, price, stock, status)
VALUES 
	('P01', 'Ramos Pinto Porto', 'V', 750, 'P', 119.00, 60, 'A'),
	('P02', 'Santa Julia Cabernet', 'V', 750, 'A', 199.00, 45, 'A'),
	('P03', 'Pulenta Estate Cabernet Sauvignon', 'V', 750, 'A', 189.90, 70, 'A'),
	('P04', 'La Rioja Alta Viña Alberdi', 'V', 500, 'E', 540.00, 80, 'A'),
	('P05', 'Amayna Pinot Noir', 'V', 750, 'C', 774.00, 100, 'A'),
	('P06', 'Pisco Don Santiago Mosto Verde Italia', 'P', 750, 'P', 59.00, 75, 'A'),
	('P07', 'Pisco Porton Mosto Verde Torontel', 'P', 750, 'P', 89.00, 100, 'A'),
	('P08', 'Tequila Olmeca Blanco', 'T', 500, 'M', 54.90, 85, 'A'),
	('P09', 'Tequila Olmeca Reposado', 'T', 750, 'M', 54.90, 85, 'A'),
	('P10', 'Black Whiskey Don Michael', 'W', 750, 'P', 159.90, 70, 'A'),
	('P11', 'Whiskey Chivas Regal 12 Años', 'W', 500, 'E', 89.90, 70, 'A');

-- Obtener registros ordenados
SELECT 
    code AS 'CODIGO',
    names AS 'PRODUCTO',
    UPPER(CASE 
        WHEN type = 'V' THEN 'Vino'
        WHEN type = 'P' THEN 'Pisco'
        WHEN type = 'T' THEN 'Tequila'
        WHEN type = 'W' THEN 'Whisky'
    END) AS 'TIPO',
    CONCAT(volume, ' ml.') AS 'VOLUMEN',
    CASE 
        WHEN country = 'P' THEN 'Perú'
        WHEN country = 'A' THEN 'Argentina'
        WHEN country = 'C' THEN 'Chile'
        WHEN country = 'E' THEN 'España'
        WHEN country = 'M' THEN 'México'
    END AS 'PAIS',
    CONCAT('S/', price) AS 'PRECIO',
    stock AS 'STOCK',
    CASE 
        WHEN status = 'A' THEN 'Activo'
        WHEN status = 'I' THEN 'Inactivo'
    END AS 'ESTADO'
INTO listado_products
FROM dbo.product;

-- Obtener todos los registros
SELECT * FROM listado_products;

/* Crear tabla sale */
CREATE TABLE sale (
    id int identity(1,1)  NOT NULL,
    seller_id int  NOT NULL,
    client_id int  NOT NULL,
    date datetime DEFAULT GETDATE() NOT NULL,
    type_pay char(1) CHECK(type_pay IN ('E', 'T', 'Y', 'P')) NOT NULL,
    type_delivery char(1) CHECK(type_delivery IN ('D', 'T')) NOT NULL,
    status char(1) DEFAULT 'A' CHECK(status IN ('A', 'I')) NOT NULL,
    CONSTRAINT sale_pk PRIMARY KEY  (id)
);

-- Insertar datos de Venta
INSERT INTO sale (seller_id, client_id, type_pay, type_delivery)
VALUES
	(100, 105, 'E', 'D'),
	(103, 107, 'T', 'T'),
	(101, 110, 'Y', 'D'),
	(100, 106, 'Y', 'T'),
	(103, 105, 'E', 'T'),
	(100, 109, 'P', 'T'),
	(100, 108, 'T', 'T');

-- Obtener registros ordenados
SELECT 
    s.id AS 'VENTA',
    CONCAT(
        FORMAT(s.date, 'dd-MMM-yy'),
        ' - ',
        FORMAT(s.date, 'HH:mm')
    ) AS 'FEC. VENTA',
    CONCAT(UPPER(pv.last_name), ', ', pv.names) AS 'VENDEDOR',
    CONCAT(UPPER(pc.last_name), ', ', pc.names) AS 'CLIENTE',
    UPPER(CASE
        WHEN s.type_pay = 'E' THEN 'Efectivo'
        WHEN s.type_pay = 'T' THEN 'Tarjeta'
        WHEN s.type_pay = 'Y' THEN 'Yape'
        WHEN s.type_pay = 'P' THEN 'Plin'
    END) AS 'TIPO PAGO',
    CASE
        WHEN s.type_delivery = 'D' THEN 'Delivery'
        WHEN s.type_delivery = 'T' THEN 'Tienda'
    END AS 'TIPO ENTREGA',
    CASE
        WHEN s.status = 'A' THEN 'Activo'
        WHEN s.status = 'I' THEN 'Inactivo'
    END AS 'EST. VENTA'
INTO listado_sale
FROM sale s
JOIN persons pv ON s.seller_id = pv.id
JOIN persons pc ON s.client_id = pc.id;

-- Obtener todos los registros
SELECT * FROM listado_sale;

/* Crear tabla sale_detail */
CREATE TABLE sale_detail (
    id int identity(1,1)  NOT NULL,
    sale_id int  NOT NULL,
    product_code char(3)  NOT NULL,
    amount int  NOT NULL,
    CONSTRAINT sale_detail_pk PRIMARY KEY  (id)
);

-- Insertar datos de Venta Detalle
INSERT INTO sale_detail (sale_id, product_code, amount)
VALUES
    (1, 'P01', 5),
    (1, 'P06', 2),
    (2, 'P01', 2),
    (3, 'P05', 6),
    (3, 'P02', 10),
    (3, 'P03', 15),
    (3, 'P04', 8),
    (4, 'P07', 6),
    (4, 'P01', 12),
    (4, 'P03', 8),
    (4, 'P06', 7),
    (5, 'P08', 6),
    (5, 'P10', 12),
    (6, 'P04', 8),
    (6, 'P02', 4),
    (6, 'P11', 10),
    (6, 'P03', 2),
    (7, 'P04', 6),
    (7, 'P02', 3),
    (7, 'P06', 1);

-- Obtener registros ordenados
SELECT 
    sd.id AS 'ID DETALLE',
    sd.sale_id AS 'ID VENTA',
    p.names AS 'PRODUCTO',
    sd.amount AS 'CANTIDAD'
INTO listado_sale_detail
FROM sale_detail sd
JOIN product p ON sd.product_code = p.code;

-- Obtener todos los registros
SELECT * FROM listado_sale_detail;

-- foreign keys
-- Reference: sale_detail_sale (table: sale_detail)
ALTER TABLE sale_detail ADD CONSTRAINT sale_detail_sale
    FOREIGN KEY (sale_id)
    REFERENCES sale (id)
	ON UPDATE CASCADE 
    ON DELETE CASCADE
GO

-- Reference: sale_persons (table: sale)
ALTER TABLE sale ADD CONSTRAINT sale_seller
    FOREIGN KEY (seller_id)
    REFERENCES persons (id)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
GO

-- Reference: Copy_of_sale_persons (table: sale)
ALTER TABLE sale ADD CONSTRAINT sale_client
    FOREIGN KEY (client_id)
    REFERENCES persons (id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
GO

-- Reference: sale_detail_product (table: sale_detail)
ALTER TABLE sale_detail ADD CONSTRAINT sale_detail_product
    FOREIGN KEY (product_code)
    REFERENCES product (code)
	ON UPDATE CASCADE 
    ON DELETE CASCADE
GO

/* Ver relaciones creadas entre las tablas de la base de datos */
SELECT 
    fk.name AS [Constraint],
    OBJECT_NAME(fk.parent_object_id) AS [Tabla],
    OBJECT_NAME(fk.referenced_object_id) AS [Tabla base]
FROM 
    sys.foreign_keys fk
GO

-- fin