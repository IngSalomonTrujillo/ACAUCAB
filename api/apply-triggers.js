import pool from './connectionPostgreSQL.js';
import fs from 'fs';
import path from 'path';

async function applyTriggers() {
    try {
        console.log('🔧 Aplicando triggers corregidos a la base de datos...');
        
        // Leer el archivo SQL de triggers
        const sqlPath = path.join(process.cwd(), '..', 'codigosql', 'trigger.sql');
        const sqlContent = fs.readFileSync(sqlPath, 'utf8');
        
        console.log('📄 Archivo de triggers leído correctamente');
        
        // Primero eliminar los triggers antiguos si existen
        console.log('🗑️ Eliminando triggers antiguos...');
        try {
            await pool.query('DROP TRIGGER IF EXISTS trigger_actualizar_inventario ON venta_física');
            await pool.query('DROP TRIGGER IF EXISTS trigger_actualizar_inventario_online ON venta_online');
            await pool.query('DROP FUNCTION IF EXISTS actualizar_inventario()');
            console.log('✅ Triggers antiguos eliminados');
        } catch (error) {
            console.log('⚠️ No se encontraron triggers antiguos para eliminar');
        }
        
        // Ejecutar el SQL de triggers corregido
        console.log('🔧 Aplicando triggers corregidos...');
        await pool.query(sqlContent);
        
        console.log('✅ Triggers aplicados exitosamente');
        
        // Verificar que los triggers se crearon
        console.log('🔍 Verificando triggers creados...');
        const triggers = await pool.query(`
            SELECT trigger_name, event_object_table, action_statement
            FROM information_schema.triggers
            WHERE trigger_name LIKE '%inventario%'
            ORDER BY trigger_name
        `);
        
        console.log('📋 Triggers de inventario encontrados:');
        triggers.rows.forEach(row => {
            console.log(`   - ${row.trigger_name} en tabla ${row.event_object_table}`);
        });
        
        // Verificar las funciones
        console.log('🔍 Verificando funciones creadas...');
        const functions = await pool.query(`
            SELECT routine_name, routine_type
            FROM information_schema.routines
            WHERE routine_name LIKE '%inventario%'
            ORDER BY routine_name
        `);
        
        console.log('📋 Funciones de inventario encontradas:');
        functions.rows.forEach(row => {
            console.log(`   - ${row.routine_name} (${row.routine_type})`);
        });
        
    } catch (error) {
        console.error('❌ Error aplicando triggers:', error);
    } finally {
        await pool.end();
    }
}

applyTriggers(); 