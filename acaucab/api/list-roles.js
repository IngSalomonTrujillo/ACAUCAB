import pool from "./connectionPostgreSQL.js";

async function listRoles() {
    try {
        console.log('📋 Listando todos los roles disponibles...\n');
        
        const result = await pool.query(`
            SELECT rol_id, nombre_rol, descripción_rol
            FROM rol
            ORDER BY rol_id
        `);

        if (result.rows.length === 0) {
            console.log('❌ No hay roles en la base de datos');
            return;
        }

        console.log('🎭 Roles Disponibles:');
        console.log('─'.repeat(80));
        
        result.rows.forEach((rol, index) => {
            console.log(`${index + 1}. ID: ${rol.rol_id} | ${rol.nombre_rol}`);
            console.log(`   Descripción: ${rol.descripción_rol}`);
            console.log('');
        });

        console.log('💡 Para consultar permisos de un rol específico:');
        console.log('   node check-role-permissions.js <ID_DEL_ROL>');
        console.log('');
        console.log('📋 Ejemplos:');
        result.rows.forEach(rol => {
            console.log(`   node check-role-permissions.js ${rol.rol_id}  (${rol.nombre_rol})`);
        });

    } catch (error) {
        console.error('❌ Error listando roles:', error);
    } finally {
        await pool.end();
    }
}

listRoles(); 