import pg from 'pg';
const { Pool } = pg;

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'ACAUCAB',
  password: '1234',
  port: 5432,
});

async function checkVentasStructure() {
  try {
    console.log('🔍 Verificando estructura de las tablas de ventas...');
    
    // Verificar venta_física
    console.log('\n📊 Tabla venta_física:');
    const ventaColumns = await pool.query(`
      SELECT column_name, data_type, is_nullable
      FROM information_schema.columns 
      WHERE table_name = 'venta_física'
      ORDER BY ordinal_position
    `);
    ventaColumns.rows.forEach(row => {
      console.log(`   - ${row.column_name} (${row.data_type}, nullable: ${row.is_nullable})`);
    });
    
    // Verificar detalle_física
    console.log('\n📊 Tabla detalle_física:');
    const detalleColumns = await pool.query(`
      SELECT column_name, data_type, is_nullable
      FROM information_schema.columns 
      WHERE table_name = 'detalle_física'
      ORDER BY ordinal_position
    `);
    detalleColumns.rows.forEach(row => {
      console.log(`   - ${row.column_name} (${row.data_type}, nullable: ${row.is_nullable})`);
    });
    
    // Verificar pago_fisica
    console.log('\n📊 Tabla pago_fisica:');
    const pagoColumns = await pool.query(`
      SELECT column_name, data_type, is_nullable
      FROM information_schema.columns 
      WHERE table_name = 'pago_fisica'
      ORDER BY ordinal_position
    `);
    pagoColumns.rows.forEach(row => {
      console.log(`   - ${row.column_name} (${row.data_type}, nullable: ${row.is_nullable})`);
    });
    
    await pool.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
    await pool.end();
  }
}

checkVentasStructure(); 