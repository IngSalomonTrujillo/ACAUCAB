import pool from './connectionPostgreSQL.js';

async function checkTableStructure() {
    try {
        console.log('🔍 Verificando estructura de tablas de inventario...');
        
        const tables = ['inventario', 'lugar_tienda', 'tienda_física', 'cerveza', 'presentación', 'cerveza_presentacion', 'tipo_cerveza'];
        
        for (const table of tables) {
            console.log(`\n📋 Estructura de la tabla: ${table}`);
            const result = await pool.query(`
                SELECT column_name, data_type, is_nullable
                FROM information_schema.columns
                WHERE table_name = $1
                ORDER BY ordinal_position
            `, [table]);
            
            result.rows.forEach(row => {
                console.log(`  - ${row.column_name} (${row.data_type}, ${row.is_nullable === 'YES' ? 'NULL' : 'NOT NULL'})`);
            });
        }
        
    } catch (error) {
        console.error('❌ Error verificando estructura:', error.message);
    } finally {
        await pool.end();
    }
}

checkTableStructure(); 