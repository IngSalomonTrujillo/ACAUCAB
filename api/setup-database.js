import pool from './connectionPostgreSQL.js';
import fs from 'fs';
import path from 'path';

async function setupDatabase() {
    try {
        console.log('🔧 Configurando base de datos ACAUCAB...');
        
        // Leer el archivo create.sql
        const createSqlPath = path.join(process.cwd(), '..', 'codigosql', 'create.sql');
        console.log('📁 Leyendo archivo:', createSqlPath);
        
        if (!fs.existsSync(createSqlPath)) {
            console.error('❌ No se encontró el archivo create.sql en:', createSqlPath);
            return;
        }
        
        const createSql = fs.readFileSync(createSqlPath, 'utf8');
        console.log('✅ Archivo create.sql leído correctamente');
        
        // Ejecutar el script SQL
        console.log('🚀 Ejecutando script create.sql...');
        await pool.query(createSql);
        
        console.log('✅ Base de datos configurada exitosamente!');
        console.log('📋 Tablas creadas:');
        
        // Listar las tablas creadas
        const tablesResult = await pool.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_type = 'BASE TABLE'
            ORDER BY table_name
        `);
        
        tablesResult.rows.forEach(row => {
            console.log(`  - ${row.table_name}`);
        });
        
    } catch (error) {
        console.error('❌ Error configurando la base de datos:', error.message);
        console.error('Detalles:', error);
    } finally {
        await pool.end();
    }
}

setupDatabase(); 