import pg from 'pg';
const { Pool } = pg;

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'acaucab',
  password: '123456',
  port: 5432,
});

async function checkPrecioPresentacion() {
  try {
    console.log('🔍 Verificando columna precio en tabla presentación...');
    
    // Verificar si la columna precio existe
    const checkColumn = await pool.query(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_name = 'presentación' 
      AND column_name = 'precio'
    `);
    
    if (checkColumn.rows.length === 0) {
      console.log('❌ La columna "precio" NO existe en la tabla presentación');
      console.log('💡 Necesitas agregar la columna precio a la tabla presentación');
      return;
    }
    
    console.log('✅ La columna "precio" existe en la tabla presentación');
    
    // Verificar si hay datos en la columna precio
    const checkData = await pool.query(`
      SELECT presentacion_id, nombre_presentación, precio 
      FROM presentación 
      WHERE precio IS NOT NULL
    `);
    
    console.log(`📊 Encontrados ${checkData.rows.length} registros con precio:`);
    checkData.rows.forEach(row => {
      console.log(`   - ID: ${row.presentacion_id}, Nombre: ${row.nombre_presentación}, Precio: ${row.precio}`);
    });
    
    // Verificar registros sin precio
    const checkNullData = await pool.query(`
      SELECT presentacion_id, nombre_presentación 
      FROM presentación 
      WHERE precio IS NULL
    `);
    
    if (checkNullData.rows.length > 0) {
      console.log(`⚠️  Encontrados ${checkNullData.rows.length} registros SIN precio:`);
      checkNullData.rows.forEach(row => {
        console.log(`   - ID: ${row.presentacion_id}, Nombre: ${row.nombre_presentación}`);
      });
    }
    
  } catch (error) {
    console.error('❌ Error verificando precio:', error);
  } finally {
    await pool.end();
  }
}

checkPrecioPresentacion(); 