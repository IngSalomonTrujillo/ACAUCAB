-- 1. Tabla Beneficio
INSERT INTO Beneficio (nombre_beneficio, descripción_beneficio) VALUES
('Seguro médico', 'Cobertura médica completa para el empleado'),
('Vale de comida', 'Vale diario para comida en restaurantes afiliados'),
('Bonificación anual', 'Bonificación equivalente a un mes de salario'),
('Días libres', 'Días adicionales de vacaciones'),
('Capacitación', 'Cursos y talleres de desarrollo profesional');

-- 2. Tabla Característica
INSERT INTO Característica (nombre_característica, descripción_caracteristica) VALUES
('Amargor', 'Nivel de amargor de la cerveza en IBUs'),
('Alcohol', 'Porcentaje de alcohol por volumen'),
('Color', 'Color de la cerveza en SRM'),
('Aroma', 'Notas aromáticas principales'),
('Cuerpo', 'Textura y sensación en boca');

-- 3. Tabla Departamento
INSERT INTO Departamento (nombre_departamento) VALUES
('Ventas'),
('Compras'),
('Logística'),
('Marketing'),
('Recursos Humanos'),
('Producción'),
('Calidad'),
('Finanzas'),
('TI'),
('Eventos');

-- 4. Tabla Estatus
INSERT INTO Estatus (estatus_nombre, descripción_estatus) VALUES
('Pendiente', 'En espera de procesamiento'),
('En proceso', 'Actualmente siendo atendido'),
('Completado', 'Finalizado exitosamente'),
('Cancelado', 'No se completó'),
('Rechazado', 'No aprobado');

-- 5. Tabla Horario
INSERT INTO Horario (dias_semana, hora_entrada_esperada, hora_salida_esperada) VALUES
('Lunes-Viernes', '08:00:00', '17:00:00'),
('Lunes-Sábado', '09:00:00', '18:00:00'),
('Turno mañana', '06:00:00', '14:00:00'),
('Turno tarde', '14:00:00', '22:00:00'),
('Turno noche', '22:00:00', '06:00:00');

-- 6. Tabla Ingrediente
INSERT INTO Ingrediente (nombre_ingrediente, Ingrediente_ingrediente_id) VALUES
('Malta Pale Ale', NULL),
('Malta Munich', NULL),
('Malta Caramel', NULL),
('Lúpulo Cascade', NULL),
('Lúpulo Columbus', NULL),
('Levadura Ale', NULL),
('Levadura Lager', NULL),
('Agua', NULL),
('Trigo', NULL),
('Azúcar candy', NULL);

-- 7. Tabla Instruccion
INSERT INTO Instruccion (descripcion) VALUES
('Macerar a 66°C por 60 minutos'),
('Lavar granos a 76°C'),
('Hervir por 60 minutos añadiendo lúpulos según horario'),
('Enfriar rápidamente a 20°C'),
('Fermentar a 18-20°C por 7 días'),
('Madurar en frío por 2 semanas'),
('Carbonatar a 2.5 volúmenes de CO2'),
('Embotellar y dejar reposar 1 semana'),
('Filtrar antes de envasar'),
('Pasteurizar a 60°C por 15 minutos');

-- 8. Tabla Juez
INSERT INTO Juez (nombre_juez) VALUES
('Carlos Mendoza'),
('Ana López'),
('Pedro Rivas'),
('María González'),
('José Pérez'),
('Luisa Fernández'),
('Juan Martínez'),
('Sofía Ramírez'),
('Ricardo Díaz'),
('Carmen Suárez');

-- 9. Tabla Lugar
INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
('Venezuela', 'País', NULL),
('Distrito Capital', 'Estado', 1),
('Miranda', 'Estado', 1),
('Caracas', 'Municipio', 2),
('Baruta', 'Municipio', 2),
('Chacao', 'Municipio', 2),
('El Hatillo', 'Municipio', 2),
('Libertador', 'Municipio', 2),
('Los Salias', 'Municipio', 3),
('Sucre', 'Municipio', 3);

-- 10. Tabla Método_Pago
INSERT INTO Método_Pago DEFAULT VALUES;


-- 11. Tabla Presentación
INSERT INTO Presentación (nombre_presentación, medida) VALUES
('Botella 330ml', '330 ml'),
('Botella 500ml', '500 ml'),
('Botella 750ml', '750 ml'),
('Lata 355ml', '355 ml'),
('Lata 473ml', '473 ml'),
('Barril 5L', '5 litros'),
('Barril 10L', '10 litros'),
('Barril 20L', '20 litros'),
('Growler 1L', '1 litro'),
('Growler 2L', '2 litros');

-- 12. Tabla Privilegio
INSERT INTO Privilegio (nombre_privilegio, descripción_privilegio) VALUES
('Crear', 'Permite crear nuevos registros'),
('Leer', 'Permite ver información'),
('Actualizar', 'Permite modificar registros'),
('Eliminar', 'Permite borrar registros'),
('Reportes', 'Generar reportes del sistema'),
('Configuración', 'Modificar parámetros del sistema'),
('Usuarios', 'Administrar usuarios y permisos'),
('Inventario', 'Gestionar inventario completo'),
('Ventas', 'Realizar operaciones de venta'),
('Compras', 'Realizar operaciones de compra');

-- 13. Tabla Rol
INSERT INTO Rol (nombre_rol, descripción_rol) VALUES
('Administrador', 'Acceso completo al sistema'),
('Gerente', 'Gestión de departamentos'),
('Supervisor', 'Supervisión de operaciones'),
('Vendedor', 'Atención al cliente y ventas'),
('Comprador', 'Gestión de compras a proveedores'),
('Almacenista', 'Control de inventario'),
('RRHH', 'Gestión de personal'),
('Marketing', 'Promoción y eventos'),
('Contabilidad', 'Gestión financiera'),
('TI', 'Soporte técnico');

-- 14. Tabla Tasa_Cambio
INSERT INTO Tasa_Cambio (moneda_origen, tasa, fecha_vigencia) VALUES
('USD', 36.50, '2025-01-01'),
('EUR', 39.80, '2025-01-01'),
('USD', 37.20, '2025-02-01'),
('EUR', 40.10, '2025-02-01'),
('USD', 36.80, '2025-03-01'),
('EUR', 39.50, '2025-03-01'),
('USD', 37.50, '2025-04-01'),
('EUR', 40.30, '2025-04-01'),
('USD', 36.20, '2025-05-01'),
('EUR', 39.20, '2025-05-01');

-- 15. Tabla Tipo_Empleado
INSERT INTO Tipo_Empleado (nombre_cargo, descripción_cargo, Tipo_Empleado_tipo_empleado_id) VALUES
('Gerente General', 'Responsable de toda la operación', NULL),
('Gerente de Ventas', 'Encargado del área comercial', NULL),
('Gerente de Compras', 'Encargado de adquisiciones', NULL),
('Supervisor', 'Supervisa operaciones diarias', NULL),
('Asistente', 'Apoyo administrativo', NULL),
('Vendedor', 'Atención directa al cliente', NULL),
('Almacenista', 'Manejo de inventario', NULL),
('Cajero', 'Procesamiento de pagos', NULL),
('Analista', 'Análisis de datos', NULL),
('Soporte', 'Asistencia técnica', NULL);

-- 16. Tabla Tipo_Evento
INSERT INTO Tipo_Evento (nombre_tipo_evento, descripción_evento, Tipo_Evento_tipo_evento_id) VALUES
('Degustación', 'Evento para probar diferentes cervezas', NULL),
('Concurso', 'Competencia de cervezas artesanales', NULL),
('Taller', 'Aprendizaje sobre elaboración de cerveza', NULL),
('Feria', 'Exposición de productos cerveceros', NULL),
('Concierto', 'Evento musical con cerveza artesanal', NULL),
('Charla', 'Conferencia sobre cultura cervecera', NULL),
('Cena', 'Maridaje de cerveza con comida', NULL),
('Festival', 'Celebración con múltiples actividades', NULL),
('Lanzamiento', 'Presentación de nuevos productos', NULL),
('Networking', 'Encuentro de profesionales del sector', NULL);

-- 20. Tabla Cheque (1 FK: Método_Pago)
INSERT INTO Cheque (método_pago_id, número_cuenta, banco, número_cheque) VALUES
(1, 123456789, 'Banco de Venezuela', 'CH-10001'),
(2, 987654321, 'Banesco', 'CH-10002'),
(3, 555555555, 'Mercantil', 'CH-10003'),
(4, 111111111, 'Provincial', 'CH-10004'),
(5, 999999999, 'BOD', 'CH-10005');

-- 21. Tabla Cliente (1 FK: Correo_Electrónico)
INSERT INTO Cliente (RIF, tipo_cliente, número_carnet) VALUES
(123456789, 'Jurídico', 'CLI00001'),
(987654321, 'Jurídico', 'CLI00002'),
(555555555, 'Jurídico', 'CLI00003'),
(111111111, 'Jurídico', 'CLI00004'),
(999999999, 'Jurídico', 'CLI00005'),
(123456780, 'Natural', 'CLI00006'),
(987654320, 'Natural', 'CLI00007'),
(555555550, 'Natural', 'CLI00008'),
(111111110, 'Natural', 'CLI00009'),
(999999990, 'Natural', 'CLI00010');

-- 22. Tabla Correo_Electrónico (1 FK: Cliente, Proveedor o Empleado)
INSERT INTO Correo_Electrónico (Cliente_RIF, Proveedor_proveedor_id, Empleado_empleado_id, correo_id, prefijo_correo, dominio_correo) VALUES
(123456789, NULL, NULL, 1, 'cliente1', 'acaucab.com'),
(987654321, NULL, NULL, 2, 'cliente2', 'acaucab.com'),
(555555555, NULL, NULL, 3, 'cliente3', 'acaucab.com'),
(111111111, NULL, NULL, 4, 'cliente4', 'acaucab.com'),
(999999999, NULL, NULL, 5, 'cliente5', 'acaucab.com'),
(123456780, NULL, NULL, 6, 'cliente6', 'acaucab.com'),
(987654320, NULL, NULL, 7, 'cliente7', 'acaucab.com'),
(555555550, NULL, NULL, 8, 'cliente8', 'acaucab.com'),
(111111110, NULL, NULL, 9, 'cliente9', 'acaucab.com'),
(999999990, NULL, NULL, 10, 'cliente10', 'acaucab.com');

-- 23. Tabla Crédito (1 FK: Método_Pago)
INSERT INTO Crédito (método_pago_id, cuenta, banco, número_tarjeta) VALUES
(6, '1234567890123456', 'Banco de Venezuela', '4111111111111111'),
(7, '9876543210987654', 'Banesco', '5500000000000004'),
(8, '5555555555555555', 'Mercantil', '340000000000009'),
(9, '1111111111111111', 'Provincial', '30000000000004'),
(10, '9999999999999999', 'BOD', '6011000000000004');

-- 24. Tabla Débito (1 FK: Método_Pago)
INSERT INTO Débito (método_pago_id, cuenta, banco, número_tarjeta) VALUES
(11, '1234567890123456', 'Banco de Venezuela', '4111111111111111'),
(12, '9876543210987654', 'Banesco', '5500000000000004'),
(13, '5555555555555555', 'Mercantil', '340000000000009'),
(14, '1111111111111111', 'Provincial', '30000000000004'),
(15, '9999999999999999', 'BOD', '6011000000000004');

-- 25. Tabla Efectivo (1 FK: Método_Pago)
INSERT INTO Efectivo (método_pago_id, tipo_divisa) VALUES
(16, 'VES'),
(17, 'USD'),
(18, 'EUR'),
(19, 'VES'),
(20, 'USD');

-- 26. Tabla Empleado (sin FK)
INSERT INTO Empleado (cédula_identidad, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_ingreso, salario) VALUES
('V12345678', 'Juan', 'Carlos', 'Pérez', 'González', '2020-01-15', 5000000),
('V23456789', 'María', 'Alejandra', 'López', 'Mendoza', '2020-03-20', 4800000),
('V34567890', 'Pedro', NULL, 'Gómez', 'Rojas', '2020-05-10', 4500000),
('V45678901', 'Ana', 'Isabel', 'Martínez', NULL, '2020-07-05', 4600000),
('V56789012', 'Luis', 'Alberto', 'Rodríguez', 'Paredes', '2020-09-15', 4700000),
('V67890123', 'Carlos', 'Andrés', 'Hernández', 'Suárez', '2021-01-10', 4200000),
('V78901234', 'Sofía', NULL, 'Díaz', 'Fernández', '2021-03-05', 4300000),
('V89012345', 'José', 'Gregorio', 'Ramírez', 'Gutiérrez', '2021-05-20', 4400000),
('V90123456', 'Laura', 'Patricia', 'García', 'Morales', '2021-07-15', 4100000),
('V01234567', 'Ricardo', NULL, 'Torres', 'Blanco', '2021-09-01', 4000000);

-- 27. Tabla Jurídico (1 FK: Cliente, 2 FK: Lugar)
INSERT INTO Jurídico (RIF, razón_social, denominación_comercial, página_web, capital_disponible, dirección_fiscal, dirección_fisica, Lugar_lugar_id, Lugar_lugar_id2) VALUES
(123456789, 'Cervecería Destilo CA', 'Destilo', 'destilo.com.ve', 1000000000, 'Av. Principal de La Castellana', 'Av. Principal de La Castellana', 4, 4),
(987654321, 'Benitz Brewing CA', 'Benitz', 'benitz.com.ve', 800000000, 'Calle California con Av. San Juan', 'Calle California con Av. San Juan', 5, 5),
(555555555, 'Mito Brewhouse CA', 'Mito', 'mitobrewhouse.com.ve', 750000000, 'Centro Comercial Paseo Las Mercedes', 'Centro Comercial Paseo Las Mercedes', 6, 6),
(111111111, 'Cervecería Lago CA', 'Lago', 'cervecerialago.com.ve', 900000000, 'Av. Francisco de Miranda', 'Av. Francisco de Miranda', 7, 7),
(999999999, 'Aldarra Brewing CA', 'Aldarra', 'aldarra.com.ve', 600000000, 'Calle Los Mangos', 'Calle Los Mangos', 8, 8);

-- 28. Tabla PersonaNatural (1 FK: Cliente, 1 FK: Lugar)
INSERT INTO PersonaNatural (RIF, cedula_identidad, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, Lugar_lugar_id) VALUES
(123456780, 'V12345670', 'Carlos', 'Andrés', 'Pérez', 'González', 4),
(987654320, 'V23456780', 'Ana', 'María', 'López', 'Mendoza', 5),
(555555550, 'V34567890', 'Pedro', NULL, 'Gómez', 'Rojas', 6),
(111111110, 'V45678900', 'María', 'Isabel', 'Martínez', NULL, 7),
(999999990, 'V56789010', 'Luis', 'Alberto', 'Rodríguez', 'Paredes', 8);

-- 29. Tabla Proveedor (1 FK: Persona_Contacto, 2 FK: Lugar)
INSERT INTO Proveedor (proveedor_id, razón_social, denominación_comercial, RIF, dirección_fiscal, página_web, fecha_afiliación, direccion_fisica, Lugar_lugar_id, Lugar_lugar_id2) VALUES
(1, 'Cervecería Destilo CA', 'Destilo', 'J-123456789', 'Av. Principal de La Castellana', 'destilo.com.ve', '2015-01-10', 'Av. Principal de La Castellana', 4, 4),
(2, 'Benitz Brewing CA', 'Benitz', 'J-987654321', 'Calle California con Av. San Juan', 'benitz.com.ve', '2015-03-15', 'Calle California con Av. San Juan', 5, 5),
(3, 'Mito Brewhouse CA', 'Mito', 'J-555555555', 'Centro Comercial Paseo Las Mercedes', 'mitobrewhouse.com.ve', '2015-05-20', 'Centro Comercial Paseo Las Mercedes', 6, 6),
(4, 'Cervecería Lago CA', 'Lago', 'J-111111111', 'Av. Francisco de Miranda', 'cervecerialago.com.ve', '2015-07-25', 'Av. Francisco de Miranda', 7, 7),
(5, 'Aldarra Brewing CA', 'Aldarra', 'J-999999999', 'Calle Los Mangos', 'aldarra.com.ve', '2015-09-30', 'Calle Los Mangos', 8, 8);

-- 30. Tabla Persona_Contacto (1 FK: Proveedor o Jurídico)
INSERT INTO Persona_Contacto (Proveedor_proveedor_id, Jurídico_RIF, contacto_id, nombre_contacto, cargo_contacto, teléfono_contacto) VALUES
(1, NULL, 1, 'Carlos Mendoza', 'Gerente General', '04141234567'),
(2, NULL, 2, 'Ana López', 'Directora Comercial', '04142345678'),
(3, NULL, 3, 'Pedro Rivas', 'Jefe de Producción', '04143456789'),
(4, NULL, 4, 'María González', 'Gerente de Ventas', '04144567890'),
(5, NULL, 5, 'José Pérez', 'Coordinador Logístico', '04145678901'),
(NULL, 123456789, 6, 'Luisa Fernández', 'Asistente', '04146789012'),
(NULL, 987654321, 7, 'Juan Martínez', 'Contador', '04147890123'),
(NULL, 555555555, 8, 'Sofía Ramírez', 'Marketing', '04148901234'),
(NULL, 111111111, 9, 'Ricardo Díaz', 'RRHH', '04149012345'),
(NULL, 999999999, 10, 'Carmen Suárez', 'Logística', '04140123456');

-- 31. Tabla Receta 
INSERT INTO Receta (receta_id, nombre_receta) VALUES
(1, 'Receta Destilo Amber'),
(2, 'Receta Benitz Pale Ale'),
(3, 'Receta Mito Candileja'),
(4, 'Receta Ángel o Demonio'),
(5, 'Receta Aldarra Mantuana'),
(6, 'Receta Latin American IPA'),
(7, 'Receta Tovar Stout'),
(8, 'Receta UCAB Lager'),
(9, 'Receta Caracas Porter'),
(10, 'Receta Avila Wheat');

-- 32. Tabla Teléfono (1 FK: Cliente, Proveedor o Empleado)
INSERT INTO Teléfono (Cliente_RIF, Proveedor_proveedor_id, Empleado_empleado_id, teléfono_id, teléfono_área, número_telefónico) VALUES
(123456789, NULL, NULL, 1, 212, 5551111),
(987654321, NULL, NULL, 2, 212, 5552222),
(555555555, NULL, NULL, 3, 212, 5553333),
(111111111, NULL, NULL, 4, 212, 5554444),
(999999999, NULL, NULL, 5, 212, 5555555),
(123456780, NULL, NULL, 6, 212, 5556666),
(987654320, NULL, NULL, 7, 212, 5557777),
(555555550, NULL, NULL, 8, 212, 5558888),
(111111110, NULL, NULL, 9, 212, 5559999),
(999999990, NULL, NULL, 10, 212, 5550000),
(NULL, 1, NULL, 11, 212, 5551234),
(NULL, 2, NULL, 12, 212, 5552345),
(NULL, 3, NULL, 13, 212, 5553456),
(NULL, 4, NULL, 14, 212, 5554567),
(NULL, 5, NULL, 15, 212, 5555678),
(NULL, NULL, 1, 16, 212, 5556789),
(NULL, NULL, 2, 17, 212, 5557890),
(NULL, NULL, 3, 18, 212, 5558901),
(NULL, NULL, 4, 19, 212, 5559012),
(NULL, NULL, 5, 20, 212, 5550123);

-- 33. Tabla Usuario (1 FK: Cliente, Proveedor o Empleado, 1 FK: Rol)
INSERT INTO Usuario (Cliente_RIF, Proveedor_proveedor_id, Empleado_empleado_id, contraseña_usuario, Rol_rol_id, nombre_usuario) VALUES
(123456789, NULL, NULL, 'cliente1pass', 4, 'cliente1'),
(987654321, NULL, NULL, 'cliente2pass', 4, 'cliente2'),
(555555555, NULL, NULL, 'cliente3pass', 4, 'cliente3'),
(111111111, NULL, NULL, 'cliente4pass', 4, 'cliente4'),
(999999999, NULL, NULL, 'cliente5pass', 4, 'cliente5'),
(123456780, NULL, NULL, 'cliente6pass', 4, 'cliente6'),
(987654320, NULL, NULL, 'cliente7pass', 4, 'cliente7'),
(555555550, NULL, NULL, 'cliente8pass', 4, 'cliente8'),
(111111110, NULL, NULL, 'cliente9pass', 4, 'cliente9'),
(999999990, NULL, NULL, 'cliente10pass', 4, 'cliente10'),
(NULL, 1, NULL, 'proveedor1pass', 5, 'proveedor1'),
(NULL, 2, NULL, 'proveedor2pass', 5, 'proveedor2'),
(NULL, 3, NULL, 'proveedor3pass', 5, 'proveedor3'),
(NULL, 4, NULL, 'proveedor4pass', 5, 'proveedor4'),
(NULL, 5, NULL, 'proveedor5pass', 5, 'proveedor5'),
(NULL, NULL, 1, 'empleado1pass', 1, 'empleado1'),
(NULL, NULL, 2, 'empleado2pass', 2, 'empleado2'),
(NULL, NULL, 3, 'empleado3pass', 3, 'empleado3'),
(NULL, NULL, 4, 'empleado4pass', 6, 'empleado4'),
(NULL, NULL, 5, 'empleado5pass', 7, 'empleado5');

-- 34. Tabla Tipo_Cerveza (1 FK: Proveedor, 1 FK: Receta)
INSERT INTO Tipo_Cerveza (Receta_receta_id, tipo_cerveza_id, nombre_tipo, descripción_general, familia, Proveedor_proveedor_id, Tipo_Cerveza_tipo_cerveza_id) VALUES
(1, 1, 'Amber Ale', 'Cerveza ámbar con buen balance maltalúpulo', 'Ale', 1, NULL),
(2, 2, 'Pale Ale', 'Ale pálida con carácter lupulizado', 'Ale', 2, NULL),
(3, 3, 'Dubbel', 'Ale belga oscura con notas frutales', 'Ale', 3, NULL),
(4, 4, 'Golden Strong', 'Ale dorada fuerte y compleja', 'Ale', 4, NULL),
(5, 5, 'Blonde Ale', 'Ale rubia fácil de beber', 'Ale', 5, NULL),
(6, 6, 'IPA', 'Ale muy lupulizada y amarga', 'Ale', 1, NULL),
(7, 7, 'Stout', 'Ale oscura con sabores a café', 'Ale', 2, NULL),
(8, 8, 'Lager', 'Cerveza de fermentación baja', 'Lager', 3, NULL),
(9, 9, 'Porter', 'Ale oscura con chocolate y caramelo', 'Ale', 4, NULL),
(10, 10, 'Weissbier', 'Ale de trigo con carácter frutal', 'Ale', 5, NULL);

-- 17. Tabla Cerveza (1 FK: Tipo_Cerveza)
INSERT INTO Cerveza (nombre_cerveza, descripción, Tipo_Cerveza_tipo_cerveza_id, presentación_id) VALUES
('Destilo Amber', 'Cerveza ámbar premium con cuerpo medio', 1, 1),
('Benitz Pale Ale', 'Pale Ale artesanal con buen balance maltalúpulo', 2, 2),
('Mito Candileja', 'Cerveza de abadía con notas a caramelo y frutas', 3, 3),
('Ángel o Demonio', 'Dorada fuerte con espuma blanca persistente', 4, 4),
('Aldarra Mantuana', 'Blonde Ale ligera con aroma tropical', 5, 5),
('Latin American IPA', 'IPA con lúpulos americanos y carácter cítrico', 6, 6),
('Tovar Stout', 'Stout negra cremosa con notas a café', 7, 7),
('UCAB Lager', 'Lager suave y refrescante', 8, 8),
('Caracas Porter', 'Porter robusta con chocolate y café', 9, 9),
('Avila Wheat', 'Weissbier con notas a plátano y clavo', 10, 10);

-- 18. Tabla Cerveza_Caracteristica (2 FK: Cerveza y Característica)
INSERT INTO Cerveza_Caracteristica (Cerveza_cerveza_id, Característica_característica_id, descripción) VALUES
(1, 1, '25 IBUs - Amargor medio-bajo'),
(1, 2, '5.8% ABV - Alcohol medio'),
(2, 1, '35 IBUs - Amargor notable'),
(2, 3, '12 SRM - Color ámbar'),
(3, 2, '7.5% ABV - Alcohol alto'),
(3, 4, 'Aroma a caramelo y frutas secas'),
(4, 2, '8.5% ABV - Muy alcohólica'),
(4, 5, 'Cuerpo medio-alto'),
(5, 1, '20 IBUs - Poco amarga'),
(5, 3, '6 SRM - Dorado pálido');

-- 19. Tabla Cerveza_Presentacion (2 FK: Cerveza y Presentación)
INSERT INTO Cerveza_Presentacion (Presentación_presentación_id, Cerveza_cerveza_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- 35. Tabla Empleado_Beneficio (2 FK: Empleado y Beneficio)
INSERT INTO Empleado_Beneficio (Empleado_empleado_id, Beneficio_beneficio_id, empleado_beneficio_id, fecha_asignación, monto_beneficio) VALUES
(1, 1, 1, '2025-01-01', NULL),
(1, 2, 2, '2025-01-01', 500000),
(2, 1, 3, '2025-01-01', NULL),
(2, 3, 4, '2025-01-01', 450000),
(3, 2, 5, '2025-01-01', 300000),
(4, 4, 6, '2025-01-01', NULL),
(4, 1, 7, '2025-01-01', NULL),
(5, 5, 8, '2025-01-01', NULL),
(6, 2, 9, '2025-01-01', 250000),
(7, 3, 10, '2025-01-01', 400000);

-- 36. Tabla Evento (2 FK: Tipo_Evento y Lugar)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(1, 'UBirra 2025', '2025-07-10', '2025-07-11', 'Festival anual de cerveza artesanal', 'S', 8, 'Plaza Mickey, Av. Principal de La Castellana', 4),
(2, 'Taller de Iniciación', '2025-04-15', NULL, 'Taller para principiantes en cerveza artesanal', 'N', 3, 'Sede ACAUCAB, Chacao', 6),
(3, 'Concurso Cervecero', '2025-08-20', '2025-08-22', 'Competencia de cervezas artesanales', 'S', 2, 'CC San Ignacio, La Castellana', 4),
(4, 'Degustación Premium', '2025-05-30', NULL, 'Degustación de ediciones limitadas', 'S', 1, 'Cigar Bar, Las Mercedes', 6),
(5, 'Cena de Maridaje', '2025-06-25', NULL, 'Maridaje de cervezas con comida gourmet', 'S', 7, 'Restaurante Alto, Av. San Juan', 5),
(6, 'Festival de Invierno', '2025-01-15', '2025-01-17', 'Evento con cervezas de temporada', 'S', 8, 'Hacienda La Trinidad', 7),
(7, 'Charla Histórica', '2025-03-10', NULL, 'Historia de la cerveza en Venezuela', 'N', 6, 'UCAB, Montalbán', 4),
(8, 'Lanzamiento Destilo', '2025-09-05', NULL, 'Presentación nueva edición Destilo', 'S', 9, 'Casa Destilo, La Castellana', 4),
(9, 'Networking Brewer', '2025-10-12', NULL, 'Encuentro de maestros cerveceros', 'S', 10, 'Hotel JW Marriott', 4),
(10, 'Feria Artesanal', '2025-11-20', '2025-11-22', 'Exposición y venta de productos', 'N', 4, 'CC Sambil, Chacao', 6);

-- 37. Tabla Instruccion_Receta (2 FK: Instruccion y Receta)
INSERT INTO Instruccion_Receta (Instruccion_instruccion_id, Receta_receta_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1),
(1, 2), (2, 2), (3, 2), (4, 2), (6, 2),
(1, 3), (2, 3), (3, 3), (4, 3), (7, 3),
(1, 4), (2, 4), (3, 4), (4, 4), (8, 4),
(1, 5), (2, 5), (3, 5), (4, 5), (5, 5);

-- 38. Tabla Receta_Ingrediente (2 FK: Receta y Ingrediente)
INSERT INTO Receta_Ingrediente (Receta_receta_id, Ingrediente_ingrediente_id, cantidad, unidad_medida) VALUES
(1, 1, 5, 'kg'), (1, 4, 50, 'g'), (1, 6, 1, 'paquete'),
(2, 1, 4.5, 'kg'), (2, 3, 0.5, 'kg'), (2, 5, 60, 'g'), (2, 6, 1, 'paquete'),
(3, 1, 6, 'kg'), (3, 2, 1, 'kg'), (3, 10, 0.5, 'kg'), (3, 6, 1, 'paquete'),
(4, 1, 7, 'kg'), (4, 10, 1, 'kg'), (4, 6, 1, 'paquete'),
(5, 1, 4, 'kg'), (5, 9, 1, 'kg'), (5, 4, 30, 'g'), (5, 6, 1, 'paquete');

-- 39. Tabla Tipo_Cerveza_Caracteristica (2 FK: Tipo_Cerveza y Característica)
INSERT INTO Tipo_Cerveza_Caracteristica (Tipo_Cerveza_tipo_cerveza_id, Característica_característica_id, descripción) VALUES
(1, 1, '20-30 IBUs'), (1, 2, '4.5-6.2% ABV'), (1, 3, '10-17 SRM'),
(2, 1, '30-50 IBUs'), (2, 2, '4.5-6% ABV'), (2, 3, '5-14 SRM'),
(3, 2, '6-7.5% ABV'), (3, 3, '14-20 SRM'), (3, 4, 'Frutos secos'),
(4, 2, '8-11% ABV'), (4, 3, '3-6 SRM'), (4, 5, 'Cuerpo medio'),
(5, 1, '15-25 IBUs'), (5, 2, '4.5-6% ABV'), (5, 3, '3-5 SRM');

-- 40. Tabla Rol_Privilegio (2 FK: Rol y Privilegio)
INSERT INTO Rol_Privilegio (Rol_rol_id, Privilegio_privilegio_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7),
(2, 2), (2, 3), (2, 5), (2, 8),
(3, 2), (3, 3), (3, 8),
(4, 2), (4, 9),
(5, 2), (5, 5), (5, 10),
(6, 2), (6, 3), (6, 8),
(7, 2), (7, 7),
(8, 2), (8, 3), (8, 5),
(9, 2), (9, 5),
(10, 2), (10, 6);

-- 41. Tabla Venta_Entrada (2 FK: Cliente y Evento)
INSERT INTO Venta_Entrada (Cliente_RIF, Evento_evento_id, venta_entrada_id, fecha_venta, total) VALUES
(123456789, 1, 1, '2025-07-01 10:00:00', 500000),
(987654321, 1, 2, '2025-07-02 11:30:00', 500000),
(555555555, 1, 3, '2025-07-03 09:15:00', 500000),
(123456780, 1, 4, '2025-07-04 15:45:00', 500000),
(987654320, 1, 5, '2025-07-05 16:30:00', 500000),
(555555550, 3, 6, '2025-08-01 14:00:00', 300000),
(123456789, 3, 7, '2025-08-02 12:30:00', 300000),
(987654321, 4, 8, '2025-05-15 10:00:00', 400000),
(555555555, 4, 9, '2025-05-20 11:00:00', 400000),
(123456780, 5, 10, '2025-06-10 09:00:00', 600000);

-- 42. Tabla Entrada_Evento (2 FK: Venta_Entrada y Evento)
INSERT INTO Entrada_Evento (entrada_evento_id, fecha_evento, Evento_evento_id, Venta_Entrada_Cliente_RIF, Venta_Entrada_Evento_evento_id, Venta_Entrada_venta_entrada_id) VALUES
(1, '2025-07-10', 1, 123456789, 1, 1),
(2, '2025-07-10', 1, 987654321, 1, 2),
(3, '2025-07-11', 1, 555555555, 1, 3),
(4, '2025-07-10', 1, 123456780, 1, 4),
(5, '2025-07-11', 1, 987654320, 1, 5),
(6, '2025-08-20', 3, 555555550, 3, 6),
(7, '2025-08-21', 3, 123456789, 3, 7),
(8, '2025-05-30', 4, 987654321, 4, 8),
(9, '2025-05-30', 4, 555555555, 4, 9),
(10, '2025-06-25', 5, 123456780, 5, 10);

-- 76. Tabla Departamento 
INSERT INTO Departamento (nombre_departamento) VALUES ('Ventas'), ('Compras'), ('Logística'), ('Marketing'), ('Recursos Humanos'), ('Producción'), ('Calidad'), ('Finanzas'), ('TI'), ('Eventos');

-- 77. Tabla tienda online 
INSERT INTO Tienda_Online (dirección_web) VALUES ('https://www.acaucab-principal.express' ), ('https://www.templodelacerveza.online'), ('https://www.acaucab-chacao.com'), ('https://www.rutaartesanal-valencia.ve'), ('https://www.birroteca-naguanagua.store'), ('https://www.refugiolupulo.com'), ('https://www.estacioncerveza-petare.net'), ('https://www.acaucab-altagracia.org'), ('https://www.bodegonlasdelicias.com'), ('https://www.casadelamalta.store');

-- 48 Insertar 10 registros de ejemplo para Inventario
INSERT INTO Inventario (
    inventario_id,
    cantidad_presentaciones,
    Tienda_Online_tienda_online_id,
    Cerveza_Presentacion_Cerveza_cerveza_id,
    Cerveza_Presentacion_Presentación_presentación_id
) VALUES
-- Inventario para tienda online 1 (Destilo Amber)
(1, 150, 1, 1, 1),
-- Inventario para tienda online 2 (Benitz Pale Ale)
(2, 120, 2, 2, 2),
-- Inventario para tienda online 3 (Mito Candileja)
(3, 100, 3, 3, 3),
-- Inventario para tienda online 4 (Ángel o Demonio)
(4, 80, 4, 4, 4),
-- Inventario para tienda online 5 (Aldarra Mantuana)
(5, 110, 5, 5, 5),
-- Inventario físico (sin tienda online) Destilo Amber
(6, 200, NULL, 1, 1),
-- Inventario físico (sin tienda online) Benitz Pale Ale
(7, 180, NULL, 2, 2),
-- Inventario físico (sin tienda online) Mito Candileja
(8, 150, NULL, 3, 3),
-- Inventario físico (sin tienda online) Ángel o Demonio
(9, 130, NULL, 4, 4),
-- Inventario físico (sin tienda online) Aldarra Mantuana
(10, 160, NULL, 5, 5);


-- 78. Tabla tienda física 
INSERT INTO Tienda_Física (tienda_fisica_id, nombre_ubicación, Orden_Reposición_orden_reposición_id, Lugar_lugar_id) VALUES
(1, 'ACAUCAB Principal', 1, 4), -- Caracas
(2, 'ACAUCAB Chacao', 2, 5), -- Baruta
(3, 'ACAUCAB Las Mercedes', 3, 6), -- Chacao
(4, 'ACAUCAB La Castellana', 4, 4), -- Caracas
(5, 'ACAUCAB San Ignacio', 5, 5), -- Baruta
(6, 'ACAUCAB El Hatillo', 6, 7), -- El Hatillo
(7, 'ACAUCAB Los Salias', 7, 9), -- Los Salias
(8, 'ACAUCAB Sucre', 8, 10), -- Sucre
(9, 'ACAUCAB Libertador', 9, 8), -- Libertador
(10, 'ACAUCAB Paseo Las Mercedes', 10, 6); -- Chacao

-- 79. Tabla Lugar tienda
INSERT INTO Lugar_Tienda (Tienda_Física_tienda_fisica_id, lugar_tienda_id, nombre_lugar_tienda, tipo_lugar_tienda, Lugar_Tienda_lugar_tienda_id, Inventario_inventario_id) VALUES
(1, 1, 'Almacén Principal', 'Almacén', NULL, 1),
(2, 1, 'Mostrador Chacao', 'Exhibición',  NULL, 2),
(3, 1, 'Bodega Las Mercedes', 'Almacén',  NULL, 3),
(4, 1, 'Área VIP Castellana', 'Exhibición', NULL, 4),
(5, 1, 'Pasillo San Ignacio', 'Exhibición', NULL, 5),
(6, 1, 'Bodega El Hatillo', 'Almacén', NULL ,6),
(7, 1, 'Mostrador Los Salias', 'Exhibición',  NULL, 7),
(8, 1, 'Área Fría Sucre', 'Almacén', NULL,  8),
(9, 1, 'Pasillo Libertador', 'Exhibición',  NULL, 9),
(10, 1, 'Bodega Paseo', 'Almacén', NULL, 10);



-- 44. Tabla TipoE_Departamento (3 FK: Tipo_Empleado, Departamento, Empleado)
INSERT INTO TipoE_Departamento (Tipo_Empleado_tipo_empleado_id, Departamento_departamento_id, nombre_departamento, Empleado_empleado_id) VALUES
(1, 11,  'Gerencia General', 1),
(2, 12,  'Ventas', 2),
(3, 13,  'Compras', 3),
(4, 14,  'Logística', 4),
(5, 15,  'Marketing', 5),
(6, 16,  'RRHH', 6),
(7, 17,  'Producción', 7),
(8, 18,  'Calidad', 8),
(9, 19,  'Finanzas', 9),
(10, 20,  'TI', 10);

-- 45. Tabla Orden_Reposición (3 FK: Tienda_Física, TipoE_Departamento)
INSERT INTO Orden_Reposición (Tienda_Física_tienda_fisica_id, orden_reposición_id, fecha_hora_generación, cantidad_a_reponer, fecha_hora_completada, TipoE_Departamento_tipo_empleado_id, TipoE_Departamento_departamento_id, TipoE_Departamento_empleado_id) VALUES
(1, 1, '2025-03-01 10:00:00', 100, '2025-03-02 15:30:00', 3, 13, 3),
(1, 2, '2025-03-15 11:00:00', 50, '2025-03-16 12:00:00', 3, 13, 3),
(2, 3, '2025-04-01 09:30:00', 75, '2025-04-02 14:00:00', 3, 13, 3),
(2, 4, '2025-04-15 10:45:00', 60, '2025-04-16 11:30:00', 3, 13, 3),
(3, 5, '2025-05-01 08:00:00', 90, '2025-05-02 16:00:00', 3, 13, 3),
(3, 6, '2025-05-15 14:20:00', 80, '2025-05-16 10:00:00', 3, 13, 3),
(4, 7, '2025-06-01 16:10:00', 70, '2025-06-02 09:45:00', 3, 13, 3),
(4, 8, '2025-06-15 13:30:00', 55, '2025-06-16 15:15:00', 3, 13, 3),
(5, 9, '2025-07-01 10:15:00', 65, '2025-07-02 11:20:00', 3, 13, 3),
(5, 10, '2025-07-15 09:00:00', 85, '2025-07-16 14:00:00', 3, 13, 3);

-- 46. Tabla Compra (3 FK: Proveedor, TipoE_Departamento)
INSERT INTO Compra (compra_id, tipo_compra, monto_total, puntos_ganados, Proveedor_proveedor_id, subtotal, TipoE_Departamento_tipo_empleado_id, TipoE_Departamento_departamento_id, TipoE_Departamento_empleado_id) VALUES
(1, 'Normal', 5000000, NULL, 1, 5000000, 3, 13, 3),
(2, 'Normal', 4500000, NULL, 2, 4500000, 3, 13, 3),
(3, 'Normal', 4800000, NULL, 3, 4800000, 3, 13, 3),
(4, 'Normal', 5200000, NULL, 4, 5200000, 3, 13, 3),
(5, 'Normal', 4600000, NULL, 5, 4600000, 3, 13, 3),
(6, 'Especial', 6000000, NULL, 1, 6000000, 3, 13, 3),
(7, 'Especial', 5500000, NULL, 2, 5500000, 3, 13, 3),
(8, 'Normal', 4900000, NULL, 3, 4900000, 3, 13, 3),
(9, 'Normal', 5100000, NULL, 4, 5100000, 3, 13, 3),
(10, 'Especial', 5800000, NULL, 5, 5800000, 3, 13, 3);

-- 47. Tabla Detalle_Compra (3 FK: Compra, Cerveza_Presentacion, Tasa_Cambio)
INSERT INTO Detalle_Compra (cantidad, precio_unitario, Tasa_Cambio_tasa_cambio_id, Compra_proveedor_id, Compra_compra_id, Cerveza_Presentacion_Cerveza_cerveza_id, Cerveza_Presentacion_Presentación_presentación_id) VALUES
(100, 50000, 1, 1, 1, 1, 1),
(80, 56250, 1, 2, 2, 2, 2),
(90, 53333, 1, 3, 3, 3, 3),
(70, 74285, 1, 4, 4, 4, 4),
(85, 54117, 1, 5, 5, 5, 5),
(120, 50000, 3, 1, 6, 6, 6),
(95, 57894, 3, 2, 7, 7, 7),
(75, 65333, 3, 3, 8, 8, 8),
(65, 78461, 3, 4, 9, 9, 9),
(110, 52727, 3, 5, 10, 10, 10);


-- 49. Tabla Venta_Física (2 FK: Tienda_Física, Usuario)
INSERT INTO Venta_Física (Tienda_Física_tienda_fisica_id, Usuario_usuario_id, fecha_hora_venta, monto_total) VALUES
(1, 16, '2025-03-05 12:30:00', 1200000),
(1, 17, '2025-03-10 15:45:00', 950000),
(1, 18, '2025-03-15 18:20:00', 1500000),
(2, 16, '2025-04-02 11:15:00', 850000),
(2, 17, '2025-04-10 16:30:00', 1100000),
(2, 18, '2025-04-20 14:10:00', 1300000),
(3, 19, '2025-05-05 10:45:00', 900000),
(3, 20, '2025-05-15 17:00:00', 750000),
(4, 19, '2025-06-03 13:20:00', 1400000),
(5, 20, '2025-07-12 12:00:00', 1250000);

-- 50. Tabla Detalle_Física (3 FK: Venta_Física, Inventario, Tasa_Cambio)
INSERT INTO Detalle_Física (precio_unitario, cantidad, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id, Tasa_Cambio_tasa_cambio_id, Inventario_inventario_id) VALUES
(60000, 20, 1, 16, 1, 1),
(47500, 20, 1, 17, 1, 2),
(50000, 30, 1, 18, 1, 3),
(42500, 20, 2, 16, 1, 4),
(55000, 20, 2, 17, 1, 5),
(43333, 30, 2, 18, 1, 6),
(45000, 20, 3, 19, 3, 7),
(37500, 20, 3, 20, 3, 8),
(46666, 30, 4, 19, 3, 9),
(41666, 30, 5, 20, 3, 10);

-- 51. Tabla Venta_Online (2 FK: Tienda_Online, Usuario)
INSERT INTO Venta_Online (Tienda_Online_tienda_online_id, Usuario_usuario_id, venta_id, fecha_hora_venta, monto_total) VALUES
(1, 1, 1, '2025-03-01 08:15:00', 800000),
(1, 2, 2, '2025-03-10 10:30:00', 950000),
(1, 3, 3, '2025-04-05 14:20:00', 1200000),
(2, 4, 4, '2025-04-15 16:45:00', 750000),
(2, 5, 5, '2025-05-10 11:10:00', 1100000),
(1, 6, 6, '2025-05-20 09:30:00', 850000),
(2, 7, 7, '2025-06-05 13:15:00', 1300000),
(1, 8, 8, '2025-06-15 15:40:00', 900000),
(2, 9, 9, '2025-07-01 10:25:00', 1400000),
(1, 10, 10, '2025-07-10 12:50:00', 1250000);

-- 52. Tabla Detalle_Online (3 FK: Venta_Online, Inventario, Tasa_Cambio)
INSERT INTO Detalle_Online (precio_unitario, cantidad, Venta_Online_tienda_online_id, Venta_Online_usuario_id, Tasa_Cambio_tasa_cambio_id, Inventario_inventario_id) VALUES
(40000, 20, 1, 1, 1, 1),
(47500, 20, 1, 2, 1, 2),
(40000, 30, 1, 3, 1, 3),
(37500, 20, 2, 4, 1, 4),
(44000, 25, 2, 5, 1, 5),
(42500, 20, 1, 6, 3, 6),
(43333, 30, 2, 7, 3, 7),
(45000, 20, 1, 8, 3, 8),
(46666, 30, 2, 9, 3, 9),
(41666, 30, 1, 10, 3, 10);

-- 53. Tabla Venta_Evento (2 FK: Proveedor, Evento)
INSERT INTO Venta_Evento (Proveedor_proveedor_id, Evento_evento_id, cantidad, precio_unitatio_pagado, fecha_hora_venta) VALUES
(1, 1, 50, 40000, '2025-07-01 10:00:00'),
(2, 1, 40, 45000, '2025-07-01 11:00:00'),
(3, 1, 30, 50000, '2025-07-02 09:30:00'),
(4, 1, 35, 48000, '2025-07-02 10:30:00'),
(5, 1, 45, 42000, '2025-07-03 08:45:00'),
(1, 3, 25, 60000, '2025-08-01 14:00:00'),
(2, 3, 20, 65000, '2025-08-02 15:00:00'),
(3, 4, 15, 70000, '2025-05-15 12:30:00'),
(4, 4, 18, 68000, '2025-05-16 13:45:00'),
(5, 5, 22, 75000, '2025-06-10 11:15:00');

-- 54. Tabla Detalle_VentaE (3 FK: Venta_Evento, Cerveza_Presentacion)
INSERT INTO Detalle_VentaE (cantidad, precio_unitario, Venta_Evento_Proveedor_proveedor_id, Venta_Evento_Evento_evento_id, Cerveza_Presentacion_Cerveza_cerveza_id, Cerveza_Presentacion_Presentación_presentación_id) VALUES
(50, 40000, 1, 1, 1, 1),
(40, 45000, 2, 1, 2, 2),
(30, 50000, 3, 1, 3, 3),
(35, 48000, 4, 1, 4, 4),
(45, 42000, 5, 1, 5, 5),
(25, 60000, 1, 3, 6, 6),
(20, 65000, 2, 3, 7, 7),
(15, 70000, 3, 4, 8, 8),
(18, 68000, 4, 4, 9, 9),
(22, 75000, 5, 5, 10, 10);

-- 55. Tabla Compra_Evento (2 FK: Cliente, Evento)
INSERT INTO Compra_Evento (Cliente_RIF, Evento_evento_id, fecha, monto_total) VALUES
(123456789, 1, '2025-07-10', 2000000),
(987654321, 1, '2025-07-10', 1800000),
(555555555, 1, '2025-07-11', 1500000),
(123456780, 1, '2025-07-11', 1200000),
(987654320, 1, '2025-07-10', 1600000),
(555555550, 3, '2025-08-20', 750000),
(123456789, 3, '2025-08-21', 600000),
(987654321, 4, '2025-05-30', 900000),
(555555555, 4, '2025-05-30', 850000),
(123456780, 5, '2025-06-25', 1100000);

-- Inserts para Inventario_E_Cerveza_P (relaciona cervezas-presentación con eventos)
INSERT INTO Inventario_E_Cerveza_P (
    Cerveza_Presentacion_Cerveza_cerveza_id,
    Cerveza_Presentacion_Presentación_presentación_id,
    cantidad,
    Evento_evento_id
) VALUES
-- Para el Evento 1 (UBirra 2025)
(1, 1, 200, 1),   -- 200 Destilo Amber (botella 330ml)
(2, 2, 150, 1),   -- 150 Benitz Pale Ale (botella 500ml)
(3, 3, 100, 1),   -- 100 Mito Candileja (botella 750ml)
-- Para el Evento 2 (Taller de Iniciación)
(4, 4, 50, 2),    -- 50 Ángel o Demonio (lata 355ml)
(5, 5, 80, 2),    -- 80 Aldarra Mantuana (lata 473ml)
-- Para el Evento 3 (Concurso Cervecero)
(6, 6, 60, 3),    -- 60 Latin American IPA (barril 5L)
(7, 7, 40, 3),    -- 40 Tovar Stout (barril 10L)
-- Para el Evento 4 (Degustación Premium)
(8, 8, 30, 4),    -- 30 UCAB Lager (barril 20L)
(9, 9, 25, 4),    -- 25 Caracas Porter (growler 1L)
-- Para el Evento 5 (Cena de Maridaje)
(10, 10, 40, 5);  -- 40 Avila Wheat (growler 2L)


-- 56. Tabla Detalle_Evento (6 FK: Compra_Evento, Inventario_E_Cerveza_P, Tasa_Cambio)
INSERT INTO Detalle_Evento (Tasa_Cambio_tasa_cambio_id, detalle_evento_id, cantidad_cerveza, Compra_Evento_Cliente_RIF, Compra_Evento_Evento_evento_id, Inventario_E_Cerveza_P_evento_id, Inventario_E_Cerveza_P_cerveza_id, Inventario_E_Cerveza_P_presentación_id) VALUES
(1, 1, 20, 123456789, 1, 1, 1, 1),
(1, 2, 15, 987654321, 1, 1, 1, 1),
(1, 3, 12, 555555555, 1, 1, 1, 1),
(1, 4, 10, 123456780, 1, 1, 1, 1),
(1, 5, 18, 987654320, 1, 1, 1, 1),
(3, 6, 8, 555555550, 3, 1, 3, 3),
(3, 7, 6, 123456789, 3, 1, 3, 3),
(1, 8, 12, 987654321, 4, 2, 4, 4),
(1, 9, 10, 555555555, 4, 2, 4, 4),
(1, 10, 15, 123456780, 5, 2, 5, 5);

-- 57. Tabla Pago_Fisica (3 FK: Venta_Física, Método_Pago)
INSERT INTO Pago_Fisica (fecha_pago, monto_pagado, referencia_pago, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id, Método_Pago_método_pago_id, puntos_usuados) VALUES
('2025-03-05', 1200000, 'PAG-001', 1, 16, 16, 0),
('2025-03-10', 950000, 'PAG-002', 1, 17, 11, 50000),
('2025-03-15', 1500000, 'PAG-003', 1, 18, 1, 0),
('2025-04-02', 850000, 'PAG-004', 2, 16, 12, 30000),
('2025-04-10', 1100000, 'PAG-005', 2, 17, 17, 0),
('2025-04-20', 1300000, 'PAG-006', 2, 18, 2, 0),
('2025-05-05', 900000, 'PAG-007', 3, 19, 13, 40000),
('2025-05-15', 750000, 'PAG-008', 3, 20, 18, 0),
('2025-06-03', 1400000, 'PAG-009', 4, 19, 3, 0),
('2025-07-12', 1250000, 'PAG-010', 5, 20, 14, 60000);

-- 58. Tabla Pago_Online (3 FK: Venta_Online, Método_Pago)
INSERT INTO Pago_Online (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Venta_Online_tienda_online_id, Venta_Online_usuario_id, puntos_usados) VALUES
(6, '2025-03-01', 800000, 'PAG-011', 1, 1, 0),
(7, '2025-03-10', 950000, 'PAG-012', 1, 2, 45000),
(8, '2025-04-05', 1200000, 'PAG-013', 1, 3, 0),
(9, '2025-04-15', 750000, 'PAG-014', 2, 4, 35000),
(10, '2025-05-10', 1100000, 'PAG-015', 2, 5, 0),
(11, '2025-05-20', 850000, 'PAG-016', 1, 6, 40000),
(12, '2025-06-05', 1300000, 'PAG-017', 2, 7, 0),
(13, '2025-06-15', 900000, 'PAG-018', 1, 8, 45000),
(14, '2025-07-01', 1400000, 'PAG-019', 2, 9, 0),
(15, '2025-07-10', 1250000, 'PAG-020', 1, 10, 60000);


-- 59. Tabla Pago_Entrada (3 FK: Venta_Entrada, Método_Pago)
INSERT INTO Pago_Entrada (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Venta_Entrada_Cliente_RIF, Venta_Entrada_Evento_evento_id, Venta_Entrada_venta_entrada_id) VALUES
(1, '2025-07-01', 500000, 'ENT-001', 123456789, 1, 1),
(2, '2025-07-02', 500000, 'ENT-002', 987654321, 1, 2),
(3, '2025-07-03', 500000, 'ENT-003', 555555555, 1, 3),
(4, '2025-07-04', 500000, 'ENT-004', 123456780, 1, 4),
(5, '2025-07-05', 500000, 'ENT-005', 987654320, 1, 5),
(6, '2025-08-01', 300000, 'ENT-006', 555555550, 3, 6),
(7, '2025-08-02', 300000, 'ENT-007', 123456789, 3, 7),
(8, '2025-05-15', 400000, 'ENT-008', 987654321, 4, 8),
(9, '2025-05-20', 400000, 'ENT-009', 555555555, 4, 9),
(10, '2025-06-10', 600000, 'ENT-010', 123456780, 5, 10);

-- 60. Tabla Pago_Compra_Evento (3 FK: Compra_Evento, Método_Pago)
INSERT INTO Pago_Compra_Evento (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Compra_Evento_Cliente_RIF, Compra_Evento_Evento_evento_id) VALUES
(1, '2025-07-10', 2000000, 'PCE-001', 123456789, 1),
(2, '2025-07-10', 1800000, 'PCE-002', 987654321, 1),
(3, '2025-07-11', 1500000, 'PCE-003', 555555555, 1),
(4, '2025-07-11', 1200000, 'PCE-004', 123456780, 1),
(5, '2025-07-10', 1600000, 'PCE-005', 987654320, 1),
(6, '2025-08-20', 750000, 'PCE-006', 555555550, 3),
(7, '2025-08-21', 600000, 'PCE-007', 123456789, 3),
(8, '2025-05-30', 900000, 'PCE-008', 987654321, 4),
(9, '2025-05-30', 850000, 'PCE-009', 555555555, 4),
(10, '2025-06-25', 1100000, 'PCE-010', 123456780, 5);

-- 61. Tabla Pago_CompraP (3 FK: Compra, Método_Pago)
INSERT INTO Pago_CompraP (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Compra_proveedor_id, Compra_compra_id) VALUES
(1, '2025-03-05', 5000000, 'PCP-001', 1, 1),
(2, '2025-03-12', 4500000, 'PCP-002', 2, 2),
(3, '2025-03-18', 4800000, 'PCP-003', 3, 3),
(4, '2025-03-25', 5200000, 'PCP-004', 4, 4),
(5, '2025-04-02', 4600000, 'PCP-005', 5, 5),
(6, '2025-04-10', 6000000, 'PCP-006', 1, 6),
(7, '2025-04-17', 5500000, 'PCP-007', 2, 7),
(8, '2025-04-24', 4900000, 'PCP-008', 3, 8),
(9, '2025-05-01', 5100000, 'PCP-009', 4, 9),
(10, '2025-05-08', 5800000, 'PCP-010', 5, 10);

-- 62. Tabla Asistencia (1 FK: Empleado)
INSERT INTO Asistencia (asistencia_id, fecha, hora_entrada_registrada, hora_salida_registrada, Empleado_empleado_id) VALUES
(1, '2025-03-01', '2025-03-01 08:00:00', '2025-03-01 17:05:00', 1),
(2, '2025-03-01', '2025-03-01 08:05:00', '2025-03-01 17:10:00', 2),
(3, '2025-03-01', '2025-03-01 08:10:00', '2025-03-01 17:15:00', 3),
(4, '2025-03-01', '2025-03-01 08:15:00', '2025-03-01 17:20:00', 4),
(5, '2025-03-01', '2025-03-01 08:20:00', '2025-03-01 17:25:00', 5),
(6, '2025-03-02', '2025-03-02 08:00:00', '2025-03-02 17:05:00', 1),
(7, '2025-03-02', '2025-03-02 08:05:00', '2025-03-02 17:10:00', 2),
(8, '2025-03-02', '2025-03-02 08:10:00', '2025-03-02 17:15:00', 3),
(9, '2025-03-02', '2025-03-02 08:15:00', '2025-03-02 17:20:00', 4),
(10, '2025-03-02', '2025-03-02 08:20:00', '2025-03-02 17:25:00', 5);

-- 63. Tabla Vacación (1 FK: Empleado)
INSERT INTO Vacación (Empleado_empleado_id, vacación_id, fecha_inicio, fecha_fin) VALUES
(1, 1, '2025-06-01', '2025-06-15'),
(2, 2, '2025-07-01', '2025-07-15'),
(3, 3, '2025-08-01', '2025-08-15'),
(4, 4, '2025-09-01', '2025-09-15'),
(5, 5, '2025-10-01', '2025-10-15'),
(6, 6, '2025-11-01', '2025-11-15'),
(7, 7, '2025-12-01', '2025-12-15'),
(8, 8, '2026-01-01', '2026-01-15'),
(9, 9, '2026-02-01', '2026-02-15'),
(10, 10, '2026-03-01', '2026-03-15');

-- 64. Tabla Cuota (1 FK: Proveedor)
INSERT INTO Cuota (cuota_id, descripción, monto_cuota, periodicidad, fecha_vigencia_monto, Proveedor_proveedor_id) VALUES
(1, 'Cuota afiliación básica', 500000, 'Mensual', '2025-01-01', 1),
(2, 'Cuota afiliación estándar', 750000, 'Mensual', '2025-01-01', 2),
(3, 'Cuota afiliación premium', 1000000, 'Mensual', '2025-01-01', 3),
(4, 'Cuota afiliación básica', 500000, 'Mensual', '2025-01-01', 4),
(5, 'Cuota afiliación estándar', 750000, 'Mensual', '2025-01-01', 5),
(6, 'Cuota promocional', 400000, 'Mensual', '2025-06-01', 1),
(7, 'Cuota promocional', 600000, 'Mensual', '2025-06-01', 2),
(8, 'Cuota promocional', 800000, 'Mensual', '2025-06-01', 3),
(9, 'Cuota promocional', 400000, 'Mensual', '2025-06-01', 4),
(10, 'Cuota promocional', 600000, 'Mensual', '2025-06-01', 5);

-- 65. Tabla Pago_Cuota (2 FK: Cuota, Método_Pago)
INSERT INTO Pago_Cuota (Método_Pago_método_pago_id, Cuota_cuota_id, fecha_pago, monto_pagado, recibo_id) VALUES
(1, 1, '2025-01-05', 500000, 'REC-001'),
(2, 2, '2025-01-05', 750000, 'REC-002'),
(3, 3, '2025-01-05', 1000000, 'REC-003'),
(4, 4, '2025-01-05', 500000, 'REC-004'),
(5, 5, '2025-01-05', 750000, 'REC-005'),
(6, 6, '2025-06-05', 400000, 'REC-006'),
(7, 7, '2025-06-05', 600000, 'REC-007'),
(8, 8, '2025-06-05', 800000, 'REC-008'),
(9, 9, '2025-06-05', 400000, 'REC-009'),
(10, 10, '2025-06-05', 600000, 'REC-010');




--80 punto
-- Inserts para la tabla Punto (10 registros)
INSERT INTO Punto (método_pago_id) VALUES
(1),  -- Puntos asociados al método de pago 1
(2),  -- Puntos asociados al método de pago 2
(3),  -- Puntos asociados al método de pago 3
(4),  -- Puntos asociados al método de pago 4
(5),  -- Puntos asociados al método de pago 5
(6),  -- Puntos asociados al método de pago 6
(7),  -- Puntos asociados al método de pago 7
(8),  -- Puntos asociados al método de pago 8
(9),  -- Puntos asociados al método de pago 9
(10); -- Puntos asociados al método de pago 10

-- 66. Tabla Cliente_Punto (2 FK: Cliente, Punto)
INSERT INTO Cliente_Punto (cantidad_puntos, Punto_método_pago_id, Cliente_RIF) VALUES
(1000, 1, 123456789),
(800, 2, 987654321),
(1200, 3, 555555555),
(750, 4, 111111111),
(1500, 5, 999999999),
(900, 6, 123456780),
(600, 7, 987654320),
(1100, 8, 555555550),
(850, 9, 111111110),
(1300, 10, 999999990);

--81 descuento 
-- Inserts para la tabla Descuento (10 registros)
INSERT INTO Descuento (descuento_id, porcentaje_descuento) VALUES
(1, 5),   -- 5% de descuento (promoción básica)
(2, 10),  -- 10% de descuento (promoción estándar)
(3, 15),  -- 15% de descuento (promoción especial)
(4, 20),  -- 20% de descuento (liquidación)
(5, 25),  -- 25% de descuento (oferta por volumen)
(6, 30),  -- 30% de descuento (días especiales)
(7, 35),  -- 35% de descuento (miembros premium)
(8, 40),  -- 40% de descuento (temporada baja)
(9, 50),  -- 50% de descuento (oferta relámpago)
(10, 60); -- 60% de descuento (últimas unidades)

-- 67. Tabla Descuento_Inventario (2 FK: Descuento, Inventario)
INSERT INTO Descuento_Inventario (Descuento_descuento_id, Inventario_inventario_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 6),
(2, 7),
(3, 8),
(4, 9),
(5, 10);

-- 68. Tabla Juez_Evento (2 FK: Juez, Evento)
INSERT INTO Juez_Evento (Evento_evento_id, Juez_juez_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5),
(3, 6), (3, 7), (3, 8),
(4, 9), (4, 10),
(5, 1), (5, 3),
(6, 2), (6, 4),
(7, 5), (7, 7),
(8, 6), (8, 8),
(9, 9), (9, 10),
(10, 1), (10, 10);

-- 81 permiso Inserts para la tabla Permiso (10 registros)
INSERT INTO Permiso (
    permiso_id,
    fecha_solicitud,
    fecha_inicio,
    fecha_fin,
    motivo
) VALUES
-- Permiso por enfermedad
(1, '2025-03-01', '2025-03-02', '2025-03-05', 'Enfermedad con certificado médico'),
-- Permiso por asuntos personales
(2, '2025-03-10', '2025-03-15', '2025-03-15', 'Trámite personal bancario'),
-- Permiso por capacitación
(3, '2025-04-05', '2025-04-10', '2025-04-12', 'Curso de certificación cervecera'),
-- Permiso por emergencia familiar
(4, '2025-04-20', '2025-04-21', '2025-04-23', 'Emergencia familiar - hospitalización'),
-- Permiso por maternidad
(5, '2025-05-01', '2025-05-15', '2025-08-15', 'Licencia por maternidad'),
-- Permiso por examen
(6, '2025-06-10', '2025-06-15', '2025-06-15', 'Examen universitario'),
-- Permiso por duelo
(7, '2025-07-05', '2025-07-07', '2025-07-10', 'Fallecimiento de familiar directo'),
-- Permiso por vacaciones
(8, '2025-08-01', '2025-08-15', '2025-08-30', 'Vacaciones anuales programadas'),
-- Permiso por evento corporativo
(9, '2025-09-10', '2025-09-20', '2025-09-22', 'Participación en festival cervecero'),
-- Permiso por paternidad
(10, '2025-10-01', '2025-10-05', '2025-10-20', 'Licencia por paternidad');

-- 69. Tabla Rol_Permiso (2 FK: Rol, Permiso)
INSERT INTO Rol_Permiso (Permiso_permiso_id, Rol_rol_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1),
(2, 2), (3, 2), (5, 2), (8, 2),
(2, 3), (3, 3), (8, 3),
(2, 4), (9, 4),
(2, 5), (5, 5), (10, 5),
(2, 6), (3, 6), (8, 6),
(2, 7), (7, 7),
(2, 8), (3, 8), (5, 8),
(2, 9), (5, 9),
(2, 10), (6, 10);

-- 70. Tabla TipoED_Horario (4 FK: TipoE_Departamento, Horario)
INSERT INTO TipoED_Horario (Horario_horario_id, TipoE_Departamento_Tipo_Empleado_tipo_empleado_id, TipoE_Departamento_Departamento_departamento_id, TipoE_Departamento_Empleado_empleado_id) VALUES
(1, 1, 11, 1),
(1, 2, 12, 2),
(1, 3, 13, 3),
(2, 4, 14, 4),
(2, 5, 15, 5),
(3, 6, 16, 6),
(3, 7, 17, 7),
(4, 8, 18, 8),
(4, 9, 19, 9),
(5, 10, 20, 10);

-- 71. Tabla Compra_Estatus (3 FK: Compra, Estatus)
INSERT INTO Compra_Estatus (fecha_inicio, fecha_fin, Estatus_estatus_id, Compra_proveedor_id, Compra_compra_id) VALUES
('2025-03-01', '2025-03-02', 1, 1, 1),
('2025-03-02', '2025-03-03', 2, 1, 1),
('2025-03-03', '2025-03-05', 3, 1, 1),
('2025-03-10', '2025-03-11', 1, 2, 2),
('2025-03-11', '2025-03-12', 2, 2, 2),
('2025-03-12', '2025-03-15', 3, 2, 2),
('2025-03-18', '2025-03-19', 1, 3, 3),
('2025-03-19', '2025-03-20', 2, 3, 3),
('2025-03-20', '2025-03-22', 3, 3, 3),
('2025-03-25', '2025-03-26', 1, 4, 4);

-- 72. Tabla OrdenR_Estatus (2 FK: Orden_Reposición, Estatus)
INSERT INTO OrdenR_Estatus (fecha_inicio, fecha_fin, Estatus_estatus_id, Orden_Reposición_orden_reposición_id) VALUES
('2025-03-01', '2025-03-01', 1, 1),
('2025-03-01', '2025-03-02', 2, 1),
('2025-03-02', NULL, 3, 1),
('2025-03-15', '2025-03-15', 1, 2),
('2025-03-15', '2025-03-16', 2, 2),
('2025-03-16', NULL, 3, 2),
('2025-04-01', '2025-04-01', 1, 3),
('2025-04-01', '2025-04-02', 2, 3),
('2025-04-02', NULL, 3, 3),
('2025-04-15', '2025-04-15', 1, 4);

-- 73. Tabla VentaF_Estatus (3 FK: Venta_Física, Estatus)
INSERT INTO VentaF_Estatus (fecha_inicio, fecha_fin, Estatus_estatus_id, Venta_Física_Tienda_Física_tienda_fisica_id, Venta_Física_Usuario_usuario_id) VALUES
('2025-03-05', '2025-03-05', 1, 1, 16),
('2025-03-05', '2025-03-05', 2, 1, 16),
('2025-03-05', NULL, 3, 1, 16),
('2025-03-10', '2025-03-10', 1, 1, 17),
('2025-03-10', '2025-03-10', 2, 1, 17),
('2025-03-10', NULL, 3, 1, 17),
('2025-03-15', '2025-03-15', 1, 1, 18),
('2025-03-15', '2025-03-15', 2, 1, 18),
('2025-03-15', NULL, 3, 1, 18),
('2025-04-02', '2025-04-02', 1, 2, 16);

-- 74. Tabla VentaO_Estatus (3 FK: Venta_Online, Estatus)
INSERT INTO VentaO_Estatus (fecha_inicio, fecha_fin, Estatus_estatus_id, Venta_Online_Tienda_Online_tienda_online_id, Venta_Online_Usuario_usuario_id) VALUES
('2025-03-01', '2025-03-01', 1, 1, 1),
('2025-03-01', '2025-03-01', 2, 1, 1),
('2025-03-01', NULL, 3, 1, 1),
('2025-03-10', '2025-03-10', 1, 1, 2),
('2025-03-10', '2025-03-10', 2, 1, 2),
('2025-03-10', NULL, 3, 1, 2),
('2025-04-05', '2025-04-05', 1, 1, 3),
('2025-04-05', '2025-04-05', 2, 1, 3),
('2025-04-05', NULL, 3, 1, 3),
('2025-04-15', '2025-04-15', 1, 2, 4);

-- 75. Tabla Vacacion_Estatus (2 FK: Vacación, Estatus)
INSERT INTO Vacacion_Estatus (fecha_inicio, fecha_fin, Estatus_estatus_id, Vacación_vacación_id) VALUES
('2025-05-20', '2025-05-25', 1, 1),
('2025-05-25', '2025-05-30', 2, 1),
('2025-05-30', NULL, 3, 1),
('2025-06-20', '2025-06-25', 1, 2),
('2025-06-25', '2025-06-30', 2, 2),
('2025-06-30', NULL, 3, 2),
('2025-07-20', '2025-07-25', 1, 3),
('2025-07-25', '2025-07-30', 2, 3),
('2025-07-30', NULL, 3, 3),
('2025-08-20', '2025-08-25', 1, 4);















