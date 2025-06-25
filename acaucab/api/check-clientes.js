import pool from './connectionPostgreSQL.js';

async function checkClientes() {
    try {
        console.log('🔍 Verificando clientes disponibles...');
        
        // Verificar clientes naturales
        const clientesNaturales = await pool.query(`
            SELECT rif, primer_nombre, primer_apellido, cedula_identidad
            FROM persona_natural
            LIMIT 10
        `);
        
        console.log('\n👤 Clientes Naturales:');
        clientesNaturales.rows.forEach(cliente => {
            console.log(`   - RIF: ${cliente.rif} | Nombre: ${cliente.primer_nombre} ${cliente.primer_apellido}`);
        });
        
        // Verificar clientes jurídicos
        const clientesJuridicos = await pool.query(`
            SELECT rif, razón_social, denominación_comercial
            FROM jurídico
            LIMIT 10
        `);
        
        console.log('\n🏢 Clientes Jurídicos:');
        clientesJuridicos.rows.forEach(cliente => {
            console.log(`   - RIF: ${cliente.rif} | Razón Social: ${cliente.razón_social}`);
        });
        
        // Verificar si hay usuarios asociados a estos clientes
        console.log('\n🔗 Verificando usuarios asociados a clientes...');
        const usuariosClientes = await pool.query(`
            SELECT u.usuario_id, u.nombre_usuario, 
                   CASE 
                       WHEN pn.rif IS NOT NULL THEN pn.rif
                       WHEN j.rif IS NOT NULL THEN j.rif
                   END as cliente_rif
            FROM usuario u
            LEFT JOIN persona_natural pn ON u.persona_natural_rif = pn.rif
            LEFT JOIN jurídico j ON u.jurídico_rif = j.rif
            WHERE pn.rif IS NOT NULL OR j.rif IS NOT NULL
            LIMIT 10
        `);
        
        console.log('\n👥 Usuarios asociados a clientes:');
        usuariosClientes.rows.forEach(usuario => {
            console.log(`   - Usuario ID: ${usuario.usuario_id} | Nombre: ${usuario.nombre_usuario} | Cliente RIF: ${usuario.cliente_rif}`);
        });
        
    } catch (error) {
        console.error('❌ Error consultando clientes:', error);
    } finally {
        await pool.end();
    }
}

checkClientes(); 