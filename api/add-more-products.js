import pool from './connectionPostgreSQL.js';

async function addMoreProducts() {
  const client = await pool.connect();
  try {
    console.log('🍺 Agregando más productos al inventario de la tienda online...');

    await client.query('BEGIN');

    // Obtener más cervezas y presentaciones existentes
    const cervezasResult = await client.query(`
      SELECT c.cerveza_id, c.nombre_cerveza, p.presentación_id, p.nombre_presentación, cp.precio_unitario
      FROM Cerveza c
      INNER JOIN Cerveza_Presentacion cp ON c.cerveza_id = cp.Cerveza_cerveza_id
      INNER JOIN Presentación p ON cp.Presentación_presentación_id = p.presentación_id
      LIMIT 20
    `);

    if (cervezasResult.rows.length === 0) {
      console.log('❌ No hay cervezas disponibles para agregar al inventario');
      return;
    }

    console.log(`📦 Encontradas ${cervezasResult.rows.length} cervezas para agregar`);

    // Insertar inventario para cada cerveza
    for (const cerveza of cervezasResult.rows) {
      // Verificar si ya existe inventario para esta cerveza en tienda online
      const existingInventory = await client.query(`
        SELECT inventario_id FROM Inventario 
        WHERE Cerveza_Presentacion_Cerveza_cerveza_id = $1 
        AND Cerveza_Presentacion_Presentación_presentación_id = $2
        AND Tienda_Online_tienda_online_id = 1
      `, [cerveza.cerveza_id, cerveza.presentación_id]);

      if (existingInventory.rows.length === 0) {
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
      } else {
        console.log(`⏭️ Inventario ya existe para ${cerveza.nombre_cerveza} ${cerveza.nombre_presentación}`);
      }
    }

    await client.query('COMMIT');
    console.log('✅ Productos agregados exitosamente');

    // Mostrar resumen final
    const finalCount = await client.query(`
      SELECT COUNT(*) as count FROM Inventario WHERE Tienda_Online_tienda_online_id = 1
    `);
    console.log(`📊 Total de productos en inventario: ${finalCount.rows[0].count}`);

  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error agregando productos:', error);
  } finally {
    client.release();
    await pool.end();
  }
}

addMoreProducts(); 