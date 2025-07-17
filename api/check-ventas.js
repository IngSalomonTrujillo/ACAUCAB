import pg from 'pg';
const { Pool } = pg;

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'ACAUCAB',
  password: '1234',
  port: 5432,
});

async function checkVentas() {
  try {
    console.log('🔍 Verificando ventas registradas...');
    
    // Ver ventas más recientes
    const ventas = await pool.query(`
      SELECT 
        v.tienda_física_tienda_fisica_id,
        v.usuario_usuario_id,
        v.fecha_hora_venta,
        v.monto_total
      FROM venta_física v
      ORDER BY v.fecha_hora_venta DESC
      LIMIT 5
    `);
    
    console.log('\n📊 Últimas 5 ventas registradas:');
    ventas.rows.forEach((venta, index) => {
      console.log(`   Venta ${index + 1}:`);
      console.log(`     - Tienda ID: ${venta.tienda_física_tienda_fisica_id}`);
      console.log(`     - Usuario ID: ${venta.usuario_usuario_id}`);
      console.log(`     - Fecha: ${venta.fecha_hora_venta}`);
      console.log(`     - Monto: $${venta.monto_total}`);
      console.log('');
    });
    
    // Ver detalles de la última venta
    if (ventas.rows.length > 0) {
      const ultimaVenta = ventas.rows[0];
      const detalles = await pool.query(`
        SELECT 
          d.precio_unitario,
          d.cantidad,
          d.inventario_inventario_id,
          d.tasa_cambio_tasa_cambio_id
        FROM detalle_física d
        WHERE d.venta_física_tienda_fisica_id = $1 AND d.venta_física_usuario_id = $2
      `, [ultimaVenta.tienda_física_tienda_fisica_id, ultimaVenta.usuario_usuario_id]);
      
      console.log('📋 Detalles de la última venta:');
      detalles.rows.forEach((detalle, index) => {
        console.log(`   Producto ${index + 1}:`);
        console.log(`     - Inventario ID: ${detalle.inventario_inventario_id}`);
        console.log(`     - Cantidad: ${detalle.cantidad}`);
        console.log(`     - Precio unitario: $${detalle.precio_unitario}`);
        console.log(`     - Tasa cambio ID: ${detalle.tasa_cambio_tasa_cambio_id}`);
        console.log('');
      });
    }
    
    await pool.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
    await pool.end();
  }
}

checkVentas(); 