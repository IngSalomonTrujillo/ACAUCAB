import pool from "./connectionPostgreSQL.js";

async function removeDuplicates() {
    try {
        console.log('🔍 Buscando y eliminando datos duplicados...');

        // 1. Eliminar duplicados de la tabla empleado
        console.log('📝 Limpiando duplicados en tabla empleado...');
        await pool.query(`
            DELETE FROM empleado 
            WHERE empleado_id NOT IN (
                SELECT MIN(empleado_id) 
                FROM empleado 
                GROUP BY cédula_identidad, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_ingreso, salario
            )
        `);
        console.log('✅ Duplicados eliminados de empleado');

        // 2. Eliminar duplicados de la tabla rol
        console.log('👥 Limpiando duplicados en tabla rol...');
        await pool.query(`
            DELETE FROM rol 
            WHERE rol_id NOT IN (
                SELECT MIN(rol_id) 
                FROM rol 
                GROUP BY nombre_rol, descripción_rol
            )
        `);
        console.log('✅ Duplicados eliminados de rol');

        // 3. Eliminar duplicados de la tabla usuario
        console.log('👤 Limpiando duplicados en tabla usuario...');
        await pool.query(`
            DELETE FROM usuario 
            WHERE usuario_id NOT IN (
                SELECT MIN(usuario_id) 
                FROM usuario 
                GROUP BY Empleado_empleado_id, Rol_rol_id, nombre_usuario, contraseña_usuario
            )
        `);
        console.log('✅ Duplicados eliminados de usuario');

        // 4. Eliminar duplicados de la tabla permiso
        console.log('🔐 Limpiando duplicados en tabla permiso...');
        await pool.query(`
            DELETE FROM permiso 
            WHERE permiso_id NOT IN (
                SELECT MIN(permiso_id) 
                FROM permiso 
                GROUP BY fecha_solicitud, fecha_inicio, fecha_fin, motivo
            )
        `);
        console.log('✅ Duplicados eliminados de permiso');

        // 5. Eliminar duplicados de la tabla privilegio
        console.log('⚡ Limpiando duplicados en tabla privilegio...');
        await pool.query(`
            DELETE FROM privilegio 
            WHERE privilegio_id NOT IN (
                SELECT MIN(privilegio_id) 
                FROM privilegio 
                GROUP BY nombre_privilegio, descripción_privilegio
            )
        `);
        console.log('✅ Duplicados eliminados de privilegio');

        // 6. Eliminar duplicados de la tabla rol_permiso
        console.log('🔗 Limpiando duplicados en tabla rol_permiso...');
        await pool.query(`
            DELETE FROM rol_permiso 
            WHERE ctid NOT IN (
                SELECT MIN(ctid) 
                FROM rol_permiso 
                GROUP BY Rol_rol_id, Permiso_permiso_id
            )
        `);
        console.log('✅ Duplicados eliminados de rol_permiso');

        // 7. Eliminar duplicados de la tabla rol_privilegio
        console.log('🔗 Limpiando duplicados en tabla rol_privilegio...');
        await pool.query(`
            DELETE FROM rol_privilegio 
            WHERE ctid NOT IN (
                SELECT MIN(ctid) 
                FROM rol_privilegio 
                GROUP BY Rol_rol_id, Privilegio_privilegio_id
            )
        `);
        console.log('✅ Duplicados eliminados de rol_privilegio');

        // Mostrar estadísticas finales
        console.log('\n📊 Estadísticas después de la limpieza:');
        
        const tables = ['empleado', 'rol', 'usuario', 'permiso', 'privilegio', 'rol_permiso', 'rol_privilegio'];
        
        for (const table of tables) {
            const result = await pool.query(`SELECT COUNT(*) as count FROM "${table}"`);
            console.log(`📋 ${table}: ${result.rows[0].count} registros`);
        }

        // Mostrar usuarios disponibles
        console.log('\n👤 Usuarios disponibles:');
        const usuariosResult = await pool.query(`
            SELECT u.nombre_usuario, u.contraseña_usuario, r.nombre_rol
            FROM usuario u
            JOIN rol r ON u.Rol_rol_id = r.rol_id
            ORDER BY u.usuario_id
        `);
        
        usuariosResult.rows.forEach(user => {
            console.log(`👤 ${user.nombre_usuario} / ${user.contraseña_usuario} (${user.nombre_rol})`);
        });

        console.log('\n✅ Limpieza de duplicados completada exitosamente');

    } catch (error) {
        console.error('❌ Error durante la limpieza:', error);
        throw error;
    } finally {
        await pool.end();
    }
}

// Ejecutar el script
removeDuplicates(); 