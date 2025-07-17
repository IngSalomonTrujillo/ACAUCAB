import pool from './connectionPostgreSQL.js';
import express from 'express';
import cors from 'cors';

const app = express();
const port = 3001; // Puerto diferente para no interferir

app.use(cors());
app.use(express.json());

// Endpoint simple para inventario
app.get('/api/inventario/tienda-fisica', async (req, res) => {
    try {
        console.log('🔍 Consultando inventario simple...');
        
        // Nueva consulta que refleja la relación directa con Tienda_Física
        const result = await pool.query(`
            SELECT 
                tf.tienda_fisica_id,
                tf.nombre_ubicación AS nombre_tienda,
                i.inventario_id,
                i.cantidad_presentaciones AS cantidad,
                c.nombre_cerveza,
                p.nombre_presentación
            FROM inventario i
            INNER JOIN tienda_física tf ON i.Tienda_Física_tienda_fisica_id = tf.tienda_fisica_id
            INNER JOIN cerveza_presentacion cp ON i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.Cerveza_cerveza_id
                AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.Presentación_presentación_id
            INNER JOIN cerveza c ON cp.Cerveza_cerveza_id = c.cerveza_id
            INNER JOIN presentación p ON cp.Presentación_presentación_id = p.presentación_id
            ORDER BY tf.nombre_ubicación, c.nombre_cerveza, p.nombre_presentación;
        `);
        
        console.log(`✅ Consulta exitosa. ${result.rows.length} registros encontrados`);
        res.json(result.rows);
        
    } catch (error) {
        console.error('❌ Error obteniendo inventario:', error);
        res.status(500).json({ 
            error: 'Error interno del servidor',
            details: error.message
        });
    }
});

app.listen(port, () => {
    console.log(`Servidor de inventario simple ejecutándose en http://localhost:${port}`);
}); 