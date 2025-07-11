
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
 CREATE OR REPLACE FUNCTION registrar_venta_tienda_fisica(
    p_tienda_fisica_id INTEGER,
    p_usuario_Rif INTEGER,
    p_fecha_hora_venta TIMESTAMP WITH TIME ZONE,
    p_productos INTEGER[], -- Array de IDs de productos
    p_cantidades INTEGER[], -- Array de cantidades de productos
    p_metodos_pago INTEGER[], -- Array de IDs de métodos de pago
    p_puntos INTEGER -- Puntos que se desean utilizar
) RETURNS VOID AS $$
DECLARE
    v_venta_id INTEGER;
    v_total DECIMAL := 0;
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
          AND tienda_física_tienda_fisica_id = p_tienda_fisica_id
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
        v_total := v_total + (v_precio_unitario * p_cantidades[i]);
    END LOOP;

	  SELECT usuario_id INTO v_usuario_id
        FROM usuario
        WHERE cliente_rif = p_usuario_rif
		limit 1;
		
		 IF v_usuario_id = NULL THEN
        RAISE EXCEPTION 'No existe el cliente con ese rif';
    END IF;

    -- Registrar la venta en la tabla Venta_Física
    INSERT INTO Venta_Física (Tienda_Física_tienda_fisica_id, Usuario_usuario_id, fecha_hora_venta, monto_total)
    VALUES (p_tienda_fisica_id,v_usuario_id, p_fecha_hora_venta, v_total)
    RETURNING venta_id INTO v_venta_id;
	
RAISE NOTICE 'Venta registrada con el id: %', v_venta_id;

    -- Registrar los detalles de la venta
    FOR i IN 1..array_length(p_productos, 1) LOOP
        -- Descontar del inventario
        UPDATE Inventario
        SET cantidad_presentaciones = cantidad_presentaciones - p_cantidades[i]
        WHERE Cerveza_Presentacion_Cerveza_cerveza_id = p_productos[i]
          AND tienda_física_tienda_fisica_id = p_tienda_fisica_id;
RAISE NOTICE 'actualize el inventario del producto %',p_productos[i];
        -- Insertar detalle de la venta

		 -- Obtener el precio unitario de la cerveza
        SELECT precio_unitario INTO v_precio_unitario
        FROM Cerveza_Presentacion
        WHERE Presentación_presentación_id = p_productos[i]
        LIMIT 1; 
		
        INSERT INTO Detalle_Física (venta_fisica_id, precio_unitario, cantidad, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id, Tasa_Cambio_tasa_cambio_id, Inventario_inventario_id)
        VALUES (v_venta_id, v_precio_unitario, p_cantidades[i], p_tienda_fisica_id, v_usuario_id, 1, p_productos[i]); -- Asumiendo tasa de cambio 1
    RAISE NOTICE 'inserte detalle x ';
	END LOOP;


      -- Registrar el pago
    FOR i IN 1..array_length(p_metodos_pago, 1) LOOP
        INSERT INTO Pago_Fisica (venta_fisica_id, fecha_pago, monto_pagado, referencia_pago, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id, Método_Pago_método_pago_id)
        VALUES (v_venta_id, p_fecha_hora_venta::DATE, v_total / array_length(p_metodos_pago, 1), 'PAG - 0' || v_venta_id, p_tienda_fisica_id, v_usuario_id, p_metodos_pago[i]); -- Dividir el total entre el número de métodos de pago
    END LOOP;

     -- Actualizar puntos del cliente
	   -- Calcular los puntos ganados (por ejemplo, 1 punto por cada 100 unidades monetarias gastadas)
    v_puntos_ganados := FLOOR(v_total / 100) - p_puntos; -- Ajusta la lógica según tus necesidades
    UPDATE Cliente_Punto
    SET cantidad_puntos = cantidad_puntos + v_puntos_ganados - p_puntos 
    WHERE Cliente_RIF = p_usuario_rif;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error al registrar la venta: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
--probada
------------------------------------------------------------------------------------------------------
-- Ejecutar la función
--SELECT registrar_venta_tienda_fisica(
    --1,  -- ID de la tienda física
    --123456789,  -- ID del usuario (cliente)
    --'2025-08-01 10:00:00',  -- Fecha y hora de la venta
    --ARRAY[1, 2],  -- IDs de productos (Destilo Amber y Benitz Pale Ale)
    --ARRAY[5, 3],  -- Cantidades de productos (5 unidades de Destilo Amber y 3 unidades de Benitz Pale Ale)
   -- ARRAY[1],  -- Método de pago (ID 1)
  --  10  -- Puntos a utilizar
--);

-- Ejecutar la función
--SELECT registrar_venta_tienda_fisica(
    --1,  -- ID de la tienda física
    --987654321,  -- ID del usuario (cliente)
    --'2025-08-01 11:00:00',  -- Fecha y hora de la venta
    --ARRAY[3],  -- ID de producto (Mito Candileja)
    --ARRAY[2],  -- Cantidad de producto (2 unidades de Mito Candileja)
    --ARRAY[1],  -- Método de pago (ID 1)
  --  0  -- Sin puntos utilizados
--);

-- Ejecutar la función
--SELECT registrar_venta_tienda_fisica(
  --  1,  -- ID de la tienda física
   -- 123456789,  -- ID del usuario (cliente)
    --'2025-08-01 10:00:00',  -- Fecha y hora de la venta
    --ARRAY[1, 2],  -- IDs de productos (Destilo Amber y Benitz Pale Ale)
    --ARRAY[30, 25],  -- Cantidades de productos (5 unidades de Destilo Amber y 3 unidades de Benitz Pale Ale)
    --ARRAY[1, 2],  -- Métodos de pago (IDs 1 y 2)
    --10  -- Puntos a utilizar
--);















--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------PRUEBA------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
    v_cantidad_reponer INTEGER := 150; -- Cantidad fija a reponer. Puedes ajustar este valor.
    v_estatus_pendiente_id INTEGER := 1; -- ID del estatus 'Pendiente'.
    
    -- Datos del empleado que genera la orden (Departamento de Compras)
    v_empleado_id INTEGER := 6;
    v_departamento_id INTEGER := 2;
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


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------PRUEBA------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
