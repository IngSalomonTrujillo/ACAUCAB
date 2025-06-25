import pool from './connectionPostgreSQL.js';

async function checkCervezaPresentacion() {
    try {
        console.log('🔍 Verificando estructura de cerveza_presentacion...');
        
        const result = await pool.query(`
            SELECT column_name, data_type, is_nullable
            FROM information_schema.columns
            WHERE table_name = 'cerveza_presentacion'
            ORDER BY ordinal_position
        `);
        
        console.log('📋 Columnas de cerveza_presentacion:');
        result.rows.forEach(row => {
            console.log(`  - ${row.column_name} (${row.data_type}, ${row.is_nullable === 'YES' ? 'NULL' : 'NOT NULL'})`);
        });
        
        // También verificar si hay datos
        const dataResult = await pool.query('SELECT * FROM cerveza_presentacion LIMIT 3');
        console.log('\n📊 Datos de ejemplo:');
        dataResult.rows.forEach(row => {
            console.log('  ', row);
        });
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    } finally {
        await pool.end();
    }
}

checkCervezaPresentacion(); 