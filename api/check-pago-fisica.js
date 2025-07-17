import pool from './connectionPostgreSQL.js';

async function checkPagoFisica() {
    try {
        console.log('🔍 Verificando datos de pago físico...');
        
        // Verificar datos de pago_fisica
        const resultPagoFisica = await pool.query(`
            SELECT 
                COUNT(*) as total_pagos,
                COUNT(DISTINCT Método_Pago_método_pago_id) as metodos_diferentes,
                COALESCE(SUM(monto_pagado), 0) as monto_total
            FROM pago_fisica
        `);
        
        console.log('📊 Pago_Fisica:', resultPagoFisica.rows[0]);
        
        // Verificar métodos de pago
        const resultMetodos = await pool.query(`
            SELECT 
                mp.método_pago_id,
                CASE 
                    WHEN c.método_pago_id IS NOT NULL THEN 'Cheque'
                    WHEN cr.método_pago_id IS NOT NULL THEN 'Crédito'
                    WHEN d.método_pago_id IS NOT NULL THEN 'Débito'
                    WHEN e.método_pago_id IS NOT NULL THEN 'Efectivo'
                    WHEN p.método_pago_id IS NOT NULL THEN 'Puntos'
                    ELSE 'Otro'
                END as nombre_método,
                COUNT(*) as cantidad_transacciones,
                COALESCE(SUM(pf.monto_pagado), 0) as monto_total
            FROM método_pago mp
            LEFT JOIN pago_fisica pf ON mp.método_pago_id = pf.Método_Pago_método_pago_id
            LEFT JOIN cheque c ON mp.método_pago_id = c.método_pago_id
            LEFT JOIN crédito cr ON mp.método_pago_id = cr.método_pago_id
            LEFT JOIN débito d ON mp.método_pago_id = d.método_pago_id
            LEFT JOIN efectivo e ON mp.método_pago_id = e.método_pago_id
            LEFT JOIN punto p ON mp.método_pago_id = p.método_pago_id
            GROUP BY mp.método_pago_id, 
                CASE 
                    WHEN c.método_pago_id IS NOT NULL THEN 'Cheque'
                    WHEN cr.método_pago_id IS NOT NULL THEN 'Crédito'
                    WHEN d.método_pago_id IS NOT NULL THEN 'Débito'
                    WHEN e.método_pago_id IS NOT NULL THEN 'Efectivo'
                    WHEN p.método_pago_id IS NOT NULL THEN 'Puntos'
                    ELSE 'Otro'
                END
            ORDER BY cantidad_transacciones DESC
        `);
        
        console.log('📊 Métodos de pago con transacciones:', resultMetodos.rows);
        
        // Verificar la consulta del reporte
        const resultReporte = await pool.query(`
            SELECT 
                tipo_pago,
                COUNT(*) as cantidad_transacciones,
                SUM(monto_pagado) as monto_total,
                ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) as porcentaje
            FROM (
                SELECT DISTINCT
                    pf.Venta_Física_tienda_fisica_id,
                    pf.Venta_Física_usuario_id,
                    pf.Método_Pago_método_pago_id,
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
                LEFT JOIN cheque c ON pf.Método_Pago_método_pago_id = c.método_pago_id
                LEFT JOIN crédito cr ON pf.Método_Pago_método_pago_id = cr.método_pago_id
                LEFT JOIN débito d ON pf.Método_Pago_método_pago_id = d.método_pago_id
                LEFT JOIN efectivo e ON pf.Método_Pago_método_pago_id = e.método_pago_id
                LEFT JOIN punto p ON pf.Método_Pago_método_pago_id = p.método_pago_id
            ) pagos
            GROUP BY tipo_pago
            ORDER BY cantidad_transacciones DESC
        `);
        
        console.log('📊 Resultados de la consulta del reporte:', resultReporte.rows);
        
    } catch (error) {
        console.error('❌ Error:', error);
    } finally {
        await pool.end();
    }
}

checkPagoFisica(); 