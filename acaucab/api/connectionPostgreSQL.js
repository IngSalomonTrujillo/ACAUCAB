import pg from "pg"

const pool = new pg.Pool({
    host: "localhost",
    port: 5432,
    database: "ACAUCAB",
    user: "postgres",
    password: "1234"
});

// Función para probar la conexión
async function testConnection() {
    try {
        const res = await pool.query('SELECT NOW()');
        console.log('✅ Conexión a PostgreSQL exitosa:', res.rows[0]);
    } catch (error) {
        console.error('❌ Error conectando a PostgreSQL:', error.message);
    }
}

// Probar conexión al iniciar
testConnection();

export default pool;