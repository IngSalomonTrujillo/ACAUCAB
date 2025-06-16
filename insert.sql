-- 
-- ########              CATÁLOGOS PRINCIPALES               ########

-- Insertar Datos Geográficos (Lugar)
-- COLUMNAS CORREGIDAS: nombre, tipo
INSERT INTO Lugar (lugar_id, nombre, tipo, lugar_lugar_id) VALUES
(1, 'Venezuela', 'País', NULL),
(10, 'Distrito Capital', 'Estado', 1),
(11, 'Miranda', 'Estado', 1),
(12, 'Zulia', 'Estado', 1),
(100, 'Libertador', 'Municipio', 10),
(110, 'Baruta', 'Municipio', 11),
(111, 'Chacao', 'Municipio', 11),
(120, 'Maracaibo', 'Municipio', 12),
(1000, 'Catedral', 'Parroquia', 100),
(1001, 'El Recreo', 'Parroquia', 100),
(1100, 'Nuestra Señora del Rosario', 'Parroquia', 110),
(1110, 'Chacao', 'Parroquia', 111),
(1200, 'Olegario Villalobos', 'Parroquia', 120);

-- Tipos de Cerveza
-- COLUMNAS CORREGIDAS: nombre, descripcion
INSERT INTO Tipo_Cerveza (tipo_cerveza_id, nombre, descripcion) VALUES
(1, 'Indian Pale Ale (IPA)', 'Cerveza de alta fermentación, amarga y aromática.'),
(2, 'Stout', 'Cerveza oscura, de sabor a malta tostada, café y chocolate.'),
(3, 'Lager', 'Cerveza de baja fermentación, ligera y refrescante.'),
(4, 'Trigo (Hefeweizen)', 'Cerveza de trigo, con notas a banana y clavo.'),
(5, 'Porter', 'Cerveza oscura similar a la Stout pero generalmente menos fuerte.');

-- Estatus para Ventas y Compras
-- COLUMNAS CORREGIDAS: nombre, descripcion
INSERT INTO Estatus (estatus_id, nombre, descripcion) VALUES
(1, 'Solicitada', 'La orden ha sido creada por el cliente.'),
(2, 'Procesando', 'La orden está siendo preparada.'),
(3, 'Enviada', 'La orden ha sido despachada.'),
(4, 'Completada', 'La orden ha sido recibida por el cliente.'),
(5, 'Cancelada', 'La orden ha sido cancelada.'),
(6, 'Pendiente de Pago', 'Esperando la confirmación del pago.'),
(7, 'Pagada', 'El pago ha sido recibido.'),
(8, 'Recibida', 'La compra a proveedor ha sido recibida en almacén.');

-- Roles de Usuario (Esta tabla estaba correcta)
INSERT INTO Rol (rol_id, nombre_rol, descripcion_rol) VALUES
(1, 'Administrador', 'Acceso total al sistema.'),
(2, 'Gerente de Tienda', 'Gestiona inventario, ventas y empleados.'),
(3, 'Vendedor', 'Registra ventas y atiende a clientes.'),
(4, 'Cliente', 'Realiza compras online y consulta historial.');

-- Tipos de Cliente
-- COLUMNAS CORREGIDAS: nombre, descripcion
INSERT INTO Tipo_Cliente (tipo_cliente_id, nombre, descripcion) VALUES
(1, 'Persona Natural', 'Cliente individual.'),
(2, 'Persona Jurídica', 'Cliente corporativo, como un bar o restaurante.');

-- Membresia
-- COLUMNAS CORREGIDAS: nombre, costo, descripcion
INSERT INTO Membresia (membresia_id, nombre, costo, descripcion) VALUES
(1, 'ACAUCAB Fan', 5.00, 'Acceso a eventos y 5% de descuento.'),
(2, 'ACAUCAB Pro', 15.00, 'Acceso prioritario, 15% de descuento y merchandising exclusivo.');

-- Otros Catálogos (Se verificaron y corrigieron según el PDF)
INSERT INTO Presentacion (presentacion_id, descripcion, volumen_ml) VALUES
(1, 'Botella 355ml', 355),
(2, 'Lata 473ml', 473),
(3, 'Barril 20L', 20000),
(4, 'Botella 660ml', 660),
(5, 'Lata 355ml', 355);

INSERT INTO Color (color_id, nombre_color) VALUES
(1, 'Negro'), (2, 'Blanco'), (3, 'Azul'), (4, 'Rojo'), (5, 'Verde');

INSERT INTO Beneficio (beneficio_id, nombre_beneficio, descripción_beneficio) VALUES
(1, 'Descuento 5%', '5% de descuento en todas las cervezas.'),
(2, 'Descuento 15%', '15% de descuento en toda la tienda.'),
(3, 'Envío Gratis', 'Envío gratis en compras online.'),
(4, 'Acceso a Eventos', 'Invitación a catas y eventos especiales.'),
(5, 'Merchandising Exclusivo', 'Acceso a compra de mercancía solo para miembros.');


-- 
-- ########                 ENTIDADES PRINCIPALES              ########
-- 

-- Usuarios
-- COLUMNAS CORREGIDAS: nombre, correo, contraseña
INSERT INTO Usuario (usuario_id, nombre, correo, contraseña, Rol_rol_id) VALUES
(1, 'admin', 'admin@acaucab.com', 'hash_contrasena_admin', 1),
(2, 'gerente_tienda_1', 'gerente1@acaucab.com', 'hash_contrasena_gerente', 2),
(3, 'vendedor_tienda_1', 'vendedor1@acaucab.com', 'hash_contrasena_vendedor', 3);

-- Proveedores (20 registros)
-- COLUMNA CORREGIDA: nombre
INSERT INTO Proveedor (proveedor_id, nombre, rif, telefono, direccion, Lugar_lugar_id) VALUES
(1, 'Maltas y Lúpulos C.A.', 'J-29542789-1', '0412-1112233', 'Av. Principal de los Cortijos', 1001),
(2, 'Distribuidora Levadura del Este', 'J-30123456-7', '0414-4445566', 'Calle El Progreso, Chacao', 1110),
(3, 'Botellas y Tapas Zulianas', 'J-40555666-8', '0416-7778899', 'Av. 5 de Julio, Maracaibo', 1200),
(4, 'Insumos Cerveceros de Venezuela', 'J-12345678-9', '0212-9876543', 'Zona Industrial de Baruta', 1100),
(5, 'Lúpulos Andinos', 'J-98765432-1', '0424-1234567', 'Av. Las Américas', 10),
(6, 'Cebada Nacional', 'J-23456789-0', '0412-2345678', 'Carretera Nacional', 11),
(7, 'Equipos de Birra', 'J-34567890-1', '0414-3456789', 'Calle Los Industriales', 10),
(8, 'Vidrios de Occidente', 'J-45678901-2', '0416-4567890', 'Zona Industrial, Maracaibo', 120),
(9, 'Agua Pura Manantial', 'J-56789012-3', '0426-5678901', 'El Hatillo', 110),
(10, 'Etiquetas Express', 'J-67890123-4', '0212-6789012', 'Boleíta Sur', 100),
(11, 'Servicios de Refrigeración C.A.', 'J-78901234-5', '0412-7890123', 'Los Ruices', 100),
(12, 'Transporte y Logística Rápida', 'J-89012345-6', '0414-8901234', 'La Trinidad', 110),
(13, 'Marketing Cervecero 360', 'J-90123456-7', '0416-9012345', 'Las Mercedes', 110),
(14, 'Cajas y Empaques Nacionales', 'J-01234567-8', '0424-0123456', 'El Llanito', 100),
(15, 'Consultores de Calidad', 'J-11223344-5', '0212-1122334', 'Altamira', 111),
(16, 'Uniformes Corporativos', 'J-22334455-6', '0412-2233445', 'Sabana Grande', 1001),
(17, 'Seguridad Industrial Cervecería', 'J-33445566-7', '0414-3344556', 'Prados del Este', 110),
(18, 'Granos Importados S.A.', 'J-44556677-8', '0416-4455667', 'La Castellana', 1110),
(19, 'Innovación en Fermentación', 'J-55667788-9', '0426-5566778', 'San Román', 110),
(20, 'Barriles de Acero Inoxidable', 'J-66778899-0', '0212-6677889', 'La Boyera', 110);

-- Clientes (40 registros)
-- COLUMNAS CORREGIDAS: nombre_cliente, apellido_cliente
INSERT INTO Cliente (cliente_id, nombre_cliente, apellido_cliente, cedula_rif, telefono, correo, tipo_cliente_id, lugar_lugar_id, membresia_membresia_id, usuario_usuario_id) VALUES
(1, 'Carlos', 'Pérez', 'V-15123456', '0412-9876543', 'carlos.perez@email.com', 1, 1001, 1, NULL),
(2, 'Ana', 'García', 'V-18765432', '0414-1234567', 'ana.garcia@email.com', 1, 1100, 2, NULL),
(3, 'Luis', 'Martínez', 'V-20555888', '0416-5554433', 'luis.martinez@email.com', 1, 1110, 1, NULL),
(4, 'Maria', 'Rodriguez', 'V-12345678', '0424-8765432', 'maria.r@email.com', 1, 1200, NULL, NULL),
(5, 'Pedro', 'Gomez', 'V-11223344', '0412-1122334', 'pedro.gomez@email.com', 1, 1000, 1, NULL),
(6, 'Laura', 'Sanchez', 'V-22334455', '0414-2233445', 'laura.sanchez@email.com', 1, 1100, 2, NULL),
(7, 'Andres', 'Hernandez', 'V-13456789', '0416-1345678', 'andres.h@email.com', 1, 1110, NULL, NULL),
(8, 'Sofia', 'Torres', 'V-24567890', '0424-2456789', 'sofia.t@email.com', 1, 1200, 1, NULL),
(9, 'Diego', 'Ramirez', 'V-14567890', '0412-1456789', 'diego.r@email.com', 1, 1001, NULL, NULL),
(10, 'Valentina', 'Flores', 'V-25678901', '0414-2567890', 'valentina.f@email.com', 1, 1100, 2, NULL),
(11, 'Javier', 'Acosta', 'V-15678901', '0416-1567890', 'javier.a@email.com', 1, 1000, 1, NULL),
(12, 'Camila', 'Rojas', 'V-26789012', '0424-2678901', 'camila.r@email.com', 1, 1200, NULL, NULL),
(13, 'Ricardo', 'Blanco', 'V-16789012', '0412-1678901', 'ricardo.b@email.com', 1, 1110, 1, NULL),
(14, 'Isabella', 'Moreno', 'V-27890123', '0414-2789012', 'isabella.m@email.com', 1, 1001, 2, NULL),
(15, 'Gabriel', 'Suarez', 'V-17890123', '0416-1789012', 'gabriel.s@email.com', 1, 1100, NULL, NULL),
(16, 'Daniela', 'Jimenez', 'V-28901234', '0424-2890123', 'daniela.j@email.com', 1, 1200, 1, NULL),
(17, 'Mateo', 'Díaz', 'V-18901234', '0412-1890123', 'mateo.d@email.com', 1, 1000, 1, NULL),
(18, 'Victoria', 'Peña', 'V-29012345', '0414-2901234', 'victoria.p@email.com', 1, 1110, 2, NULL),
(19, 'Sebastián', 'Castillo', 'V-19012345', '0416-1901234', 'sebastian.c@email.com', 1, 1001, NULL, NULL),
(20, 'Luciana', 'Mora', 'V-21098765', '0424-2109876', 'luciana.m@email.com', 1, 1200, 1, NULL),
(21, 'Bodegón La Esquina', NULL, 'J-40111222-3', '0212-5551111', 'compras@bodegonlaesquina.com', 2, 1110, NULL, NULL),
(22, 'Restaurante El Buen Sabor', NULL, 'J-40222333-4', '0212-6662222', 'gerencia@buensabor.com', 2, 1100, NULL, NULL),
(23, 'Bar Nocturno C.A.', NULL, 'J-40333444-5', '0212-7773333', 'pedidos@barnocturno.com', 2, 1001, NULL, NULL),
(24, 'Distribuidora Licores Central', NULL, 'J-40444555-6', '0212-8884444', 'licorescentral@email.com', 2, 1200, NULL, NULL),
(25, 'Hotel Plaza Real', NULL, 'J-50111222-3', '0212-5011122', 'alimentos@hotelplazareal.com', 2, 1110, NULL, NULL),
(26, 'Tascalab', NULL, 'J-50222333-4', '0212-5022233', 'compras@tascalab.com', 2, 1100, NULL, NULL),
(27, 'Club Social La Montaña', NULL, 'J-50333444-5', '0212-5033344', 'bar@clublamontana.com', 2, 1100, NULL, NULL),
(28, 'Supermercado El Ahorro', NULL, 'J-50444555-6', '0212-5044455', 'bebidas@elahorro.com', 2, 1001, NULL, NULL),
(29, 'Catering Services VIP', NULL, 'J-50555666-7', '0212-5055566', 'eventos@cateringservices.com', 2, 1110, NULL, NULL),
(30, 'Pizzeria La Nostra', NULL, 'J-50666777-8', '0212-5066677', 'lanostrapizza@email.com', 2, 1000, NULL, NULL),
(31, 'Centro de Eventos Metropolitano', NULL, 'J-50777888-9', '0212-5077788', 'logistica@eventosmetro.com', 2, 1110, NULL, NULL),
(32, 'Licorería El Gato Negro', NULL, 'J-50888999-0', '0212-5088899', 'gatonegro@email.com', 2, 1200, NULL, NULL),
(33, 'Casino Fortuna', NULL, 'J-50999000-1', '0212-5099900', 'barmanager@fortunacasino.com', 2, 1110, NULL, NULL),
(34, 'Gourmet Market', NULL, 'J-51000111-2', '0212-5100011', 'gourmetmarket@email.com', 2, 1100, NULL, NULL),
(35, 'La Casa del Cervecero', NULL, 'J-51111222-3', '0212-5111122', 'pedidos@casacervecero.com', 2, 1001, NULL, NULL),
(36, 'Bar & Grill El Fogonazo', NULL, 'J-51222333-4', '0212-5122233', 'elfogonazo@email.com', 2, 1110, NULL, NULL),
(37, 'Teatro Municipal de Chacao', NULL, 'J-51333444-5', '0212-5133344', 'concesiones@teatrochacao.com', 2, 1110, NULL, NULL),
(38, 'Eventos Corporativos Premier', NULL, 'J-51444555-6', '0212-5144455', 'premier@email.com', 2, 1100, NULL, NULL),
(39, 'Club de Golf Valle Arriba', NULL, 'J-51555666-7', '0212-5155566', 'social@vallearriba.com', 2, 1100, NULL, NULL),
(40, 'Minimarket La Parada', NULL, 'J-51666777-8', '0212-5166677', 'laparada@email.com', 2, 1000, NULL, NULL);

-- Cervezas (Nombres de columna estaban correctos)
INSERT INTO Cerveza (cerveza_id, nombre_cerveza, descripción, tipo_cerveza_tipo_cerveza_id, presentación_id) VALUES
(1, 'UCAB IPA', 'IPA clásica con lúpulos cítricos.', 1, 1),
(2, 'UCAB Stout', 'Stout robusta con notas de café.', 2, 2),
(3, 'UCAB Lager', 'Lager suave y fácil de tomar.', 3, 1),
(4, 'UCAB Trigo', 'Cerveza de trigo refrescante.', 4, 1),
(5, 'UCAB Porter', 'Porter con toques de caramelo.', 5, 2),
(6, 'Doble IPA del Caos', 'Una IPA extra lupulada y amarga.', 1, 4),
(7, 'Stout de Medianoche', 'Imperial Stout con cacao y vainilla.', 2, 4),
(8, 'Lager del Sol', 'Lager estilo pilsner muy refrescante.', 3, 5);

-- Productos
-- COLUMNAS CORREGIDAS: nombre, descripcion, precio
INSERT INTO Producto (producto_id, nombre, descripcion, precio, Cerveza_cerveza_id, Merchandising_merchandising_id) VALUES
(1, 'UCAB IPA', 'Botella 355ml de nuestra IPA insignia.', 3.50, 1, NULL),
(2, 'UCAB Stout', 'Lata 473ml de nuestra Stout robusta.', 4.00, 2, NULL),
(3, 'UCAB Lager', 'Botella 355ml de nuestra Lager.', 3.00, 3, NULL),
(4, 'UCAB Trigo', 'Botella 355ml de cerveza de trigo.', 3.25, 4, NULL),
(5, 'UCAB Porter', 'Lata 473ml de Porter.', 3.75, 5, NULL),
(6, 'Doble IPA del Caos', 'Botella 660ml de Doble IPA.', 5.50, 6, NULL),
(7, 'Stout de Medianoche', 'Botella 660ml de Imperial Stout.', 6.00, 7, NULL),
(8, 'Lager del Sol', 'Lata 355ml de pilsner.', 3.15, 8, NULL);

-- Tienda Física
-- COLUMNA CORREGIDA: nombre
INSERT INTO Tienda_Fisica (tienda_fisica_id, nombre, Lugar_lugar_id) VALUES
(1, 'ACAUCAB Sede Montalbán', 100);


-- 
-- ########              TRANSACCIONES Y EVENTOS               ########
-- 

-- Órdenes de Compra a Proveedores (10 registros)
-- COLUMNA CORREGIDA: fecha
INSERT INTO Compra (compra_id, fecha, monto_total, proveedor_proveedor_id, usuario_usuario_id) VALUES
(1, '2025-06-01', 1500.00, 1, 2),
(2, '2025-06-02', 850.50, 2, 2),
(3, '2025-06-03', 2200.00, 3, 2),
(4, '2025-06-04', 500.00, 4, 2),
(5, '2025-06-05', 3000.00, 5, 2),
(6, '2025-06-06', 1250.00, 6, 2),
(7, '2025-06-07', 980.75, 7, 2),
(8, '2025-06-08', 450.00, 8, 2),
(9, '2025-06-09', 1800.00, 9, 2),
(10, '2025-06-10', 2100.00, 10, 2);

-- Productos por Compra (Ejemplo para la primera compra)
INSERT INTO Producto_Compra (cantidad, precio_unitario, Compra_compra_id, Producto_producto_id) VALUES
(100, 2.50, 1, 1),
(100, 3.00, 1, 2),
(200, 2.00, 1, 3);

-- Ventas en Tienda Física (Ejemplo de algunas ventas)
-- COLUMNA CORREGIDA: fecha_hora
INSERT INTO Venta_Fisica (venta_fisica_id, fecha_hora, monto_total, Cliente_cliente_id, Tienda_Fisica_tienda_fisica_id, Usuario_usuario_id) VALUES
(1, '2025-06-10 14:30:00', 35.00, 1, 1, 3),
(2, '2025-06-10 15:00:00', 40.00, 21, 1, 3);
-- NOTA: El requisito es "2 órdenes de compra con 10 productos por cliente".
-- Esto se interpreta como 2 VENTAS por cada uno de los 40 clientes = 80 ventas en total.
-- Aquí se muestran solo 2 como ejemplo, pero deberás generar las 78 restantes.

-- Productos por Venta Física (10 productos por orden)
INSERT INTO Producto_VentaF (cantidad, precio_unitario, Venta_Fisica_venta_fisica_id, Producto_producto_id) VALUES
(2, 3.50, 1, 1),
(2, 4.00, 1, 2),
(2, 3.00, 1, 3),
(2, 3.25, 1, 4),
(2, 3.75, 1, 5);
-- Para la segunda venta
INSERT INTO Producto_VentaF (cantidad, precio_unitario, Venta_Fisica_venta_fisica_id, Producto_producto_id) VALUES
(10, 4.00, 2, 2);

-- Eventos (5 por estado - ejemplo para 2 estados)
-- COLUMNAS CORREGIDAS: nombre, fecha, descripcion
INSERT INTO Evento (evento_id, nombre, fecha, descripcion, lugar_lugar_id) VALUES
(1, 'Cata de IPAs', '2025-07-15', 'Cata guiada de nuestras IPAs.', 1001),
(2, 'Noche de Stouts y Postres', '2025-07-22', 'Maridaje de cervezas Stout con postres de chocolate.', 1000),
(3, 'Lanzamiento Lager del Sol', '2025-08-01', 'Fiesta de lanzamiento de nuestra nueva pilsner.', 1001),
(4, 'Curso Básico de Elaboración', '2025-08-10', 'Aprende a hacer tu propia cerveza en casa.', 1000),
(5, 'Oktoberfest UCAB', '2025-10-05', 'Nuestra versión del festival alemán.', 1001),
(6, 'Concierto Acústico y Cerveza', '2025-07-18', 'Música en vivo en Chacao.', 1110),
(7, 'Yoga y Cerveza', '2025-07-25', 'Clase de yoga seguida de una degustación.', 1100),
(8, 'Competencia Homebrew', '2025-08-15', 'Competencia para cerveceros caseros.', 1110),
(9, 'Maridaje con Quesos Venezolanos', '2025-08-22', 'Explora sabores locales.', 1100),
(10, 'Aniversario ACAUCAB Miranda', '2025-09-01', 'Celebración de nuestro primer año en la zona.', 1110);
