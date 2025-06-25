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
        
        // Consulta simple que funcione con la estructura real
        const result = await pool.query(`
            SELECT 
                tf.tienda_fisica_id,
                tf.nombre_ubicación as nombre_tienda,
                lt.lugar_tienda_id,
                lt.nombre_lugar_tienda,
                lt.tipo_lugar_tienda,
                i.inventario_id,
                i.cantidad_presentaciones as cantidad
            FROM lugar_tienda lt
            INNER JOIN tienda_física tf ON lt.tienda_física_tienda_fisica_id = tf.tienda_fisica_id
            INNER JOIN inventario i ON lt.inventario_inventario_id = i.inventario_id
            ORDER BY tf.nombre_ubicación, lt.nombre_lugar_tienda
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