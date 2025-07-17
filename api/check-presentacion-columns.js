import pg from 'pg';
const { Pool } = pg;

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'ACAUCAB',
  password: '1234',
  port: 5432,
});

async function checkPresentacionColumns() {
  try {
    console.log('🔍 Verificando columnas de la tabla presentación...');
    
    // Verificar todas las columnas de la tabla presentación
    const checkColumns = await pool.query(`
      SELECT column_name, data_type, is_nullable
      FROM information_schema.columns 
      WHERE table_name = 'presentación'
      ORDER BY ordinal_position
    `);
    
    console.log('📊 Columnas encontradas en la tabla presentación:');
    checkColumns.rows.forEach(row => {
      console.log(`   - ${row.column_name} (${row.data_type}, nullable: ${row.is_nullable})`);
    });
    
    // Verificar si existe la columna precio
    const checkPrecio = await pool.query(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_name = 'presentación' 
      AND column_name = 'precio'
    `);
    
    if (checkPrecio.rows.length === 0) {
      console.log('❌ La columna "precio" NO existe en la tabla presentación');
    } else {
      console.log('✅ La columna "precio" existe en la tabla presentación');
    }
    
    // Verificar datos de ejemplo
    const sampleData = await pool.query(`
      SELECT * FROM presentación LIMIT 3
    `);
    
    console.log('📋 Datos de ejemplo de la tabla presentación:');
    sampleData.rows.forEach((row, index) => {
      console.log(`   Registro ${index + 1}:`, row);
    });
    
  } catch (error) {
    console.error('❌ Error verificando columnas:', error);
  } finally {
    await pool.end();
  }
}

checkPresentacionColumns(); 