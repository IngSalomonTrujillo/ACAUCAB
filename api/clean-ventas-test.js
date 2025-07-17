import pool from './connectionPostgreSQL.js';

async function cleanVentasTest() {
    const client = await pool.connect();
    try {
        console.log('🧹 Limpiando ventas de prueba...');
        
        // Verificar ventas existentes
        const ventasExistentes = await client.query(`
            SELECT tienda_física_tienda_fisica_id, usuario_usuario_id, fecha_hora_venta, monto_total
            FROM venta_física
            ORDER BY fecha_hora_venta DESC
            LIMIT 10
        `);
        
        console.log('📊 Ventas existentes:');
        ventasExistentes.rows.forEach((venta, index) => {
            console.log(`   ${index + 1}. Tienda: ${venta.tienda_física_tienda_fisica_id}, Usuario: ${venta.usuario_usuario_id}, Fecha: ${venta.fecha_hora_venta}, Monto: ${venta.monto_total}`);
        });
        
        if (ventasExistentes.rows.length > 0) {
            console.log('\n🗑️ Eliminando ventas de prueba...');
            
            // Eliminar detalles primero (por restricciones de FK)
            await client.query('DELETE FROM detalle_física');
            console.log('✅ Detalles eliminados');
            
            // Eliminar pagos si existen
            try {
                await client.query('DELETE FROM pago_fisica');
                console.log('✅ Pagos eliminados');
            } catch (e) {
                console.log('⚠️ No se encontraron pagos para eliminar');
            }
            
            // Eliminar ventas
            await client.query('DELETE FROM venta_física');
            console.log('✅ Ventas eliminadas');
            
            console.log('\n🎉 Limpieza completada. Ahora puedes probar nuevas ventas.');
        } else {
            console.log('✅ No hay ventas para limpiar');
        }
        
    } catch (error) {
        console.error('❌ Error limpiando ventas:', error);
    } finally {
        client.release();
        await pool.end();
    }
}

cleanVentasTest(); 