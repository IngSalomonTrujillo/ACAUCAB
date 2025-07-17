-- Comando para Dropear Todas las Tablas (Versión Corregida y Completa)

-- Deshabilitar temporalmente las verificaciones de claves foráneas (si tu DBMS lo soporta y lo prefieres)
-- Para PostgreSQL, la opción más común es usar DROP ... CASCADE.

-- 1. Tablas de Estatus (dependen de tablas principales)
DROP TABLE IF EXISTS VentaF_Estatus CASCADE;
DROP TABLE IF EXISTS VentaO_Estatus CASCADE;
DROP TABLE IF EXISTS Vacacion_Estatus CASCADE;
DROP TABLE IF EXISTS OrdenR_Estatus CASCADE;
DROP TABLE IF EXISTS Compra_Estatus CASCADE;

-- 2. Tablas de Pago (dependen de métodos de pago y entidades principales)
DROP TABLE IF EXISTS Pago_Compra_Evento CASCADE;
DROP TABLE IF EXISTS Pago_CompraP CASCADE;
DROP TABLE IF EXISTS Pago_Cuota CASCADE;
DROP TABLE IF EXISTS Pago_Entrada CASCADE;
DROP TABLE IF EXISTS Pago_Fisica CASCADE;
DROP TABLE IF EXISTS Pago_Online CASCADE;

-- 3. Tablas de Detalle (dependen de ventas/compras y productos/inventario)
DROP TABLE IF EXISTS Detalle_Compra CASCADE;
DROP TABLE IF EXISTS Detalle_Evento CASCADE;
DROP TABLE IF EXISTS Detalle_Física CASCADE;
DROP TABLE IF EXISTS Detalle_Online CASCADE;
DROP TABLE IF EXISTS Detalle_VentaE CASCADE;

-- 4. Tablas de Venta (dependen de clientes, eventos, usuarios, tiendas)
DROP TABLE IF EXISTS Venta_Entrada CASCADE;
DROP TABLE IF EXISTS Venta_Evento CASCADE;
DROP TABLE IF EXISTS Venta_Física CASCADE;
DROP TABLE IF EXISTS Venta_Online CASCADE;

-- 5. Tablas de Inventario y sus relaciones (Inventario depende de Cerveza_Presentacion)
DROP TABLE IF EXISTS Descuento_Inventario CASCADE;
DROP TABLE IF EXISTS Inventario_E_Cerveza_P CASCADE;
DROP TABLE IF EXISTS Inventario CASCADE; -- Esta debe ir antes de Cerveza_Presentacion

-- 6. Tablas de Cerveza y sus componentes (Cerveza_Presentacion depende de Cerveza y Presentacion)
DROP TABLE IF EXISTS Cerveza_Caracteristica CASCADE;
DROP TABLE IF EXISTS Cerveza_Presentacion CASCADE; -- Ahora se puede eliminar
DROP TABLE IF EXISTS Cerveza CASCADE;
DROP TABLE IF EXISTS Tipo_Cerveza_Caracteristica CASCADE;
DROP TABLE IF EXISTS Tipo_Cerveza CASCADE;
DROP TABLE IF EXISTS Presentación CASCADE;
DROP TABLE IF EXISTS Característica CASCADE;

-- 7. Tablas de Empleado y sus relaciones (Asistencia, Beneficios, Vacaciones, Horarios, Departamentos)
DROP TABLE IF EXISTS Asistencia CASCADE;
DROP TABLE IF EXISTS Empleado_Beneficio CASCADE;
DROP TABLE IF EXISTS Vacación CASCADE;
DROP TABLE IF EXISTS TipoED_Horario CASCADE;
DROP TABLE IF EXISTS Orden_Reposición CASCADE;
DROP TABLE IF EXISTS TipoE_Departamento CASCADE; -- Agregada aquí, depende de Tipo_Empleado y Departamento
DROP TABLE IF EXISTS Empleado CASCADE;
DROP TABLE IF EXISTS Beneficio CASCADE;
DROP TABLE IF EXISTS Horario CASCADE;
DROP TABLE IF EXISTS Departamento CASCADE;
DROP TABLE IF EXISTS Tipo_Empleado CASCADE; -- Agregada aquí, puede tener dependencias recursivas o ser referenciada

-- 8. Tablas de Roles y Permisos
DROP TABLE IF EXISTS Rol_Permiso CASCADE;
DROP TABLE IF EXISTS Rol_Privilegio CASCADE;
DROP TABLE IF EXISTS Permiso CASCADE;
DROP TABLE IF EXISTS Privilegio CASCADE;
DROP TABLE IF EXISTS Rol CASCADE;

-- 9. Tablas de Evento y sus relaciones (Compra_Evento, Juez_Evento)
DROP TABLE IF EXISTS Entrada_Evento CASCADE; -- Agregada aquí, depende de Venta_Entrada y Evento
DROP TABLE IF EXISTS Compra_Evento CASCADE;
DROP TABLE IF EXISTS Juez_Evento CASCADE;
DROP TABLE IF EXISTS Evento CASCADE;
DROP TABLE IF EXISTS Juez CASCADE;
DROP TABLE IF EXISTS Tipo_Evento CASCADE;

-- 10. Tablas de Recetas e Ingredientes
DROP TABLE IF EXISTS Instruccion_Receta CASCADE;
DROP TABLE IF EXISTS Receta_Ingrediente CASCADE;
DROP TABLE IF EXISTS Instruccion CASCADE;
DROP TABLE IF EXISTS Receta CASCADE;
DROP TABLE IF EXISTS Ingrediente CASCADE;

-- 11. Tablas de Tiendas (Lugar_Tienda depende de Tienda_Física y Inventario)
DROP TABLE IF EXISTS Lugar_Tienda CASCADE;
DROP TABLE IF EXISTS Tienda_Física CASCADE;
DROP TABLE IF EXISTS Tienda_Online CASCADE;

-- 12. Tablas de Compra y Proveedor (Compra depende de Proveedor y TipoE_Departamento)
DROP TABLE IF EXISTS Compra CASCADE;
DROP TABLE IF EXISTS Cuota CASCADE;
DROP TABLE IF EXISTS Persona_Contacto CASCADE;
DROP TABLE IF EXISTS Proveedor CASCADE;

-- 13. Tablas de Usuario y Contacto (Usuario depende de Cliente, Empleado, Proveedor, Rol)
DROP TABLE IF EXISTS Usuario CASCADE;
DROP TABLE IF EXISTS Correo_Electrónico CASCADE;
DROP TABLE IF EXISTS Teléfono CASCADE;

-- 14. Tablas de Cliente y Persona (Cliente_Punto depende de Cliente y Punto)
DROP TABLE IF EXISTS Cliente_Punto CASCADE;
DROP TABLE IF EXISTS PersonaNatural CASCADE;
DROP TABLE IF EXISTS Jurídico CASCADE;
DROP TABLE IF EXISTS Cliente CASCADE;

-- 15. Tablas de Métodos de Pago (Cheque, Crédito, Débito, Efectivo dependen de Método_Pago)
DROP TABLE IF EXISTS Cheque CASCADE;
DROP TABLE IF EXISTS Crédito CASCADE;
DROP TABLE IF EXISTS Débito CASCADE;
DROP TABLE IF EXISTS Efectivo CASCADE;
DROP TABLE IF EXISTS Punto CASCADE;
DROP TABLE IF EXISTS Método_Pago CASCADE;

-- 16. Tablas Generales (sin dependencias o con dependencias ya eliminadas)
DROP TABLE IF EXISTS Tasa_Cambio CASCADE;
DROP TABLE IF EXISTS Descuento CASCADE;
DROP TABLE IF EXISTS Estatus CASCADE;
DROP TABLE IF EXISTS Lugar CASCADE;


--triggers

DROP FUNCTION IF EXISTS registrar_venta_tienda_fisica( p_tienda_fisica_id INTEGER,
    p_usuario_id INTEGER,
    p_fecha_hora_venta TIMESTAMP WITH TIME ZONE,
    p_productos INTEGER[], -- Array de IDs de productos
    p_cantidades INTEGER[], -- Array de cantidades de productos
    p_metodos_pago INTEGER[], -- Array de IDs de métodos de pago
    p_puntos INTEGER -- Puntos que se desean utilizar
	);


-- 1. Eliminar el trigger y la función para validar stock en compras
DROP TRIGGER IF EXISTS trigger_validar_stock ON Detalle_Compra;
DROP FUNCTION IF EXISTS validar_stock_compra();

-- 2. Eliminar el trigger y la función para actualizar estatus de compra
DROP TRIGGER IF EXISTS trigger_actualizar_estatus_compra ON Compra;
DROP FUNCTION IF EXISTS actualizar_estatus_compra();

-- 3. Eliminar el trigger y la función para verificar asistencia tarde
DROP TRIGGER IF EXISTS trigger_verificar_asistencia ON Asistencia;
DROP FUNCTION IF EXISTS verificar_asistencia_tarde();

-- 4. Eliminar el trigger y la función para validar fechas
DROP TRIGGER IF EXISTS trg_check_compra_estatus_fechas ON Compra_Estatus;
DROP TRIGGER IF EXISTS trg_check_evento_fechas ON Evento;
DROP TRIGGER IF EXISTS trg_check_ordenr_estatus_fechas ON OrdenR_Estatus;
DROP TRIGGER IF EXISTS trg_check_permiso_fechas ON Permiso;
DROP TRIGGER IF EXISTS trg_check_vacacion_fechas ON Vacación;
DROP TRIGGER IF EXISTS trg_check_vacacion_estatus_fechas ON Vacacion_Estatus;
DROP TRIGGER IF EXISTS trg_check_ventaf_estatus_fechas ON VentaF_Estatus;
DROP TRIGGER IF EXISTS trg_check_ventao_estatus_fechas ON VentaO_Estatus;
DROP FUNCTION IF EXISTS check_fechas_validas();

-- 5. Eliminar el trigger y la función para aviso de orden de reposición
DROP TRIGGER IF EXISTS trg_aviso_orden_reposicion ON Inventario;
DROP FUNCTION IF EXISTS generar_orden_reposicion_aviso();

-- 6. Eliminar la función para registrar venta en tienda física
DROP FUNCTION IF EXISTS registrar_venta_tienda_fisica();