import pool from './connectionPostgreSQL.js';

async function testVentaSimple() {
    const client = await pool.connect();
    try {
        console.log('🧪 Probando venta simple...');
        
        // 1. Verificar inventario antes
        console.log('\n📊 Inventario ANTES:');
        const inventarioAntes = await client.query(`
            SELECT inventario_id, cantidad_presentaciones 
            FROM inventario 
            WHERE inventario_id = 1
        `);
        
        if (inventarioAntes.rows.length === 0) {
            console.log('❌ No hay inventario con ID 1');
            return;
        }
        
        console.log(`   - Inventario ID 1: ${inventarioAntes.rows[0].cantidad_presentaciones} unidades`);
        
        // 2. Obtener usuario único
        const usuariosResult = await client.query('SELECT MAX(usuario_id) as max_id FROM usuario');
        const siguienteUsuarioId = (usuariosResult.rows[0].max_id || 0) + 1;
        
        // 3. Crear venta con usuario único
        console.log('\n🛒 Creando venta...');
        const ventaResult = await client.query(`
            INSERT INTO venta_física (fecha_hora_venta, monto_total, tienda_física_tienda_fisica_id, usuario_usuario_id)
            VALUES (NOW(), 100000, 1, $1)
            RETURNING tienda_física_tienda_fisica_id, usuario_usuario_id
        `, [siguienteUsuarioId]);
        
        const ventaFisicaId = ventaResult.rows[0].tienda_física_tienda_fisica_id;
        const ventaUsuarioId = ventaResult.rows[0].usuario_usuario_id;
        
        console.log(`   - Venta creada: Tienda ${ventaFisicaId}, Usuario ${ventaUsuarioId}`);
        
        // 4. Insertar detalle (esto activará el trigger)
        console.log('\n📋 Insertando detalle de venta...');
        await client.query(`
            INSERT INTO detalle_física (precio_unitario, cantidad, venta_física_tienda_fisica_id, venta_física_usuario_id, inventario_inventario_id, tasa_cambio_tasa_cambio_id)
            VALUES (50000, 2, $1, $2, 1, 1)
        `, [ventaFisicaId, ventaUsuarioId]);
        
        console.log('   - Detalle insertado: 2 unidades del inventario ID 1');
        
        // 5. Verificar inventario después
        console.log('\n📊 Inventario DESPUÉS:');
        const inventarioDespues = await client.query(`
            SELECT inventario_id, cantidad_presentaciones 
            FROM inventario 
            WHERE inventario_id = 1
        `);
        
        console.log(`   - Inventario ID 1: ${inventarioDespues.rows[0].cantidad_presentaciones} unidades`);
        
        // 6. Verificar resultado
        const cantidadAntes = inventarioAntes.rows[0].cantidad_presentaciones;
        const cantidadDespues = inventarioDespues.rows[0].cantidad_presentaciones;
        const cantidadVendida = 2;
        const esperado = cantidadAntes - cantidadVendida;
        
        console.log('\n📋 Resultado:');
        console.log(`   - Antes: ${cantidadAntes}`);
        console.log(`   - Vendido: ${cantidadVendida}`);
        console.log(`   - Esperado: ${esperado}`);
        console.log(`   - Real: ${cantidadDespues}`);
        console.log(`   - ✅ Funcionó: ${cantidadDespues === esperado ? 'SÍ' : 'NO'}`);
        
    } catch (error) {
        console.error('❌ Error en la prueba:', error);
        console.error('Detalles:', error.message);
    } finally {
        client.release();
        await pool.end();
    }
}

testVentaSimple(); 