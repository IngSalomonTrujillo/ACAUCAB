import pool from './connectionPostgreSQL.js';

async function checkTables() {
    try {
        const result = await pool.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND (table_name ILIKE '%persona%' OR table_name ILIKE '%juridico%' OR table_name ILIKE '%cliente%')
            ORDER BY table_name
        `);
        
        console.log('Tablas de clientes encontradas:');
        result.rows.forEach(row => {
            console.log(`  - ${row.table_name}`);
        });
        
        // Verificar si existe personanatural
        try {
            const personas = await pool.query('SELECT rif, primer_nombre, primer_apellido FROM personanatural LIMIT 5');
            console.log('\nClientes naturales:');
            personas.rows.forEach(p => {
                console.log(`  - RIF: ${p.rif} | ${p.primer_nombre} ${p.primer_apellido}`);
            });
        } catch (e) {
            console.log('No se encontró tabla personanatural');
        }
        
    } catch (error) {
        console.error('Error:', error);
    } finally {
        await pool.end();
    }
}

checkTables(); 