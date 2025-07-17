import pool from './connectionPostgreSQL.js';

async function insertTiendaData() {
  const client = await pool.connect();
  try {
    console.log('🍺 Insertando datos de prueba para la tienda online...');

    await client.query('BEGIN');

    // 1. Insertar tienda online
    console.log('📦 Insertando tienda online...');
    await client.query(`
      INSERT INTO Tienda_Online (tienda_online_id, dirección_web) 
      VALUES (1, 'acaucab.com/tienda') 
      ON CONFLICT (tienda_online_id) DO NOTHING
    `);

    // 2. Insertar inventario para tienda online
    console.log('📦 Insertando inventario para tienda online...');
    
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
        ON CONFLICT (inventario_id) DO UPDATE SET
        cantidad_presentaciones = EXCLUDED.cantidad_presentaciones
      `, [
        1, // tienda_online_id
        Math.floor(Math.random() * 50) + 10, // stock entre 10-60
        cerveza.cerveza_id,
        cerveza.presentación_id,
        1 // tienda_fisica_id (requerido por la FK)
      ]);
      
      console.log(`✅ Inventario creado para ${cerveza.nombre_cerveza} ${cerveza.nombre_presentación}`);
    }

    // 3. Insertar estatus para ventas online
    console.log('📊 Insertando estatus para ventas online...');
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

    // 4. Insertar métodos de pago
    console.log('💳 Insertando métodos de pago...');
    await client.query(`
      INSERT INTO Método_Pago (método_pago_id) VALUES
      (1), (2), (3), (4), (5)
      ON CONFLICT (método_pago_id) DO NOTHING
    `);

    await client.query(`
      INSERT INTO Efectivo (método_pago_id, tipo_divisa) VALUES (1, 'Bolívares')
      ON CONFLICT (método_pago_id) DO NOTHING
    `);

    await client.query(`
      INSERT INTO Débito (método_pago_id, cuenta, banco, número_tarjeta) VALUES (2, 'Cuenta Corriente', 'Banco de Venezuela', '1234567890123456')
      ON CONFLICT (método_pago_id) DO NOTHING
    `);

    await client.query(`
      INSERT INTO Crédito (método_pago_id, cuenta, banco, número_tarjeta) VALUES (3, 'Tarjeta de Crédito', 'Banesco', '6543210987654321')
      ON CONFLICT (método_pago_id) DO NOTHING
    `);

    await client.query(`
      INSERT INTO Punto (método_pago_id) VALUES (4)
      ON CONFLICT (método_pago_id) DO NOTHING
    `);

    await client.query(`
      INSERT INTO Cheque (método_pago_id, número_cuenta, banco, número_cheque) VALUES (5, 123456789, 'Banco Mercantil', 'CHK001234')
      ON CONFLICT (método_pago_id) DO NOTHING
    `;

    // 5. Insertar puntos para clientes existentes
    console.log('🎯 Insertando puntos para clientes...');
    const clientesResult = await client.query(`
      SELECT c.RIF FROM Cliente c
      INNER JOIN Usuario u ON c.RIF = u.Cliente_RIF
      LIMIT 5
    `);

    for (const cliente of clientesResult.rows) {
      await client.query(`
        INSERT INTO Cliente_Punto (cantidad_puntos, Punto_método_pago_id, Cliente_RIF) VALUES
        ($1, 4, $2)
        ON CONFLICT (Cliente_RIF, Punto_método_pago_id) DO UPDATE SET
        cantidad_puntos = EXCLUDED.cantidad_puntos
      `, [
        Math.floor(Math.random() * 1000) + 100, // 100-1100 puntos
        cliente.RIF
      ]);
    }

    await client.query('COMMIT');
    console.log('✅ Datos de tienda online insertados exitosamente');

  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error insertando datos de tienda online:', error);
  } finally {
    client.release();
    await pool.end();
  }
}

insertTiendaData(); 