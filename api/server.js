import pool from "./connectionPostgreSQL.js";
import express from 'express';
import cors from 'cors';
import { setupInventarioEndpoints } from './fixed-inventario-endpoint.js';
import { 
    generateInventarioReport, 
    generateVentasReport, 
    generateClientesReport,
    generateRankingProveedoresReport,
    generatePuntosCanjeadosReport,
    generateFlujoPagoReport,
    generateDuracionPedidosReport,
    generateIncumplimientosHorariosReport,
    generateTendenciasVentasReport,
    generateVentasCanalReport,
    generateProductosTopReport,
    generateRotacionInventarioReport,
    generateAnalisisClientesReport,
    generateEmpleadosReport,
    generateVentasEmpleadoReport
} from './report-generator.js';
import path from 'path';
import { fileURLToPath } from 'url';

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Servir archivos estáticos del frontend
app.use(express.static(path.join(__dirname, '../frontend')));

// Configurar endpoints de inventario
setupInventarioEndpoints(app, pool);

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
                u.Cliente_RIF,
                e.primer_nombre,
                e.primer_apellido,
                r.rol_id,
                r.nombre_rol,
                r.descripción_rol
            FROM usuario u
            LEFT JOIN empleado e ON u.Empleado_empleado_id = e.empleado_id
            LEFT JOIN cliente c ON u.Cliente_RIF = c.RIF
            LEFT JOIN rol r ON u.Rol_rol_id = r.rol_id
            WHERE u.nombre_usuario = $1 AND u.contraseña_usuario = $2
            AND (u.Empleado_empleado_id IS NOT NULL OR u.Cliente_RIF IS NOT NULL)
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
            firstName: user.primer_nombre || user.nombre_usuario,
            lastName: user.primer_apellido || '',
            fullName: user.primer_nombre && user.primer_apellido 
                ? `${user.primer_nombre} ${user.primer_apellido}` 
                : user.nombre_usuario,
            cliente_rif: user.cliente_rif || user.Cliente_RIF, // minúscula para frontend
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
                u.Cliente_RIF,
                e.primer_nombre,
                e.primer_apellido,
                r.rol_id,
                r.nombre_rol,
                r.descripción_rol
            FROM usuario u
            LEFT JOIN empleado e ON u.Empleado_empleado_id = e.empleado_id
            LEFT JOIN cliente c ON u.Cliente_RIF = c.RIF
            LEFT JOIN rol r ON u.Rol_rol_id = r.rol_id
            WHERE u.usuario_id = $1 AND (u.Empleado_empleado_id IS NOT NULL OR u.Cliente_RIF IS NOT NULL)
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
                firstName: user.primer_nombre || user.nombre_usuario,
                lastName: user.primer_apellido || '',
                fullName: user.primer_nombre && user.primer_apellido 
                    ? `${user.primer_nombre} ${user.primer_apellido}` 
                    : user.nombre_usuario,
                Cliente_RIF: user.Cliente_RIF,
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
            LEFT JOIN Presentación p ON c.presentación_id = p.presentacion_id
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

// Endpoint para inventario de tienda física (funcional con estructura real)
app.get('/api/inventario/tienda-fisica', async (req, res) => {
    try {
        console.log('🔍 Iniciando consulta de inventario...');
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
        console.log('✅ Consulta exitosa:', result.rows.length, 'registros');
        res.json(result.rows);
    } catch (error) {
        console.error('❌ Error obteniendo inventario:', error);
        if (error.stack) console.error('STACK:', error.stack);
        res.status(500).json({ 
            error: 'Error interno del servidor',
            details: error.message
        });
    }
});

// ENDPOINT: Obtener todos los clientes
app.get('/api/clientes', async (req, res) => {
    try {
        if (!(await tableExists('cliente'))) {
            return res.json([]);
        }
        // Intentar traer también el correo si existe
        let correoJoin = '';
        let correoSelect = '';
        if (await tableExists('correo_electrónico')) {
            correoJoin = 'LEFT JOIN correo_electrónico ce ON ce.cliente_rif = c.rif';
            correoSelect = ', ce.prefijo_correo, ce.dominio_correo';
        }
        // Verificar existencia de tablas hijas
        const tieneNatural = await tableExists('personanatural');
        const tieneJuridico = await tableExists('jurídico');
        let joinNatural = '', joinJuridico = '', selectNatural = '', selectJuridico = '';
        if (tieneNatural) {
            joinNatural = 'LEFT JOIN personanatural pn ON c.rif = pn.rif';
            selectNatural = ', pn.primer_nombre AS nombre_natural, pn.primer_apellido AS apellido_natural, pn.cedula_identidad AS cedula_natural';
        }
        if (tieneJuridico) {
            joinJuridico = 'LEFT JOIN jurídico j ON c.rif = j.rif';
            selectJuridico = ', j.razón_social AS nombre_juridico';
        }
        const sql = `
            SELECT c.rif, c.tipo_cliente, c.número_carnet${correoSelect}${selectNatural}${selectJuridico}
            FROM cliente c
            ${joinNatural}
            ${joinJuridico}
            ${correoJoin}
            ORDER BY c.rif
        `;
        console.log('SQL CLIENTES:', sql);
        const result = await pool.query(sql);
        // Unificar datos según tipo_cliente
        const clientes = result.rows.map(row => {
            let nombre = '', apellido = '', telefono = '';
            if (row.tipo_cliente === 'Natural') {
                nombre = row.nombre_natural || '';
                apellido = row.apellido_natural || '';
                telefono = row.cedula_natural || '';
            } else if (row.tipo_cliente === 'Jurídico') {
                nombre = row.nombre_juridico || '';
                apellido = '';
                telefono = '';
            }
            return {
                rif: row.rif,
                tipo_cliente: row.tipo_cliente,
                numero_carnet: row.número_carnet,
                correo: row.prefijo_correo && row.dominio_correo ? `${row.prefijo_correo}@${row.dominio_correo}` : null,
                nombre,
                apellido,
                telefono
            };
        });
        res.json(clientes);
    } catch (error) {
        console.error('Error obteniendo clientes:', error);
        res.status(500).json({ error: 'Error interno del servidor', details: error.message });
    }
});

// ENDPOINT: Obtener puntos de un cliente
app.get('/api/clientes/:rif/puntos', async (req, res) => {
    try {
        const { rif } = req.params;
        if (!(await tableExists('cliente_punto'))) {
            return res.json({ puntos: 0 });
        }
        const result = await pool.query(`
            SELECT SUM(cantidad_puntos) as puntos
            FROM cliente_punto
            WHERE cliente_rif = $1
        `, [rif]);
        res.json({ puntos: parseInt(result.rows[0].puntos) || 0 });
    } catch (error) {
        console.error('Error obteniendo puntos del cliente:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// ENDPOINT: Métodos de pago agrupados y detallados
app.get('/api/metodos-pago', async (req, res) => {
    const metodos = [];
    // Efectivo
    try {
        const result = await pool.query('SELECT método_pago_id, tipo_divisa FROM "Efectivo"');
        result.rows.forEach(row => {
            metodos.push({
                id: row.método_pago_id,
                tipo: 'Efectivo',
                detalles: { divisa: row.tipo_divisa }
            });
        });
    } catch (e) {}
    // Débito
    try {
        const result = await pool.query('SELECT método_pago_id, cuenta, banco, número_tarjeta FROM "Débito"');
        result.rows.forEach(row => {
            metodos.push({
                id: row.método_pago_id,
                tipo: 'Débito',
                detalles: { banco: row.banco, cuenta: row.cuenta, numero_tarjeta: row.número_tarjeta }
            });
        });
    } catch (e) {}
    // Crédito
    try {
        const result = await pool.query('SELECT método_pago_id, cuenta, banco, número_tarjeta FROM "Crédito"');
        result.rows.forEach(row => {
            metodos.push({
                id: row.método_pago_id,
                tipo: 'Crédito',
                detalles: { banco: row.banco, cuenta: row.cuenta, numero_tarjeta: row.número_tarjeta }
            });
        });
    } catch (e) {}
    // Cheque
    try {
        const result = await pool.query('SELECT método_pago_id, número_cuenta, banco, número_cheque FROM "Cheque"');
        result.rows.forEach(row => {
            metodos.push({
                id: row.método_pago_id,
                tipo: 'Cheque',
                detalles: { banco: row.banco, numero_cuenta: row.número_cuenta, numero_cheque: row.número_cheque }
            });
        });
    } catch (e) {}
    // Punto
    try {
        const result = await pool.query('SELECT método_pago_id FROM "Punto"');
        result.rows.forEach(row => {
            metodos.push({
                id: row.método_pago_id,
                tipo: 'Punto',
                detalles: { descripcion: 'Puntos de fidelidad' }
            });
        });
    } catch (e) {}
    // Agrupar por tipo para el frontend
    const agrupados = {};
    metodos.forEach(m => {
        if (!agrupados[m.tipo]) agrupados[m.tipo] = [];
        agrupados[m.tipo].push(m);
    });
    res.json(agrupados);
});

// ENDPOINT: Tasa de cambio más reciente (USD y EUR)
app.get('/api/tasa-cambio', async (req, res) => {
    try {
        if (!(await tableExists('tasa_cambio'))) {
            return res.json([]);
        }
        // Traer la tasa más reciente por moneda
        const result = await pool.query(`
            SELECT DISTINCT ON (moneda_origen) moneda_origen, tasa, fecha_vigencia
            FROM tasa_cambio
            ORDER BY moneda_origen, fecha_vigencia DESC
        `);
        res.json(result.rows);
    } catch (error) {
        console.error('Error obteniendo tasa de cambio:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// ENDPOINT: Registrar una compra física (realizar compra)
app.post('/api/compras/realizar', async (req, res) => {
    console.log('>>> [DEBUG] Entró al endpoint /api/compras/realizar');
    console.log('>>> [DEBUG] req.body:', req.body);
    const client = await pool.connect();
    try {
        const {
            clienteRif,
            carrito, // [{ id, quantity, price, cerveza_id, presentacion_id }]
            metodosPago, // [{ tipo, monto, detalles, id }]
            puntosUsados,
            tasaCambioId, // id de la tasa usada
            subtotal,
            iva,
            total
        } = req.body;

        console.log('--- [VENTA] ---');
        console.log('Datos recibidos:', JSON.stringify(req.body, null, 2));

        if (!clienteRif || !Array.isArray(carrito) || carrito.length === 0 || !Array.isArray(metodosPago) || metodosPago.length === 0) {
            console.log('❌ Datos incompletos para la venta:', req.body);
            return res.status(400).json({ error: 'Datos incompletos para la venta', body: req.body });
        }

        // Preparar arrays para la función SQL
        const tiendaFisicaId = 1; // Simulado, deberías obtenerlo del contexto
        const fechaVenta = new Date();
        const productosArray = carrito.map(item => item.id); // IDs de inventario/presentación
        const cantidadesArray = carrito.map(item => item.quantity);
        // Si metodosPago ya trae los IDs, usarlos; si no, simular con 1
        const metodosPagoArray = metodosPago.map(mp => mp.id || 1);
        const puntos = puntosUsados || 0;

        await client.query('BEGIN');
        try {
            await client.query(
                `SELECT registrar_venta_tienda_fisica(
                    $1::integer, 
                    $2::integer, 
                    $3::timestamptz, 
                    $4::integer[], 
                    $5::integer[], 
                    $6::integer[], 
                    $7::integer
                )`,
                [
                    Number(tiendaFisicaId),
                    Number(clienteRif),
                    fechaVenta,
                    productosArray.map(Number),
                    cantidadesArray.map(Number),
                    metodosPagoArray.map(Number),
                    Number(puntos)
                ]
            );
        } catch (err) {
            await client.query('ROLLBACK');
            console.error('❌ Error ejecutando registrar_venta_tienda_fisica:', err);
            if (err.stack) console.error('STACK:', err.stack);
            return res.status(500).json({ error: 'Error registrando venta física', details: err.message });
        }
        await client.query('COMMIT');
        console.log('✅ Venta registrada correctamente (función SQL)');
        res.json({ success: true });
    } catch (error) {
        await client.query('ROLLBACK');
        console.error('❌ Error registrando venta física:', error);
        if (error.stack) console.error('STACK:', error.stack);
        res.status(500).json({ error: 'Error interno al registrar la venta física', details: error.message });
    } finally {
        client.release();
    }
});

// ENDPOINTS PARA REPORTES

// Endpoint para generar reporte de inventario
app.get('/api/admin/reports/inventario', async (req, res) => {
    try {
        console.log('📊 Generando reporte de inventario...');
        
        // Obtener datos reales de inventario
        const result = await pool.query(`
            SELECT 
                c.nombre_cerveza,
                p.nombre_presentación,
                i.cantidad_presentaciones,
                p.precio_unitario,
                (i.cantidad_presentaciones * p.precio_unitario) as valor_total,
                tf.nombre_tienda
            FROM inventario i
            INNER JOIN cerveza_presentacion cp ON i.cerveza_presentacion_cerveza_cerveza_id = cp.cerveza_cerveza_id 
                AND i.cerveza_presentacion_presentación_presentación_id = cp.presentación_presentación_id
            INNER JOIN cerveza c ON cp.cerveza_cerveza_id = c.cerveza_id
            INNER JOIN presentación p ON cp.presentación_presentación_id = p.presentación_id
            INNER JOIN tienda_física tf ON i.tienda_online_tienda_online_id = tf.tienda_fisica_id
            ORDER BY i.cantidad_presentaciones DESC
        `);

        // Generar el reporte
        const report = await generateInventarioReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="inventario.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de inventario generado exitosamente');
        
    } catch (error) {
        console.error('❌ Error generando reporte de inventario:', error);
        res.status(500).json({ error: 'Error generando reporte de inventario', details: error.message });
    }
});

// Endpoint para generar reporte de ventas
app.get('/api/reports/ventas', async (req, res) => {
    try {
        console.log('📊 Generando reporte de ventas...');
        
        // Obtener datos de ventas
        const result = await pool.query(`
            SELECT 
                vf.tienda_física_tienda_fisica_id as venta_id,
                CONCAT(pn.primer_nombre, ' ', pn.primer_apellido) as nombre_cliente,
                c.nombre_cerveza as nombre_producto,
                df.cantidad,
                df.precio_unitario,
                (df.cantidad * df.precio_unitario) as total,
                vf.fecha_hora_venta as fecha_venta
            FROM venta_física vf
            LEFT JOIN detalle_física df ON vf.tienda_física_tienda_fisica_id = df.venta_física_tienda_fisica_id 
                AND vf.usuario_usuario_id = df.venta_física_usuario_id
            LEFT JOIN inventario i ON df.inventario_inventario_id = i.inventario_id
            LEFT JOIN Cerveza c ON i.Cerveza_Presentacion_Cerveza_cerveza_id = c.cerveza_id
            LEFT JOIN usuario u ON vf.usuario_usuario_id = u.usuario_id
                LEFT JOIN personanatural pn ON u.Cliente_RIF = pn.rif
                LEFT JOIN jurídico j ON u.Cliente_RIF = j.rif
            ORDER BY vf.fecha_hora_venta DESC
        `);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'No hay datos de ventas disponibles' });
        }

        // Generar el reporte
        const report = await generateVentasReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="reporte-ventas.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de ventas generado exitosamente');
        
        } catch (error) {
        console.error('❌ Error generando reporte de ventas:', error);
        res.status(500).json({ error: 'Error generando reporte de ventas', details: error.message });
    }
});

// Endpoint para generar reporte de clientes
app.get('/api/reports/clientes', async (req, res) => {
    try {
        console.log('📊 Generando reporte de clientes...');
        
        // Obtener datos de clientes
        const result = await pool.query(`
            SELECT 
                pn.rif as cliente_id,
                pn.primer_nombre,
                pn.primer_apellido,
                pn.email,
                pn.telefono,
                pn.direccion
            FROM personanatural pn
            UNION ALL
            SELECT 
                j.rif as cliente_id,
                j.razon_social as primer_nombre,
                '' as primer_apellido,
                j.email,
                j.telefono,
                j.direccion
            FROM jurídico j
            ORDER BY primer_nombre
        `);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'No hay datos de clientes disponibles' });
        }

        // Generar el reporte
        const report = await generateClientesReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="reporte-clientes.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de clientes generado exitosamente');
        
    } catch (error) {
        console.error('❌ Error generando reporte de clientes:', error);
        res.status(500).json({ error: 'Error generando reporte de clientes', details: error.message });
    }
});

// Endpoint para listar reportes disponibles
app.get('/api/reports', (req, res) => {
    const reportes = [
        {
            id: 'inventario',
            nombre: 'Reporte de Inventario',
            descripcion: 'Muestra el estado actual del inventario con cantidades y valores',
            endpoint: '/api/reports/inventario'
        },
        {
            id: 'ventas',
            nombre: 'Reporte de Ventas',
            descripcion: 'Historial de ventas realizadas con detalles de productos y clientes',
            endpoint: '/api/reports/ventas'
        },
        {
            id: 'clientes',
            nombre: 'Reporte de Clientes',
            descripcion: 'Lista completa de clientes registrados en el sistema',
            endpoint: '/api/reports/clientes'
        },
        {
            id: 'tendencias-ventas',
            nombre: 'Tendencias de Ventas',
            descripcion: 'Análisis de tendencias de ventas por período con gráficos de evolución',
            endpoint: '/api/reports/tendencias-ventas'
        },
        {
            id: 'ventas-canal',
            nombre: 'Ventas por Canal',
            descripcion: 'Comparación de ventas físicas vs online con análisis de rendimiento',
            endpoint: '/api/reports/ventas-canal'
        },
        {
            id: 'productos-top',
            nombre: 'Productos Top',
            descripcion: 'Ranking de productos más vendidos con análisis de rendimiento',
            endpoint: '/api/reports/productos-top'
        },
        {
            id: 'rotacion-inventario',
            nombre: 'Rotación de Inventario',
            descripcion: 'Análisis de rotación de productos y productos de lento movimiento',
            endpoint: '/api/reports/rotacion-inventario'
        },
        {
            id: 'analisis-clientes',
            nombre: 'Análisis de Clientes',
            descripcion: 'Análisis de clientes nuevos vs recurrentes y tasa de retención',
            endpoint: '/api/reports/analisis-clientes'
        },
        {
            id: 'empleados',
            nombre: 'Reporte de Empleados',
            descripcion: 'Lista de empleados con información de contacto y roles asignados',
            endpoint: '/api/reports/empleados'
        },
        {
            id: 'ventas-empleado',
            nombre: 'Ventas por Empleado',
            descripcion: 'Análisis de rendimiento de ventas por empleado',
            endpoint: '/api/reports/ventas-empleado'
        }
    ];
    
    res.json(reportes);
});

// ENDPOINTS PARA REPORTES DEL ADMIN

// Endpoint para generar reporte de ranking de proveedores
app.get('/api/admin/reports/ranking-proveedores', async (req, res) => {
    try {
        console.log('📊 [1] Iniciando generación de reporte de ranking de proveedores...');
        // Obtener datos reales del ranking de proveedores
        const result = await pool.query(`
            SELECT 
                p.razón_social as nombre_proveedor,
                STRING_AGG(DISTINCT tc.nombre_tipo, ', ') as tipos_cerveza,
                COUNT(DISTINCT c.cerveza_id) as total_cervezas,
                COUNT(DISTINCT i.inventario_id) as total_presentaciones
            FROM proveedor p
            LEFT JOIN tipo_cerveza tc ON p.proveedor_id = tc.proveedor_proveedor_id
            LEFT JOIN cerveza c ON tc.tipo_cerveza_id = c.tipo_cerveza_tipo_cerveza_id
            LEFT JOIN cerveza_presentacion cp ON c.cerveza_id = cp.cerveza_cerveza_id
            LEFT JOIN inventario i ON 
                i.cerveza_presentacion_cerveza_cerveza_id = cp.cerveza_cerveza_id AND 
                i.cerveza_presentacion_presentación_presentación_id = cp.presentación_presentación_id
            GROUP BY p.proveedor_id, p.razón_social
            ORDER BY total_cervezas DESC, total_presentaciones DESC
        `);
        console.log('📊 [2] Datos obtenidos de la base de datos:', JSON.stringify(result.rows, null, 2));

        if (result.rows.length === 0) {
            console.log('📊 [3] No hay datos de proveedores disponibles para el reporte.');
            return res.status(404).json({ error: 'No hay datos de proveedores disponibles' });
        }

        // Generar el reporte
        console.log('📊 [4] Llamando a generateRankingProveedoresReport...');
        const report = await generateRankingProveedoresReport(result.rows);
        console.log('📊 [5] Reporte generado, enviando PDF al cliente...');
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="ranking-proveedores.pdf"');
        res.send(report.content);
        console.log('✅ [6] Reporte de ranking de proveedores generado y enviado exitosamente');
    } catch (error) {
        console.error('❌ [ERROR] generando reporte de ranking de proveedores:', error, error.stack);
        res.status(500).json({ error: 'Error generando reporte de ranking de proveedores', details: error.message, stack: error.stack });
    }
});

// Endpoint para generar reporte de puntos canjeados
app.get('/api/admin/reports/puntos-canjeados', async (req, res) => {
    try {
        console.log('📊 Generando reporte de puntos canjeados...');
        
        // Obtener datos reales de puntos usados en pagos con fechas reales
        const result = await pool.query(`
            SELECT 
                c.rif,
                c.tipo_cliente,
                c.número_carnet,
                COALESCE(pn.primer_nombre || ' ' || pn.primer_apellido, j.razón_social) as nombre_cliente,
                COALESCE(pf.puntos_usuados, po.puntos_usados, 0) as puntos_canjeados,
                (COALESCE(pf.puntos_usuados, po.puntos_usados, 0) * 1.00) as valor_bs,
                COALESCE(pf.fecha_pago, po.fecha_pago) as fecha_canje
            FROM cliente c
            LEFT JOIN personanatural pn ON c.rif = pn.rif
            LEFT JOIN jurídico j ON c.rif = j.rif
            LEFT JOIN usuario u ON c.rif = u.cliente_rif
            LEFT JOIN pago_fisica pf ON u.usuario_id = pf.venta_física_usuario_id
            LEFT JOIN pago_online po ON u.usuario_id = po.venta_online_usuario_id
            WHERE (pf.puntos_usuados > 0 OR po.puntos_usados > 0)
            ORDER BY fecha_canje DESC, c.rif
        `);

        console.log('📊 Datos obtenidos:', result.rows);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'No se encontraron puntos canjeados' });
        }

        // Generar el PDF
        const reportData = {
            title: 'Reporte de Puntos Canjeados',
            subtitle: 'Valor de Puntos Canjeados por Cliente',
            generatedAt: new Date().toLocaleString('es-VE'),
            data: result.rows.map(row => ({
                rif: row.rif,
                tipo_cliente: row.tipo_cliente,
                numero_carnet: row.número_carnet,
                nombre_cliente: row.nombre_cliente,
                puntos_canjeados: row.puntos_canjeados,
                valor_bs: row.valor_bs,
                fecha_canje: row.fecha_canje ? new Date(row.fecha_canje).toLocaleDateString('es-VE') : 'N/A'
            }))
        };

        console.log('📊 Generando PDF con datos:', reportData);

        const pdfBuffer = await generatePuntosCanjeadosReport(result.rows);
        
        console.log('📊 PDF generado exitosamente, tamaño del buffer:', pdfBuffer.length);

        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="reporte-puntos-canjeados.pdf"');
        res.setHeader('Content-Length', pdfBuffer.length);
        res.send(pdfBuffer);

    } catch (error) {
        console.error('❌ Error generando reporte de puntos canjeados:', error, error.stack);
        res.status(500).json({ error: 'Error generando reporte de puntos canjeados', details: error.message });
    }
});

// Endpoint para generar reporte de flujo de pago
app.get('/api/admin/reports/flujo-pago', async (req, res) => {
    try {
        console.log('📊 Generando reporte de flujo de pago...');
        
        // Obtener datos reales de flujo de pago
        const result = await pool.query(`
            SELECT 
                tipo_pago,
                COUNT(*) as cantidad_transacciones,
                SUM(monto_pagado) as monto_total,
                ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) as porcentaje
            FROM (
                SELECT DISTINCT
                    pf.venta_física_tienda_fisica_id,
                    pf.venta_física_usuario_id,
                    pf.método_pago_método_pago_id,
                    pf.monto_pagado,
                    CASE 
                        WHEN c.método_pago_id IS NOT NULL THEN 'Cheque'
                        WHEN cr.método_pago_id IS NOT NULL THEN 'Crédito'
                        WHEN d.método_pago_id IS NOT NULL THEN 'Débito'
                        WHEN e.método_pago_id IS NOT NULL THEN 'Efectivo'
                        WHEN p.método_pago_id IS NOT NULL THEN 'Puntos'
                        ELSE 'Otro'
                    END as tipo_pago
                FROM pago_fisica pf
                LEFT JOIN cheque c ON pf.método_pago_método_pago_id = c.método_pago_id
                LEFT JOIN crédito cr ON pf.método_pago_método_pago_id = cr.método_pago_id
                LEFT JOIN débito d ON pf.método_pago_método_pago_id = d.método_pago_id
                LEFT JOIN efectivo e ON pf.método_pago_método_pago_id = e.método_pago_id
                LEFT JOIN punto p ON pf.método_pago_método_pago_id = p.método_pago_id
            ) pagos
            GROUP BY tipo_pago
            ORDER BY cantidad_transacciones DESC
        `);

        // Generar el reporte
        const report = await generateFlujoPagoReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="flujo-pago.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de flujo de pago generado exitosamente');
        
    } catch (error) {
        console.error('❌ Error generando reporte de flujo de pago:', error);
        res.status(500).json({ error: 'Error generando reporte de flujo de pago', details: error.message });
    }
});

// Endpoint para generar reporte de duración de pedidos
app.get('/api/admin/reports/duracion-pedidos', async (req, res) => {
    try {
        console.log('📊 Generando reporte de duración de pedidos...');
        
        // Obtener datos de duración de pedidos (simulado)
        const result = await pool.query(`
            SELECT 
                'Lunes' as dia_semana,
                15 as pedidos_procesados,
                25 as tiempo_promedio,
                15 as tiempo_minimo,
                45 as tiempo_maximo
            UNION ALL
            SELECT 
                'Martes' as dia_semana,
                18 as pedidos_procesados,
                22 as tiempo_promedio,
                12 as tiempo_minimo,
                40 as tiempo_maximo
            UNION ALL
            SELECT 
                'Miércoles' as dia_semana,
                12 as pedidos_procesados,
                28 as tiempo_promedio,
                18 as tiempo_minimo,
                50 as tiempo_maximo
            UNION ALL
            SELECT 
                'Jueves' as dia_semana,
                20 as pedidos_procesados,
                20 as tiempo_promedio,
                10 as tiempo_minimo,
                35 as tiempo_maximo
            UNION ALL
            SELECT 
                'Viernes' as dia_semana,
                25 as pedidos_procesados,
                18 as tiempo_promedio,
                8 as tiempo_minimo,
                30 as tiempo_maximo
            UNION ALL
            SELECT 
                'Sábado' as dia_semana,
                30 as pedidos_procesados,
                15 as tiempo_promedio,
                5 as tiempo_minimo,
                25 as tiempo_maximo
            UNION ALL
            SELECT 
                'Domingo' as dia_semana,
                22 as pedidos_procesados,
                17 as tiempo_promedio,
                7 as tiempo_minimo,
                28 as tiempo_maximo
        `);

        // Generar el reporte
        const report = await generateDuracionPedidosReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="duracion-pedidos.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de duración de pedidos generado exitosamente');
        
    } catch (error) {
        console.error('❌ Error generando reporte de duración de pedidos:', error);
        res.status(500).json({ error: 'Error generando reporte de duración de pedidos', details: error.message });
    }
});

// Endpoint para generar reporte de incumplimientos horarios
app.get('/api/admin/reports/incumplimientos-horarios', async (req, res) => {
    try {
        console.log('📊 Generando reporte de incumplimientos horarios...');
        
        // Obtener datos de incumplimientos horarios (simulado)
        const result = await pool.query(`
            SELECT 
                CONCAT(e.primer_nombre, ' ', e.primer_apellido) as nombre_completo,
                e.cédula_identidad as cedula,
                3 as llegadas_tarde,
                1 as salidas_tempranas,
                4 as total_incumplimientos,
                '2024-01-15' as ultimo_incidente
            FROM empleado e
            LIMIT 10
        `);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'No hay datos de empleados disponibles' });
        }

        // Generar el reporte
        const report = await generateIncumplimientosHorariosReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="incumplimientos-horarios.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de incumplimientos horarios generado exitosamente');
        
    } catch (error) {
        console.error('❌ Error generando reporte de incumplimientos horarios:', error);
        res.status(500).json({ error: 'Error generando reporte de incumplimientos horarios', details: error.message });
    }
});

// Endpoint: Ventas Totales por Tienda (física y online)
app.get('/api/dashboard/ventas-totales', async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        let whereFisica = '';
        let whereOnline = '';
        const paramsFisica = [];
        const paramsOnline = [];

        if (fecha_inicio) {
            whereFisica += (whereFisica ? ' AND ' : ' WHERE ') + 'vf.fecha_hora_venta >= $1';
            whereOnline += (whereOnline ? ' AND ' : ' WHERE ') + 'vo.fecha_hora_venta >= $1';
            paramsFisica.push(fecha_inicio);
            paramsOnline.push(fecha_inicio);
        }
        if (fecha_fin) {
            whereFisica += (whereFisica ? ' AND ' : ' WHERE ') + `vf.fecha_hora_venta <= $${paramsFisica.length + 1}`;
            whereOnline += (whereOnline ? ' AND ' : ' WHERE ') + `vo.fecha_hora_venta <= $${paramsOnline.length + 1}`;
            paramsFisica.push(fecha_fin);
            paramsOnline.push(fecha_fin);
        }

        // Ventas físicas
        const fisicaQuery = `
            SELECT vf.Tienda_Física_tienda_fisica_id AS tienda_id, tf.nombre_ubicación AS nombre, SUM(vf.monto_total) AS total
            FROM Venta_Física vf
            JOIN Tienda_Física tf ON vf.Tienda_Física_tienda_fisica_id = tf.tienda_fisica_id
            ${whereFisica}
            GROUP BY vf.Tienda_Física_tienda_fisica_id, tf.nombre_ubicación
            ORDER BY tienda_id
        `;
        const fisicaResult = await pool.query(fisicaQuery, paramsFisica);

        // Ventas online
        const onlineQuery = `
            SELECT vo.Tienda_Online_tienda_online_id AS tienda_id, to2.dirección_web AS nombre, SUM(vo.monto_total) AS total
            FROM Venta_Online vo
            JOIN Tienda_Online to2 ON vo.Tienda_Online_tienda_online_id = to2.tienda_online_id
            ${whereOnline}
            GROUP BY vo.Tienda_Online_tienda_online_id, to2.dirección_web
            ORDER BY tienda_id
        `;
        const onlineResult = await pool.query(onlineQuery, paramsOnline);

        res.json({
            fisica: fisicaResult.rows,
            online: onlineResult.rows
        });
    } catch (error) {
        console.error('Error en /api/dashboard/ventas-totales:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Endpoint: Crecimiento de Ventas (último mes vs. anterior o rango)
app.get('/api/dashboard/ventas-crecimiento', async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        let lastMonthStart, lastMonthEnd, prevMonthStart, prevMonthEnd;
        if (fecha_inicio && fecha_fin) {
            // Si se pasa un rango, comparar ese rango vs. el rango anterior de igual duración
            lastMonthStart = fecha_inicio;
            lastMonthEnd = fecha_fin;
            // Calcular el rango anterior
            const startDate = new Date(fecha_inicio);
            const endDate = new Date(fecha_fin);
            const diff = endDate - startDate;
            const prevEnd = new Date(startDate - 1);
            const prevStart = new Date(prevEnd - diff);
            prevMonthStart = prevStart.toISOString().slice(0, 10);
            prevMonthEnd = prevEnd.toISOString().slice(0, 10);
        } else {
            // Por defecto: último mes vs. anterior
            const now = new Date();
            const year = now.getFullYear();
            const month = now.getMonth() + 1; // 1-12
            const lastMonth = month === 1 ? 12 : month - 1;
            const lastMonthYear = month === 1 ? year - 1 : year;
            const prevMonth = lastMonth === 1 ? 12 : lastMonth - 1;
            const prevMonthYear = lastMonth === 1 ? lastMonthYear - 1 : lastMonthYear;
            lastMonthStart = `${lastMonthYear}-${String(lastMonth).padStart(2, '0')}-01`;
            lastMonthEnd = `${lastMonthYear}-${String(lastMonth + 1).padStart(2, '0')}-01`;
            prevMonthStart = `${prevMonthYear}-${String(prevMonth).padStart(2, '0')}-01`;
            prevMonthEnd = lastMonthStart;
        }
        // Ventas físicas
        const fisicaLast = await pool.query(
            `SELECT SUM(monto_total) AS total FROM Venta_Física WHERE fecha_hora_venta >= $1 AND fecha_hora_venta < $2`,
            [lastMonthStart, lastMonthEnd]
        );
        const fisicaPrev = await pool.query(
            `SELECT SUM(monto_total) AS total FROM Venta_Física WHERE fecha_hora_venta >= $1 AND fecha_hora_venta < $2`,
            [prevMonthStart, prevMonthEnd]
        );
        // Ventas online
        const onlineLast = await pool.query(
            `SELECT SUM(monto_total) AS total FROM Venta_Online WHERE fecha_hora_venta >= $1 AND fecha_hora_venta < $2`,
            [lastMonthStart, lastMonthEnd]
        );
        const onlinePrev = await pool.query(
            `SELECT SUM(monto_total) AS total FROM Venta_Online WHERE fecha_hora_venta >= $1 AND fecha_hora_venta < $2`,
            [prevMonthStart, prevMonthEnd]
        );
        // Totales
        const totalLast = Number(fisicaLast.rows[0].total || 0) + Number(onlineLast.rows[0].total || 0);
        const totalPrev = Number(fisicaPrev.rows[0].total || 0) + Number(onlinePrev.rows[0].total || 0);
        const crecimiento = totalLast - totalPrev;
        const porcentaje = totalPrev === 0 ? null : (crecimiento / totalPrev) * 100;
        res.json({
            total_ultimo_mes: totalLast,
            total_mes_anterior: totalPrev,
            crecimiento,
            porcentaje,
            detalle: {
                fisica: {
                    ultimo_mes: Number(fisicaLast.rows[0].total || 0),
                    mes_anterior: Number(fisicaPrev.rows[0].total || 0)
                },
                online: {
                    ultimo_mes: Number(onlineLast.rows[0].total || 0),
                    mes_anterior: Number(onlinePrev.rows[0].total || 0)
                }
            },
            periodo: {
                ultimo_mes: { inicio: lastMonthStart, fin: lastMonthEnd },
                mes_anterior: { inicio: prevMonthStart, fin: prevMonthEnd }
            }
        });
    } catch (error) {
        console.error('Error en /api/dashboard/ventas-crecimiento:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Endpoint: Ticket Promedio (último mes o rango)
app.get('/api/dashboard/ticket-promedio', async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        let lastMonthStart, lastMonthEnd;
        if (fecha_inicio && fecha_fin) {
            lastMonthStart = fecha_inicio;
            lastMonthEnd = fecha_fin;
        } else {
            const now = new Date();
            const year = now.getFullYear();
            const month = now.getMonth() + 1;
            const lastMonth = month === 1 ? 12 : month - 1;
            const lastMonthYear = month === 1 ? year - 1 : year;
            lastMonthStart = `${lastMonthYear}-${String(lastMonth).padStart(2, '0')}-01`;
            lastMonthEnd = `${lastMonthYear}-${String(lastMonth + 1).padStart(2, '0')}-01`;
        }
        // Ventas físicas
        const fisica = await pool.query(
            `SELECT COUNT(*) AS cantidad, SUM(monto_total) AS total FROM Venta_Física WHERE fecha_hora_venta >= $1 AND fecha_hora_venta < $2`,
            [lastMonthStart, lastMonthEnd]
        );
        // Ventas online
        const online = await pool.query(
            `SELECT COUNT(*) AS cantidad, SUM(monto_total) AS total FROM Venta_Online WHERE fecha_hora_venta >= $1 AND fecha_hora_venta < $2`,
            [lastMonthStart, lastMonthEnd]
        );
        const cantidadFisica = Number(fisica.rows[0].cantidad || 0);
        const totalFisica = Number(fisica.rows[0].total || 0);
        const cantidadOnline = Number(online.rows[0].cantidad || 0);
        const totalOnline = Number(online.rows[0].total || 0);
        const cantidadTotal = cantidadFisica + cantidadOnline;
        const total = totalFisica + totalOnline;
        res.json({
            ticket_promedio: cantidadTotal === 0 ? 0 : total / cantidadTotal,
            fisica: cantidadFisica === 0 ? 0 : totalFisica / cantidadFisica,
            online: cantidadOnline === 0 ? 0 : totalOnline / cantidadOnline,
            cantidad: cantidadTotal,
            cantidad_fisica: cantidadFisica,
            cantidad_online: cantidadOnline,
            periodo: { inicio: lastMonthStart, fin: lastMonthEnd }
        });
    } catch (error) {
        console.error('Error en /api/dashboard/ticket-promedio:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Endpoint: Volumen de Unidades Vendidas (por rango)
app.get('/api/dashboard/volumen-unidades', async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        let whereFisica = '';
        let whereOnline = '';
        const paramsFisica = [];
        const paramsOnline = [];
        if (fecha_inicio) {
            whereFisica += (whereFisica ? ' AND ' : ' WHERE ') + 'vf.fecha_hora_venta >= $1';
            whereOnline += (whereOnline ? ' AND ' : ' WHERE ') + 'vo.fecha_hora_venta >= $1';
            paramsFisica.push(fecha_inicio);
            paramsOnline.push(fecha_inicio);
        }
        if (fecha_fin) {
            whereFisica += (whereFisica ? ' AND ' : ' WHERE ') + `vf.fecha_hora_venta <= $${paramsFisica.length + 1}`;
            whereOnline += (whereOnline ? ' AND ' : ' WHERE ') + `vo.fecha_hora_venta <= $${paramsOnline.length + 1}`;
            paramsFisica.push(fecha_fin);
            paramsOnline.push(fecha_fin);
        }
        // Físicas
        const fisicaQuery = `
            SELECT SUM(df.cantidad) AS unidades
            FROM Detalle_Física df
            JOIN Venta_Física vf ON df.Venta_fisica_id = vf.Venta_id AND df.Venta_Física_tienda_fisica_id = vf.Tienda_Física_tienda_fisica_id AND df.Venta_Física_usuario_id = vf.Usuario_usuario_id
            ${whereFisica}
        `;
        const fisicaResult = await pool.query(fisicaQuery, paramsFisica);
        // Online
        const onlineQuery = `
            SELECT SUM(d_o.cantidad) AS unidades
            FROM Detalle_Online d_o
            JOIN Venta_Online vo ON d_o.Venta_Online_tienda_online_id = vo.Tienda_Online_tienda_online_id AND d_o.Venta_Online_usuario_id = vo.Usuario_usuario_id
            ${whereOnline}
        `;
        const onlineResult = await pool.query(onlineQuery, paramsOnline);
        const fisica = Number(fisicaResult.rows[0].unidades || 0);
        const online = Number(onlineResult.rows[0].unidades || 0);
        res.json({
            total: fisica + online,
            fisica,
            online
        });
    } catch (error) {
        console.error('Error en /api/dashboard/volumen-unidades:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Endpoint: Ventas por Estilo de Cerveza (por rango)
app.get('/api/dashboard/ventas-por-estilo', async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        // Físicas
        let whereFisica = '';
        const paramsFisica = [];
        if (fecha_inicio) {
            whereFisica += (whereFisica ? ' AND ' : ' WHERE ') + 'vf.fecha_hora_venta >= $1';
            paramsFisica.push(fecha_inicio);
        }
        if (fecha_fin) {
            whereFisica += (whereFisica ? ' AND ' : ' WHERE ') + `vf.fecha_hora_venta <= $${paramsFisica.length + 1}`;
            paramsFisica.push(fecha_fin);
        }
        const fisicaQuery = `
            SELECT tc.nombre_tipo AS estilo, SUM(df.cantidad) AS unidades
            FROM Detalle_Física df
            JOIN Venta_Física vf ON df.Venta_fisica_id = vf.Venta_id AND df.Venta_Física_tienda_fisica_id = vf.Tienda_Física_tienda_fisica_id AND df.Venta_Física_usuario_id = vf.Usuario_usuario_id
            JOIN Inventario i ON df.Inventario_inventario_id = i.inventario_id
            JOIN Cerveza_Presentacion cp ON i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.Cerveza_cerveza_id AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.Presentación_presentación_id
            JOIN Cerveza c ON cp.Cerveza_cerveza_id = c.cerveza_id
            JOIN Tipo_Cerveza tc ON c.Tipo_Cerveza_tipo_cerveza_id = tc.tipo_cerveza_id
            ${whereFisica}
            GROUP BY tc.nombre_tipo
        `;
        const fisicaResult = await pool.query(fisicaQuery, paramsFisica);
        // Online
        let whereOnline = '';
        const paramsOnline = [];
        if (fecha_inicio) {
            whereOnline += (whereOnline ? ' AND ' : ' WHERE ') + 'vo.fecha_hora_venta >= $1';
            paramsOnline.push(fecha_inicio);
        }
        if (fecha_fin) {
            whereOnline += (whereOnline ? ' AND ' : ' WHERE ') + `vo.fecha_hora_venta <= $${paramsOnline.length + 1}`;
            paramsOnline.push(fecha_fin);
        }
        const onlineQuery = `
            SELECT tc.nombre_tipo AS estilo, SUM(d_o.cantidad) AS unidades
            FROM Detalle_Online d_o
            JOIN Venta_Online vo ON d_o.Venta_Online_tienda_online_id = vo.Tienda_Online_tienda_online_id AND d_o.Venta_Online_usuario_id = vo.Usuario_usuario_id
            JOIN Inventario i ON d_o.Inventario_inventario_id = i.inventario_id
            JOIN Cerveza_Presentacion cp ON i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.Cerveza_cerveza_id AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.Presentación_presentación_id
            JOIN Cerveza c ON cp.Cerveza_cerveza_id = c.cerveza_id
            JOIN Tipo_Cerveza tc ON c.Tipo_Cerveza_tipo_cerveza_id = tc.tipo_cerveza_id
            ${whereOnline}
            GROUP BY tc.nombre_tipo
        `;
        const onlineResult = await pool.query(onlineQuery, paramsOnline);
        // Unir resultados por estilo
        const estilos = {};
        for (const row of fisicaResult.rows) {
            estilos[row.estilo] = (estilos[row.estilo] || 0) + Number(row.unidades || 0);
        }
        for (const row of onlineResult.rows) {
            estilos[row.estilo] = (estilos[row.estilo] || 0) + Number(row.unidades || 0);
        }
        const resultado = Object.entries(estilos).map(([estilo, unidades]) => ({ estilo, unidades }));
        res.json(resultado);
    } catch (error) {
        console.error('Error en /api/dashboard/ventas-por-estilo:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Endpoint: Número de Clientes Nuevos vs. Recurrentes (por rango)
app.get('/api/dashboard/clientes-nuevos-recurrentes', async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ error: 'Debe especificar fecha_inicio y fecha_fin' });
        }
        // Clientes que compraron en el rango
        const clientesEnRangoQuery = `
            SELECT DISTINCT u.Cliente_RIF
            FROM (
                SELECT Usuario_usuario_id, fecha_hora_venta FROM Venta_Física WHERE fecha_hora_venta >= $1 AND fecha_hora_venta <= $2
                UNION ALL
                SELECT Usuario_usuario_id, fecha_hora_venta FROM Venta_Online WHERE fecha_hora_venta >= $1 AND fecha_hora_venta <= $2
            ) t
            JOIN Usuario u ON t.Usuario_usuario_id = u.usuario_id
            WHERE u.Cliente_RIF IS NOT NULL
        `;
        const clientesEnRangoResult = await pool.query(clientesEnRangoQuery, [fecha_inicio, fecha_fin]);
        const clientesEnRango = clientesEnRangoResult.rows.map(r => r.cliente_rif);
        if (clientesEnRango.length === 0) {
            return res.json({ nuevos: 0, recurrentes: 0 });
        }
        // Para cada cliente, ver si tenía compras antes del rango
        const nuevos = [];
        const recurrentes = [];
        for (const rif of clientesEnRango) {
            const comprasAntes = await pool.query(`
                SELECT 1 FROM (
                    SELECT Usuario_usuario_id, fecha_hora_venta FROM Venta_Física WHERE fecha_hora_venta < $2
                    UNION ALL
                    SELECT Usuario_usuario_id, fecha_hora_venta FROM Venta_Online WHERE fecha_hora_venta < $2
                ) t
                JOIN Usuario u ON t.Usuario_usuario_id = u.usuario_id
                WHERE u.Cliente_RIF = $1
                LIMIT 1
            `, [rif, fecha_inicio]);
            if (comprasAntes.rows.length === 0) {
                nuevos.push(rif);
            } else {
                recurrentes.push(rif);
            }
        }
        res.json({ nuevos: nuevos.length, recurrentes: recurrentes.length });
    } catch (error) {
        console.error('Error en /api/dashboard/clientes-nuevos-recurrentes:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Endpoint: Tasa de Retención de Clientes (por rango)
app.get('/api/dashboard/tasa-retencion-clientes', async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ error: 'Debe especificar fecha_inicio y fecha_fin' });
        }
        // Clientes que compraron en el período
        const clientesEnRangoQuery = `
            SELECT DISTINCT u.Cliente_RIF
            FROM (
                SELECT Usuario_usuario_id, fecha_hora_venta FROM Venta_Física WHERE fecha_hora_venta >= $1 AND fecha_hora_venta <= $2
                UNION ALL
                SELECT Usuario_usuario_id, fecha_hora_venta FROM Venta_Online WHERE fecha_hora_venta >= $1 AND fecha_hora_venta <= $2
            ) t
            JOIN Usuario u ON t.Usuario_usuario_id = u.usuario_id
            WHERE u.Cliente_RIF IS NOT NULL
        `;
        const clientesEnRangoResult = await pool.query(clientesEnRangoQuery, [fecha_inicio, fecha_fin]);
        const clientesEnRango = clientesEnRangoResult.rows.map(r => r.cliente_rif);
        if (clientesEnRango.length === 0) {
            return res.json({ retencion: 0, retenidos: 0, total: 0 });
        }
        // Clientes que ya habían comprado antes del período y repiten en el período
        let retenidos = 0;
        for (const rif of clientesEnRango) {
            const comprasAntes = await pool.query(`
                SELECT 1 FROM (
                    SELECT Usuario_usuario_id, fecha_hora_venta FROM Venta_Física WHERE fecha_hora_venta < $2
                    UNION ALL
                    SELECT Usuario_usuario_id, fecha_hora_venta FROM Venta_Online WHERE fecha_hora_venta < $2
                ) t
                JOIN Usuario u ON t.Usuario_usuario_id = u.usuario_id
                WHERE u.Cliente_RIF = $1
                LIMIT 1
            `, [rif, fecha_inicio]);
            if (comprasAntes.rows.length > 0) {
                retenidos++;
            }
        }
        const retencion = (retenidos / clientesEnRango.length) * 100;
        res.json({ retencion, retenidos, total: clientesEnRango.length });
    } catch (error) {
        console.error('Error en /api/dashboard/tasa-retencion-clientes:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Endpoint: Rotación de Inventario (por rango)
app.get('/api/dashboard/rotacion-inventario', async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ error: 'Debe especificar fecha_inicio y fecha_fin' });
        }
        // Ventas totales en el período
        const ventasResult = await pool.query(`
            SELECT SUM(monto_total) AS total
            FROM (
                SELECT monto_total, fecha_hora_venta FROM Venta_Física WHERE fecha_hora_venta >= $1 AND fecha_hora_venta <= $2
                UNION ALL
                SELECT monto_total, fecha_hora_venta FROM Venta_Online WHERE fecha_hora_venta >= $1 AND fecha_hora_venta <= $2
            ) t
        `, [fecha_inicio, fecha_fin]);
        const ventas = Number(ventasResult.rows[0].total || 0);
        // Inventario al inicio
        const inventarioInicioResult = await pool.query(`
            SELECT SUM(cantidad_presentaciones) AS stock
            FROM Inventario
        `);
        const inventarioInicio = Number(inventarioInicioResult.rows[0].stock || 0);
        // Inventario al final (usamos el stock actual, por simplicidad)
        const inventarioFin = inventarioInicio; // Si tienes histórico, aquí deberías calcular el stock al final del período
        // Promedio
        const inventarioPromedio = (inventarioInicio + inventarioFin) / 2;
        const rotacion = inventarioPromedio === 0 ? 0 : ventas / inventarioPromedio;
        res.json({ rotacion, ventas, inventarioPromedio });
    } catch (error) {
        console.error('Error en /api/dashboard/rotacion-inventario:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Endpoint: Tasa de Ruptura de Stock (porcentaje de productos con stock = 0)
app.get('/api/dashboard/stockout-rate', async (req, res) => {
    try {
        // Si tuvieras histórico, podrías calcularlo al final del período. Por ahora, usamos el stock actual.
        const totalResult = await pool.query('SELECT COUNT(*) AS total FROM Inventario');
        const stockoutResult = await pool.query('SELECT COUNT(*) AS sin_stock FROM Inventario WHERE cantidad_presentaciones = 0');
        const total = Number(totalResult.rows[0].total || 0);
        const sin_stock = Number(stockoutResult.rows[0].sin_stock || 0);
        const tasa = total === 0 ? 0 : (sin_stock / total) * 100;
        res.json({ tasa, sin_stock, total });
    } catch (error) {
        console.error('Error en /api/dashboard/stockout-rate:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Endpoint: Ventas por Empleado (por rango)
app.get('/api/dashboard/ventas-por-empleado', async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        let where = '';
        const params = [];
        if (fecha_inicio) {
            where += (where ? ' AND ' : ' WHERE ') + 'vf.fecha_hora_venta >= $1';
            params.push(fecha_inicio);
        }
        if (fecha_fin) {
            where += (where ? ' AND ' : ' WHERE ') + `vf.fecha_hora_venta <= $${params.length + 1}`;
            params.push(fecha_fin);
        }
        const query = `
            SELECT e.primer_nombre || ' ' || e.primer_apellido AS empleado, COUNT(*) AS ventas
            FROM Venta_Física vf
            JOIN Usuario u ON vf.Usuario_usuario_id = u.usuario_id
            JOIN Empleado e ON u.Empleado_empleado_id = e.empleado_id
            ${where}
            GROUP BY e.primer_nombre, e.primer_apellido
            ORDER BY ventas DESC
        `;
        const result = await pool.query(query, params);
        res.json(result.rows);
    } catch (error) {
        console.error('Error en /api/dashboard/ventas-por-empleado:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// ===== NUEVOS ENDPOINTS DE REPORTES =====

// Endpoint para reporte de tendencias de ventas
app.get('/api/reports/tendencias-ventas', async (req, res) => {
    try {
        console.log('📊 Generando reporte de tendencias de ventas...');
        const { startDate, endDate } = req.query;
        let whereClause = '';
        const params = [];
        if (startDate && endDate) {
            whereClause = 'WHERE fecha_hora_venta >= $1 AND fecha_hora_venta <= $2';
            params.push(startDate, endDate);
        }
        const result = await pool.query(`
            SELECT 
                DATE(fecha_hora_venta) as fecha,
                SUM(monto_total) as total_ventas,
                COUNT(*) as cantidad_ventas
            FROM (
                SELECT fecha_hora_venta, monto_total FROM Venta_Física
                UNION ALL
                SELECT fecha_hora_venta, monto_total FROM Venta_Online
            ) ventas
            ${whereClause}
            GROUP BY DATE(fecha_hora_venta)
            ORDER BY fecha
        `, params);
        // Cambiado: devolver array vacío si no hay datos
        if (req.headers.accept && req.headers.accept.includes('application/json')) {
            res.json(result.rows || []);
            console.log('✅ Datos de tendencias de ventas enviados al dashboard');
            return;
        }
        // Generar el reporte PDF
        const report = await generateTendenciasVentasReport(result.rows);
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="tendencias-ventas.pdf"');
        res.send(report.content);
        console.log('✅ Reporte de tendencias de ventas generado exitosamente');
    } catch (error) {
        console.error('❌ Error generando reporte de tendencias de ventas:', error);
        res.status(500).json({ error: 'Error generando reporte de tendencias de ventas', details: error.message });
    }
});

// Endpoint para reporte de ventas por canal
app.get('/api/reports/ventas-canal', async (req, res) => {
    try {
        console.log('📊 Generando reporte de ventas por canal...');
        const { startDate, endDate } = req.query;
        
        let whereClause = '';
        const params = [];
        
        if (startDate && endDate) {
            whereClause = 'WHERE fecha_hora_venta >= $1 AND fecha_hora_venta <= $2';
            params.push(startDate, endDate);
        }
        
        // Obtener datos de ventas por canal
        const result = await pool.query(`
            SELECT 
                'Física' as canal,
                COUNT(*) as cantidad_ventas,
                SUM(monto_total) as total_ventas,
                AVG(monto_total) as promedio_venta
            FROM Venta_Física
            ${whereClause}
            UNION ALL
            SELECT 
                'Online' as canal,
                COUNT(*) as cantidad_ventas,
                SUM(monto_total) as total_ventas,
                AVG(monto_total) as promedio_venta
            FROM Venta_Online
            ${whereClause}
            ORDER BY total_ventas DESC
        `, params);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'No hay datos de ventas disponibles para el período' });
        }

        // Si el cliente solicita JSON (dashboard), devolver datos
        if (req.headers.accept && req.headers.accept.includes('application/json')) {
            res.json(result.rows);
            console.log('✅ Datos de ventas por canal enviados al dashboard');
            return;
        }

        // Generar el reporte PDF
        const report = await generateVentasCanalReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="ventas-canal.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de ventas por canal generado exitosamente');
        
    } catch (error) {
        console.error('❌ Error generando reporte de ventas por canal:', error);
        res.status(500).json({ error: 'Error generando reporte de ventas por canal', details: error.message });
    }
});

// Endpoint para reporte de productos top
app.get('/api/reports/productos-top', async (req, res) => {
    try {
        console.log('📊 Generando reporte de productos top...');
        const { startDate, endDate } = req.query;
        let whereClause = '';
        const params = [];
        if (startDate && endDate) {
            whereClause = 'WHERE v.fecha_hora_venta >= $1 AND v.fecha_hora_venta <= $2';
            params.push(startDate, endDate);
        }
        const result = await pool.query(`
            SELECT 
                c.nombre_cerveza as producto,
                p.nombre_presentación as presentacion,
                SUM(df.cantidad) as unidades_vendidas,
                SUM(df.cantidad * df.precio_unitario) as total_ventas,
                COUNT(DISTINCT v.tienda_física_tienda_fisica_id) as cantidad_ventas
            FROM Venta_Física v
            JOIN Detalle_Física df ON v.tienda_física_tienda_fisica_id = df.venta_física_tienda_fisica_id 
                AND v.usuario_usuario_id = df.venta_física_usuario_id
            JOIN Inventario i ON df.inventario_inventario_id = i.inventario_id
            JOIN Cerveza c ON i.Cerveza_Presentacion_Cerveza_cerveza_id = c.cerveza_id
            JOIN Cerveza_Presentacion cp ON i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.cerveza_cerveza_id 
                AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.presentación_presentación_id
            JOIN Presentación p ON cp.presentación_presentación_id = p.presentación_id
            ${whereClause}
            GROUP BY c.nombre_cerveza, p.nombre_presentación
            ORDER BY unidades_vendidas DESC
            LIMIT 20
        `, params);
        // Cambiado: devolver array vacío si no hay datos
        if (req.headers.accept && req.headers.accept.includes('application/json')) {
            res.json(result.rows || []);
            console.log('✅ Datos de productos top enviados al dashboard');
            return;
        }
        // Generar el reporte PDF
        const report = await generateProductosTopReport(result.rows);
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="productos-top.pdf"');
        res.send(report.content);
        console.log('✅ Reporte de productos top generado exitosamente');
    } catch (error) {
        console.error('❌ Error generando reporte de productos top:', error);
        res.status(500).json({ error: 'Error generando reporte de productos top', details: error.message });
    }
});

// Endpoint para reporte de rotación de inventario
app.get('/api/reports/rotacion-inventario', async (req, res) => {
    try {
        console.log('📊 Generando reporte de rotación de inventario...');
        const { startDate, endDate } = req.query;
        
        let whereClause = '';
        const params = [];
        
        if (startDate && endDate) {
            whereClause = 'WHERE v.fecha_hora_venta >= $1 AND v.fecha_hora_venta <= $2';
            params.push(startDate, endDate);
        }
        
        // Obtener datos de rotación de inventario
        const result = await pool.query(`
            SELECT 
                c.nombre_cerveza as producto,
                p.nombre_presentación as presentacion,
                i.cantidad_presentaciones as stock_actual,
                COALESCE(SUM(df.cantidad), 0) as unidades_vendidas,
                CASE 
                    WHEN i.cantidad_presentaciones = 0 THEN 0
                    ELSE COALESCE(SUM(df.cantidad), 0) / i.cantidad_presentaciones
                END as rotacion
            FROM Inventario i
            JOIN Cerveza c ON i.Cerveza_Presentacion_Cerveza_cerveza_id = c.cerveza_id
            JOIN Cerveza_Presentacion cp ON i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.cerveza_cerveza_id 
                AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.presentación_presentación_id
            JOIN Presentación p ON cp.presentación_presentación_id = p.presentación_id
            LEFT JOIN Detalle_Física df ON i.inventario_id = df.inventario_inventario_id
            LEFT JOIN Venta_Física v ON df.venta_física_tienda_fisica_id = v.tienda_física_tienda_fisica_id 
                AND df.venta_física_usuario_id = v.usuario_usuario_id
            ${whereClause}
            GROUP BY c.nombre_cerveza, p.nombre_presentación, i.cantidad_presentaciones, i.inventario_id
            ORDER BY rotacion DESC
        `, params);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'No hay datos de inventario disponibles' });
        }

        // Generar el reporte
        const report = await generateRotacionInventarioReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="rotacion-inventario.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de rotación de inventario generado exitosamente');
        
    } catch (error) {
        console.error('❌ Error generando reporte de rotación de inventario:', error);
        res.status(500).json({ error: 'Error generando reporte de rotación de inventario', details: error.message });
    }
});

// Endpoint para reporte de análisis de clientes
app.get('/api/reports/analisis-clientes', async (req, res) => {
    try {
        console.log('📊 Generando reporte de análisis de clientes...');
        const { startDate, endDate } = req.query;
        
        let whereClause = '';
        const params = [];
        
        if (startDate && endDate) {
            whereClause = 'WHERE v.fecha_hora_venta >= $1 AND v.fecha_hora_venta <= $2';
            params.push(startDate, endDate);
        }
        
        // Obtener datos de análisis de clientes
        const result = await pool.query(`
            SELECT 
                COALESCE(pn.primer_nombre || ' ' || pn.primer_apellido, j.razón_social) as nombre_cliente,
                c.rif,
                c.tipo_cliente,
                COUNT(DISTINCT v.tienda_física_tienda_fisica_id) as cantidad_compras,
                SUM(v.monto_total) as total_gastado,
                AVG(v.monto_total) as promedio_compra,
                MIN(v.fecha_hora_venta) as primera_compra,
                MAX(v.fecha_hora_venta) as ultima_compra
            FROM Cliente c
            LEFT JOIN PersonaNatural pn ON c.rif = pn.rif
            LEFT JOIN Jurídico j ON c.rif = j.rif
            LEFT JOIN Usuario u ON c.rif = u.Cliente_RIF
            LEFT JOIN Venta_Física v ON u.usuario_id = v.usuario_usuario_id
            ${whereClause}
            GROUP BY c.rif, c.tipo_cliente, pn.primer_nombre, pn.primer_apellido, j.razón_social
            ORDER BY total_gastado DESC
        `, params);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'No hay datos de clientes disponibles para el período' });
        }

        // Generar el reporte
        const report = await generateAnalisisClientesReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="analisis-clientes.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de análisis de clientes generado exitosamente');
        
    } catch (error) {
        console.error('❌ Error generando reporte de análisis de clientes:', error);
        res.status(500).json({ error: 'Error generando reporte de análisis de clientes', details: error.message });
    }
});

// Endpoint para reporte de empleados
app.get('/api/reports/empleados', async (req, res) => {
    try {
        console.log('📊 Generando reporte de empleados...');
        
        // Obtener datos de empleados
        const result = await pool.query(`
            SELECT 
                e.empleado_id,
                e.primer_nombre,
                e.primer_apellido,
                e.email,
                e.telefono,
                e.fecha_contratacion,
                r.nombre_rol as rol
            FROM Empleado e
            LEFT JOIN Usuario u ON e.empleado_id = u.Empleado_empleado_id
            LEFT JOIN Rol r ON u.Rol_rol_id = r.rol_id
            ORDER BY e.primer_nombre, e.primer_apellido
        `);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'No hay datos de empleados disponibles' });
        }

        // Generar el reporte
        const report = await generateEmpleadosReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="empleados.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de empleados generado exitosamente');
        
    } catch (error) {
        console.error('❌ Error generando reporte de empleados:', error);
        res.status(500).json({ error: 'Error generando reporte de empleados', details: error.message });
    }
});

// Endpoint para reporte de ventas por empleado
app.get('/api/reports/ventas-empleado', async (req, res) => {
    try {
        console.log('📊 Generando reporte de ventas por empleado...');
        const { startDate, endDate } = req.query;
        
        let whereClause = '';
        const params = [];
        
        if (startDate && endDate) {
            whereClause = 'WHERE v.fecha_hora_venta >= $1 AND v.fecha_hora_venta <= $2';
            params.push(startDate, endDate);
        }
        
        // Obtener datos de ventas por empleado
        const result = await pool.query(`
            SELECT 
                e.primer_nombre || ' ' || e.primer_apellido as empleado,
                COUNT(DISTINCT v.tienda_física_tienda_fisica_id) as cantidad_ventas,
                SUM(v.monto_total) as total_ventas,
                AVG(v.monto_total) as promedio_venta,
                MIN(v.fecha_hora_venta) as primera_venta,
                MAX(v.fecha_hora_venta) as ultima_venta
            FROM Empleado e
            JOIN Usuario u ON e.empleado_id = u.Empleado_empleado_id
            JOIN Venta_Física v ON u.usuario_id = v.usuario_usuario_id
            ${whereClause}
            GROUP BY e.empleado_id, e.primer_nombre, e.primer_apellido
            ORDER BY total_ventas DESC
        `, params);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'No hay datos de ventas por empleado disponibles para el período' });
        }

        // Generar el reporte
        const report = await generateVentasEmpleadoReport(result.rows);
        
        // Configurar headers para descarga
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="ventas-empleado.pdf"');
        
        res.send(report.content);
        console.log('✅ Reporte de ventas por empleado generado exitosamente');
        
    } catch (error) {
        console.error('❌ Error generando reporte de ventas por empleado:', error);
        res.status(500).json({ error: 'Error generando reporte de ventas por empleado', details: error.message });
    }
});

// Endpoint para datos de inventario actual (JSON) - para dashboard
app.get('/api/reports/inventario', async (req, res) => {
    try {
        console.log('📊 Obteniendo datos de inventario actual para dashboard...');
        
        // Obtener datos de inventario actual agrupados para evitar duplicados
        const result = await pool.query(`
            SELECT 
                c.nombre_cerveza,
                p.nombre_presentación,
                SUM(i.cantidad_presentaciones) as stock_actual
            FROM Inventario i
            JOIN Cerveza c ON i.Cerveza_Presentacion_Cerveza_cerveza_id = c.cerveza_id
            JOIN Cerveza_Presentacion cp ON i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.cerveza_cerveza_id 
                AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.presentación_presentación_id
            JOIN Presentación p ON cp.presentación_presentación_id = p.presentación_id
            WHERE i.cantidad_presentaciones > 0
            GROUP BY c.nombre_cerveza, p.nombre_presentación
            ORDER BY stock_actual DESC
            LIMIT 20
        `);

        res.json(result.rows);
        console.log('✅ Datos de inventario actual enviados al dashboard');
        
    } catch (error) {
        console.error('❌ Error obteniendo datos de inventario actual:', error);
        res.status(500).json({ error: 'Error obteniendo datos de inventario actual', details: error.message });
    }
});

app.listen(port, () => {
    console.log(`Servidor ACAUCAB ejecutándose en http://localhost:${port}`);
});

// Middleware global de manejo de errores
app.use((err, req, res, next) => {
    console.error('>>> [GLOBAL ERROR HANDLER]', err);
    res.status(500).json({ error: 'Error interno global', details: err.message });
});

// CAPTURA GLOBAL DE ERRORES
process.on('uncaughtException', (err) => {
  console.error('❌ uncaughtException:', err, err.stack);
});
process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ unhandledRejection:', reason);
}); 

// ===== CRUD de Eventos para Admin =====

// Listar todos los eventos
app.get('/api/eventos', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, direccion_evento, Lugar_lugar_id
            FROM Evento
            ORDER BY fecha_inicio DESC
        `);
        res.json(result.rows);
    } catch (error) {
        console.error('❌ Error listando eventos:', error);
        res.status(500).json({ error: 'Error listando eventos', details: error.message });
    }
});

// ENDPOINT: Listar eventos disponibles para clientes
app.get('/api/eventos/disponibles', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        e.evento_id AS id,
        e.nombre_evento AS nombre,
        e.fecha_inicio AS fecha,
        e.lugar_lugar_id AS lugar_id,
        l.nombre AS lugar_nombre,
        e.descripcion_evento AS descripcion,
        e.requiere_entrada_paga,
        ee.precio_entrada,
        ee.cupos_disponibles,
        ee.cupos_totales
      FROM evento e
      LEFT JOIN lugar l ON e.lugar_lugar_id = l.lugar_id
      LEFT JOIN (
        SELECT evento_evento_id, MIN(precio) AS precio_entrada, SUM(cupos_disponibles) AS cupos_disponibles, SUM(cupos_totales) AS cupos_totales
        FROM entrada_evento
        GROUP BY evento_evento_id
      ) ee ON ee.evento_evento_id = e.evento_id
      WHERE e.fecha_inicio >= CURRENT_DATE
      ORDER BY e.fecha_inicio ASC
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error obteniendo eventos disponibles:', error);
    res.status(500).json({ error: 'Error obteniendo eventos disponibles' });
  }
});

// Obtener un evento por ID
app.get('/api/eventos/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query(`
            SELECT evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, direccion_evento, Lugar_lugar_id
            FROM Evento WHERE evento_id = $1
        `, [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Evento no encontrado' });
        }
        res.json(result.rows[0]);
    } catch (error) {
        console.error('❌ Error obteniendo evento:', error);
        res.status(500).json({ error: 'Error obteniendo evento', details: error.message });
    }
});



// Editar un evento existente
app.put('/api/eventos/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre_evento, fecha_inicio, fecha_fin, descripcion_evento, requiere_entrada_paga, direccion_evento, Lugar_lugar_id } = req.body;
        const result = await pool.query(`
            UPDATE Evento SET nombre_evento = $1, fecha_inicio = $2, fecha_fin = $3, descripción_evento = $4, requiere_entrada_paga = $5, direccion_evento = $6, Lugar_lugar_id = $7
            WHERE evento_id = $8
            RETURNING evento_id
        `, [nombre_evento, fecha_inicio, fecha_fin, descripcion_evento, requiere_entrada_paga, direccion_evento, Lugar_lugar_id, id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Evento no encontrado' });
        }
        res.json({ evento_id: result.rows[0].evento_id });
    } catch (error) {
        console.error('❌ Error editando evento:', error);
        res.status(500).json({ error: 'Error editando evento', details: error.message });
    }
});

// Eliminar un evento
app.delete('/api/eventos/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query(`
            DELETE FROM Evento WHERE evento_id = $1 RETURNING evento_id
        `, [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Evento no encontrado' });
        }
        res.json({ evento_id: result.rows[0].evento_id });
    } catch (error) {
        console.error('❌ Error eliminando evento:', error);
        res.status(500).json({ error: 'Error eliminando evento', details: error.message });
    }
}); 

// ENDPOINT: Listar tipos de evento (actividades)
app.get('/api/tipos-evento', async (req, res) => {
  try {
    const result = await pool.query('SELECT tipo_evento_id, nombre_tipo_evento FROM tipo_evento');
    res.json(result.rows);
  } catch (error) {
    console.error('Error obteniendo tipos de evento:', error);
    res.status(500).json({ error: 'Error obteniendo tipos de evento' });
  }
});

// ENDPOINT: Listar proveedores
app.get('/api/proveedores', async (req, res) => {
  try {
    const result = await pool.query('SELECT proveedor_id, razón_social FROM proveedor');
    res.json(result.rows);
  } catch (error) {
    console.error('Error obteniendo proveedores:', error);
    res.status(500).json({ error: 'Error obteniendo proveedores' });
  }
});

// ENDPOINT: Listar cervezas
app.get('/api/cervezas', async (req, res) => {
  try {
    const result = await pool.query('SELECT cerveza_id, nombre_cerveza FROM cerveza');
    res.json(result.rows);
  } catch (error) {
    console.error('Error obteniendo cervezas:', error);
    res.status(500).json({ error: 'Error obteniendo cervezas' });
  }
});

// ENDPOINT: Crear evento completo
app.post('/api/eventos', async (req, res) => {
  const client = await pool.connect();
  try {
    console.log('BODY RECIBIDO EN /api/eventos:', req.body);
    console.log('tipo_evento_tipo_evento_id recibido:', req.body.tipo_evento_tipo_evento_id);

    let {
      nombre_evento,
      fecha_inicio,
      fecha_fin,
      descripcion_evento,
      requiere_entrada_paga,
      direccion_evento,
      Lugar_lugar_id,
      tipo_evento_tipo_evento_id,
      entradas_disponibles,
      proveedores = []
    } = req.body;

    // Forzar a número
    tipo_evento_tipo_evento_id = Number(tipo_evento_tipo_evento_id);

    // Si sigue sin ser válido, buscar el primer tipo de evento de la base de datos
    if (!tipo_evento_tipo_evento_id || isNaN(tipo_evento_tipo_evento_id)) {
      const tipoRes = await client.query('SELECT tipo_evento_id FROM tipo_evento LIMIT 1');
      if (tipoRes.rows.length > 0) {
        tipo_evento_tipo_evento_id = tipoRes.rows[0].tipo_evento_id;
        console.log('Asignado tipo_evento_tipo_evento_id por defecto:', tipo_evento_tipo_evento_id);
      } else {
        await client.query('ROLLBACK');
        return res.status(400).json({
          error: 'No se pudo determinar un tipo de evento válido. Por favor, seleccione uno.'
        });
      }
    }

    await client.query('BEGIN');
    // Log antes del insert para depuración
    console.log('Insertando evento con tipo_evento_tipo_evento_id:', tipo_evento_tipo_evento_id);

    // Asegurar el nombre del campo en el query coincide con la base de datos (usualmente minúsculas)
    const insertEvento = await client.query(
      `INSERT INTO evento (nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, direccion_evento, lugar_lugar_id, tipo_evento_tipo_evento_id, entradas_disponibles)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING evento_id`,
      [
        nombre_evento,
        fecha_inicio,
        fecha_fin,
        descripcion_evento,
        requiere_entrada_paga,
        direccion_evento,
        Lugar_lugar_id,
        tipo_evento_tipo_evento_id,
        entradas_disponibles
      ]
    );
    const evento_id = insertEvento.rows[0].evento_id;

    // Insertar proveedores y cervezas
    for (const prov of proveedores) {
      await client.query(
        `INSERT INTO evento_proveedor (evento_id, proveedor_id) VALUES ($1, $2)`,
        [evento_id, prov.proveedor_id]
      );
      if (Array.isArray(prov.cervezas)) {
        for (const cerveza_id of prov.cervezas) {
          await client.query(
            `INSERT INTO evento_proveedor_cerveza (evento_id, proveedor_id, cerveza_id) VALUES ($1, $2, $3)`,
            [evento_id, prov.proveedor_id, cerveza_id]
          );
        }
      }
    }
    await client.query('COMMIT');
    res.status(201).json({ evento_id });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error creando evento:', error);
    res.status(500).json({ error: 'Error creando evento', details: error.message });
  } finally {
    client.release();
  }
});

// ENDPOINT: Editar evento completo
app.put('/api/eventos/:id', async (req, res) => {
  const client = await pool.connect();
  try {
    const evento_id = parseInt(req.params.id);
    const {
      nombre_evento,
      fecha_inicio,
      fecha_fin,
      descripcion_evento,
      requiere_entrada_paga,
      direccion_evento,
      Lugar_lugar_id,
      tipo_evento_tipo_evento_id,
      entradas_disponibles,
      proveedores = []
    } = req.body;

    await client.query('BEGIN');
    // Actualizar evento
    await client.query(
      `UPDATE evento SET nombre_evento=$1, fecha_inicio=$2, fecha_fin=$3, descripción_evento=$4, requiere_entrada_paga=$5, direccion_evento=$6, Lugar_lugar_id=$7, tipo_evento_tipo_evento_id=$8, entradas_disponibles=$9 WHERE evento_id=$10`,
      [nombre_evento, fecha_inicio, fecha_fin, descripcion_evento, requiere_entrada_paga, direccion_evento, Lugar_lugar_id, tipo_evento_tipo_evento_id, entradas_disponibles, evento_id]
    );
    // Eliminar relaciones previas
    await client.query(`DELETE FROM evento_proveedor_cerveza WHERE evento_id=$1`, [evento_id]);
    await client.query(`DELETE FROM evento_proveedor WHERE evento_id=$1`, [evento_id]);
    // Insertar proveedores y cervezas
    for (const prov of proveedores) {
      await client.query(
        `INSERT INTO evento_proveedor (evento_id, proveedor_id) VALUES ($1, $2)`,
        [evento_id, prov.proveedor_id]
      );
      if (Array.isArray(prov.cervezas)) {
        for (const cerveza_id of prov.cervezas) {
          await client.query(
            `INSERT INTO evento_proveedor_cerveza (evento_id, proveedor_id, cerveza_id) VALUES ($1, $2, $3)`,
            [evento_id, prov.proveedor_id, cerveza_id]
          );
        }
      }
    }
    await client.query('COMMIT');
    res.json({ evento_id });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error editando evento:', error);
    res.status(500).json({ error: 'Error editando evento', details: error.message });
  } finally {
    client.release();
  }
});

// ENDPOINT: Obtener detalle completo de un evento
app.get('/api/eventos/:id/detalle', async (req, res) => {
  const evento_id = parseInt(req.params.id);
  try {
    // Obtener datos básicos del evento
    const eventoRes = await pool.query(
      `SELECT * FROM evento WHERE evento_id = $1`, [evento_id]
    );
    if (eventoRes.rows.length === 0) {
      return res.status(404).json({ error: 'Evento no encontrado' });
    }
    const evento = eventoRes.rows[0];

    // Obtener proveedores asignados
    const proveedoresRes = await pool.query(
      `SELECT ep.proveedor_id, p.razón_social
       FROM evento_proveedor ep
       JOIN proveedor p ON ep.proveedor_id = p.proveedor_id
       WHERE ep.evento_id = $1`, [evento_id]
    );
    const proveedores = [];
    for (const prov of proveedoresRes.rows) {
      // Obtener cervezas asignadas a este proveedor en este evento
      const cervezasRes = await pool.query(
        `SELECT c.cerveza_id, c.nombre_cerveza
         FROM evento_proveedor_cerveza epc
         JOIN cerveza c ON epc.cerveza_id = c.cerveza_id
         WHERE epc.evento_id = $1 AND epc.proveedor_id = $2`,
        [evento_id, prov.proveedor_id]
      );
      proveedores.push({
        proveedor_id: prov.proveedor_id,
        razon_social: prov.razón_social,
        cervezas: cervezasRes.rows
      });
    }

    res.json({
      ...evento,
      proveedores
    });
  } catch (error) {
    console.error('Error obteniendo detalle de evento:', error);
    res.status(500).json({ error: 'Error obteniendo detalle de evento', details: error.message });
  }
});

// ========================================
// ENDPOINTS PARA TIENDA ONLINE
// ========================================

// ENDPOINT: Obtener catálogo de productos para tienda online
app.get('/api/tienda/productos', async (req, res) => {
  try {
    let { 
      page = 1, 
      pageSize = 12, 
      categoria, 
      precioMin, 
      precioMax, 
      ordenar = 'nombre',
      tiendaOnlineId = 1 
    } = req.query;

    const offset = (page - 1) * pageSize;
    
    // Normalizar filtros
    if (typeof categoria !== 'string' || !categoria.trim()) categoria = undefined;
    if (typeof precioMin !== 'string' || isNaN(Number(precioMin)) || precioMin === '') precioMin = undefined;
    if (typeof precioMax !== 'string' || isNaN(Number(precioMax)) || precioMax === '') precioMax = undefined;
    if (!['nombre','precio_asc','precio_desc','categoria','stock'].includes(ordenar)) ordenar = 'nombre';

    // Construir la consulta base
    let query = `
      SELECT DISTINCT
        i.inventario_id,
        c.cerveza_id,
        c.nombre_cerveza,
        c.descripción as descripcion_cerveza,
        p.presentación_id,
        p.nombre_presentación,
        cp.precio_unitario,
        i.cantidad_presentaciones as stock_disponible,
        tc.nombre_tipo as categoria,
        tc.familia
      FROM Inventario i
      INNER JOIN Cerveza_Presentacion cp ON 
        i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.Cerveza_cerveza_id 
        AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.Presentación_presentación_id
      INNER JOIN Cerveza c ON cp.Cerveza_cerveza_id = c.cerveza_id
      INNER JOIN Presentación p ON cp.Presentación_presentación_id = p.presentación_id
      INNER JOIN Tipo_Cerveza tc ON c.Tipo_Cerveza_tipo_cerveza_id = tc.tipo_cerveza_id
      WHERE i.Tienda_Online_tienda_online_id = $1
        AND i.cantidad_presentaciones > 0
    `;

    const params = [tiendaOnlineId];
    let paramIndex = 2;

    // Aplicar filtros solo si tienen valor válido
    if (categoria) {
      query += ` AND tc.nombre_tipo = $${paramIndex}`;
      params.push(categoria);
      paramIndex++;
    }
    if (precioMin !== undefined) {
      query += ` AND cp.precio_unitario >= $${paramIndex}`;
      params.push(Number(precioMin));
      paramIndex++;
    }
    if (precioMax !== undefined) {
      query += ` AND cp.precio_unitario <= $${paramIndex}`;
      params.push(Number(precioMax));
      paramIndex++;
    }

    // Ordenamiento
    const ordenamientos = {
      'nombre': 'c.nombre_cerveza ASC',
      'precio_asc': 'cp.precio_unitario ASC',
      'precio_desc': 'cp.precio_unitario DESC',
      'categoria': 'tc.nombre_tipo ASC',
      'stock': 'i.cantidad_presentaciones DESC'
    };

    query += ` ORDER BY ${ordenamientos[ordenar] || ordenamientos.nombre}`;

    // Contar total para paginación
    let total = 0;
    try {
      const countQuery = query.replace(/SELECT DISTINCT.*FROM/, 'SELECT COUNT(DISTINCT i.inventario_id) as total FROM');
      const countResult = await pool.query(countQuery, params);
      total = parseInt(countResult.rows[0]?.total || 0);
    } catch (countError) {
      console.error('Error contando productos:', countError);
      total = 0;
    }

    // Aplicar paginación
    query += ` LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`;
    params.push(pageSize, offset);

    const result = await pool.query(query, params);

    // Formatear respuesta
    const productos = result.rows.map(row => ({
      id: row.inventario_id,
      cerveza_id: row.cerveza_id,
      nombre: row.nombre_cerveza,
      descripcion: row.descripcion_cerveza,
      presentacion_id: row.presentación_id,
      presentacion: row.nombre_presentación,
      precio: parseFloat(row.precio_unitario),
      stock: row.stock_disponible,
      categoria: row.categoria,
      familia: row.familia,
      disponible: row.stock_disponible > 0
    }));

    res.json({
      productos,
      paginacion: {
        page: parseInt(page),
        pageSize: parseInt(pageSize),
        total,
        totalPages: Math.ceil(total / pageSize)
      },
      filtros: {
        categoria,
        precioMin: precioMin !== undefined ? parseFloat(precioMin) : null,
        precioMax: precioMax !== undefined ? parseFloat(precioMax) : null,
        ordenar
      }
    });

  } catch (error) {
    console.error('Error obteniendo productos:', error);
    res.status(500).json({ error: 'Error obteniendo productos' });
  }
});

// ENDPOINT: Obtener detalles de un producto específico
app.get('/api/tienda/productos/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const query = `
      SELECT 
        i.inventario_id,
        c.cerveza_id,
        c.nombre_cerveza,
        c.descripción as descripcion_cerveza,
        p.presentación_id,
        p.nombre_presentación,
        cp.precio_unitario,
        i.cantidad_presentaciones as stock_disponible,
        tc.nombre_tipo as categoria,
        tc.familia,
        tc.descripción_general as descripcion_tipo
      FROM Inventario i
      INNER JOIN Cerveza_Presentacion cp ON 
        i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.Cerveza_cerveza_id 
        AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.Presentación_presentación_id
      INNER JOIN Cerveza c ON cp.Cerveza_cerveza_id = c.cerveza_id
      INNER JOIN Presentación p ON cp.Presentación_presentación_id = p.presentación_id
      INNER JOIN Tipo_Cerveza tc ON c.Tipo_Cerveza_tipo_cerveza_id = tc.tipo_cerveza_id
      WHERE i.inventario_id = $1 AND i.Tienda_Online_tienda_online_id IS NOT NULL
    `;

    const result = await pool.query(query, [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Producto no encontrado' });
    }

    const producto = result.rows[0];
    
    // Obtener características del producto
    const caracteristicasQuery = `
      SELECT cc.descripción, car.nombre_característica
      FROM Cerveza_Caracteristica cc
      INNER JOIN Característica car ON cc.Característica_característica_id = car.característica_id
      WHERE cc.Cerveza_cerveza_id = $1
    `;
    
    const caracteristicasResult = await pool.query(caracteristicasQuery, [producto.cerveza_id]);

    const productoDetallado = {
      id: producto.inventario_id,
      cerveza_id: producto.cerveza_id,
      nombre: producto.nombre_cerveza,
      descripcion: producto.descripcion_cerveza,
      presentacion_id: producto.presentación_id,
      presentacion: producto.nombre_presentación,
      precio: parseFloat(producto.precio_unitario),
      stock: producto.stock_disponible,
      categoria: producto.categoria,
      familia: producto.familia,
      descripcion_tipo: producto.descripcion_tipo,
      caracteristicas: caracteristicasResult.rows.map(c => ({
        nombre: c.nombre_característica,
        descripcion: c.descripción
      })),
      disponible: producto.stock_disponible > 0
    };

    res.json(productoDetallado);

  } catch (error) {
    console.error('Error obteniendo producto:', error);
    res.status(500).json({ error: 'Error obteniendo producto' });
  }
});

// ENDPOINT: Obtener categorías disponibles
app.get('/api/tienda/categorias', async (req, res) => {
  try {
    const query = `
      SELECT DISTINCT tc.nombre_tipo as categoria, tc.familia
      FROM Inventario i
      INNER JOIN Cerveza_Presentacion cp ON 
        i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.Cerveza_cerveza_id 
        AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.Presentación_presentación_id
      INNER JOIN Cerveza c ON cp.Cerveza_cerveza_id = c.cerveza_id
      INNER JOIN Tipo_Cerveza tc ON c.Tipo_Cerveza_tipo_cerveza_id = tc.tipo_cerveza_id
      WHERE i.Tienda_Online_tienda_online_id IS NOT NULL
        AND i.cantidad_presentaciones > 0
      ORDER BY tc.nombre_tipo
    `;

    const result = await pool.query(query);
    
    const categorias = result.rows.map(row => ({
      nombre: row.categoria,
      familia: row.familia
    }));

    res.json(categorias);

  } catch (error) {
    console.error('Error obteniendo categorías:', error);
    res.status(500).json({ error: 'Error obteniendo categorías' });
  }
});

// ENDPOINT: Verificar stock de productos
app.post('/api/tienda/verificar-stock', async (req, res) => {
  try {
    const { productos } = req.body; // Array de { inventario_id, cantidad }

    if (!Array.isArray(productos)) {
      return res.status(400).json({ error: 'Formato inválido de productos' });
    }

    const verificaciones = [];

    for (const producto of productos) {
      const query = `
        SELECT 
          i.inventario_id,
          i.cantidad_presentaciones as stock_actual,
          c.nombre_cerveza,
          p.nombre_presentación
        FROM Inventario i
        INNER JOIN Cerveza_Presentacion cp ON 
          i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.Cerveza_cerveza_id 
          AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.Presentación_presentación_id
        INNER JOIN Cerveza c ON cp.Cerveza_cerveza_id = c.cerveza_id
        INNER JOIN Presentación p ON cp.Presentación_presentación_id = p.presentación_id
        WHERE i.inventario_id = $1 AND i.Tienda_Online_tienda_online_id IS NOT NULL
      `;

      const result = await pool.query(query, [producto.inventario_id]);
      
      if (result.rows.length === 0) {
        verificaciones.push({
          inventario_id: producto.inventario_id,
          disponible: false,
          error: 'Producto no encontrado'
        });
      } else {
        const stock = result.rows[0];
        const disponible = stock.stock_actual >= producto.cantidad;
        
        verificaciones.push({
          inventario_id: producto.inventario_id,
          nombre: stock.nombre_cerveza,
          presentacion: stock.nombre_presentación,
          stock_actual: stock.stock_actual,
          cantidad_solicitada: producto.cantidad,
          disponible,
          error: disponible ? null : 'Stock insuficiente'
        });
      }
    }

    const todosDisponibles = verificaciones.every(v => v.disponible);

    res.json({
      disponible: todosDisponibles,
      verificaciones
    });

  } catch (error) {
    console.error('Error verificando stock:', error);
    res.status(500).json({ error: 'Error verificando stock' });
  }
});

// ENDPOINT: Procesar checkout y crear venta online
app.post('/api/tienda/checkout', async (req, res) => {
  const client = await pool.connect();
  try {
    const {
      clienteRif,
      productos, // Array de { inventario_id, cantidad, precio }
      metodosPago, // Array de métodos de pago
      direccionEnvio,
      puntosUsados = 0,
      tiendaOnlineId = 1
    } = req.body;

    console.log('🛒 Procesando checkout:', { clienteRif, productos, metodosPago });

    // Validaciones básicas
    if (!clienteRif || !Array.isArray(productos) || productos.length === 0) {
      return res.status(400).json({ error: 'Datos incompletos para el checkout' });
    }

    // Preparar arrays para el procedimiento
    const productosArray = productos.map(p => Number(p.inventario_id));
    const cantidadesArray = productos.map(p => Number(p.cantidad));
    const metodosPagoArray = metodosPago.map(mp => Number(mp.metodo_pago_id || mp.id || 1));
    const montosPagadosArray = metodosPago.map(mp => Number(mp.monto));
    const fechaVenta = new Date();

    await client.query('BEGIN');
    try {
      await client.query(
        `CALL registrar_venta_tienda_online(
          $1::integer, 
          $2::integer, 
          $3::timestamptz, 
          $4::integer[], 
          $5::integer[], 
          $6::integer[], 
          $7::integer, 
          $8::integer[]
        )`,
        [
          Number(tiendaOnlineId),
          Number(clienteRif),
          fechaVenta,
          productosArray,
          cantidadesArray,
          metodosPagoArray,
          Number(puntosUsados),
          montosPagadosArray
        ]
      );
    } catch (err) {
      await client.query('ROLLBACK');
      console.error('❌ Error ejecutando registrar_venta_tienda_online:', err);
      if (err.stack) console.error('STACK:', err.stack);
      return res.status(500).json({ error: 'Error registrando venta online', details: err.message });
    }
    await client.query('COMMIT');
    console.log('✅ Venta online registrada correctamente (procedimiento SQL)');
    res.json({ success: true, mensaje: 'Venta online procesada exitosamente' });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error registrando venta online:', error);
    if (error.stack) console.error('STACK:', error.stack);
    res.status(500).json({ error: 'Error interno al registrar la venta online', details: error.message });
  } finally {
    client.release();
  }
});

// ENDPOINT: Obtener historial de pedidos de un cliente
app.get('/api/tienda/mis-pedidos/:clienteRif', async (req, res) => {
  try {
    const { clienteRif } = req.params;
    const { page = 1, pageSize = 10 } = req.query;
    const offset = (page - 1) * pageSize;

    // Obtener usuario_id del cliente
    const usuarioQuery = `
      SELECT usuario_id FROM Usuario WHERE Cliente_RIF = $1
    `;
    
    const usuarioResult = await pool.query(usuarioQuery, [clienteRif]);
    
    if (usuarioResult.rows.length === 0) {
      return res.status(404).json({ error: 'Cliente no encontrado' });
    }

    const usuarioId = usuarioResult.rows[0].usuario_id;

    // Consulta para obtener ventas con detalles
    const query = `
      SELECT 
        vo.venta_id,
        vo.fecha_hora_venta,
        vo.monto_total,
        vo.Tienda_Online_tienda_online_id,
        to.dirección_web as tienda_nombre,
        voe.fecha_inicio as fecha_estatus,
        e.estatus_nombre,
        e.descripción_estatus
      FROM Venta_Online vo
      INNER JOIN Tienda_Online to ON vo.Tienda_Online_tienda_online_id = to.tienda_online_id
      LEFT JOIN VentaO_Estatus voe ON vo.Tienda_Online_tienda_online_id = voe.Venta_Online_Tienda_Online_tienda_online_id 
        AND vo.Usuario_usuario_id = voe.Venta_Online_Usuario_usuario_id
      LEFT JOIN Estatus e ON voe.Estatus_estatus_id = e.estatus_id
      WHERE vo.Usuario_usuario_id = $1
      ORDER BY vo.fecha_hora_venta DESC
      LIMIT $2 OFFSET $3
    `;

    const result = await pool.query(query, [usuarioId, pageSize, offset]);

    // Obtener detalles de cada venta
    const pedidos = [];
    for (const venta of result.rows) {
      const detallesQuery = `
        SELECT 
          do.precio_unitario,
          do.cantidad,
          c.nombre_cerveza,
          p.nombre_presentación,
          (do.precio_unitario * do.cantidad) as subtotal
        FROM Detalle_Online do
        INNER JOIN Inventario i ON do.Inventario_inventario_id = i.inventario_id
        INNER JOIN Cerveza_Presentacion cp ON 
          i.Cerveza_Presentacion_Cerveza_cerveza_id = cp.Cerveza_cerveza_id 
          AND i.Cerveza_Presentacion_Presentación_presentación_id = cp.Presentación_presentación_id
        INNER JOIN Cerveza c ON cp.Cerveza_cerveza_id = c.cerveza_id
        INNER JOIN Presentación p ON cp.Presentación_presentación_id = p.presentación_id
        WHERE do.Venta_Online_tienda_online_id = $1 AND do.Venta_Online_usuario_id = $2
      `;

      const detallesResult = await pool.query(detallesQuery, [venta.tienda_online_tienda_online_id, usuarioId]);
      
      pedidos.push({
        venta_id: venta.venta_id,
        fecha: venta.fecha_hora_venta,
        total: parseFloat(venta.monto_total),
        tienda: venta.tienda_nombre,
        estatus: venta.estatus_nombre,
        descripcion_estatus: venta.descripción_estatus,
        productos: detallesResult.rows.map(d => ({
          nombre: d.nombre_cerveza,
          presentacion: d.nombre_presentación,
          cantidad: d.cantidad,
          precio_unitario: parseFloat(d.precio_unitario),
          subtotal: parseFloat(d.subtotal)
        }))
      });
    }

    // Contar total de pedidos
    const countQuery = `
      SELECT COUNT(*) as total
      FROM Venta_Online vo
      WHERE vo.Usuario_usuario_id = $1
    `;
    
    const countResult = await pool.query(countQuery, [usuarioId]);
    const total = parseInt(countResult.rows[0].total);

    res.json({
      pedidos,
      paginacion: {
        page: parseInt(page),
        pageSize: parseInt(pageSize),
        total,
        totalPages: Math.ceil(total / pageSize)
      }
    });

  } catch (error) {
    console.error('Error obteniendo pedidos:', error);
    res.status(500).json({ error: 'Error obteniendo pedidos' });
  }
});

// ENDPOINT: Obtener puntos de un cliente
app.get('/api/tienda/puntos/:clienteRif', async (req, res) => {
  try {
    const { clienteRif } = req.params;

    const query = `
      SELECT cp.cantidad_puntos
      FROM Cliente_Punto cp
      WHERE cp.Cliente_RIF = $1
    `;

    const result = await pool.query(query, [clienteRif]);

    if (result.rows.length === 0) {
      res.json({ puntos: 0 });
    } else {
      res.json({ puntos: result.rows[0].cantidad_puntos });
    }

  } catch (error) {
    console.error('Error obteniendo puntos:', error);
    res.status(500).json({ error: 'Error obteniendo puntos' });
  }
});


// ENDPOINT: Listar cervezas disponibles en un evento
app.get('/api/eventos/:eventoId/cervezas', async (req, res) => {
  const eventoId = req.params.eventoId;
  try {
    const result = await pool.query(`
      SELECT 
        c.cerveza_id AS id,
        c.nombre_cerveza AS nombre,
        p.presentacion_id,
        p.nombre_presentacion AS presentacion,
        cp.precio_unitario AS precio,
        iecp.cantidad AS stock
      FROM inventario_e_cerveza_p iecp
      INNER JOIN cerveza_presentacion cp ON 
        iecp.cerveza_presentacion_cerveza_cerveza_id = cp.cerveza_cerveza_id AND
        iecp.cerveza_presentacion_presentacion_presentacion_id = cp.presentacion_presentacion_id
      INNER JOIN cerveza c ON cp.cerveza_cerveza_id = c.cerveza_id
      INNER JOIN presentacion p ON cp.presentacion_presentacion_id = p.presentacion_id
      WHERE iecp.evento_id = $1
    `, [eventoId]);
    res.json(result.rows);
  } catch (error) {
    console.error('Error obteniendo cervezas del evento:', error);
    res.status(500).json({ error: 'Error obteniendo cervezas del evento' });
  }
});

// ENDPOINT: Registrar compra de entradas y cervezas para un evento
app.post('/api/eventos/comprar', async (req, res) => {
  const client = await pool.connect();
  try {
    const { eventoId, clienteId, cantidadEntradas, cervezas, metodosPago } = req.body;
    if (!eventoId || !clienteId || !cantidadEntradas || cantidadEntradas < 1 || !Array.isArray(metodosPago) || metodosPago.length === 0) {
      return res.status(400).json({ error: 'Datos incompletos para la compra' });
    }
    await client.query('BEGIN');
    // 1. Insertar entradas
    const insertEntrada = await client.query(
      `INSERT INTO entrada_evento (fecha_evento, evento_evento_id, venta_entrada_cliente_rif, venta_entrada_evento_evento_id, venta_entrada_venta_entrada_id, precio, cupos_disponibles, cupos_totales)
       VALUES (CURRENT_DATE, $1, $2, $1, nextval('entrada_evento_id_seq'), 0, $3, $3) RETURNING venta_entrada_id`,
      [eventoId, clienteId, cantidadEntradas]
    );
    const entradaId = insertEntrada.rows[0].venta_entrada_id;
    // 2. Insertar pagos
    for (const pago of metodosPago) {
      await client.query(
        `INSERT INTO pago_entrada (método_pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, venta_entrada_cliente_rif, venta_entrada_evento_evento_id, venta_entrada_venta_entrada_id)
         VALUES ($1, CURRENT_DATE, $2, $3, $4, $5, $6)`,
        [pago.metodo_pago_id, pago.monto, pago.referencia || '', clienteId, eventoId, entradaId]
      );
    }
    // 3. Descontar stock de cervezas del evento
    if (Array.isArray(cervezas)) {
      for (const cerveza of cervezas) {
        await client.query(
          `UPDATE inventario_e_cerveza_p SET cantidad = cantidad - $1 WHERE evento_id = $2 AND cerveza_presentacion_cerveza_cerveza_id = $3`,
          [cerveza.cantidad, eventoId, cerveza.id]
        );
      }
    }
    await client.query('COMMIT');
    res.json({ success: true, entradaId });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error registrando compra de evento:', error);
    res.status(500).json({ error: 'Error registrando compra de evento', details: error.message });
  } finally {
    client.release();
  }
});

// ENDPOINT: Listar cervezas de un proveedor según los tipos de cerveza que ofrece
app.get('/api/proveedores/:proveedorId/cervezas', async (req, res) => {
  const { proveedorId } = req.params;
  try {
    const result = await pool.query(
      `SELECT c.cerveza_id, c.nombre_cerveza
       FROM Cerveza c
       JOIN Tipo_Cerveza tc ON c.Tipo_Cerveza_tipo_cerveza_id = tc.tipo_cerveza_id
       WHERE tc.proveedor_proveedor_id = $1`,
      [proveedorId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Error obteniendo cervezas del proveedor' });
  }
});

