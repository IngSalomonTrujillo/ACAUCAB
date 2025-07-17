------------------------------------------------------------------------------------------------------

--1. Trigger para Actualizar Inventario: primero tienda física, luego general
CREATE OR REPLACE FUNCTION descontar_inventario_tienda_y_general()
RETURNS TRIGGER AS $$
DECLARE
    stock_actual INTEGER;
    stock_general INTEGER;
    cantidad_faltante INTEGER;
    inventario_general_id INTEGER;
BEGIN
    -- 1. Verificar stock en la tienda física
    SELECT cantidad_presentaciones INTO stock_actual
    FROM Inventario
    WHERE inventario_id = NEW.inventario_inventario_id;

    IF stock_actual >= NEW.cantidad THEN
        -- Hay suficiente en la tienda física, solo descuenta ahí
        UPDATE Inventario
        SET cantidad_presentaciones = cantidad_presentaciones - NEW.cantidad
        WHERE inventario_id = NEW.inventario_inventario_id;
    ELSE
        -- No hay suficiente, descuenta lo que haya y el resto del general
        cantidad_faltante := NEW.cantidad - stock_actual;

        -- Poner a 0 el inventario de la tienda física
        UPDATE Inventario
        SET cantidad_presentaciones = 0
        WHERE inventario_id = NEW.inventario_inventario_id;

        -- Buscar el inventario general (ajusta la lógica si tienes un ID específico)
        SELECT inventario_id, cantidad_presentaciones INTO inventario_general_id, stock_general
        FROM Inventario
        WHERE tienda_online_tienda_online_id IS NULL
          AND inventario_id <> NEW.inventario_inventario_id
        LIMIT 1;

        IF stock_general >= cantidad_faltante THEN
            UPDATE Inventario
            SET cantidad_presentaciones = cantidad_presentaciones - cantidad_faltante
            WHERE inventario_id = inventario_general_id;
        ELSE
            RAISE EXCEPTION 'No hay suficiente stock ni en tienda física ni en el inventario general';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para ventas físicas que actualiza el inventario (primero tienda física, luego general)
DROP TRIGGER IF EXISTS trigger_actualizar_inventario_fisica ON Detalle_Física;
CREATE TRIGGER trigger_actualizar_inventario_fisica
AFTER INSERT OR UPDATE ON Detalle_Física
FOR EACH ROW EXECUTE FUNCTION descontar_inventario_tienda_y_general();

-- Trigger para ventas online (si se usa en el futuro)
DROP TRIGGER IF EXISTS trigger_actualizar_inventario_online ON Detalle_Online;
CREATE TRIGGER trigger_actualizar_inventario_online
AFTER INSERT OR UPDATE ON Detalle_Online
FOR EACH ROW EXECUTE FUNCTION descontar_inventario_tienda_y_general();

------------------------------------------------------------------------------------------------------

--2. Trigger para Actualizar Inventario de Eventos (mantener el original para eventos)
CREATE OR REPLACE FUNCTION actualizar_inventario_eventos()
RETURNS TRIGGER AS $$
BEGIN
    -- Reducir la cantidad en el inventario de eventos después de una venta
    UPDATE Inventario_E_Cerveza_P
    SET cantidad = cantidad - NEW.cantidad_cerveza
    WHERE Cerveza_Presentacion_Cerveza_cerveza_id = NEW.Inventario_E_Cerveza_P_cerveza_id
      AND Cerveza_Presentacion_Presentación_presentación_id = NEW.Inventario_E_Cerveza_P_presentación_id
      AND Evento_evento_id = NEW.Inventario_E_Cerveza_P_evento_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para ventas de eventos
CREATE TRIGGER trigger_actualizar_inventario_eventos
AFTER INSERT OR UPDATE ON Detalle_Evento
FOR EACH ROW EXECUTE FUNCTION actualizar_inventario_eventos();

------------------------------------------------------------------------------------------------------

--3. Trigger para Controlar Puntos de Cliente
CREATE OR REPLACE FUNCTION actualizar_puntos_cliente()
RETURNS TRIGGER AS $$
BEGIN
    -- Aumentar los puntos del cliente basado en el monto pagado
    UPDATE Cliente_Punto
    SET cantidad_puntos = cantidad_puntos + (NEW.monto_pagado / 100)  -- Ejemplo: 1 punto por cada 100 Bs
    WHERE Cliente_RIF = NEW.Cliente_RIF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_puntos
AFTER INSERT ON Pago_Fisica
FOR EACH ROW EXECUTE FUNCTION actualizar_puntos_cliente();

CREATE TRIGGER trigger_actualizar_puntos_online
AFTER INSERT ON Pago_Online
FOR EACH ROW EXECUTE FUNCTION actualizar_puntos_cliente();
------------------------------------------------------------------------------------------------------

-- 4. Trigger para Validar Stock en Compras (actualizado para inventario general)
CREATE OR REPLACE FUNCTION validar_stock_compra()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar que haya suficiente stock antes de permitir la compra
    IF (SELECT cantidad_presentaciones FROM Inventario
        WHERE Cerveza_Presentacion_Cerveza_cerveza_id = NEW.Cerveza_Presentacion_Cerveza_cerveza_id
          AND Cerveza_Presentacion_Presentación_presentación_id = NEW.Cerveza_Presentacion_Presentación_presentación_id) < NEW.cantidad THEN
        RAISE EXCEPTION 'No hay suficiente stock para la compra';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_stock
BEFORE INSERT ON Detalle_Compra
FOR EACH ROW EXECUTE FUNCTION validar_stock_compra();

------------------------------------------------------------------------------------------------------

--5. Trigger para Actualizar Estatus de Compra
CREATE OR REPLACE FUNCTION actualizar_estatus_compra()
RETURNS TRIGGER AS $$
BEGIN
    -- Establecer el estatus de la compra a "Pendiente" al crear una nueva compra
    INSERT INTO Compra_Estatus (fecha_inicio, Estatus_estatus_id, Compra_proveedor_id, Compra_compra_id)
    VALUES (CURRENT_DATE, 1, NEW.Proveedor_proveedor_id, NEW.compra_id);  -- 1 es el ID de "Pendiente"

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_estatus_compra
AFTER INSERT ON Compra
FOR EACH ROW EXECUTE FUNCTION actualizar_estatus_compra();
------------------------------------------------------------------------------------------------------
--6. Trigger para Registro de Asistencia
CREATE OR REPLACE FUNCTION verificar_asistencia_tarde()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si la hora de entrada registrada es posterior a la hora de entrada esperada
    IF NEW.hora_entrada_registrada > (SELECT hora_entrada_esperada FROM Horario WHERE dias_semana = TO_CHAR(NEW.fecha, 'Day')) THEN
        RAISE NOTICE 'El empleado % llegó tarde', NEW.Empleado_empleado_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verificar_asistencia
AFTER INSERT ON Asistencia
FOR EACH ROW EXECUTE FUNCTION verificar_asistencia_tarde();
------------------------------------------------------------------------------------------------------

--7. Validar Fechas
CREATE OR REPLACE FUNCTION check_fechas_validas()
RETURNS TRIGGER AS $$
BEGIN
    -- Si fecha_fin no es NULL y es menor que fecha_inicio, lanzar un error
    IF NEW.fecha_fin IS NOT NULL AND NEW.fecha_fin < NEW.fecha_inicio THEN
        RAISE EXCEPTION 'La fecha final (%) no puede ser menor que la fecha inicial (%)', NEW.fecha_fin, NEW.fecha_inicio;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--7.1. Trigger para Compra_Estatus
CREATE TRIGGER trg_check_compra_estatus_fechas
BEFORE INSERT OR UPDATE ON Compra_Estatus
FOR EACH ROW EXECUTE FUNCTION check_fechas_validas();
--7.2. Trigger para Evento
CREATE TRIGGER trg_check_evento_fechas
BEFORE INSERT OR UPDATE ON Evento
FOR EACH ROW EXECUTE FUNCTION check_fechas_validas();

--7.3. Trigger para OrdenR_Estatus
CREATE TRIGGER trg_check_ordenr_estatus_fechas
BEFORE INSERT OR UPDATE ON OrdenR_Estatus
FOR EACH ROW EXECUTE FUNCTION check_fechas_validas();

--7.4. Trigger para Permiso
CREATE TRIGGER trg_check_permiso_fechas
BEFORE INSERT OR UPDATE ON Permiso
FOR EACH ROW EXECUTE FUNCTION check_fechas_validas();

--7.5. Trigger para Vacación
CREATE TRIGGER trg_check_vacacion_fechas
BEFORE INSERT OR UPDATE ON Vacación
FOR EACH ROW EXECUTE FUNCTION check_fechas_validas();

--7.6. Trigger para Vacacion_Estatus
CREATE TRIGGER trg_check_vacacion_estatus_fechas
BEFORE INSERT OR UPDATE ON Vacacion_Estatus
FOR EACH ROW EXECUTE FUNCTION check_fechas_validas();
--7.7. Trigger para VentaF_Estatus
CREATE TRIGGER trg_check_ventaf_estatus_fechas
BEFORE INSERT OR UPDATE ON VentaF_Estatus
FOR EACH ROW EXECUTE FUNCTION check_fechas_validas();
--7.8. Trigger para VentaO_Estatus
CREATE TRIGGER trg_check_ventao_estatus_fechas
BEFORE INSERT OR UPDATE ON VentaO_Estatus
FOR EACH ROW EXECUTE FUNCTION check_fechas_validas();
------------------------------------------------------------------------------------------------------
 --8. Trigger para Aviso de Orden de Reposición
-- Función para el trigger de orden de reposición
CREATE OR REPLACE FUNCTION generar_orden_reposicion_aviso()
RETURNS TRIGGER AS $$
DECLARE
    v_proveedor_id INTEGER;
    v_tipo_empleado_id INTEGER := 3; -- ID del Tipo_Empleado (Gerente de Compras)
    v_departamento_id INTEGER := 13; -- ID del Departamento (Compras)
    v_empleado_id INTEGER := 3;     -- ID del Empleado (Pedro Gómez, Gerente de Compras)
    v_tienda_fisica_id INTEGER;
BEGIN
    -- Solo actuar si la cantidad actual es <= 100 y la cantidad anterior era > 100
    -- Esto evita generar múltiples órdenes si la cantidad se mantiene por debajo de 100
    IF NEW.cantidad_presentaciones <= 100 AND OLD.cantidad_presentaciones > 100 THEN
        -- Obtener el proveedor_id asociado a esta cerveza y presentación
        SELECT tc.Proveedor_proveedor_id
        INTO v_proveedor_id
        FROM Cerveza_Presentacion cp
        JOIN Cerveza c ON cp.Cerveza_cerveza_id = c.cerveza_id
        JOIN Tipo_Cerveza tc ON c.Tipo_Cerveza_tipo_cerveza_id = tc.tipo_cerveza_id
        WHERE cp.Cerveza_cerveza_id = NEW.Cerveza_Presentacion_Cerveza_cerveza_id
          AND cp.Presentación_presentación_id = NEW.Cerveza_Presentacion_Presentación_presentación_id;

        -- Determinar la tienda física asociada al inventario (si aplica)
        -- Si el inventario es de una tienda online, no se genera orden de reposición para tienda física
        -- Si el inventario es físico (Tienda_Online_tienda_online_id IS NULL), asumimos que es para una tienda física
        -- Para este ejemplo, asumiremos que el inventario físico (Tienda_Online_tienda_online_id IS NULL)
        -- corresponde a la tienda física con ID 1 (ACAUCAB Principal) o se puede buscar dinámicamente.
        -- Si NEW.Tienda_Online_tienda_online_id IS NULL, significa que es inventario físico.
        -- En un sistema real, Inventario debería tener una FK a Tienda_Física o Lugar_Tienda.
        -- Para este ejemplo, si es inventario físico, asignamos a la tienda_fisica_id 1.
        IF NEW.Tienda_Online_tienda_online_id IS NULL THEN
            -- Buscar la tienda física que maneja este inventario físico.
            -- Esto es una simplificación. En un diseño más robusto, Inventario debería tener una FK a Tienda_Física.
            -- Por ahora, si es inventario físico, lo asociamos a la primera tienda física.
            SELECT tienda_fisica_id INTO v_tienda_fisica_id FROM Tienda_Física LIMIT 1;
        ELSE
            -- Si es inventario de tienda online, no generamos orden de reposición física con esta lógica.
            -- Podrías RAISE NOTICE o simplemente RETURN NEW si no aplica.
            RETURN NEW;
        END IF;

        -- Insertar la nueva orden de reposición
        INSERT INTO Orden_Reposición (
            Tienda_Física_tienda_fisica_id,
            fecha_hora_generación,
            cantidad_a_reponer,
            TipoE_Departamento_tipo_empleado_id,
            TipoE_Departamento_departamento_id,
            TipoE_Departamento_empleado_id
        ) VALUES (
            v_tienda_fisica_id,
            NOW(), -- Fecha y hora actual
            10000, -- Cantidad a reponer según el PDF
            v_tipo_empleado_id,
            v_departamento_id,
            v_empleado_id
        );

        RAISE NOTICE 'Orden de reposición generada para cerveza_id % y presentación_id % del proveedor %',
                     NEW.Cerveza_Presentacion_Cerveza_cerveza_id,
                     NEW.Cerveza_Presentacion_Presentación_presentación_id,
                     v_proveedor_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que se activa después de actualizar la cantidad en Inventario
CREATE TRIGGER trg_aviso_orden_reposicion
AFTER UPDATE ON Inventario
FOR EACH ROW EXECUTE FUNCTION generar_orden_reposicion_aviso();
------------------------------------------------------------------------------------------------------




CREATE OR REPLACE procedure registrar_venta_tienda_online(
    p_tienda_online_id INTEGER,
    p_usuario_Rif INTEGER,
    p_fecha_hora_venta TIMESTAMP WITH TIME ZONE,
    p_productos INTEGER[], -- Array de IDs de productos
    p_cantidades INTEGER[], -- Array de cantidades de productos
    p_metodos_pago INTEGER[], -- Array de IDs de métodos de pago
    p_puntos INTEGER, -- Puntos que se desean utilizar
	p_cantidad_pagada_metodo INTEGER[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_venta_id INTEGER;
    v_total DECIMAL := 0;
	v_valor_total_pagado DECIMAL := 0;
    v_stock_actual INTEGER;
    v_precio_unitario DECIMAL;
    v_puntos_disponibles INTEGER;
	v_usuario_id INTEGER;
	v_puntos_ganados INTEGER := 0;
BEGIN
    -- Verificar puntos disponibles
    SELECT cantidad_puntos INTO v_puntos_disponibles
    FROM Cliente_Punto
    WHERE Cliente_RIF = p_usuario_rif
    LIMIT 1;

    IF v_puntos_disponibles < p_puntos THEN
        RAISE EXCEPTION 'No hay suficientes puntos para realizar la venta';
    END IF;

    -- Calcular el monto total de la venta
    FOR i IN 1..array_length(p_productos, 1) LOOP
        -- Verificar stock en el inventario
        SELECT cantidad_presentaciones INTO v_stock_actual
        FROM Inventario
        WHERE Cerveza_Presentacion_Cerveza_cerveza_id = p_productos[i] 
          AND tienda_online_tienda_online_id = p_tienda_online_id
          LIMIT 1;

        IF v_stock_actual < p_cantidades[i] THEN
            RAISE EXCEPTION 'No hay suficiente stock para la cerveza con ID %', p_productos[i];
        END IF;

        -- Obtener el precio unitario de la cerveza
        SELECT precio_unitario INTO v_precio_unitario
        FROM Cerveza_Presentacion
        WHERE Presentación_presentación_id = p_productos[i]
        LIMIT 1;

        -- Calcular el total
		v_valor_total_pagado := v_valor_total_pagado + p_cantidad_pagada_metodo[i];
        v_total := v_total + (v_precio_unitario * p_cantidades[i]);
    END LOOP;
		v_valor_total_pagado := v_valor_total_pagado + p_puntos;
	if v_valor_total_pagado != v_total then 
  		RAISE EXCEPTION 'No se pago el valor de la compra';
  	end if;
	  SELECT usuario_id INTO v_usuario_id
        FROM usuario
        WHERE cliente_rif = p_usuario_rif
		limit 1;
		
		 IF v_usuario_id = NULL THEN
        RAISE EXCEPTION 'No existe el cliente con ese rif';
    END IF;

    -- Registrar la venta en la tabla Venta_online
    INSERT INTO Venta_online (tienda_online_tienda_online_id, Usuario_usuario_id, fecha_hora_venta, monto_total)
    VALUES ( p_tienda_online_id,v_usuario_id, p_fecha_hora_venta, v_total)
    RETURNING venta_id INTO v_venta_id;

RAISE NOTICE 'Venta registrada con el id: %', v_venta_id;

    -- Registrar los detalles de la venta
    FOR i IN 1..array_length(p_productos, 1) LOOP
        -- Descontar del inventario
        UPDATE Inventario
        SET cantidad_presentaciones = cantidad_presentaciones - p_cantidades[i]
        WHERE Cerveza_Presentacion_Cerveza_cerveza_id = p_productos[i]
          AND tienda_online_tienda_online_id  = p_tienda_online_id;
RAISE NOTICE 'actualize el inventario del producto %',p_productos[i];
        -- Insertar detalle de la venta

		 -- Obtener el precio unitario de la cerveza
        SELECT precio_unitario INTO v_precio_unitario
        FROM Cerveza_Presentacion
        WHERE Presentación_presentación_id = p_productos[i]
        LIMIT 1; 
		
        INSERT INTO Detalle_online (venta_online_id, precio_unitario, cantidad, venta_online_tienda_online_id, venta_online_usuario_id, Tasa_Cambio_tasa_cambio_id, Inventario_inventario_id)
        VALUES (v_venta_id, v_precio_unitario, p_cantidades[i], p_tienda_online_id, v_usuario_id, 1, p_productos[i]); -- Asumiendo tasa de cambio 1
    RAISE NOTICE 'inserte detalle x ';
	END LOOP;


      -- Registrar el pago
    FOR i IN 1..array_length(p_metodos_pago, 1) LOOP
        INSERT INTO Pago_online (venta_online_id, fecha_pago, monto_pagado, referencia_pago, venta_online_tienda_online_id, venta_online_usuario_id, Método_Pago_método_pago_id, puntos_usados)
        VALUES (v_venta_id, p_fecha_hora_venta::DATE, p_cantidad_pagada_metodo[i], 'PAG - 0' || v_venta_id, p_tienda_online_id, v_usuario_id, p_metodos_pago[i], p_puntos ); -- Dividir el total entre el número de métodos de pago
    END LOOP;



EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error al registrar la venta: %', SQLERRM;
END;
$$;


-- Como se llama el procedimiento
--CALL registrar_venta_tienda_online(
    --1,  -- ID de la tienda física
    --123456789,  -- ID del usuario (cliente)
    --'2025-09-07 00:49:00',  -- Fecha y hora de la venta
    --ARRAY[1, 2],  -- IDs de productos (Destilo Amber y Benitz Pale Ale)
    --ARRAY[22, 11],  -- Cantidades de productos (5 unidades de Destilo Amber y 3 unidades de Benitz Pale Ale)
    --ARRAY[1, 2],  -- Métodos de pago (IDs 1 y 2)
    --10,  -- Puntos a utilizar
    --ARRAY[60, 40]
--);


-- #############################################################################
-- # 2. PROCEDIMIENTO CON LA LÓGICA PARA SER LLAMADO POR EL TRIGGER
-- #############################################################################
CREATE OR REPLACE PROCEDURE P_actualizar_venta_estatus(
    p_venta_id INTEGER,
    p_tienda_id INTEGER,
    p_usuario_id INTEGER,
    p_fecha_venta TIMESTAMP WITH TIME ZONE
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Este procedimiento contiene la lógica de inserción en VentaF_Estatus.
    INSERT INTO Ventao_Estatus(
        venta_online_id,
        venta_online_tienda_online_tienda_online_id,
        venta_online_usuario_usuario_id,
        estatus_estatus_id,
        fecha_inicio,
        fecha_fin
    )
    VALUES(
        p_venta_id,
        p_tienda_id,
        p_usuario_id,
        1, -- Se asume que 1 es el ID para el estatus 'Registrada' o similar.
        p_fecha_venta::DATE,
        NULL
    );
END;
$$;


-- #############################################################################
-- # 3. FUNCIÓN INTERMEDIARIA PARA EL TRIGGER
-- #############################################################################
CREATE OR REPLACE FUNCTION F_trigger_venta_online_estatus()
RETURNS TRIGGER AS $$
BEGIN
    -- Esta función solo sirve como puente para llamar al procedimiento,
    -- pasando los datos de la fila recién insertada (NEW).
    CALL P_actualizar_venta_estatus(
        NEW.venta_id,
        NEW.tienda_online_tienda_online_id,
        NEW.Usuario_usuario_id,
        NEW.fecha_hora_venta
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- #############################################################################
-- # 4. CREACIÓN DEL TRIGGER
-- #############################################################################
-- Se elimina el trigger si ya existe para poder ejecutar el script varias veces.
DROP TRIGGER IF EXISTS T_after_insert_venta_online ON Venta_online;

-- Se crea el trigger que se dispara DESPUÉS de una inserción en Venta_Física.
CREATE TRIGGER T_after_insert_venta_online
AFTER INSERT ON Venta_online
FOR EACH ROW -- Se ejecuta para cada fila insertada.
EXECUTE FUNCTION F_trigger_venta_online_estatus();






-- #  Orden de reposicion 
-- #############################################################################
-- # PASO 1: MODIFICAR LAS TABLAS PARA SOPORTAR TIENDAS ONLINE
-- #############################################################################

-- Primero, agregamos la capacidad a la tabla de órdenes de vincularse a una tienda online.
ALTER TABLE Orden_Reposición ADD COLUMN IF NOT EXISTS tienda_online_id INTEGER;

ALTER TABLE Orden_Reposición 
ADD CONSTRAINT fk_orden_tienda_online 
FOREIGN KEY (tienda_online_id) REFERENCES Tienda_Online(tienda_online_id);

-- Hacemos que la referencia a tienda física sea opcional (nullable)
ALTER TABLE Orden_Reposición ALTER COLUMN Tienda_Física_tienda_fisica_id DROP NOT NULL;

-- Segundo, hacemos lo mismo para la tabla que vincula el inventario con la orden.
ALTER TABLE Inventario_Orden_Reposicion ADD COLUMN IF NOT EXISTS tienda_online_id INTEGER;
ALTER TABLE Inventario_Orden_Reposicion ALTER COLUMN tienda_fisica_id DROP NOT NULL;


-- #############################################################################
-- # PASO 2: CREAR LA NUEVA FUNCIÓN DE TRIGGER UNIFICADA
-- #############################################################################

CREATE OR REPLACE FUNCTION F_generar_orden_reposicion_unificada()
RETURNS TRIGGER AS $$
DECLARE
    v_orden_id INTEGER;
    v_cantidad_reponer INTEGER := 400; -- Cantidad fija a reponer. Puedes ajustar este valor.
    v_estatus_pendiente_id INTEGER := 1; -- ID del estatus 'Pendiente'.
    
    -- Datos del empleado que genera la orden (Departamento de Compras)
    v_empleado_id INTEGER := 3;
    v_departamento_id INTEGER := 13;
    v_tipo_empleado_id INTEGER := 3;

BEGIN
    RAISE NOTICE '[TRIGGER] Actualización en inventario ID: %. Cantidad anterior: %, Cantidad nueva: %.', NEW.inventario_id, OLD.cantidad_presentaciones, NEW.cantidad_presentaciones;

    -- La condición principal no cambia: se activa al cruzar el umbral de 100.
    IF NEW.cantidad_presentaciones <= 100 AND OLD.cantidad_presentaciones > 100 THEN
        
        RAISE NOTICE '[TRIGGER] ¡Condición de stock bajo cumplida! Generando orden de reposición.';

        -- Paso 2.1: Insertar la nueva orden de reposición.
        -- Ahora es inteligente: guarda el ID de la tienda física O de la online, según corresponda.
        INSERT INTO Orden_Reposición (
            Tienda_Física_tienda_fisica_id,
            tienda_online_id, -- Nueva columna
            fecha_hora_generación,
            cantidad_a_reponer,
            fecha_hora_completada,
            TipoE_Departamento_tipo_empleado_id,
            TipoE_Departamento_departamento_id,
            TipoE_Departamento_empleado_id
        )
        VALUES (
            NEW.tienda_física_tienda_fisica_id, -- Será NULL si es tienda online
            NEW.tienda_online_tienda_online_id, -- Será NULL si es tienda física
            NOW(),
            v_cantidad_reponer,
            NULL,
            v_tipo_empleado_id,
            v_departamento_id,
            v_empleado_id
        )
        RETURNING orden_reposición_id INTO v_orden_id;

        RAISE NOTICE '[TRIGGER] Orden de reposición N° % creada.', v_orden_id;

        -- Paso 2.2: Insertar el estatus inicial ('Pendiente') para la orden.
        INSERT INTO OrdenR_Estatus (
            Orden_Reposición_orden_reposición_id, Estatus_estatus_id, fecha_inicio, fecha_fin
        ) VALUES (
            v_orden_id, v_estatus_pendiente_id, NOW(), NULL
        );

        RAISE NOTICE '[TRIGGER] Estatus ''Pendiente'' registrado para la orden N° %.', v_orden_id;
        
        -- Paso 2.3: Vincular el item del inventario con la orden en la tabla intermedia.
        -- También es inteligente y guarda el ID de la tienda correcta.
        INSERT INTO Inventario_Orden_Reposicion(
            inventario_id,
            orden_reposición_id,
            tienda_fisica_id,
            tienda_online_id, -- Nueva columna
            cerveza_id,
            presentacion_id,
            cantidad
        ) VALUES (
            NEW.inventario_id,
            v_orden_id,
            NEW.tienda_física_tienda_fisica_id,
            NEW.tienda_online_tienda_online_id,
            NEW.Cerveza_Presentacion_Cerveza_cerveza_id,
            NEW.Cerveza_Presentacion_Presentación_presentación_id,
            v_cantidad_reponer
        );
        
        RAISE NOTICE '[TRIGGER] Vínculo creado entre inventario ID % y orden N° %.', NEW.inventario_id, v_orden_id;

    ELSE
        RAISE NOTICE '[TRIGGER] La condición de stock bajo no se cumplió. No se genera orden.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- #############################################################################
-- # PASO 3: RECREAR EL TRIGGER PARA QUE USE LA NUEVA FUNCIÓN
-- #############################################################################

-- Se elimina el trigger anterior si existe.
DROP TRIGGER IF EXISTS T_control_stock_reposicion ON Inventario;

-- Se crea el nuevo trigger que apunta a la función unificada.
CREATE TRIGGER T_control_stock_reposicion
AFTER UPDATE ON Inventario
FOR EACH ROW
EXECUTE FUNCTION F_generar_orden_reposicion_unificada();

-- #############################################################################
-- # PASO 4: SINCRONIZAR LA SECUENCIA DE LA LLAVE PRIMARIA (SOLUCIÓN AL ERROR)
-- #############################################################################
-- NOTA: Este paso es crucial porque los datos de ejemplo insertan manualmente
-- los IDs, lo que desincroniza el contador automático (la secuencia).
-- Este comando ajusta el contador al valor máximo actual en la tabla,
-- evitando errores de "llave duplicada" en futuras inserciones automáticas.
SELECT setval(
    pg_get_serial_sequence('orden_reposición', 'orden_reposición_id'),
    (SELECT MAX(orden_reposición_id) FROM Orden_Reposición)
);



-- PROCEDIMIENTO PARA CAMBIAR EL ESTATUS DE LA ORDEN DE REPOSICION
CREATE OR REPLACE PROCEDURE P_actualizar_estado_orden_reposicion(
    p_orden_reposicion_id INTEGER,
    p_nueva_cantidad INTEGER,
    p_nuevo_estatus_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_inventario_orden_rec RECORD;
    v_orden_rec RECORD;
BEGIN
    -- PASO 1: Validar que la orden de reposición exista.
    SELECT * INTO v_orden_rec
    FROM Orden_Reposición
    WHERE orden_reposición_id = p_orden_reposicion_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La orden de reposición con ID % no existe.', p_orden_reposicion_id;
    END IF;

    -- PASO 2: Cerrar el estatus actual de la orden poniendo la fecha de fin.
    -- Esto asegura que solo haya un estatus activo a la vez.
    UPDATE OrdenR_Estatus
    SET fecha_fin = NOW()
    WHERE Orden_Reposición_orden_reposición_id = p_orden_reposicion_id
      AND fecha_fin IS NULL;

    -- PASO 3: Lógica condicional basada en el nuevo estatus.

    -- ESTATUS 2: 'En Proceso' o 'Aprobado'
    IF p_nuevo_estatus_id = 2 THEN
        RAISE NOTICE 'Procesando orden % con estatus 2 (En Proceso).', p_orden_reposicion_id;

        -- Si se proporciona una nueva cantidad (diferente de 0), se actualizan las tablas.
        IF p_nueva_cantidad > 0 THEN
            UPDATE Orden_Reposición
            SET cantidad_a_reponer = p_nueva_cantidad
            WHERE orden_reposición_id = p_orden_reposicion_id;

            UPDATE Inventario_Orden_Reposicion
            SET cantidad = p_nueva_cantidad
            WHERE orden_reposición_id = p_orden_reposicion_id;

            RAISE NOTICE 'Cantidad de la orden % actualizada a %.', p_orden_reposicion_id, p_nueva_cantidad;
        ELSE
            RAISE NOTICE 'No se especificó una nueva cantidad. La cantidad de la orden no se modifica.';
        END IF;

        -- Insertar el nuevo estatus 'En Proceso', dejándolo activo (fecha_fin es NULL).
        INSERT INTO OrdenR_Estatus (Orden_Reposición_orden_reposición_id, Estatus_estatus_id, fecha_inicio, fecha_fin)
        VALUES (p_orden_reposicion_id, p_nuevo_estatus_id, NOW(), NULL);

    -- ESTATUS 3: 'Completado'
    ELSIF p_nuevo_estatus_id = 3 THEN
        RAISE NOTICE 'Procesando orden % con estatus 3 (Completado).', p_orden_reposicion_id;

        -- Obtener los detalles del inventario y la cantidad desde la tabla de relación.
        SELECT inventario_id, cantidad
        INTO v_inventario_orden_rec
        FROM Inventario_Orden_Reposicion
        WHERE orden_reposición_id = p_orden_reposicion_id;

        -- Incrementar el stock en la tabla de Inventario.
        UPDATE Inventario
        SET cantidad_presentaciones = cantidad_presentaciones + v_inventario_orden_rec.cantidad
        WHERE inventario_id = v_inventario_orden_rec.inventario_id;

        RAISE NOTICE 'Se agregaron % unidades al inventario ID %.', v_inventario_orden_rec.cantidad, v_inventario_orden_rec.inventario_id;

        -- Insertar el nuevo estatus 'Completado' y cerrarlo inmediatamente (es un estado final).
        INSERT INTO OrdenR_Estatus (Orden_Reposición_orden_reposición_id, Estatus_estatus_id, fecha_inicio, fecha_fin)
        VALUES (p_orden_reposicion_id, p_nuevo_estatus_id, NOW(), NOW());
        
        -- También se actualiza la fecha de completado en la tabla principal de la orden.
        UPDATE Orden_Reposición
        SET fecha_hora_completada = NOW()
        WHERE orden_reposición_id = p_orden_reposicion_id;

    -- ESTATUS 4 o 5: 'Cancelado' o 'Rechazado'
    ELSIF p_nuevo_estatus_id IN (4, 5) THEN
        RAISE NOTICE 'Procesando orden % con estatus % (Estado Final).', p_orden_reposicion_id, p_nuevo_estatus_id;

        -- Insertar el nuevo estatus y cerrarlo inmediatamente, ya que son estados finales.
        INSERT INTO OrdenR_Estatus (Orden_Reposición_orden_reposición_id, Estatus_estatus_id, fecha_inicio, fecha_fin)
        VALUES (p_orden_reposicion_id, p_nuevo_estatus_id, NOW(), NOW());

    ELSE
        -- Si el ID de estatus no es válido, se lanza un error.
        RAISE EXCEPTION 'El estatus ID % no es válido. Los valores permitidos son 2, 3, 4, 5.', p_nuevo_estatus_id;
    END IF;

    RAISE NOTICE 'La orden % ha sido actualizada exitosamente al estatus %.', p_orden_reposicion_id, p_nuevo_estatus_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocurrió un error inesperado al actualizar la orden: %', SQLERRM;
        RAISE; -- Re-lanza la excepción para detener la transacción.
END;
$$;

--CALL P_actualizar_estado_orden_reposicion(
    --p_orden_reposicion_id => 11,
    --p_nueva_cantidad => 400, -- Nueva cantidad deseada
   -- p_nuevo_estatus_id => 2 -- 2 para cambiar el estatus a (en proceso) 
--);
--CALL P_actualizar_estado_orden_reposicion(
    --p_orden_reposicion_id => 11,
   -- p_nueva_cantidad => 0, -- 0 para no cambiar la cantidad
   -- p_nuevo_estatus_id => 2 -- 2 para cambiar el estatus a (en proceso) 
--);

--CALL P_actualizar_estado_orden_reposicion(
    --p_orden_reposicion_id => 1,
    --p_nueva_cantidad => 0, -- Se ignora para el estatus 3
    --p_nuevo_estatus_id => 3 -- 3 para cambiar el estatus a (completado), tambien inserta en el inventario
--);



-- ACTUALIZAR EL ESTATUS DE VENTAO_ESTATUS 
CREATE OR REPLACE PROCEDURE P_actualizar_venta_online_estatus(
    p_venta_online_id INTEGER,
    p_nuevo_estatus_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- PASO 1: Validar que el nuevo estatus sea uno de los permitidos para esta operación.
    IF p_nuevo_estatus_id NOT IN (2, 3, 4, 5) THEN
        RAISE EXCEPTION 'El estatus ID % no es válido. Los valores permitidos son 2, 3, 4, 5.', p_nuevo_estatus_id;
    END IF;

    -- PASO 2: Actualizar directamente el registro de estatus existente.
    -- La lógica para la fecha_fin se maneja con una expresión CASE.
    UPDATE VentaO_Estatus
    SET
        estatus_estatus_id = p_nuevo_estatus_id,
        -- Se actualiza la fecha de inicio para reflejar cuándo comenzó el *nuevo* estado.
        fecha_inicio = NOW(),
        -- Si el nuevo estado es final (Completado, Cancelado, etc.), se registra la fecha de fin.
        -- Si es un estado intermedio (En Proceso), la fecha de fin se deja en NULL.
        fecha_fin = CASE
                        WHEN p_nuevo_estatus_id IN (3, 4, 5) THEN NOW()
                        ELSE NULL
                    END
    WHERE venta_online_id = p_venta_online_id;

    -- PASO 3: Verificar que la actualización se haya realizado.
    -- GET DIAGNOSTICS obtiene información sobre la última consulta ejecutada.
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;

    IF v_rows_affected = 0 THEN
        -- Si no se actualizó ninguna fila, significa que no existía un registro para esa venta.
        RAISE EXCEPTION 'No se encontró un registro de estatus para la venta online con ID %.', p_venta_online_id;
    END IF;

    RAISE NOTICE 'El estatus de la venta online % fue actualizado a %.', p_venta_online_id, p_nuevo_estatus_id;

EXCEPTION
    WHEN OTHERS THEN
        -- Captura cualquier otro error y lo muestra.
        RAISE NOTICE 'Ocurrió un error al actualizar el estatus de la venta: %', SQLERRM;
        RAISE;
END;
$$;

-- ASUMIENDO QUE LA VENTA 1 EXISTE Y TIENE EL ESTATUS 1 (REGISTRADA)

-- 1. Mover la venta al estado "En Proceso" (ID 2)
-- La fila en VentaO_Estatus se actualizará a estatus_id = 2 y fecha_fin = NULL.

--CALL P_actualizar_venta_online_estatus(
    --p_venta_online_id => 18,
  --  p_nuevo_estatus_id => 2
--);

-- 2. Mover la venta al estado "Completado" (ID 3)
-- La misma fila ahora se actualizará a estatus_id = 3 y fecha_fin se establecerá a la hora actual.
--CALL P_actualizar_venta_online_estatus(
  --  p_venta_online_id => 19,
    --p_nuevo_estatus_id => 3
--);