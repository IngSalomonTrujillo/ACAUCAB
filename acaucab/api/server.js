import pool from "./connectionPostgreSQL.js";
import express from 'express';
import cors from 'cors';

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

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

// Ruta de autenticación
app.post('/api/auth/login', async (req, res) => {
    try {
        console.log('🔐 Login attempt received:', req.body);
        const { username, password } = req.body;

        if (!username || !password) {
            console.log('❌ Missing username or password');
            return res.status(400).json({ error: 'Usuario y contraseña son requeridos' });
        }

        console.log('🔍 Checking if Usuario table exists...');
        if (!(await tableExists('usuario'))) {
            console.log('❌ Usuario table does not exist');
            return res.status(400).json({ error: 'La tabla Usuario no existe en la base de datos' });
        }

        console.log('✅ Usuario table exists, querying for user...');
        // Buscar usuario por nombre de usuario y contraseña
        const result = await pool.query(`
            SELECT 
                u.usuario_id,
                u.nombre_usuario,
                u.contraseña_usuario,
                e.primer_nombre,
                e.primer_apellido,
                r.rol_id,
                r.nombre_rol,
                r.descripción_rol
            FROM usuario u
            LEFT JOIN empleado e ON u.Empleado_empleado_id = e.empleado_id
            LEFT JOIN rol r ON u.Rol_rol_id = r.rol_id
            WHERE u.nombre_usuario = $1 AND u.contraseña_usuario = $2
            AND u.Empleado_empleado_id IS NOT NULL
        `, [username, password]);

        console.log('🔍 Query result:', result.rows);

        if (result.rows.length === 0) {
            console.log('❌ No user found with provided credentials');
            return res.status(401).json({ error: 'Credenciales incorrectas' });
        }

        const user = result.rows[0];
        console.log('✅ User found:', user);

        // Obtener permisos del rol (si la tabla existe)
        let permisosResult = { rows: [] };
        if (await tableExists('rol_permiso') && await tableExists('permiso')) {
            try {
                permisosResult = await pool.query(`
                    SELECT 
                        rp.Permiso_permiso_id,
                        p.fecha_solicitud,
                        p.fecha_inicio,
                        p.fecha_fin,
                        p.motivo
                    FROM rol_permiso rp
                    LEFT JOIN permiso p ON rp.Permiso_permiso_id = p.permiso_id
                    WHERE rp.Rol_rol_id = $1
                `, [user.rol_id]);
            } catch (error) {
                console.log('⚠️ Error getting permissions, using empty array:', error.message);
                permisosResult = { rows: [] };
            }
        } else {
            console.log('⚠️ Permiso tables do not exist, using empty permissions');
        }

        // Obtener privilegios del rol (si la tabla existe)
        let privilegiosResult = { rows: [] };
        if (await tableExists('rol_privilegio') && await tableExists('privilegio')) {
            try {
                privilegiosResult = await pool.query(`
                    SELECT 
                        rp.Privilegio_privilegio_id,
                        p.nombre_privilegio,
                        p.descripción_privilegio
                    FROM rol_privilegio rp
                    LEFT JOIN privilegio p ON rp.Privilegio_privilegio_id = p.privilegio_id
                    WHERE rp.Rol_rol_id = $1
                `, [user.rol_id]);
            } catch (error) {
                console.log('⚠️ Error getting privileges, using empty array:', error.message);
                privilegiosResult = { rows: [] };
            }
        } else {
            console.log('⚠️ Privilegio tables do not exist, using empty privileges');
        }

        const userData = {
            id: user.usuario_id,
            username: user.nombre_usuario,
            firstName: user.primer_nombre,
            lastName: user.primer_apellido,
            fullName: `${user.primer_nombre} ${user.primer_apellido}`,
            role: {
                id: user.rol_id,
                name: user.nombre_rol,
                description: user.descripción_rol
            },
            permissions: permisosResult.rows,
            privileges: privilegiosResult.rows
        };

        console.log('✅ Login successful for user:', userData.username);
        res.json({
            success: true,
            message: 'Login exitoso',
            user: userData
        });

    } catch (error) {
        console.error('❌ Error en login:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para verificar autenticación
app.get('/api/auth/verify', async (req, res) => {
    try {
        const { userId } = req.query;

        if (!userId) {
            return res.status(401).json({ error: 'Usuario no autenticado' });
        }

        if (!(await tableExists('usuario'))) {
            return res.status(400).json({ error: 'La tabla Usuario no existe en la base de datos' });
        }

        const result = await pool.query(`
            SELECT 
                u.usuario_id,
                u.nombre_usuario,
                e.primer_nombre,
                e.primer_apellido,
                r.rol_id,
                r.nombre_rol,
                r.descripción_rol
            FROM usuario u
            LEFT JOIN empleado e ON u.Empleado_empleado_id = e.empleado_id
            LEFT JOIN rol r ON u.Rol_rol_id = r.rol_id
            WHERE u.usuario_id = $1 AND u.Empleado_empleado_id IS NOT NULL
        `, [userId]);

        if (result.rows.length === 0) {
            return res.status(401).json({ error: 'Usuario no encontrado' });
        }

        const user = result.rows[0];

        res.json({
            success: true,
            user: {
                id: user.usuario_id,
                username: user.nombre_usuario,
                firstName: user.primer_nombre,
                lastName: user.primer_apellido,
                fullName: `${user.primer_nombre} ${user.primer_apellido}`,
                role: {
                    id: user.rol_id,
                    name: user.nombre_rol,
                    description: user.descripción_rol
                }
            }
        });

    } catch (error) {
        console.error('Error verificando autenticación:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Rutas para el Dashboard
app.get('/api/dashboard/stats', async (req, res) => {
    try {
        const stats = {
            totalUsuarios: 0,
            totalEmpleados: 0,
            totalRoles: 0
        };

        // Verificar y contar usuarios si la tabla existe
        if (await tableExists('usuario')) {
            const usuariosResult = await pool.query("SELECT COUNT(*) as total FROM usuario WHERE Empleado_empleado_id IS NOT NULL");
            stats.totalUsuarios = parseInt(usuariosResult.rows[0].total);
        }

        // Verificar y contar empleados si la tabla existe
        if (await tableExists('empleado')) {
            const empleadosResult = await pool.query("SELECT COUNT(*) as total FROM empleado");
            stats.totalEmpleados = parseInt(empleadosResult.rows[0].total);
        }

        // Verificar y contar roles si la tabla existe
        if (await tableExists('rol')) {
            const rolesResult = await pool.query("SELECT COUNT(*) as total FROM rol");
            stats.totalRoles = parseInt(rolesResult.rows[0].total);
        }

        res.json(stats);
    } catch (error) {
        console.error('Error obteniendo estadísticas:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Rutas para Usuarios
app.get('/api/usuarios', async (req, res) => {
    try {
        if (!(await tableExists('usuario'))) {
            return res.json([]);
        }

        const result = await pool.query(`
            SELECT 
                u.usuario_id,
                u.nombre_usuario,
                u.contraseña_usuario,
                COALESCE(e.primer_nombre || ' ' || e.primer_apellido, 'N/A') as nombre_empleado,
                COALESCE(r.nombre_rol, 'Sin rol') as nombre_rol,
                CASE 
                    WHEN u.Empleado_empleado_id IS NOT NULL THEN 'Activo'
                    ELSE 'Inactivo'
                END as estado
            FROM usuario u
            LEFT JOIN empleado e ON u.Empleado_empleado_id = e.empleado_id
            LEFT JOIN rol r ON u.Rol_rol_id = r.rol_id
            WHERE u.Empleado_empleado_id IS NOT NULL
            ORDER BY u.usuario_id
        `);
        
        res.json(result.rows);
    } catch (error) {
        console.error('Error obteniendo usuarios:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

app.post('/api/usuarios', async (req, res) => {
    try {
        if (!(await tableExists('usuario'))) {
            return res.status(400).json({ error: 'La tabla Usuario no existe en la base de datos' });
        }

        const { empleadoId, rolId, nombreUsuario, contraseñaUsuario, estado } = req.body;
        
        // Verificar si el empleado ya tiene un usuario
        const existingUser = await pool.query(
            "SELECT usuario_id FROM usuario WHERE Empleado_empleado_id = $1",
            [empleadoId]
        );

        if (existingUser.rows.length > 0) {
            return res.status(400).json({ error: 'El empleado ya tiene un usuario asignado' });
        }

        // Crear nuevo usuario
        const result = await pool.query(`
            INSERT INTO usuario (Empleado_empleado_id, Rol_rol_id, nombre_usuario, contraseña_usuario)
            VALUES ($1, $2, $3, $4)
            RETURNING usuario_id
        `, [empleadoId, rolId, nombreUsuario, contraseñaUsuario]);

        res.status(201).json({ 
            message: 'Usuario creado exitosamente',
            usuarioId: result.rows[0].usuario_id 
        });
    } catch (error) {
        console.error('Error creando usuario:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

app.put('/api/usuarios/:id', async (req, res) => {
    try {
        if (!(await tableExists('usuario'))) {
            return res.status(400).json({ error: 'La tabla Usuario no existe en la base de datos' });
        }

        const { id } = req.params;
        const { empleadoId, rolId, nombreUsuario, contraseñaUsuario, estado } = req.body;
        
        const result = await pool.query(`
            UPDATE usuario 
            SET Empleado_empleado_id = $1, Rol_rol_id = $2, nombre_usuario = $3, contraseña_usuario = $4
            WHERE usuario_id = $5
            RETURNING usuario_id
        `, [empleadoId, rolId, nombreUsuario, contraseñaUsuario, id]);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Usuario no encontrado' });
        }

        res.json({ message: 'Usuario actualizado exitosamente' });
    } catch (error) {
        console.error('Error actualizando usuario:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

app.delete('/api/usuarios/:id', async (req, res) => {
    try {
        if (!(await tableExists('usuario'))) {
            return res.status(400).json({ error: 'La tabla Usuario no existe en la base de datos' });
        }

        const { id } = req.params;
        
        const result = await pool.query(
            "DELETE FROM usuario WHERE usuario_id = $1 RETURNING usuario_id",
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Usuario no encontrado' });
        }

        res.json({ message: 'Usuario eliminado exitosamente' });
    } catch (error) {
        console.error('Error eliminando usuario:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para obtener un usuario específico por ID
app.get('/api/usuarios/:id', async (req, res) => {
    try {
        if (!(await tableExists('usuario'))) {
            return res.status(400).json({ error: 'La tabla Usuario no existe en la base de datos' });
        }

        const { id } = req.params;
        
        const result = await pool.query(`
            SELECT 
                u.usuario_id,
                u.nombre_usuario,
                u.contraseña_usuario,
                u.Empleado_empleado_id,
                u.Rol_rol_id,
                COALESCE(e.primer_nombre || ' ' || e.primer_apellido, 'N/A') as nombre_empleado,
                COALESCE(r.nombre_rol, 'Sin rol') as nombre_rol
            FROM usuario u
            LEFT JOIN empleado e ON u.Empleado_empleado_id = e.empleado_id
            LEFT JOIN rol r ON u.Rol_rol_id = r.rol_id
            WHERE u.usuario_id = $1 AND u.Empleado_empleado_id IS NOT NULL
        `, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Usuario no encontrado' });
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Error obteniendo usuario:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Rutas para Empleados
app.get('/api/empleados', async (req, res) => {
    try {
        if (!(await tableExists('empleado'))) {
            return res.json([]);
        }

        const result = await pool.query(`
            SELECT 
                empleado_id,
                cédula_identidad,
                primer_nombre,
                segundo_nombre,
                primer_apellido,
                segundo_apellido,
                fecha_ingreso,
                salario,
                CONCAT(primer_nombre, ' ', primer_apellido) as nombre_completo
            FROM empleado
            ORDER BY primer_nombre, primer_apellido
        `);
        
        res.json(result.rows);
    } catch (error) {
        console.error('Error obteniendo empleados:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

app.post('/api/empleados', async (req, res) => {
    try {
        if (!(await tableExists('empleado'))) {
            return res.status(400).json({ error: 'La tabla Empleado no existe en la base de datos' });
        }

        const { cédula_identidad, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_ingreso, salario } = req.body;
        
        // Verificar si la cédula ya existe
        const existingEmpleado = await pool.query(
            "SELECT empleado_id FROM empleado WHERE cédula_identidad = $1",
            [cédula_identidad]
        );

        if (existingEmpleado.rows.length > 0) {
            return res.status(400).json({ error: 'Ya existe un empleado con esta cédula de identidad' });
        }

        // Crear nuevo empleado
        const result = await pool.query(`
            INSERT INTO empleado (cédula_identidad, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_ingreso, salario)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            RETURNING empleado_id
        `, [cédula_identidad, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_ingreso, salario]);

        res.status(201).json({ 
            message: 'Empleado creado exitosamente',
            empleadoId: result.rows[0].empleado_id 
        });
    } catch (error) {
        console.error('Error creando empleado:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

app.put('/api/empleados/:id', async (req, res) => {
    try {
        if (!(await tableExists('empleado'))) {
            return res.status(400).json({ error: 'La tabla Empleado no existe en la base de datos' });
        }

        const { id } = req.params;
        const { cédula_identidad, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_ingreso, salario } = req.body;
        
        const result = await pool.query(`
            UPDATE empleado 
            SET cédula_identidad = $1, primer_nombre = $2, segundo_nombre = $3, primer_apellido = $4, segundo_apellido = $5, fecha_ingreso = $6, salario = $7
            WHERE empleado_id = $8
            RETURNING empleado_id
        `, [cédula_identidad, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_ingreso, salario, id]);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Empleado no encontrado' });
        }

        res.json({ message: 'Empleado actualizado exitosamente' });
    } catch (error) {
        console.error('Error actualizando empleado:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

app.delete('/api/empleados/:id', async (req, res) => {
    try {
        if (!(await tableExists('empleado'))) {
            return res.status(400).json({ error: 'La tabla Empleado no existe en la base de datos' });
        }

        const { id } = req.params;
        
        const result = await pool.query(
            "DELETE FROM empleado WHERE empleado_id = $1 RETURNING empleado_id",
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Empleado no encontrado' });
        }

        res.json({ message: 'Empleado eliminado exitosamente' });
    } catch (error) {
        console.error('Error eliminando empleado:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

app.get('/api/empleados/:id', async (req, res) => {
    try {
        if (!(await tableExists('empleado'))) {
            return res.status(400).json({ error: 'La tabla Empleado no existe en la base de datos' });
        }

        const { id } = req.params;
        
        const result = await pool.query(`
            SELECT 
                empleado_id,
                cédula_identidad,
                primer_nombre,
                segundo_nombre,
                primer_apellido,
                segundo_apellido,
                fecha_ingreso,
                salario
            FROM empleado
            WHERE empleado_id = $1
        `, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Empleado no encontrado' });
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Error obteniendo empleado:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Rutas para Roles
app.get('/api/roles', async (req, res) => {
    try {
        if (!(await tableExists('rol'))) {
            return res.json([]);
        }

        const result = await pool.query(`
            SELECT rol_id, nombre_rol, descripción_rol
            FROM rol
            ORDER BY nombre_rol
        `);
        
        res.json(result.rows);
    } catch (error) {
        console.error('Error obteniendo roles:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para obtener un rol específico por ID
app.get('/api/roles/:id', async (req, res) => {
    try {
        if (!(await tableExists('rol'))) {
            return res.status(400).json({ error: 'La tabla Rol no existe en la base de datos' });
        }

        const { id } = req.params;
        
        const result = await pool.query(`
            SELECT rol_id, nombre_rol, descripción_rol
            FROM rol
            WHERE rol_id = $1
        `, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Rol no encontrado' });
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Error obteniendo rol:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para crear un nuevo rol
app.post('/api/roles', async (req, res) => {
    try {
        if (!(await tableExists('rol'))) {
            return res.status(400).json({ error: 'La tabla Rol no existe en la base de datos' });
        }

        const { nombre_rol, descripción_rol } = req.body;
        
        // Verificar si el rol ya existe
        const existingRol = await pool.query(
            "SELECT rol_id FROM rol WHERE nombre_rol = $1",
            [nombre_rol]
        );

        if (existingRol.rows.length > 0) {
            return res.status(400).json({ error: 'Ya existe un rol con este nombre' });
        }

        // Crear nuevo rol
        const result = await pool.query(`
            INSERT INTO rol (nombre_rol, descripción_rol)
            VALUES ($1, $2)
            RETURNING rol_id
        `, [nombre_rol, descripción_rol]);

        res.status(201).json({ 
            message: 'Rol creado exitosamente',
            rolId: result.rows[0].rol_id 
        });
    } catch (error) {
        console.error('Error creando rol:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para actualizar un rol
app.put('/api/roles/:id', async (req, res) => {
    try {
        if (!(await tableExists('rol'))) {
            return res.status(400).json({ error: 'La tabla Rol no existe en la base de datos' });
        }

        const { id } = req.params;
        const { nombre_rol, descripción_rol } = req.body;
        
        // Verificar si el rol existe
        const existingRol = await pool.query(
            "SELECT rol_id FROM rol WHERE rol_id = $1",
            [id]
        );

        if (existingRol.rows.length === 0) {
            return res.status(404).json({ error: 'Rol no encontrado' });
        }

        // Verificar si el nuevo nombre ya existe en otro rol
        const duplicateRol = await pool.query(
            "SELECT rol_id FROM rol WHERE nombre_rol = $1 AND rol_id != $2",
            [nombre_rol, id]
        );

        if (duplicateRol.rows.length > 0) {
            return res.status(400).json({ error: 'Ya existe otro rol con este nombre' });
        }

        // Actualizar rol
        const result = await pool.query(`
            UPDATE rol 
            SET nombre_rol = $1, descripción_rol = $2
            WHERE rol_id = $3
            RETURNING rol_id
        `, [nombre_rol, descripción_rol, id]);

        res.json({ message: 'Rol actualizado exitosamente' });
    } catch (error) {
        console.error('Error actualizando rol:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para eliminar un rol
app.delete('/api/roles/:id', async (req, res) => {
    try {
        if (!(await tableExists('rol'))) {
            return res.status(400).json({ error: 'La tabla Rol no existe en la base de datos' });
        }

        const { id } = req.params;
        
        // Verificar si el rol existe
        const existingRol = await pool.query(
            "SELECT rol_id FROM rol WHERE rol_id = $1",
            [id]
        );

        if (existingRol.rows.length === 0) {
            return res.status(404).json({ error: 'Rol no encontrado' });
        }

        // Verificar si hay usuarios usando este rol
        const usuariosConRol = await pool.query(
            "SELECT COUNT(*) as total FROM usuario WHERE Rol_rol_id = $1",
            [id]
        );

        if (parseInt(usuariosConRol.rows[0].total) > 0) {
            return res.status(400).json({ 
                error: 'No se puede eliminar el rol porque hay usuarios asignados a él' 
            });
        }

        // Eliminar privilegios del rol primero
        if (await tableExists('rol_privilegio')) {
            await pool.query('DELETE FROM rol_privilegio WHERE Rol_rol_id = $1', [id]);
        }

        // Eliminar permisos del rol
        if (await tableExists('rol_permiso')) {
            await pool.query('DELETE FROM rol_permiso WHERE Rol_rol_id = $1', [id]);
        }

        // Eliminar el rol
        const result = await pool.query(
            "DELETE FROM rol WHERE rol_id = $1 RETURNING rol_id",
            [id]
        );

        res.json({ message: 'Rol eliminado exitosamente' });
    } catch (error) {
        console.error('Error eliminando rol:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para obtener todas las tablas de la base de datos
app.get('/api/tables', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_type = 'BASE TABLE'
            ORDER BY table_name
        `);
        
        const tables = result.rows.map(row => row.table_name);
        res.json(tables);
    } catch (error) {
        console.error('Error obteniendo tablas:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para obtener permisos de un rol específico
app.get('/api/roles/:id/permisos', async (req, res) => {
    try {
        const { id } = req.params;
        
        if (!(await tableExists('rol_permiso'))) {
            return res.json({ permisos: [], privilegios: [] });
        }

        // Obtener permisos del rol
        const permisosResult = await pool.query(`
            SELECT 
                rp.Permiso_permiso_id,
                p.fecha_solicitud,
                p.fecha_inicio,
                p.fecha_fin,
                p.motivo
            FROM rol_permiso rp
            LEFT JOIN permiso p ON rp.Permiso_permiso_id = p.permiso_id
            WHERE rp.Rol_rol_id = $1
        `, [id]);

        // Obtener privilegios del rol
        const privilegiosResult = await pool.query(`
            SELECT 
                rp.Privilegio_privilegio_id,
                p.nombre_privilegio,
                p.descripción_privilegio
            FROM rol_privilegio rp
            LEFT JOIN privilegio p ON rp.Privilegio_privilegio_id = p.privilegio_id
            WHERE rp.Rol_rol_id = $1
        `, [id]);

        res.json({
            permisos: permisosResult.rows,
            privilegios: privilegiosResult.rows
        });
    } catch (error) {
        console.error('Error obteniendo permisos del rol:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para actualizar permisos CRUD de un rol
app.put('/api/roles/:id/permisos-crud', async (req, res) => {
    try {
        const { id } = req.params;
        const { permisos } = req.body; // Array de objetos { tabla, create, read, update, delete }

        // Primero, eliminar todos los privilegios existentes del rol
        if (await tableExists('rol_privilegio')) {
            await pool.query('DELETE FROM rol_privilegio WHERE Rol_rol_id = $1', [id]);
        }

        // Crear nuevos privilegios basados en los permisos CRUD
        for (const permiso of permisos) {
            const { tabla, create, read, update, delete: deletePerm } = permiso;
            
            // Crear privilegios para cada operación CRUD
            const operaciones = [
                { nombre: `${tabla}_CREATE`, descripcion: `Crear registros en ${tabla}`, tiene: create },
                { nombre: `${tabla}_READ`, descripcion: `Leer registros de ${tabla}`, tiene: read },
                { nombre: `${tabla}_UPDATE`, descripcion: `Actualizar registros en ${tabla}`, tiene: update },
                { nombre: `${tabla}_DELETE`, descripcion: `Eliminar registros de ${tabla}`, tiene: deletePerm }
            ];

            for (const operacion of operaciones) {
                if (operacion.tiene) {
                    // Verificar si el privilegio ya existe
                    let privilegioResult = await pool.query(
                        'SELECT privilegio_id FROM privilegio WHERE nombre_privilegio = $1',
                        [operacion.nombre]
                    );

                    let privilegioId;
                    if (privilegioResult.rows.length === 0) {
                        // Crear nuevo privilegio
                        const newPrivilegioResult = await pool.query(`
                            INSERT INTO privilegio (nombre_privilegio, descripción_privilegio)
                            VALUES ($1, $2)
                            RETURNING privilegio_id
                        `, [operacion.nombre, operacion.descripcion]);
                        privilegioId = newPrivilegioResult.rows[0].privilegio_id;
                    } else {
                        privilegioId = privilegioResult.rows[0].privilegio_id;
                    }

                    // Asignar privilegio al rol
                    await pool.query(`
                        INSERT INTO rol_privilegio (Rol_rol_id, Privilegio_privilegio_id)
                        VALUES ($1, $2)
                        ON CONFLICT (Rol_rol_id, Privilegio_privilegio_id) DO NOTHING
                    `, [id, privilegioId]);
                }
            }
        }

        res.json({ message: 'Permisos CRUD actualizados exitosamente' });
    } catch (error) {
        console.error('Error actualizando permisos CRUD:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para obtener todos los privilegios disponibles
app.get('/api/privilegios', async (req, res) => {
    try {
        if (!(await tableExists('privilegio'))) {
            return res.json([]);
        }

        const result = await pool.query(`
            SELECT privilegio_id, nombre_privilegio, descripción_privilegio
            FROM privilegio
            ORDER BY nombre_privilegio
        `);
        
        res.json(result.rows);
    } catch (error) {
        console.error('Error obteniendo privilegios:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Rutas para Cervezas
app.get('/api/cervezas', async (req, res) => {
    try {
        if (!(await tableExists('Cerveza'))) {
            return res.json([]);
        }

        const result = await pool.query(`
            SELECT 
                c.cerveza_id,
                c.nombre_cerveza,
                c.descripción,
                COALESCE(tc.nombre_tipo, 'Sin tipo') as tipo_cerveza,
                COALESCE(p.nombre_presentación, 'Sin presentación') as presentacion
            FROM Cerveza c
            LEFT JOIN Tipo_Cerveza tc ON c.Tipo_Cerveza_tipo_cerveza_id = tc.tipo_cerveza_id
            LEFT JOIN Presentación p ON c.presentación_id = p.presentación_id
            ORDER BY c.nombre_cerveza
        `);
        
        res.json(result.rows);
    } catch (error) {
        console.error('Error obteniendo cervezas:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta de prueba
app.get('/', (req, res) => {
    res.json({ message: 'API de ACAUCAB funcionando correctamente' });
});

app.listen(port, () => {
    console.log(`Servidor ACAUCAB ejecutándose en http://localhost:${port}`);
}); 