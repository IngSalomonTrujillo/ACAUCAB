import { Pool } from 'pg';

const pool = new Pool({
    host: 'localhost',
    database: 'ACAUCAB',
    user: 'postgres',
    password: '1234',
    port: 5432
});

async function checkRealData() {
    try {
        console.log('🔍 Revisando datos reales en las tablas principales...\n');

        // 1. Revisar pagos físicos
        console.log('📊 1. TABLA: pago_fisica');
        const pagosFisicos = await pool.query('SELECT COUNT(*) as total FROM pago_fisica');
        console.log(`   Total registros: ${pagosFisicos.rows[0].total}`);
        
        if (pagosFisicos.rows[0].total > 0) {
            const muestraPagos = await pool.query('SELECT * FROM pago_fisica LIMIT 3');
            console.log('   Muestra de datos:', JSON.stringify(muestraPagos.rows, null, 2));
        }
        console.log('');

        // 2. Revisar clientes
        console.log('📊 2. TABLA: cliente');
        const clientes = await pool.query('SELECT COUNT(*) as total FROM cliente');
        console.log(`   Total registros: ${clientes.rows[0].total}`);
        
        if (clientes.rows[0].total > 0) {
            const muestraClientes = await pool.query('SELECT * FROM cliente LIMIT 3');
            console.log('   Muestra de datos:', JSON.stringify(muestraClientes.rows, null, 2));
        }
        console.log('');

        // 3. Revisar puntos de clientes
        console.log('📊 3. TABLA: cliente_punto');
        const puntos = await pool.query('SELECT COUNT(*) as total FROM cliente_punto');
        console.log(`   Total registros: ${puntos.rows[0].total}`);
        
        if (puntos.rows[0].total > 0) {
            const muestraPuntos = await pool.query('SELECT * FROM cliente_punto LIMIT 3');
            console.log('   Muestra de datos:', JSON.stringify(muestraPuntos.rows, null, 2));
        }
        console.log('');

        // 4. Revisar ventas físicas
        console.log('📊 4. TABLA: detalle_física');
        const ventasFisicas = await pool.query('SELECT COUNT(*) as total FROM detalle_física');
        console.log(`   Total registros: ${ventasFisicas.rows[0].total}`);
        
        if (ventasFisicas.rows[0].total > 0) {
            const muestraVentas = await pool.query('SELECT * FROM detalle_física LIMIT 3');
            console.log('   Muestra de datos:', JSON.stringify(muestraVentas.rows, null, 2));
        }
        console.log('');

        // 5. Revisar empleados
        console.log('📊 5. TABLA: empleado');
        const empleados = await pool.query('SELECT COUNT(*) as total FROM empleado');
        console.log(`   Total registros: ${empleados.rows[0].total}`);
        
        if (empleados.rows[0].total > 0) {
            const muestraEmpleados = await pool.query('SELECT * FROM empleado LIMIT 3');
            console.log('   Muestra de datos:', JSON.stringify(muestraEmpleados.rows, null, 2));
        }
        console.log('');

        // 6. Revisar inventario
        console.log('📊 6. TABLA: inventario');
        const inventario = await pool.query('SELECT COUNT(*) as total FROM inventario');
        console.log(`   Total registros: ${inventario.rows[0].total}`);
        
        if (inventario.rows[0].total > 0) {
            const muestraInventario = await pool.query('SELECT * FROM inventario LIMIT 3');
            console.log('   Muestra de datos:', JSON.stringify(muestraInventario.rows, null, 2));
        }
        console.log('');

        // 7. Revisar proveedores
        console.log('📊 7. TABLA: proveedor');
        const proveedores = await pool.query('SELECT COUNT(*) as total FROM proveedor');
        console.log(`   Total registros: ${proveedores.rows[0].total}`);
        
        if (proveedores.rows[0].total > 0) {
            const muestraProveedores = await pool.query('SELECT * FROM proveedor LIMIT 3');
            console.log('   Muestra de datos:', JSON.stringify(muestraProveedores.rows, null, 2));
        }
        console.log('');

        console.log('✅ Revisión completada');

    } catch (error) {
        console.error('❌ Error revisando datos:', error.message);
    } finally {
        await pool.end();
    }
}

checkRealData(); 