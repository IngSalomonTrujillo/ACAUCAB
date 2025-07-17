import pg from 'pg';
const { Pool } = pg;

const pool = new Pool({
    host: 'localhost',
    port: 5432,
    database: 'ACAUCAB',
    user: 'postgres',
    password: '1234'
});

async function insertTestData() {
    try {
        console.log('📊 Insertando datos de prueba para puntos canjeados...');

        // Inserts previos en Venta_Física (para llaves foráneas)
        console.log('📝 Insertando en Venta_Física...');
        const ventaFisicaResult = await pool.query(`
            INSERT INTO Venta_Física (Tienda_Física_tienda_fisica_id, Usuario_usuario_id, fecha_hora_venta, monto_total) VALUES
            (1, 16, '2025-06-15 10:00:00', 800000),
            (2, 17, '2025-06-20 11:00:00', 1200000),
            (3, 18, '2025-06-25 12:00:00', 950000)
            ON CONFLICT DO NOTHING
            RETURNING *;
        `);
        console.log('✅ Registros insertados en Venta_Física:', ventaFisicaResult.rows.length);

        // Inserts previos en Venta_Online (para llaves foráneas)
        console.log('📝 Insertando en Venta_Online...');
        const ventaOnlineResult = await pool.query(`
            INSERT INTO Venta_Online (Tienda_Online_tienda_online_id, Usuario_usuario_id, venta_id, fecha_hora_venta, monto_total) VALUES
            (1, 1, 1001, '2025-06-18 13:00:00', 1100000),
            (2, 2, 1002, '2025-06-22 14:00:00', 750000),
            (1, 3, 1003, '2025-06-28 15:00:00', 1300000)
            ON CONFLICT DO NOTHING
            RETURNING *;
        `);
        console.log('✅ Registros insertados en Venta_Online:', ventaOnlineResult.rows.length);

        // 1. Insert en Pago_Fisica con puntos usados (IDs válidos)
        console.log('📝 Insertando en Pago_Fisica...');
        const pagoFisicaResult = await pool.query(`
            INSERT INTO Pago_Fisica (fecha_pago, monto_pagado, referencia_pago, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id, Método_Pago_método_pago_id, puntos_usuados) VALUES
            ('2025-06-15', 800000, 'PAG-TEST-001', 1, 16, 16, 25000),
            ('2025-06-20', 1200000, 'PAG-TEST-002', 2, 17, 11, 35000),
            ('2025-06-25', 950000, 'PAG-TEST-003', 3, 18, 12, 15000)
            RETURNING *;
        `);
        console.log('✅ Datos insertados en Pago_Fisica:', pagoFisicaResult.rows.length);

        // 2. Insert en Pago_Online con puntos usados (IDs válidos)
        console.log('📝 Insertando en Pago_Online...');
        const pagoOnlineResult = await pool.query(`
            INSERT INTO Pago_Online (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Venta_Online_tienda_online_id, Venta_Online_usuario_id, puntos_usados) VALUES
            (16, '2025-06-18', 1100000, 'PAG-TEST-004', 1, 1, 28000),
            (17, '2025-06-22', 750000, 'PAG-TEST-005', 2, 2, 20000),
            (18, '2025-06-28', 1300000, 'PAG-TEST-006', 1, 3, 42000)
            RETURNING *;
        `);
        console.log('✅ Datos insertados en Pago_Online:', pagoOnlineResult.rows.length);

        // 3. Insert adicional en Pago_Fisica SIN puntos usados (NO cumple condición)
        await pool.query(`
            INSERT INTO Pago_Fisica (fecha_pago, monto_pagado, referencia_pago, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id, Método_Pago_método_pago_id, puntos_usuados) VALUES
            ('2025-06-30', 600000, 'PAG-TEST-007', 1, 19, 13, 0),
            ('2025-07-05', 900000, 'PAG-TEST-008', 2, 20, 14, 0)
        `);
        console.log('✅ Datos insertados en Pago_Fisica SIN puntos usados');

        // 4. Insert adicional en Pago_Online SIN puntos usados (NO cumple condición)
        await pool.query(`
            INSERT INTO Pago_Online (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Venta_Online_tienda_online_id, Venta_Online_usuario_id, puntos_usados) VALUES
            (19, '2025-07-01', 850000, 'PAG-TEST-009', 1, 4, 0),
            (20, '2025-07-08', 1400000, 'PAG-TEST-010', 2, 5, 0)
        `);
        console.log('✅ Datos insertados en Pago_Online SIN puntos usados');

        console.log('🎉 Todos los datos de prueba insertados exitosamente');
    } catch (error) {
        console.error('❌ Error insertando datos de prueba:', error.message);
        console.error('Detalles:', error);
    } finally {
        await pool.end();
    }
}

insertTestData(); 