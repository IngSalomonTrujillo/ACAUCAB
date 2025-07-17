import pg from 'pg';
const { Pool } = pg;

const pool = new Pool({
    host: 'localhost',
    port: 5432,
    database: 'ACAUCAB',
    user: 'postgres',
    password: '1234'
});

async function checkPuntosData() {
    try {
        console.log('🔍 Verificando datos de puntos canjeados...');

        // 1. Verificar datos en Pago_Fisica
        const pagoFisica = await pool.query(`
            SELECT COUNT(*) as total, SUM(puntos_usuados) as total_puntos
            FROM pago_fisica 
            WHERE puntos_usuados > 0
        `);
        console.log('📊 Pago_Fisica con puntos usados:', pagoFisica.rows[0]);

        // 2. Verificar datos en Pago_Online
        const pagoOnline = await pool.query(`
            SELECT COUNT(*) as total, SUM(puntos_usados) as total_puntos
            FROM pago_online 
            WHERE puntos_usados > 0
        `);
        console.log('📊 Pago_Online con puntos usados:', pagoOnline.rows[0]);

        // 3. Verificar la consulta completa del reporte
        const reporteQuery = await pool.query(`
            SELECT 
                c.rif,
                c.tipo_cliente,
                c.número_carnet,
                COALESCE(pn.primer_nombre || ' ' || pn.primer_apellido, j.razón_social) as nombre_cliente,
                COALESCE(pf.puntos_usuados, po.puntos_usados, 0) as puntos_canjeados,
                (COALESCE(pf.puntos_usuados, po.puntos_usados, 0) * 1.00) as valor_bs,
                COALESCE(pf.fecha_pago, po.fecha_pago) as fecha_canje
            FROM cliente c
            LEFT JOIN personanatural pn ON c.rif = pn.rif
            LEFT JOIN jurídico j ON c.rif = j.rif
            LEFT JOIN usuario u ON c.rif = u.cliente_rif
            LEFT JOIN pago_fisica pf ON u.usuario_id = pf.venta_física_usuario_id 
                AND pf.puntos_usuados > 0
            LEFT JOIN pago_online po ON u.usuario_id = po.venta_online_usuario_id 
                AND po.puntos_usados > 0
            WHERE COALESCE(pf.puntos_usuados, po.puntos_usados, 0) > 0
            ORDER BY fecha_canje DESC, c.rif
        `);
        
        console.log('📊 Resultados de la consulta del reporte:', reporteQuery.rows.length, 'registros');
        if (reporteQuery.rows.length > 0) {
            console.log('📋 Primeros 3 registros:');
            reporteQuery.rows.slice(0, 3).forEach((row, index) => {
                console.log(`  ${index + 1}. ${row.nombre_cliente} - ${row.puntos_canjeados} puntos - ${row.fecha_canje}`);
            });
        }

        // 4. Verificar usuarios y clientes
        const usuarios = await pool.query(`
            SELECT COUNT(*) as total_usuarios, COUNT(cliente_rif) as usuarios_con_cliente
            FROM usuario
        `);
        console.log('📊 Usuarios:', usuarios.rows[0]);

        const clientes = await pool.query(`
            SELECT COUNT(*) as total_clientes
            FROM cliente
        `);
        console.log('📊 Clientes:', clientes.rows[0]);

    } catch (error) {
        console.error('❌ Error verificando datos:', error);
    } finally {
        await pool.end();
    }
}

checkPuntosData(); 