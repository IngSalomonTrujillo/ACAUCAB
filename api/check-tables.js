import pool from "./connectionPostgreSQL.js";

async function checkTables() {
    try {
        console.log('🔍 Verificando tablas en la base de datos ACAUCAB...');
        
        const result = await pool.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_type = 'BASE TABLE'
            ORDER BY table_name
        `);
        
        console.log('✅ Tablas encontradas:');
        result.rows.forEach(row => {
            console.log(`  - ${row.table_name}`);
        });
        
        // Verificar tablas específicas que necesitamos
        const tablasNecesarias = [
            'Inventario',
            'Lugar_Tienda', 
            'Tienda_Física',
            'Cerveza',
            'Presentación',
            'Cerveza_Presentacion',
            'Tipo_Cerveza'
        ];
        
        console.log('\n🔍 Verificando tablas necesarias para inventario:');
        for (const tabla of tablasNecesarias) {
            const existe = result.rows.some(row => row.table_name.toLowerCase() === tabla.toLowerCase());
            console.log(`  ${existe ? '✅' : '❌'} ${tabla}`);
        }
        
    } catch (error) {
        console.error('❌ Error verificando tablas:', error.message);
    } finally {
        await pool.end();
    }
}

checkTables(); 