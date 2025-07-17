import pool from './connectionPostgreSQL.js';

async function testInventarioTrigger() {
    try {
        console.log('🧪 Probando trigger de inventario...');
        
        // 1. Verificar inventario antes de la venta
        console.log('\n📊 Inventario ANTES de la venta:');
        const inventarioAntes = await pool.query(`
            SELECT 
                i.inventario_id,
                i.cantidad_presentaciones,
                c.nombre_cerveza,
                p.nombre_presentación
            FROM inventario i
            INNER JOIN cerveza_presentacion cp ON i.cerveza_presentacion_cerveza_cerveza_id = cp.cerveza_cerveza_id 
                AND i.cerveza_presentacion_presentación_presentación_id = cp.presentación_presentación_id
            INNER JOIN cerveza c ON cp.cerveza_cerveza_id = c.cerveza_id
            INNER JOIN presentación p ON cp.presentación_presentación_id = p.presentación_id
            WHERE i.inventario_id = 1
        `);
        
        if (inventarioAntes.rows.length === 0) {
            console.log('❌ No se encontró inventario con ID 1');
            return;
        }
        
        const inventario = inventarioAntes.rows[0];
        console.log(`   - Inventario ID: ${inventario.inventario_id}`);
        console.log(`   - Cerveza: ${inventario.nombre_cerveza}`);
        console.log(`   - Presentación: ${inventario.nombre_presentación}`);
        console.log(`   - Cantidad actual: ${inventario.cantidad_presentaciones}`);
        
        // 2. Simular una venta física con valores únicos
        console.log('\n🛒 Simulando venta física...');
        const cantidadVenta = 5;
        
        // Obtener el siguiente ID de usuario disponible
        const usuariosResult = await pool.query('SELECT MAX(usuario_id) as max_id FROM usuario');
        const siguienteUsuarioId = (usuariosResult.rows[0].max_id || 0) + 1;
        
        // Insertar venta física con usuario único
        const ventaResult = await pool.query(`
            INSERT INTO venta_física (fecha_hora_venta, monto_total, tienda_física_tienda_fisica_id, usuario_usuario_id)
            VALUES (NOW(), 250000, 1, $1)
            RETURNING tienda_física_tienda_fisica_id, usuario_usuario_id
        `, [siguienteUsuarioId]);
        
        const ventaFisicaId = ventaResult.rows[0].tienda_física_tienda_fisica_id;
        const ventaUsuarioId = ventaResult.rows[0].usuario_usuario_id;
        
        console.log(`   - Venta física creada: Tienda ID ${ventaFisicaId}, Usuario ID ${ventaUsuarioId}`);
        
        // Insertar detalle de venta (esto debería activar el trigger)
        await pool.query(`
            INSERT INTO detalle_física (precio_unitario, cantidad, venta_física_tienda_fisica_id, venta_física_usuario_id, inventario_inventario_id, tasa_cambio_tasa_cambio_id)
            VALUES (50000, $1, $2, $3, 1, 1)
        `, [cantidadVenta, ventaFisicaId, ventaUsuarioId]);
        
        console.log(`   - Detalle de venta insertado: ${cantidadVenta} unidades del inventario ID 1`);
        
        // 3. Verificar inventario después de la venta
        console.log('\n📊 Inventario DESPUÉS de la venta:');
        const inventarioDespues = await pool.query(`
            SELECT 
                i.inventario_id,
                i.cantidad_presentaciones,
                c.nombre_cerveza,
                p.nombre_presentación
            FROM inventario i
            INNER JOIN cerveza_presentacion cp ON i.cerveza_presentacion_cerveza_cerveza_id = cp.cerveza_cerveza_id 
                AND i.cerveza_presentacion_presentación_presentación_id = cp.presentación_presentación_id
            INNER JOIN cerveza c ON cp.cerveza_cerveza_id = c.cerveza_id
            INNER JOIN presentación p ON cp.presentación_presentación_id = p.presentación_id
            WHERE i.inventario_id = 1
        `);
        
        const inventarioNuevo = inventarioDespues.rows[0];
        console.log(`   - Cantidad nueva: ${inventarioNuevo.cantidad_presentaciones}`);
        
        // 4. Verificar si el trigger funcionó
        const cantidadEsperada = inventario.cantidad_presentaciones - cantidadVenta;
        const triggerFunciono = inventarioNuevo.cantidad_presentaciones === cantidadEsperada;
        
        console.log('\n📋 Resultado de la prueba:');
        console.log(`   - Cantidad antes: ${inventario.cantidad_presentaciones}`);
        console.log(`   - Cantidad vendida: ${cantidadVenta}`);
        console.log(`   - Cantidad esperada después: ${cantidadEsperada}`);
        console.log(`   - Cantidad real después: ${inventarioNuevo.cantidad_presentaciones}`);
        console.log(`   - Trigger funcionó: ${triggerFunciono ? '✅ SÍ' : '❌ NO'}`);
        
        if (triggerFunciono) {
            console.log('\n🎉 ¡El trigger de inventario funciona correctamente!');
        } else {
            console.log('\n⚠️ El trigger no funcionó como se esperaba');
        }
        
    } catch (error) {
        console.error('❌ Error en la prueba:', error);
    } finally {
        await pool.end();
    }
}

testInventarioTrigger(); 