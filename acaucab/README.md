# ACAUCAB - Sistema de Gestión de Cerveza Artesanal

## Descripción
ACAUCAB es un sistema de gestión integral para una empresa de cerveza artesanal, desarrollado con Node.js/Express en el backend y HTML/CSS/JavaScript en el frontend, conectado a una base de datos PostgreSQL.

## Características Principales

### 🔐 Sistema de Autenticación y Autorización
- Login basado en roles y permisos
- Control de acceso granular por secciones
- Gestión de usuarios, empleados y roles
- **NUEVO: Sistema de permisos CRUD por tabla de base de datos**

### 👥 Gestión de Usuarios y Empleados
- CRUD completo de usuarios
- CRUD completo de empleados
- Asignación de roles a usuarios
- Validación de datos y duplicados

### 🛡️ Gestión de Roles y Permisos
- Creación y edición de roles
- **NUEVO: Gestión de permisos CRUD por tabla**
- Asignación de privilegios específicos
- Control de acceso basado en roles (RBAC)

### 🍺 Gestión de Productos
- Gestión de cervezas
- Información de tipos y presentaciones
- Integración con base de datos

### 📊 Dashboard y Reportes
- Estadísticas en tiempo real
- Reportes de usuarios y empleados
- Métricas del sistema

## 🚀 Instalación y Configuración

### Prerrequisitos
- Node.js (versión 14 o superior)
- PostgreSQL (versión 12 o superior)
- npm o yarn

### 1. Clonar el repositorio
```bash
git clone <url-del-repositorio>
cd acaucab
```

### 2. Configurar la base de datos
```bash
# Crear la base de datos en PostgreSQL
createdb acaucab

# Ejecutar el script de creación de tablas
psql -d acaucab -f codigosql/create.sql
```

### 3. Configurar el backend
```bash
cd api
npm install
```

### 4. Configurar la conexión a la base de datos
Editar el archivo `api/connectionPostgreSQL.js` con tus credenciales:
```javascript
const pool = new Pool({
  user: 'tu_usuario',
  host: 'localhost',
  database: 'acaucab',
  password: 'tu_contraseña',
  port: 5432,
});
```

### 5. Insertar datos de prueba
```bash
cd api
node insert-test-data.js
```

### 6. Iniciar el servidor
```bash
npm start
```

El servidor estará disponible en `http://localhost:3000`

## 👤 Usuarios de Prueba

El sistema incluye los siguientes usuarios de prueba:

| Usuario | Contraseña | Rol | Descripción |
|---------|------------|-----|-------------|
| admin | admin123 | Administrador | Acceso completo al sistema |
| supervisor | super123 | Supervisor | Puede gestionar usuarios y ver reportes |
| empleado | emp123 | Empleado | Acceso básico al sistema |
| lectura | read123 | Solo Lectura | Solo puede ver información |
| pedro | pedro123 | Empleado | Acceso básico al sistema |

## 🎯 Uso del Sistema

### Acceso al Sistema
1. Abrir `http://localhost:3000` en el navegador
2. Usar las credenciales de prueba para iniciar sesión
3. El sistema redirigirá automáticamente según el rol del usuario

### Gestión de Usuarios
- **Ver usuarios**: Lista todos los usuarios activos
- **Crear usuario**: Asignar empleado, rol y credenciales
- **Editar usuario**: Modificar información del usuario
- **Eliminar usuario**: Remover usuario del sistema

### Gestión de Empleados
- **Ver empleados**: Lista todos los empleados
- **Crear empleado**: Agregar nuevo empleado con datos completos
- **Editar empleado**: Modificar información del empleado
- **Eliminar empleado**: Remover empleado del sistema

### Gestión de Roles
- **Ver roles**: Lista todos los roles disponibles
- **Crear rol**: Definir nuevo rol con descripción
- **Editar rol**: Modificar información del rol
- **Eliminar rol**: Remover rol del sistema

### 🆕 Gestión de Permisos por Rol
**NUEVA FUNCIONALIDAD**: Sistema de permisos CRUD por tabla de base de datos

1. **Acceder a la sección**: Ir a "Permisos" en el menú lateral
2. **Seleccionar rol**: Elegir el rol a gestionar desde el dropdown
3. **Configurar permisos**: Para cada tabla de la base de datos:
   - ✅ **Crear**: Permite insertar nuevos registros
   - 👁️ **Leer**: Permite consultar registros
   - ✏️ **Actualizar**: Permite modificar registros existentes
   - 🗑️ **Eliminar**: Permite eliminar registros
4. **Guardar cambios**: Hacer clic en "Guardar Permisos"

#### Tablas Disponibles para Permisos
El sistema detecta automáticamente todas las tablas de la base de datos y permite configurar permisos CRUD para cada una:
- Usuario, Empleado, Rol, Permiso, Privilegio
- Cerveza, Tipo_Cerveza, Presentación
- Cliente, Proveedor, Compra, Venta
- Inventario, Receta, Ingrediente
- Y todas las demás tablas del sistema

### Gestión de Cervezas
- **Ver cervezas**: Lista todas las cervezas disponibles
- **Crear cerveza**: Agregar nueva cerveza con tipo y presentación
- **Editar cerveza**: Modificar información de la cerveza
- **Eliminar cerveza**: Remover cerveza del sistema

## 🔧 Estructura del Proyecto

```
acaucab/
├── api/                    # Backend Node.js/Express
│   ├── server.js          # Servidor principal
│   ├── connectionPostgreSQL.js  # Conexión a BD
│   ├── insert-test-data.js      # Datos de prueba
│   └── package.json
├── frontend/              # Frontend HTML/CSS/JS
│   ├── admin.html         # Panel de administración
│   ├── admin.js           # Lógica del panel admin
│   ├── auth.js            # Sistema de autenticación
│   ├── login.html         # Página de login
│   └── styles/            # Estilos CSS
├── codigosql/             # Scripts SQL
│   ├── create.sql         # Creación de tablas
│   └── drop.sql           # Eliminación de tablas
└── README.md
```

## 🔐 Sistema de Permisos

### Roles Predefinidos
1. **Administrador**: Acceso completo a todas las funcionalidades
2. **Supervisor**: Puede gestionar usuarios y ver reportes
3. **Empleado**: Acceso básico al sistema
4. **Solo Lectura**: Solo puede ver información, no modificar

### Privilegios del Sistema
- **Gestionar Usuarios**: Crear, editar y eliminar usuarios
- **Ver Reportes**: Acceder a reportes del sistema
- **Gestionar Productos**: Gestionar productos e inventario
- **Acceso Básico**: Acceso básico al sistema

### Permisos CRUD por Tabla
El nuevo sistema permite configurar permisos específicos para cada tabla:
- **CREATE**: Insertar nuevos registros
- **READ**: Consultar registros existentes
- **UPDATE**: Modificar registros existentes
- **DELETE**: Eliminar registros

## 🛠️ Desarrollo

### Agregar Nuevas Funcionalidades
1. Crear las rutas en `api/server.js`
2. Agregar la interfaz en `frontend/admin.html`
3. Implementar la lógica en `frontend/admin.js`
4. Agregar estilos en `frontend/styles/admin.css`

### Base de Datos
- Las tablas se crean automáticamente con `codigosql/create.sql`
- Los datos de prueba se insertan con `api/insert-test-data.js`
- El sistema detecta automáticamente las tablas para permisos

## 🐛 Solución de Problemas

### Error de conexión a la base de datos
- Verificar que PostgreSQL esté ejecutándose
- Comprobar credenciales en `connectionPostgreSQL.js`
- Asegurar que la base de datos `acaucab` existe

### Error 404 al editar usuarios
- Verificar que el servidor esté ejecutándose en puerto 3000
- Comprobar que la ruta `/api/usuarios/:id` esté disponible
- Revisar la consola del navegador para errores

### Permisos no se guardan
- Verificar que las tablas `privilegio` y `rol_privilegio` existan
- Comprobar que el usuario tenga rol de Administrador
- Revisar la consola del servidor para errores

## 📝 Notas de la Versión

### v2.0 - Sistema de Permisos CRUD
- ✅ Agregado sistema de permisos CRUD por tabla
- ✅ Interfaz visual para gestión de permisos
- ✅ Detección automática de tablas de base de datos
- ✅ Guardado automático de privilegios
- ✅ Estadísticas en tiempo real de permisos activos

### v1.0 - Funcionalidades Básicas
- ✅ Sistema de autenticación
- ✅ Gestión de usuarios y empleados
- ✅ Gestión de roles y privilegios básicos
- ✅ Dashboard con estadísticas
- ✅ Gestión de cervezas

## 📞 Soporte

Para soporte técnico o reportar problemas:
1. Revisar la consola del navegador (F12)
2. Revisar los logs del servidor
3. Verificar la configuración de la base de datos
4. Consultar este README para soluciones comunes

---

**ACAUCAB** - Sistema de Gestión de Cerveza Artesanal
Desarrollado con Node.js, Express, PostgreSQL y JavaScript 