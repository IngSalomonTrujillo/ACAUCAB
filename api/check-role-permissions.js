import pool from "./connectionPostgreSQL.js";

async function checkRolePermissions(roleId) {
    try {
        console.log(`🔍 Consultando permisos del rol ID: ${roleId}`);
        
        // Obtener información del rol
        const rolResult = await pool.query(`
            SELECT rol_id, nombre_rol, descripción_rol
            FROM rol
            WHERE rol_id = $1
        `, [roleId]);

        if (rolResult.rows.length === 0) {
            console.log('❌ Rol no encontrado');
            return;
        }

        const rol = rolResult.rows[0];
        console.log(`\n📋 Información del Rol:`);
        console.log(`   ID: ${rol.rol_id}`);
        console.log(`   Nombre: ${rol.nombre_rol}`);
        console.log(`   Descripción: ${rol.descripción_rol}`);

        // Obtener privilegios del rol
        const privilegiosResult = await pool.query(`
            SELECT 
                p.privilegio_id,
                p.nombre_privilegio,
                p.descripción_privilegio
            FROM rol_privilegio rp
            LEFT JOIN privilegio p ON rp.Privilegio_privilegio_id = p.privilegio_id
            WHERE rp.Rol_rol_id = $1
            ORDER BY p.nombre_privilegio
        `, [roleId]);

        console.log(`\n⚡ Privilegios Asignados (${privilegiosResult.rows.length}):`);
        if (privilegiosResult.rows.length === 0) {
            console.log('   ❌ No tiene privilegios asignados');
        } else {
            privilegiosResult.rows.forEach((privilegio, index) => {
                console.log(`   ${index + 1}. ${privilegio.nombre_privilegio}`);
                console.log(`      Descripción: ${privilegio.descripción_privilegio}`);
            });
        }

        // Obtener permisos del rol
        const permisosResult = await pool.query(`
            SELECT 
                p.permiso_id,
                p.fecha_solicitud,
                p.fecha_inicio,
                p.fecha_fin,
                p.motivo
            FROM rol_permiso rp
            LEFT JOIN permiso p ON rp.Permiso_permiso_id = p.permiso_id
            WHERE rp.Rol_rol_id = $1
        `, [roleId]);

        console.log(`\n🔐 Permisos Asignados (${permisosResult.rows.length}):`);
        if (permisosResult.rows.length === 0) {
            console.log('   ❌ No tiene permisos asignados');
        } else {
            permisosResult.rows.forEach((permiso, index) => {
                console.log(`   ${index + 1}. Permiso ID: ${permiso.permiso_id}`);
                console.log(`      Motivo: ${permiso.motivo}`);
                console.log(`      Fecha inicio: ${permiso.fecha_inicio}`);
                console.log(`      Fecha fin: ${permiso.fecha_fin}`);
            });
        }

        // Obtener usuarios con este rol
        const usuariosResult = await pool.query(`
            SELECT 
                u.usuario_id,
                u.nombre_usuario,
                CONCAT(e.primer_nombre, ' ', e.primer_apellido) as nombre_empleado
            FROM usuario u
            LEFT JOIN empleado e ON u.Empleado_empleado_id = e.empleado_id
            WHERE u.Rol_rol_id = $1
        `, [roleId]);

        console.log(`\n👥 Usuarios con este Rol (${usuariosResult.rows.length}):`);
        if (usuariosResult.rows.length === 0) {
            console.log('   ❌ No hay usuarios con este rol');
        } else {
            usuariosResult.rows.forEach((usuario, index) => {
                console.log(`   ${index + 1}. ${usuario.nombre_usuario} (${usuario.nombre_empleado})`);
            });
        }

        // Analizar privilegios CRUD por tabla
        console.log(`\n📊 Análisis de Permisos CRUD por Tabla:`);
        const crudPrivilegios = privilegiosResult.rows.filter(p => 
            p.nombre_privilegio.includes('_CREATE') || 
            p.nombre_privilegio.includes('_READ') || 
            p.nombre_privilegio.includes('_UPDATE') || 
            p.nombre_privilegio.includes('_DELETE')
        );

        if (crudPrivilegios.length === 0) {
            console.log('   ❌ No tiene permisos CRUD configurados');
        } else {
            // Agrupar por tabla
            const tablas = {};
            crudPrivilegios.forEach(privilegio => {
                const parts = privilegio.nombre_privilegio.split('_');
                if (parts.length >= 2) {
                    const tabla = parts[0];
                    const operacion = parts[1];
                    
                    if (!tablas[tabla]) {
                        tablas[tabla] = [];
                    }
                    tablas[tabla].push(operacion);
                }
            });

            Object.entries(tablas).forEach(([tabla, operaciones]) => {
                console.log(`   📋 ${tabla}:`);
                operaciones.forEach(op => {
                    const icon = {
                        'CREATE': '✅',
                        'READ': '👁️',
                        'UPDATE': '✏️',
                        'DELETE': '🗑️'
                    }[op] || '❓';
                    console.log(`      ${icon} ${op}`);
                });
            });
        }

    } catch (error) {
        console.error('❌ Error consultando permisos:', error);
    } finally {
        await pool.end();
    }
}

// Obtener el ID del rol desde los argumentos de línea de comandos
const roleId = process.argv[2];

if (!roleId) {
    console.log('❌ Uso: node check-role-permissions.js <ID_DEL_ROL>');
    console.log('📋 Ejemplos:');
    console.log('   node check-role-permissions.js 1  (para el rol Administrador)');
    console.log('   node check-role-permissions.js 2  (para el rol Supervisor)');
    console.log('   node check-role-permissions.js 3  (para el rol Empleado)');
    process.exit(1);
}

checkRolePermissions(roleId); 