import pool from "./connectionPostgreSQL.js";

async function checkTables() {
    try {
        console.log('�� Verificando tablas existentes en la base de datos...');
        
        const result = await pool.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            ORDER BY table_name
        `);
        
        console.log('\n📋 Tablas encontradas:');
        result.rows.forEach(row => {
            console.log(`- ${row.table_name}`);
        });
        
        // Verificar el contenido de cada tabla
        console.log('\n📊 Contenido de las tablas:');
        for (const row of result.rows) {
            const tableName = row.table_name;
            const countResult = await pool.query(`SELECT COUNT(*) as count FROM "${tableName}"`);
            console.log(`📋 ${tableName}: ${countResult.rows[0].count} registros`);
        }
        
    } catch (error) {
        console.error('❌ Error:', error);
    } finally {
        await pool.end();
    }
}

checkTables(); 