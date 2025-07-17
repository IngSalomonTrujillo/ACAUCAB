import pool from './connectionPostgreSQL.js';

async function checkUsuarios() {
    try {
        const result = await pool.query('SELECT usuario_id, nombre_usuario FROM usuario LIMIT 20');
        console.log('IDs de usuario válidos:');
        result.rows.forEach(row => {
            console.log(`  - ID: ${row.usuario_id} | Usuario: ${row.nombre_usuario}`);
        });
    } catch (error) {
        console.error('❌ Error consultando usuarios:', error);
    } finally {
        await pool.end();
    }
}

checkUsuarios(); 