import pg from 'pg';
const { Pool } = pg;

const pool = new Pool({
    host: 'localhost',
    port: 5432,
    database: 'ACAUCAB',
    user: 'postgres',
    password: '1234'
});

async function listVentas() {
    try {
        console.log('🔍 Listando registros de Venta_Física...');
        const fisica = await pool.query('SELECT * FROM Venta_Física LIMIT 10');
        fisica.rows.forEach(row => {
            console.log(`Venta_Física: Tienda_Física_tienda_fisica_id=${row.tienda_física_tienda_fisica_id}, Usuario_usuario_id=${row.usuario_usuario_id}`);
        });

        console.log('🔍 Listando registros de Venta_Online...');
        const online = await pool.query('SELECT * FROM Venta_Online LIMIT 10');
        online.rows.forEach(row => {
            console.log(`Venta_Online: Tienda_Online_tienda_online_id=${row.tienda_online_tienda_online_id}, Usuario_usuario_id=${row.usuario_usuario_id}`);
        });
    } catch (error) {
        console.error('❌ Error listando ventas:', error);
    } finally {
        await pool.end();
    }
}

listVentas(); 