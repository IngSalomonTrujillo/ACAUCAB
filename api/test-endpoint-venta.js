import pool from './connectionPostgreSQL.js';

async function testEndpointVenta() {
    const client = await pool.connect();
    try {
        console.log('🧪 Probando endpoint de venta...');
        
        // Simular los datos que envía el frontend
        const datosVenta = {
            clienteRif: 123456789, // RIF de ejemplo
            carrito: [
                {
                    id: 1, // inventario_id
                    quantity: 2,
                    price: 50000,
                    cerveza_id: 1,
                    presentacion_id: 1
                }
            ],
            metodosPago: [
                {
                    tipo: 'Efectivo',
                    monto: 100000,
                    detalles: {}
                }
            ],
            puntosUsados: 0,
            tasaCambioId: 1,
            subtotal: 100000,
            iva: 16000,
            total: 116000
        };
        
        console.log('📋 Datos de prueba:', JSON.stringify(datosVenta, null, 2));
        
        // 1. Probar la búsqueda de usuario
        console.log('\n🔍 Probando búsqueda de usuario...');
        try {
            const usuarioResult = await client.query(`
                SELECT u.usuario_id 
                FROM usuario u
                LEFT JOIN personanatural pn ON u.persona_natural_rif = pn.rif
                LEFT JOIN jurídico j ON u.jurídico_rif = j.rif
                WHERE pn.rif = $1 OR j.rif = $1
            `, [datosVenta.clienteRif]);
            
            console.log('Resultado búsqueda usuario:', usuarioResult.rows);
            
            if (usuarioResult.rows.length > 0) {
                console.log('✅ Usuario encontrado:', usuarioResult.rows[0].usuario_id);
            } else {
                console.log('⚠️ No se encontró usuario, usando por defecto');
            }
        } catch (error) {
            console.error('❌ Error en búsqueda de usuario:', error.message);
        }
        
        // 2. Probar inserción de venta
        console.log('\n🛒 Probando inserción de venta...');
        try {
            const usuarioId = 1; // Usuario por defecto
            const tiendaFisicaId = 1;
            const fechaVenta = new Date();
            
            const resultVenta = await client.query(`
                INSERT INTO venta_física (fecha_hora_venta, monto_total, tienda_física_tienda_fisica_id, usuario_usuario_id)
                VALUES ($1, $2, $3, $4)
                RETURNING tienda_física_tienda_fisica_id, usuario_usuario_id
            `, [fechaVenta, datosVenta.total, tiendaFisicaId, usuarioId]);
            
            console.log('✅ Venta insertada:', resultVenta.rows[0]);
            
            const ventaFisicaId = resultVenta.rows[0].tienda_física_tienda_fisica_id;
            const ventaUsuarioId = resultVenta.rows[0].usuario_usuario_id;
            
            // 3. Probar inserción de detalle
            console.log('\n📋 Probando inserción de detalle...');
            for (const item of datosVenta.carrito) {
                await client.query(`
                    INSERT INTO detalle_física (precio_unitario, cantidad, venta_física_tienda_fisica_id, venta_física_usuario_id, inventario_inventario_id, tasa_cambio_tasa_cambio_id)
                    VALUES ($1, $2, $3, $4, $5, $6)
                `, [
                    item.price,
                    item.quantity,
                    ventaFisicaId,
                    ventaUsuarioId,
                    item.id,
                    1
                ]);
                
                console.log('✅ Detalle insertado para item:', item.id);
            }
            
            // 4. Verificar inventario después
            console.log('\n📊 Verificando inventario después...');
            const inventarioDespues = await client.query(`
                SELECT inventario_id, cantidad_presentaciones 
                FROM inventario 
                WHERE inventario_id = 1
            `);
            
            console.log('Inventario después:', inventarioDespues.rows[0]);
            
        } catch (error) {
            console.error('❌ Error en inserción:', error.message);
            console.error('Detalles completos:', error);
        }
        
    } catch (error) {
        console.error('❌ Error general:', error);
    } finally {
        client.release();
        await pool.end();
    }
}

testEndpointVenta(); 