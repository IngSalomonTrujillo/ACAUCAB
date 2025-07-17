-- Inserts de prueba para puntos canjeados
-- Estos inserts crean pagos con puntos usados para probar el reporte

-- 1. Insert adicional en Pago_Fisica con puntos usados (cumple condición)
INSERT INTO Pago_Fisica (fecha_pago, monto_pagado, referencia_pago, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id, Método_Pago_método_pago_id, puntos_usuados) VALUES
('2025-06-15', 800000, 'PAG-TEST-001', 1, 16, 16, 25000),
('2025-06-20', 1200000, 'PAG-TEST-002', 2, 17, 11, 35000),
('2025-06-25', 950000, 'PAG-TEST-003', 3, 18, 12, 15000);

-- 2. Insert adicional en Pago_Online con puntos usados (cumple condición)
INSERT INTO Pago_Online (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Venta_Online_tienda_online_id, Venta_Online_usuario_id, puntos_usados) VALUES
(16, '2025-06-18', 1100000, 'PAG-TEST-004', 1, 1, 28000),
(17, '2025-06-22', 750000, 'PAG-TEST-005', 2, 2, 20000),
(18, '2025-06-28', 1300000, 'PAG-TEST-006', 1, 3, 42000);

-- 3. Insert adicional en Pago_Fisica SIN puntos usados (NO cumple condición)
INSERT INTO Pago_Fisica (fecha_pago, monto_pagado, referencia_pago, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id, Método_Pago_método_pago_id, puntos_usuados) VALUES
('2025-06-30', 600000, 'PAG-TEST-007', 1, 19, 13, 0),
('2025-07-05', 900000, 'PAG-TEST-008', 2, 20, 14, 0);

-- 4. Insert adicional en Pago_Online SIN puntos usados (NO cumple condición)
INSERT INTO Pago_Online (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Venta_Online_tienda_online_id, Venta_Online_usuario_id, puntos_usados) VALUES
(19, '2025-07-01', 850000, 'PAG-TEST-009', 1, 4, 0),
(20, '2025-07-08', 1400000, 'PAG-TEST-010', 2, 5, 0); 