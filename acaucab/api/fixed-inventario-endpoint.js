// Endpoint para inventario de tienda física - VERSIÓN CORREGIDA
export function setupInventarioEndpoints(app, pool) {
    // Función para verificar si una tabla existe
    async function tableExists(tableName) {
        try {
            const result = await pool.query(`
                SELECT EXISTS (
                    SELECT FROM information_schema.tables 
                    WHERE table_schema = 'public' 
                    AND table_name = $1
                );
            `, [tableName]);
            return result.rows[0].exists;
        } catch (error) {
            console.error(`Error verificando tabla ${tableName}:`, error);
            return false;
        }
    }

    app.get('/api/inventario/tienda-fisica', async (req, res) => {
        try {
            console.log('🔍 Verificando tablas para inventario...');
            
            // Verificar qué tablas existen (usando nombres en minúsculas)
            const tablasRequeridas = [
                'inventario',
                'lugar_tienda', 
                'tienda_física',
                'cerveza',
                'presentación',
                'cerveza_presentacion',
                'tipo_cerveza'
            ];
            
            const tablasExistentes = [];
            const tablasFaltantes = [];
            
            for (const tabla of tablasRequeridas) {
                const existe = await tableExists(tabla);
                if (existe) {
                    tablasExistentes.push(tabla);
                } else {
                    tablasFaltantes.push(tabla);
                }
            }
            
            console.log('✅ Tablas existentes:', tablasExistentes);
            console.log('❌ Tablas faltantes:', tablasFaltantes);
            
            // Si faltan tablas críticas, devolver error con información
            if (tablasFaltantes.length > 0) {
                return res.status(400).json({ 
                    error: 'Faltan tablas en la base de datos',
                    tablasFaltantes,
                    tablasExistentes,
                    message: 'Necesitas ejecutar el script create.sql para crear las tablas'
                });
            }
            
            // Si todas las tablas existen, intentar la consulta
            console.log('🔍 Ejecutando consulta de inventario...');
            const result = await pool.query(`
                SELECT 
                    tf.tienda_fisica_id,
                    tf."nombre_ubicación",
                    lt.lugar_tienda_id,
                    lt.nombre_lugar_tienda,
                    lt.tipo_lugar_tienda,
                    i.inventario_id,
                    cp.cerveza_cerveza_id AS cerveza_id,
                    c.nombre_cerveza,
                    c.descripción AS descripcion_cerveza,
                    tc.nombre_tipo AS tipo_cerveza,
                    p."presentación_id",
                    p."nombre_presentación",
                    p.precio,
                    i.cantidad_presentaciones AS cantidad
                FROM lugar_tienda lt
                INNER JOIN tienda_física tf ON lt.tienda_física_tienda_fisica_id = tf.tienda_fisica_id
                INNER JOIN inventario i ON lt.inventario_inventario_id = i.inventario_id
                INNER JOIN cerveza_presentacion cp ON i.cerveza_presentacion_cerveza_cerveza_id = cp.cerveza_cerveza_id AND i.cerveza_presentacion_presentación_presentación_id = cp."presentación_presentación_id"
                INNER JOIN cerveza c ON cp.cerveza_cerveza_id = c.cerveza_id
                INNER JOIN presentación p ON cp."presentación_presentación_id" = p."presentación_id"
                LEFT JOIN tipo_cerveza tc ON c.tipo_cerveza_tipo_cerveza_id = tc.tipo_cerveza_id
                ORDER BY tf."nombre_ubicación", lt.nombre_lugar_tienda, c.nombre_cerveza, p."nombre_presentación"
            `);
            
            console.log(`✅ Consulta exitosa. ${result.rows.length} productos encontrados`);
            res.json(result.rows);
            
        } catch (error) {
            console.error('❌ Error obteniendo inventario de tienda física:', error);
            res.status(500).json({ 
                error: 'Error interno del servidor',
                details: error.message,
                message: 'Verifica que la base de datos esté configurada correctamente'
            });
        }
    });
} 