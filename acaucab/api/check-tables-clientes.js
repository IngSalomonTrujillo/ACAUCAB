import pool from './connectionPostgreSQL.js';

async function checkTablesClientes() {
    try {
        console.log('🔍 Verificando tablas de clientes...');
        
        // Verificar todas las tablas que contengan "persona" o "juridico"
        const tables = await pool.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND (table_name ILIKE '%persona%' OR table_name ILIKE '%juridico%' OR table_name ILIKE '%cliente%')
            ORDER BY table_name
        `);
        
        console.log('📋 Tablas encontradas:');
        tables.rows.forEach(table => {
            console.log(`   - ${table.table_name}`);
        });
        
        // Verificar estructura de la tabla persona_natural (si existe)
        try {
            const personaColumns = await pool.query(`
                SELECT column_name, data_type
                FROM information_schema.columns
                WHERE table_name = 'personanatural'
                ORDER BY ordinal_position
            `);
            
            console.log('\n📊 Estructura de tabla personanatural:');
            personaColumns.rows.forEach(col => {
                console.log(`   - ${col.column_name} (${col.data_type})`);
            });
        } catch (e) {
            console.log('❌ Tabla personanatural no encontrada');
        }
        
        // Verificar estructura de la tabla jurídico (si existe)
        try {
            const juridicoColumns = await pool.query(`
                SELECT column_name, data_type
                FROM information_schema.columns
                WHERE table_name = 'jurídico'
                ORDER BY ordinal_position
            `);
            
            console.log('\n📊 Estructura de tabla jurídico:');
            juridicoColumns.rows.forEach(col => {
                console.log(`   - ${col.column_name} (${col.data_type})`);
            });
        } catch (e) {
            console.log('❌ Tabla jurídico no encontrada');
        }
        
    } catch (error) {
        console.error('❌ Error:', error);
    } finally {
        await pool.end();
    }
}

checkTablesClientes(); 