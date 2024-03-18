drop database Tienda_Computo
CREATE DATABASE Tienda_Computo;
GO

USE Tienda_Computo;
GO

-- Crear la tabla Pais
CREATE TABLE Pais (
    id_pais INT IDENTITY(1,1) PRIMARY KEY,
    nombre_pais NVARCHAR(50) NULL
);

-- Crear la tabla Departamento
CREATE TABLE Departamento (
    id_departamento INT IDENTITY(1,1) PRIMARY KEY,
    nombre_departamento NVARCHAR(50) NULL,
    id_pais INT FOREIGN KEY REFERENCES Pais(id_pais)
);

-- Crear la tabla Provincia
CREATE TABLE Provincia (
    id_provincia INT IDENTITY(1,1) PRIMARY KEY,
    nombre_provincia NVARCHAR(50) NULL,
    id_departamento INT FOREIGN KEY REFERENCES Departamento(id_departamento)
);

-- Crear la tabla Cliente
CREATE TABLE Cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NULL,
    apellido NVARCHAR(50) NULL,
    correo NVARCHAR(70) NULL,
    direccion NVARCHAR(100) NULL,
    telefono NVARCHAR(9) NULL,
    id_provincia INT FOREIGN KEY REFERENCES Provincia(id_provincia)
);

-- Crear la tabla Proveedor
CREATE TABLE Proveedor (
    id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    razon_social NVARCHAR(80) NULL,
    direccion NVARCHAR(100) NULL,
    telefono NVARCHAR(9) NULL,
    correo NVARCHAR(80) NULL,
    url_pagina_web NVARCHAR(100) NULL,
    id_provincia INT FOREIGN KEY REFERENCES Provincia(id_provincia)
);

-- Crear la tabla Categoria
CREATE TABLE Categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria NVARCHAR(50) NULL,
    descripcion_categoria NVARCHAR(150) NULL
);

-- Crear la tabla Marca
CREATE TABLE Marca (
    id_marca INT IDENTITY(1,1) PRIMARY KEY,
    nombre_marca NVARCHAR(50) NULL
);

-- Crear la tabla Inventario
CREATE TABLE Inventario (
    id_inventario INT IDENTITY(1,1) PRIMARY KEY,
    cantidad_producto INT NULL,
    fecha_publicacion DATE NULL
);

-- Crear la tabla Articulo
CREATE TABLE Articulo (
    id_articulo INT IDENTITY(1,1) PRIMARY KEY,
    id_categoria INT FOREIGN KEY REFERENCES Categoria(id_categoria),
    cantidad INT NULL,
    id_marca INT FOREIGN KEY REFERENCES Marca(id_marca),
    precio FLOAT NULL,
    imagen NVARCHAR(50) NULL,
    id_inventario INT FOREIGN KEY REFERENCES Inventario(id_inventario),
    nombre NVARCHAR(50) NULL,
    id_proveedor INT FOREIGN KEY REFERENCES Proveedor(id_proveedor),
    descripcion NVARCHAR(200) NULL
);

-- Crear la tabla Detalle_venta
CREATE TABLE Detalle_venta (
    id_detalle_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_articulo INT FOREIGN KEY REFERENCES Articulo(id_articulo),
    fecha DATE NULL,
    subtotal FLOAT NULL,
    descuento FLOAT NULL,
    impuestos FLOAT NULL
);

-- Crear la tabla Venta
CREATE TABLE Venta (
    id_factura INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT FOREIGN KEY REFERENCES Cliente(id_cliente),
    id_detalle_venta INT FOREIGN KEY REFERENCES Detalle_venta(id_detalle_venta),
    fecha DATE NULL,
    monto_pagado FLOAT NULL,
    tipo_pago NVARCHAR(50) NULL,
    estado_venta NVARCHAR(50) NULL
);

-- Introducción del país
INSERT INTO Pais (nombre_pais) VALUES ('Perú');

-- Introducción del departamento
INSERT INTO Departamento (nombre_departamento, id_pais) VALUES ('Ancash', 1);

-- Insertar las provincias de Ancash
INSERT INTO Provincia (nombre_provincia, id_departamento) VALUES
('Huaraz', 1),
('Carhuaz', 1),
('Casma', 1),
('Huari', 1),
('Santa', 1);

-- Insertar clientes
INSERT INTO Cliente (nombre, apellido, correo, direccion, telefono, id_provincia) VALUES
('Juan', 'Pérez', 'juan@example.com', 'Calle Principal 123', '987654321', 1),
('María', 'Gómez', 'maria@example.com', 'Avenida Central 456', '987654322', 2),
('Carlos', 'López', 'carlos@example.com', 'Plaza Mayor 789', '987654323', 3),
('Laura', 'Martínez', 'laura@example.com', 'Callejón Secreto 1011', '987654324', 4),
('Pedro', 'Rodríguez', 'pedro@example.com', 'Boulevard Norte 1213', '987654325', 5),
('Ana', 'Sánchez', 'ana@example.com', 'Rue de la Rivière 1415', '987654326', 2),
('Sofía', 'Hernández', 'sofia@example.com', 'Via Roma 1617', '987654327', 3),
('Pablo', 'Díaz', 'pablo@example.com', 'Callejón de la Luna 1819', '987654328', 1),
('Elena', 'Torres', 'elena@example.com', 'Hauptstrasse 2021', '987654329', 2),
('Mario', 'Flores', 'mario@example.com', 'Piazza San Marco 2223', '987654330', 5);

-- Introducción de proveedores
INSERT INTO Proveedor (razon_social, direccion, telefono, correo, url_pagina_web, id_provincia) VALUES
('Computadoras World', 'Avenida Principal 123', '987654321', 'info@computadorasworld.com', 'www.computadorasworld.com', 1),
('Tecnología Total', 'Calle Central 456', '987654322', 'info@tecnologiatotal.com', 'www.tecnologiatotal.com', 2),
('Electrónica Estrella', 'Plaza Mayor 789', '987654323', 'info@electronicaestrella.com', 'www.electronicaestrella.com', 3),
('Componentes Excel', 'Boulevard Norte 1011', '987654324', 'info@componentesexcel.com', 'www.componentesexcel.com', 3),
('Redes Rápidas', 'Rue de la Rivière 1213', '987654325', 'info@redesrapidas.com', 'www.redesrapidas.com', 5),
('Accesorios Avanzados', 'Via Roma 1415', '987654326', 'info@accesoriosavanzados.com', 'www.accesoriosavanzados.com', 5),
('Hardware Innovador', 'Callejón de la Luna 1617', '987654327', 'info@hardwareinnovador.com', 'www.hardwareinnovador.com', 5),
('Impresoras Inteligentes', 'Hauptstrasse 1819', '987654328', 'info@impresorasinteligentes.com', 'www.impresorasinteligentes.com', 2),
('Tecnología y Más', 'Piazza San Marco 2021', '987654329', 'info@tecnologiaymas.com', 'www.tecnologiaymas.com', 3),
('Soluciones Informáticas', 'Rathausplatz 2223', '987654330', 'info@solucionesinformaticas.com', 'www.solucionesinformaticas.com', 5);

-- Insertar categorías
INSERT INTO Categoria (nombre_categoria, descripcion_categoria) VALUES
('Laptops', 'Computadoras portátiles'),
('Computadoras de escritorio', 'Computadoras para uso en escritorio'),
('Accesorios', 'Periféricos y otros accesorios para computadoras'),
('Componentes de hardware', 'Partes internas de las computadoras, como procesadores, tarjetas gráficas, etc.'),
('Periféricos', 'Dispositivos adicionales para complementar las computadoras, como impresoras, escáneres, etc.');

-- Insertar marcas 
INSERT INTO Marca (nombre_marca) VALUES
('HP'),
('Dell'),
('Lenovo'),
('Apple'),
('Asus'),
('Acer'),
('Samsung'),
('Microsoft'),
('Sony'),
('Toshiba');

-- Insertar registros de inventario ficticios
INSERT INTO Inventario (cantidad_producto, fecha_publicacion) VALUES
(50, '2023-01-15'),
(30, '2023-02-20'),
(20, '2023-03-10'),
(40, '2023-04-05'),
(60, '2023-05-18'),
(25, '2023-06-22'),
(35, '2023-07-11'),
(45, '2023-08-30'),
(55, '2023-09-14'),
(15, '2023-10-25');

-- Insertar productos ficticios
INSERT INTO Articulo (id_categoria, cantidad, id_marca, precio, imagen, id_inventario, nombre, id_proveedor, descripcion) VALUES
(1, 55, 1, 999.99, 'producto1.jpg', 9,'Laptop HP Pavilion', 10,'Laptop HP de alta calidad con pantalla táctil de 15.6 pulgadas y procesador Intel Core i7.' ),
(2, 50, 2, 799.99, 'producto2.jpg', 1,'PC de Escritorio Dell Inspiron', 1,'Computadora de escritorio Dell con procesador Intel Core i5 y 8GB de RAM.' ),
(3, 35, 5, 149.99, 'producto3.jpg', 7,'Teclado mecánico Corsair K70', 6,'Teclado mecánico retroiluminado con interruptores Cherry MX y teclas programables.'),
(3, 55, 7, 49.99, 'producto4.jpg', 9,'Ratón inalámbrico Logitech MX Master', 6,'Ratón inalámbrico con sensor láser de alta precisión y hasta 40 días de duración de la batería.'),
(3, 60, 5, 199.99, 'producto5.jpg', 5,'Monitor ASUS 27 pulgadas', 7,'Monitor de alta definición con tecnología IPS y frecuencia de actualización de 144Hz.'),
(4, 60, 5, 299.99, 'producto6.jpg', 5,'Tarjeta gráfica NVIDIA GeForce RTX 3060', 7,'Tarjeta gráfica de última generación con 12GB de memoria GDDR6 y ray tracing en tiempo real.'),
(5, 60, 1, 99.99, 'producto7.jpg', 5,'Impresora HP Deskjet 3755', 8,'Impresora todo-en-uno compacta con conectividad inalámbrica y compatible con impresión desde dispositivos móviles.'),
(4, 40, 7, 249.99, 'producto8.jpg', 4,'Disco duro externo Seagate Backup Plus', 7,'Disco duro externo de 2TB con conectividad USB 3.0 y copia de seguridad automática.'),
(5, 30, 6, 39.99, 'producto9.jpg', 2,'Router inalámbrico TP-Link Archer C7', 5,'Router de doble banda con velocidad de hasta 1750Mbps y tecnología Beamforming para una conexión estable.'),
(4, 25, 8, 179.99, 'producto10.jpg', 6,'Software Microsoft Office 365', 4,'Suite de productividad que incluye Word, Excel, PowerPoint, Outlook y más, con suscripción anual.'),
(4, 40, 7, 499.99, 'producto11.jpg', 4,'Disco SSD Samsung 1TB', 7,'Unidad de estado sólido de 1TB con velocidad de lectura/escritura rápida y durabilidad mejorada.'),
(4, 30, 6, 149.99, 'producto12.jpg', 2,'Memoria RAM Corsair Vengeance RGB', 10,'Módulo de memoria DDR4 de 16GB con iluminación RGB personalizable y rendimiento optimizado.'),
(3, 55, 7, 29.99, 'producto13.jpg', 9,'Webcam Logitech C920 HD Pro', 10,'Cámara web HD con resolución de 1080p y corrección automática de iluminación.'),
(5, 60, 3, 599.99, 'producto14.jpg', 5,'Smart TV Sony Bravia 55 pulgadas', 7,'Televisor inteligente con resolución 4K HDR y sistema operativo Android TV para acceder a aplicaciones y servicios de transmisión.'),
(3, 15, 10, 129.99, 'producto15.jpg', 10,'Auriculares inalámbricos Bose QuietComfort 35 II', 6,'Auriculares con cancelación de ruido activa, conexión Bluetooth y hasta 20 horas de duración de la batería.');

-- Insertar registros en Detalle_venta
INSERT INTO Detalle_venta (id_articulo, fecha, subtotal, descuento, impuestos) VALUES
(5,'2023-01-15', 199.99, 10.00, 20.00),
(6,'2023-01-20', 299.99, 15.00, 30.00),
(7,'2023-02-05', 99.99, 5.00, 10.00),
(11,'2023-02-10', 499.99, 25.00, 50.00),
(8,'2023-02-18', 399.99, 20.00, 40.00),
(3,'2023-03-02', 149.99, 7.50, 15.00),
(14,'2023-03-15', 599.99, 30.00, 60.00),
(4,'2023-03-20', 79.99, 4.00, 8.00),
(11,'2023-04-05', 349.99, 17.50, 35.00),
(8,'2023-04-10', 249.99, 12.50, 25.00);

-- Insertar registros ficticios en Venta
INSERT INTO Venta (id_cliente, id_detalle_venta, fecha, monto_pagado, tipo_pago, estado_venta) VALUES
(5,1,'2023-01-15', 199.99, 'Tarjeta de crédito', 'Completada'),
(7,2,'2023-01-20', 299.99, 'Efectivo', 'Completada'),
(1,3,'2023-02-05', 99.99, 'Transferencia bancaria', 'Completada'),
(3,4,'2023-02-10', 499.99, 'Tarjeta de débito', 'Completada'),
(9,5,'2023-02-18', 399.99, 'Efectivo', 'Pendiente'),
(2,6,'2023-03-02', 149.99, 'Tarjeta de crédito', 'Completada'),
(10,7,'2023-03-15', 599.99, 'Transferencia bancaria', 'Completada'),
(6,8,'2023-03-20', 79.99, 'Efectivo', 'Completada'),
(8,9,'2023-04-05', 349.99, 'Tarjeta de débito', 'Pendiente'),
(4,10,'2023-04-10', 249.99, 'Efectivo', 'Completada');



----------------------------------------------------------------------------------------------------------------------------------
-- Procedimiento para mostrar información de todos los países incluyendo información relacionada
CREATE PROCEDURE MostrarPaises
AS
BEGIN
    -- Selecciona todos los registros de la tabla Pais y la información relacionada
    SELECT 
        P.*,
        D.nombre_departamento AS departamento_relacionado,
        P2.nombre_pais AS pais_relacionado
    FROM 
        Pais P
    LEFT JOIN 
        Departamento D ON P.id_pais = D.id_pais
    LEFT JOIN 
        Pais P2 ON D.id_pais = P2.id_pais;
END;

-- Procedimiento para mostrar información de todos los departamentos incluyendo información relacionada
CREATE PROCEDURE MostrarDepartamentos
AS
BEGIN
    -- Selecciona todos los registros de la tabla Departamento y la información relacionada
    SELECT 
        D.*,
        P.nombre_pais AS pais_relacionado
    FROM 
        Departamento D
    LEFT JOIN 
        Pais P ON D.id_pais = P.id_pais;
END;

-- Procedimiento para mostrar información de todas las provincias incluyendo información relacionada
CREATE PROCEDURE MostrarProvincias
AS
BEGIN
    -- Selecciona todos los registros de la tabla Provincia y la información relacionada
    SELECT 
        Pr.*,
        D.nombre_departamento AS departamento_relacionado,
        P.nombre_pais AS pais_relacionado
    FROM 
        Provincia Pr
    LEFT JOIN 
        Departamento D ON Pr.id_departamento = D.id_departamento
    LEFT JOIN 
        Pais P ON D.id_pais = P.id_pais;
END;

-- Procedimiento para mostrar información de todos los clientes incluyendo información relacionada
CREATE PROCEDURE MostrarClientes
AS
BEGIN
    -- Selecciona todos los registros de la tabla Cliente y la información relacionada
    SELECT 
        C.*,
        Pr.nombre_provincia AS provincia_relacionada,
        D.nombre_departamento AS departamento_relacionado,
        P.nombre_pais AS pais_relacionado
    FROM 
        Cliente C
    LEFT JOIN 
        Provincia Pr ON C.id_provincia = Pr.id_provincia
    LEFT JOIN 
        Departamento D ON Pr.id_departamento = D.id_departamento
    LEFT JOIN 
        Pais P ON D.id_pais = P.id_pais;
END;

-- Procedimiento para mostrar información de todos los proveedores incluyendo información relacionada
CREATE PROCEDURE MostrarProveedores
AS
BEGIN
    -- Selecciona todos los registros de la tabla Proveedor y la información relacionada
    SELECT 
        Pv.*,
        Pr.nombre_provincia AS provincia_relacionada,
        D.nombre_departamento AS departamento_relacionado,
        P.nombre_pais AS pais_relacionado
    FROM 
        Proveedor Pv
    LEFT JOIN 
        Provincia Pr ON Pv.id_provincia = Pr.id_provincia
    LEFT JOIN 
        Departamento D ON Pr.id_departamento = D.id_departamento
    LEFT JOIN 
        Pais P ON D.id_pais = P.id_pais;
END;


---------------------------------------------------------------------------------------------------------------------------------------
-- Procedimiento para guardar un nuevo país
CREATE PROCEDURE GuardarPais
    @nombre_pais NVARCHAR(50) -- Nombre del país a guardar
AS
BEGIN
    -- Inserta un nuevo país en la tabla Pais
    INSERT INTO Pais (nombre_pais) VALUES (@nombre_pais);
END;

-- Procedimiento para guardar un nuevo departamento
CREATE PROCEDURE GuardarDepartamento
    @nombre_departamento NVARCHAR(50), -- Nombre del departamento a guardar
    @id_pais INT -- ID del país al que pertenece el departamento
AS
BEGIN
    -- Inserta un nuevo departamento en la tabla Departamento
    INSERT INTO Departamento (nombre_departamento, id_pais) VALUES (@nombre_departamento, @id_pais);
END;

-- Procedimiento para guardar una nueva provincia
CREATE PROCEDURE GuardarProvincia
    @nombre_provincia NVARCHAR(50), -- Nombre de la provincia a guardar
    @id_departamento INT -- ID del departamento al que pertenece la provincia
AS
BEGIN
    -- Inserta una nueva provincia en la tabla Provincia
    INSERT INTO Provincia (nombre_provincia, id_departamento) VALUES (@nombre_provincia, @id_departamento);
END;

-- Procedimiento para guardar un nuevo cliente
CREATE PROCEDURE GuardarCliente
    @nombre NVARCHAR(50), -- Nombre del cliente
    @apellido NVARCHAR(50), -- Apellido del cliente
    @correo NVARCHAR(70), -- Correo electrónico del cliente
    @direccion NVARCHAR(100), -- Dirección del cliente
    @telefono NVARCHAR(9), -- Teléfono del cliente
    @id_provincia INT -- ID de la provincia del cliente
AS
BEGIN
    -- Inserta un nuevo cliente en la tabla Cliente
    INSERT INTO Cliente (nombre, apellido, correo, direccion, telefono, id_provincia) 
    VALUES (@nombre, @apellido, @correo, @direccion, @telefono, @id_provincia);
END;

-- Procedimiento para guardar un nuevo proveedor
CREATE PROCEDURE GuardarProveedor
    @razon_social NVARCHAR(80), -- Razón social del proveedor
    @direccion NVARCHAR(100), -- Dirección del proveedor
    @telefono NVARCHAR(9), -- Teléfono del proveedor
    @correo NVARCHAR(80), -- Correo electrónico del proveedor
    @url_pagina_web NVARCHAR(100), -- URL de la página web del proveedor
    @id_provincia INT -- ID de la provincia del proveedor
AS
BEGIN
    -- Inserta un nuevo proveedor en la tabla Proveedor
    INSERT INTO Proveedor (razon_social, direccion, telefono, correo, url_pagina_web, id_provincia) 
    VALUES (@razon_social, @direccion, @telefono, @correo, @url_pagina_web, @id_provincia);
END;

----------------------------------------------------------------------------------------------------------------------------------------

-- Procedimiento para modificar un país existente
CREATE PROCEDURE ModificarPais
    @id_pais INT, -- ID del país a modificar
    @nombre_pais NVARCHAR(50) -- Nuevo nombre del país
AS
BEGIN
    -- Actualiza el nombre del país en la tabla Pais
    UPDATE Pais SET nombre_pais = @nombre_pais WHERE id_pais = @id_pais;
END;


-- Procedimiento para modificar un departamento existente
CREATE PROCEDURE ModificarDepartamento
    @id_departamento INT, -- ID del departamento a modificar
    @nombre_departamento NVARCHAR(50) -- Nuevo nombre del departamento
AS
BEGIN
    -- Actualiza el nombre del departamento en la tabla Departamento
    UPDATE Departamento SET nombre_departamento = @nombre_departamento WHERE id_departamento = @id_departamento;
END;


-- Procedimiento para modificar una provincia existente
CREATE PROCEDURE ModificarProvincia
    @id_provincia INT, -- ID de la provincia a modificar
    @nombre_provincia NVARCHAR(50) -- Nuevo nombre de la provincia
AS
BEGIN
    -- Actualiza el nombre de la provincia en la tabla Provincia
    UPDATE Provincia SET nombre_provincia = @nombre_provincia WHERE id_provincia = @id_provincia;
END;

-- Procedimiento para modificar un cliente existente
CREATE PROCEDURE ModificarCliente
    @id_cliente INT, -- ID del cliente a modificar
    @nombre NVARCHAR(50), -- Nuevo nombre del cliente
    @apellido NVARCHAR(50), -- Nuevo apellido del cliente
    @correo NVARCHAR(70), -- Nuevo correo electrónico del cliente
    @direccion NVARCHAR(100), -- Nueva dirección del cliente
    @telefono NVARCHAR(9), -- Nuevo teléfono del cliente
    @id_provincia INT -- Nuevo ID de la provincia del cliente
AS
BEGIN
    -- Actualiza la información del cliente en la tabla Cliente
    UPDATE Cliente SET 
        nombre = @nombre,
        apellido = @apellido,
        correo = @correo,
        direccion = @direccion,
        telefono = @telefono,
        id_provincia = @id_provincia
    WHERE id_cliente = @id_cliente;
END;

-- Procedimiento para modificar un proveedor existente
CREATE PROCEDURE ModificarProveedor
    @id_proveedor INT, -- ID del proveedor a modificar
    @razon_social NVARCHAR(80), -- Nueva razón social del proveedor
    @direccion NVARCHAR(100), -- Nueva dirección del proveedor
    @telefono NVARCHAR(9), -- Nuevo teléfono del proveedor
    @correo NVARCHAR(80), -- Nuevo correo electrónico del proveedor
    @url_pagina_web NVARCHAR(100), -- Nueva URL de la página web del proveedor
    @id_provincia INT -- Nuevo ID de la provincia del proveedor
AS
BEGIN
    -- Actualiza la información del proveedor en la tabla Proveedor
    UPDATE Proveedor SET 
        razon_social = @razon_social,
        direccion = @direccion,
        telefono = @telefono,
        correo = @correo,
        url_pagina_web = @url_pagina_web,
        id_provincia = @id_provincia
    WHERE id_proveedor = @id_proveedor;
END;
-------------------------------------------------------------------------------------------------------------------------

-- Procedimiento para eliminar un país
CREATE PROCEDURE EliminarPais
    @id_pais INT -- ID del país a eliminar
AS
BEGIN
    -- Elimina el país de la tabla Pais
    DELETE FROM Pais WHERE id_pais = @id_pais;
END;


-- Procedimiento para eliminar un departamento
CREATE PROCEDURE EliminarDepartamento
    @id_departamento INT -- ID del departamento a eliminar
AS
BEGIN
    -- Elimina el departamento de la tabla Departamento
    DELETE FROM Departamento WHERE id_departamento = @id_departamento;
END;


-- Procedimiento para eliminar una provincia
CREATE PROCEDURE EliminarProvincia
    @id_provincia INT -- ID de la provincia a eliminar
AS
BEGIN
    -- Elimina la provincia de la tabla Provincia
    DELETE FROM Provincia WHERE id_provincia = @id_provincia;
END;

-- Procedimiento para eliminar un cliente
CREATE PROCEDURE EliminarCliente
    @id_cliente INT -- ID del cliente a eliminar
AS
BEGIN
    -- Elimina el cliente de la tabla Cliente
    DELETE FROM Cliente WHERE id_cliente = @id_cliente;
END;


-- Procedimiento para eliminar un proveedor
CREATE PROCEDURE EliminarProveedor
    @id_proveedor INT -- ID del proveedor a eliminar
AS
BEGIN
    -- Elimina el proveedor de la tabla Proveedor
    DELETE FROM Proveedor WHERE id_proveedor = @id_proveedor;
END;













/*
--7. Crear un procedimiento almacenado sin parámetros
CREATE PROCEDURE ObtenerClientes
AS
BEGIN
    SELECT *
    FROM Cliente;
END;

EXECUTE ObtenerClientes
--6. Crear una vista para mostrar el detalle de las ventas completadas
CREATE VIEW VistaVentasCompletadas
AS
SELECT
    v.id_factura,
    v.fecha,
    v.monto_pagado,
    v.tipo_pago,
    v.estado_venta,
    c.Nombre AS nombre_cliente
FROM Venta v
JOIN
    Cliente c ON v.id_cliente = c.id_cliente
WHERE
    v.estado_venta = 'Completada';

SELECT*FROM VistaVentasCompletadas

--1. Creamos un procedure para guardar en la tabla Marca.
SELECT*FROM Proveedor
CREATE PROCEDURE guardar_marca
@nmar VARCHAR (50)
AS
BEGIN
INSERT INTO Marca (nombre_marca) VALUES ( @nmar)
END

execute guardar_marca  'MSI'

--2. Creamos un procedure para guardar en la tabla Cliente.
CREATE PROCEDURE guardar_cliente
@nmar VARCHAR (50),
@apelli VARCHAR(50),
@corre VARCHAR(50),
@direc VARCHAR(50),
@telefono INT ,
@provin INT

AS
BEGIN
INSERT INTO Cliente(
				nombre,
				apellido, 
				correo, 
				direccion, 
				telefono, 
				id_provincia
				) VALUES ( 
				@nmar, 
				@apelli, 
				@corre, 
				@direc, 
				@telefono, 
				@provin)
END

execute guardar_cliente 'Daniel', 'Cordova', 
'dani123@gmail.com', 'Garatea 579','946813654', '5';

SELECT*FROM Marca


--3. Creamos un procedure para actualizar la tabla 
CREATE PROCEDURE Actualizar_marca
@id_marca int,
@nombre_marca VARCHAR(50)

AS
BEGIN
UPDATE Marca SET nombre_marca=@nombre_marca WHERE id_marca=@id_marca
END


EXECUTE Actualizar_marca 9, 'GIGABYTE'


--4. Creamos un procedure para eliminar la tabla Articulo
CREATE PROCEDURE eliminar_articulo
@id_articulo int
AS
BEGIN 
DELETE FROM Articulo WHERE id_articulo=@id_articulo
END


EXECUTE eliminar_articulo 2

SELECT*FROM Inventario

--5. Creamos un procedure para la tabla Inventar io
CREATE PROCEDURE eliminar_inventario
@id_inventario int
AS
BEGIN 
DELETE FROM Inventario WHERE id_inventario=@id_inventario
END


EXECUTE eliminar_inventario 3*/