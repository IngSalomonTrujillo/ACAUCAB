import pool from "./connectionPostgreSQL.js";
import fs from 'fs';
import path from 'path';

async function createTables() {
    try {
        console.log('🔧 Creando tablas en la base de datos...');
        
        // Leer el archivo SQL
        const sqlPath = path.join(process.cwd(), '..', 'codigosql', 'create.sql');
        const sqlContent = fs.readFileSync(sqlPath, 'utf8');
        
        console.log('📄 Archivo SQL leído correctamente');
        
        // Ejecutar el SQL
        await pool.query(sqlContent);
        
        console.log('✅ Tablas creadas exitosamente');
        
        // Verificar que las tablas se crearon
        const tables = ['Usuario', 'Empleado', 'Rol', 'Permiso', 'Privilegio', 'Rol_Permiso', 'Rol_Privilegio'];
        
        for (const table of tables) {
            const exists = await pool.query(`
                SELECT EXISTS (
                    SELECT FROM information_schema.tables 
                    WHERE table_schema = 'public' 
                    AND table_name = $1
                );
            `, [table]);
            
            console.log(`Tabla ${table} existe:`, exists.rows[0].exists);
        }
        
    } catch (error) {
        console.error('❌ Error creando tablas:', error);
    } finally {
        await pool.end();
    }
}

createTables(); 