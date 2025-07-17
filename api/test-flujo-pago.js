import pool from './connectionPostgreSQL.js';

async function testFlujoPago() {
    try {
        console.log('🔍 Probando consulta de flujo de pago...');
        
        // Primero, verificar todos los registros de pago_fisica
        const allPagos = await pool.query(`
            SELECT 
                Venta_Física_tienda_fisica_id,
                Venta_Física_usuario_id,
                Método_Pago_método_pago_id,
                monto_pagado,
                fecha_pago
            FROM pago_fisica
            ORDER BY fecha_pago
        `);
        
        console.log('📊 Todos los pagos físicos:', allPagos.rows);
        console.log('📊 Total de registros:', allPagos.rows.length);
        
        // Ahora probar la consulta del reporte paso a paso
        const result = await pool.query(`
            SELECT 
                tipo_pago,
                COUNT(*) as cantidad_transacciones,
                SUM(monto_pagado) as monto_total,
                ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) as porcentaje
            FROM (
                SELECT DISTINCT
                    pf.venta_física_tienda_fisica_id,
                    pf.venta_física_usuario_id,
                    pf.método_pago_método_pago_id,
                    pf.monto_pagado,
                    CASE 
                        WHEN c.método_pago_id IS NOT NULL THEN 'Cheque'
                        WHEN cr.método_pago_id IS NOT NULL THEN 'Crédito'
                        WHEN d.método_pago_id IS NOT NULL THEN 'Débito'
                        WHEN e.método_pago_id IS NOT NULL THEN 'Efectivo'
                        WHEN p.método_pago_id IS NOT NULL THEN 'Puntos'
                        ELSE 'Otro'
                    END as tipo_pago
                FROM pago_fisica pf
                LEFT JOIN cheque c ON pf.método_pago_método_pago_id = c.método_pago_id
                LEFT JOIN crédito cr ON pf.método_pago_método_pago_id = cr.método_pago_id
                LEFT JOIN débito d ON pf.método_pago_método_pago_id = d.método_pago_id
                LEFT JOIN efectivo e ON pf.método_pago_método_pago_id = e.método_pago_id
                LEFT JOIN punto p ON pf.método_pago_método_pago_id = p.método_pago_id
            ) pagos
            GROUP BY tipo_pago
            ORDER BY cantidad_transacciones DESC
        `);
        
        console.log('📊 Resultado del reporte:', result.rows);
        
        // Verificar cada método de pago individualmente
        console.log('\n🔍 Verificando cada método de pago:');
        
        const metodos = ['Cheque', 'Crédito', 'Débito', 'Efectivo', 'Puntos'];
        
        for (const metodo of metodos) {
            const count = await pool.query(`
                SELECT COUNT(*) as count
                FROM pago_fisica pf
                LEFT JOIN cheque c ON pf.Método_Pago_método_pago_id = c.método_pago_id
                LEFT JOIN crédito cr ON pf.Método_Pago_método_pago_id = cr.método_pago_id
                LEFT JOIN débito d ON pf.Método_Pago_método_pago_id = d.método_pago_id
                LEFT JOIN efectivo e ON pf.Método_Pago_método_pago_id = e.método_pago_id
                LEFT JOIN punto p ON pf.Método_Pago_método_pago_id = p.método_pago_id
                WHERE CASE 
                    WHEN c.método_pago_id IS NOT NULL THEN 'Cheque'
                    WHEN cr.método_pago_id IS NOT NULL THEN 'Crédito'
                    WHEN d.método_pago_id IS NOT NULL THEN 'Débito'
                    WHEN e.método_pago_id IS NOT NULL THEN 'Efectivo'
                    WHEN p.método_pago_id IS NOT NULL THEN 'Puntos'
                    ELSE 'Otro'
                END = $1
            `, [metodo]);
            
            console.log(`${metodo}: ${count.rows[0].count} transacciones`);
        }
        
    } catch (error) {
        console.error('❌ Error:', error);
    } finally {
        await pool.end();
    }
}

testFlujoPago(); 