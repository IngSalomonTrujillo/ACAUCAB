import pool from './connectionPostgreSQL.js';

async function checkEmpleados() {
    try {
        const result = await pool.query(`
            SELECT cédula_identidad, primer_nombre, primer_apellido FROM empleado
        `);
        if (result.rows.length === 0) {
            console.log('❌ No hay empleados en la tabla.');
        } else {
            console.log('✅ Empleados encontrados:', result.rows);
        }
    } catch (error) {
        console.error('❌ Error consultando empleados:', error);
    } finally {
        await pool.end();
    }
}

checkEmpleados(); 