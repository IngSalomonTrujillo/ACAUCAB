import pool from './connectionPostgreSQL.js';

async function setupTiendaOnline() {
  const client = await pool.connect();
  try {
    console.log('🍺 Configurando tienda online con datos existentes...');

    await client.query('BEGIN');

    // 1. Verificar si ya existe tienda online
    console.log('📦 Verificando tienda online...');
    const tiendaResult = await client.query(`
      SELECT tienda_online_id FROM Tienda_Online WHERE tienda_online_id = 1
    `);

    if (tiendaResult.rows.length === 0) {
      console.log('📦 Creando tienda online...');
      await client.query(`
        INSERT INTO Tienda_Online (tienda_online_id, dirección_web) 
        VALUES (1, 'acaucab.com/tienda')
      `);
    } else {
      console.log('✅ Tienda online ya existe');
    }

    // 2. Verificar inventario existente para tienda online
    console.log('📦 Verificando inventario para tienda online...');
    const inventarioResult = await client.query(`
      SELECT COUNT(*) as count FROM Inventario 
      WHERE Tienda_Online_tienda_online_id = 1
    `);

    if (parseInt(inventarioResult.rows[0].count) === 0) {
      console.log('📦 Creando inventario para tienda online...');
      
      // Obtener cervezas y presentaciones existentes
      const cervezasResult = await client.query(`
        SELECT c.cerveza_id, c.nombre_cerveza, p.presentación_id, p.nombre_presentación, cp.precio_unitario
        FROM Cerveza c
        INNER JOIN Cerveza_Presentacion cp ON c.cerveza_id = cp.Cerveza_cerveza_id
        INNER JOIN Presentación p ON cp.Presentación_presentación_id = p.presentación_id
        LIMIT 10
      `);

      if (cervezasResult.rows.length === 0) {
        console.log('❌ No hay cervezas disponibles para crear inventario');
        return;
      }

      // Insertar inventario para cada cerveza
      for (const cerveza of cervezasResult.rows) {
        await client.query(`
          INSERT INTO Inventario (
            Tienda_Online_tienda_online_id,
            cantidad_presentaciones,
            Cerveza_Presentacion_Cerveza_cerveza_id,
            Cerveza_Presentacion_Presentación_presentación_id,
            Tienda_Física_tienda_fisica_id
          ) VALUES ($1, $2, $3, $4, $5)
        `, [
          1, // tienda_online_id
          Math.floor(Math.random() * 50) + 10, // stock entre 10-60
          cerveza.cerveza_id,
          cerveza.presentación_id,
          1 // tienda_fisica_id (requerido por la FK)
        ]);
        
        console.log(`✅ Inventario creado para ${cerveza.nombre_cerveza} ${cerveza.nombre_presentación}`);
      }
    } else {
      console.log('✅ Inventario para tienda online ya existe');
    }

    // 3. Verificar estatus existentes
    console.log('📊 Verificando estatus...');
    const estatusResult = await client.query(`
      SELECT COUNT(*) as count FROM Estatus WHERE estatus_id IN (1,2,3,4,5,6)
    `);

    if (parseInt(estatusResult.rows[0].count) < 6) {
      console.log('📊 Insertando estatus faltantes...');
      await client.query(`
        INSERT INTO Estatus (estatus_id, estatus_nombre, descripción_estatus) VALUES
        (1, 'Pendiente', 'Pedido recibido y pendiente de procesamiento'),
        (2, 'En Preparación', 'Pedido siendo preparado para envío'),
        (3, 'Listo para Envío', 'Pedido preparado y listo para ser enviado'),
        (4, 'En Camino', 'Pedido en ruta de entrega'),
        (5, 'Entregado', 'Pedido entregado exitosamente'),
        (6, 'Cancelado', 'Pedido cancelado')
        ON CONFLICT (estatus_id) DO NOTHING
      `);
    } else {
      console.log('✅ Estatus ya existen');
    }

    // 4. Verificar métodos de pago
    console.log('💳 Verificando métodos de pago...');
    const metodosResult = await client.query(`
      SELECT COUNT(*) as count FROM Método_Pago WHERE método_pago_id IN (1,2,3,4,5)
    `);

    if (parseInt(metodosResult.rows[0].count) < 5) {
      console.log('💳 Insertando métodos de pago faltantes...');
      
      // Insertar métodos de pago básicos
      await client.query(`
        INSERT INTO Método_Pago (método_pago_id) VALUES
        (1), (2), (3), (4), (5)
        ON CONFLICT (método_pago_id) DO NOTHING
      `);

      // Insertar tipos específicos
      await client.query(`
        INSERT INTO Efectivo (método_pago_id, tipo_divisa) VALUES (1, 'Bolívares')
        ON CONFLICT (método_pago_id) DO NOTHING
      `);

      await client.query(`
        INSERT INTO Punto (método_pago_id) VALUES (4)
        ON CONFLICT (método_pago_id) DO NOTHING
      `);
    } else {
      console.log('✅ Métodos de pago ya existen');
    }

    // 5. Verificar puntos para clientes
    console.log('🎯 Verificando puntos para clientes...');
    const puntosResult = await client.query(`
      SELECT COUNT(*) as count FROM Cliente_Punto
    `);

    if (parseInt(puntosResult.rows[0].count) === 0) {
      console.log('🎯 Asignando puntos a clientes existentes...');
      
      // Obtener clientes que tienen usuarios
      const clientesResult = await client.query(`
        SELECT c.RIF FROM Cliente c
        INNER JOIN Usuario u ON c.RIF = u.Cliente_RIF
        LIMIT 5
      `);

      for (const cliente of clientesResult.rows) {
        await client.query(`
          INSERT INTO Cliente_Punto (cantidad_puntos, Punto_método_pago_id, Cliente_RIF) VALUES
          ($1, 4, $2)
          ON CONFLICT (Cliente_RIF, Punto_método_pago_id) DO NOTHING
        `, [
          Math.floor(Math.random() * 1000) + 100, // 100-1100 puntos
          cliente.RIF
        ]);
        console.log(`✅ Puntos asignados para cliente ${cliente.RIF}`);
      }
    } else {
      console.log('✅ Puntos para clientes ya existen');
    }

    await client.query('COMMIT');
    console.log('✅ Tienda online configurada exitosamente');

    // Mostrar resumen
    console.log('\n📊 Resumen de configuración:');
    
    const inventarioCount = await client.query(`
      SELECT COUNT(*) as count FROM Inventario WHERE Tienda_Online_tienda_online_id = 1
    `);
    console.log(`- Productos en inventario: ${inventarioCount.rows[0].count}`);
    
    const clientesCount = await client.query(`
      SELECT COUNT(*) as count FROM Cliente c
      INNER JOIN Usuario u ON c.RIF = u.Cliente_RIF
    `);
    console.log(`- Clientes con acceso: ${clientesCount.rows[0].count}`);

  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error configurando tienda online:', error);
  } finally {
    client.release();
    await pool.end();
  }
}

setupTiendaOnline(); 