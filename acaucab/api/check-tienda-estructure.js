import pg from 'pg';
const { Pool } = pg;

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'ACAUCAB',
  password: '1234',
  port: 5432,
});

async function checkTiendaStructure() {
  try {
    console.log('🔍 Verificando estructura de la tabla tienda_física...');
    
    // Verificar todas las columnas de la tabla tienda_física
    const checkColumns = await pool.query(`
      SELECT column_name, data_type, is_nullable
      FROM information_schema.columns 
      WHERE table_name = 'tienda_física'
      ORDER BY ordinal_position
    `);
    
    console.log('📊 Columnas encontradas en la tabla tienda_física:');
    checkColumns.rows.forEach(row => {
      console.log(`   - ${row.column_name} (${row.data_type}, nullable: ${row.is_nullable})`);
    });
    
    // Verificar si hay datos
    const checkData = await pool.query(`
      SELECT * FROM tienda_física LIMIT 3
    `);
    
    console.log('\n📋 Datos de ejemplo en tienda_física:');
    checkData.rows.forEach((row, index) => {
      console.log(`   Registro ${index + 1}:`, row);
    });
    
    await pool.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
    await pool.end();
  }
}

checkTiendaStructure(); 