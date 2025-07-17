import pool from './connectionPostgreSQL.js';
import fs from 'fs';
import path from 'path';

async function cleanAndApplyTriggers() {
    try {
        console.log('🧹 Limpiando todos los triggers existentes...');
        
        // Lista de todos los triggers que queremos eliminar
        const triggersToDrop = [
            'trigger_actualizar_inventario_fisica',
            'trigger_actualizar_inventario_online',
            'trigger_actualizar_inventario_eventos',
            'trigger_actualizar_puntos',
            'trigger_actualizar_puntos_online',
            'trigger_validar_stock',
            'trigger_actualizar_estatus_compra',
            'trigger_verificar_asistencia',
            'trg_check_compra_estatus_fechas',
            'trg_check_evento_fechas',
            'trg_check_ordenr_estatus_fechas',
            'trg_check_permiso_fechas',
            'trg_check_vacacion_fechas',
            'trg_check_vacacion_estatus_fechas',
            'trg_check_ventaf_estatus_fechas',
            'trg_check_ventao_estatus_fechas',
            'trg_aviso_orden_reposicion'
        ];
        
        // Eliminar triggers
        for (const triggerName of triggersToDrop) {
            try {
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON detalle_física`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON detalle_online`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON detalle_evento`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON pago_fisica`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON pago_online`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON detalle_compra`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON compra`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON asistencia`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON compra_estatus`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON evento`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON ordenr_estatus`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON permiso`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON vacación`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON vacacion_estatus`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON ventaf_estatus`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON ventao_estatus`);
                await pool.query(`DROP TRIGGER IF EXISTS ${triggerName} ON inventario`);
            } catch (error) {
                // Ignorar errores si el trigger no existe
            }
        }
        
        // Eliminar funciones
        const functionsToDrop = [
            'actualizar_inventario_fisica',
            'actualizar_inventario_eventos',
            'actualizar_puntos_cliente',
            'validar_stock_compra',
            'actualizar_estatus_compra',
            'verificar_asistencia_tarde',
            'check_fechas_validas',
            'generar_orden_reposicion_aviso',
            'descontar_inventario_tienda_y_general'
        ];
        
        for (const functionName of functionsToDrop) {
            try {
                await pool.query(`DROP FUNCTION IF EXISTS ${functionName}()`);
            } catch (error) {
                // Ignorar errores si la función no existe
            }
        }
        
        console.log('✅ Triggers y funciones eliminados');
        
        // Leer y aplicar el archivo SQL de triggers
        console.log('🔧 Aplicando triggers corregidos...');
        const sqlPath = path.join(process.cwd(), '..', 'codigosql', 'trigger.sql');
        const sqlContent = fs.readFileSync(sqlPath, 'utf8');
        
        await pool.query(sqlContent);
        
        console.log('✅ Triggers aplicados exitosamente');
        
        // Verificar que los triggers se crearon
        console.log('🔍 Verificando triggers creados...');
        const triggers = await pool.query(`
            SELECT trigger_name, event_object_table
            FROM information_schema.triggers
            WHERE trigger_name LIKE '%inventario%'
            ORDER BY trigger_name
        `);
        
        console.log('📋 Triggers de inventario encontrados:');
        triggers.rows.forEach(row => {
            console.log(`   - ${row.trigger_name} en tabla ${row.event_object_table}`);
        });
        
    } catch (error) {
        console.error('❌ Error:', error);
    } finally {
        await pool.end();
    }
}

cleanAndApplyTriggers(); 