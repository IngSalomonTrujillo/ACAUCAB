 CREATE TABLE Asistencia 
    ( 
     asistencia_id           serial  NOT NULL , 
     fecha                   DATE  NOT NULL , 
     hora_entrada_registrada TIMESTAMP WITH TIME ZONE  NOT NULL , 
     hora_salida_registrada  TIMESTAMP WITH TIME ZONE  NOT NULL , 
     Empleado_empleado_id    INTEGER 
    ) 
;

ALTER TABLE Asistencia 
    ADD CONSTRAINT Asistencia_PK PRIMARY KEY ( asistencia_id ) ;

CREATE TABLE Beneficio 
    ( 
     beneficio_id          serial  NOT NULL , 
     nombre_beneficio      VARCHAR (50)  NOT NULL , 
     descripción_beneficio text  NOT NULL 
    ) 
;

ALTER TABLE Beneficio 
    ADD CONSTRAINT Beneficio_PK PRIMARY KEY ( beneficio_id ) ;

CREATE TABLE Característica 
    ( 
     característica_id          serial  NOT NULL , 
     nombre_característica      VARCHAR (50)  NOT NULL , 
     descripción_caracteristica text  NOT NULL 
    ) 
;

ALTER TABLE Característica 
    ADD CONSTRAINT Característica_PK PRIMARY KEY ( característica_id ) ;

CREATE TABLE Cerveza 
    ( 
     cerveza_id                   serial  NOT NULL , 
     nombre_cerveza               VARCHAR (50)  NOT NULL , 
     descripción                  text  NOT NULL , 
     Tipo_Cerveza_tipo_cerveza_id INTEGER  NOT NULL , 
     presentación_id              INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Cerveza 
    ADD CONSTRAINT Cerveza_PK PRIMARY KEY ( cerveza_id ) ;

CREATE TABLE Cerveza_Caracteristica 
    ( 
     Cerveza_cerveza_id               INTEGER  NOT NULL , 
     descripción                      text , 
     Característica_característica_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Cerveza_Caracteristica 
    ADD CONSTRAINT Cerveza_Caracteristica_PK PRIMARY KEY ( Cerveza_cerveza_id, Característica_característica_id ) ;

CREATE TABLE Cerveza_Presentacion 
    ( 
     Presentación_presentación_id INTEGER  NOT NULL , 
     Cerveza_cerveza_id           INTEGER  NOT NULL ,
      precio_unitario             INTEGER  NOT NULL
    ) 
;

ALTER TABLE Cerveza_Presentacion 
    ADD CONSTRAINT Cerveza_Presentacion_PK PRIMARY KEY ( Cerveza_cerveza_id, Presentación_presentación_id ) ;

CREATE TABLE Cheque 
    ( 
     método_pago_id INTEGER  NOT NULL , 
     número_cuenta  INTEGER  NOT NULL , 
     banco          text  NOT NULL , 
     número_cheque  VARCHAR (30)  NOT NULL 
    ) 
;

ALTER TABLE Cheque 
    ADD CONSTRAINT Cheque_PK PRIMARY KEY ( método_pago_id ) ;

CREATE TABLE Cliente 
    ( 
     RIF                          INTEGER  NOT NULL , 
     tipo_cliente                 VARCHAR (50)  NOT NULL , 
     número_carnet                VARCHAR (8)  NOT NULL 
    ) 
;

ALTER TABLE Cliente 
    ADD CONSTRAINT Cliente_PK PRIMARY KEY ( RIF ) ;

CREATE TABLE Cliente_Punto 
    ( 
     cantidad_puntos      INTEGER  NOT NULL , 
     Punto_método_pago_id INTEGER  NOT NULL , 
     Cliente_RIF          INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Cliente_Punto 
    ADD CONSTRAINT Cliente_Punto_PK PRIMARY KEY ( Cliente_RIF, Punto_método_pago_id ) ;

CREATE TABLE Compra 
    ( 
     compra_id                           serial  NOT NULL , 
     tipo_compra                         VARCHAR (50)  NOT NULL , 
     monto_total                         decimal  NOT NULL , 
     puntos_ganados                      INTEGER , 
     Proveedor_proveedor_id              INTEGER  NOT NULL , 
     subtotal                            decimal  NOT NULL , 
     TipoE_Departamento_tipo_empleado_id INTEGER  NOT NULL , 
     TipoE_Departamento_departamento_id  INTEGER  NOT NULL , 
     TipoE_Departamento_empleado_id      INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Compra 
    ADD CONSTRAINT Compra_PK PRIMARY KEY ( Proveedor_proveedor_id, compra_id ) ;

CREATE TABLE Compra_Estatus 
    ( 
     fecha_inicio        DATE  NOT NULL , 
     fecha_fin           DATE , 
     Estatus_estatus_id  INTEGER  NOT NULL , 
     Compra_proveedor_id INTEGER  NOT NULL , 
     Compra_compra_id    INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Compra_Estatus 
    ADD CONSTRAINT Compra_Estatus_PK PRIMARY KEY ( Estatus_estatus_id, Compra_proveedor_id, Compra_compra_id ) ;

CREATE TABLE Compra_Evento 
    ( 
     Cliente_RIF      INTEGER  NOT NULL , 
     Evento_evento_id INTEGER  NOT NULL , 
     fecha            DATE  NOT NULL , 
     monto_total      decimal  NOT NULL 
    ) 
;

ALTER TABLE Compra_Evento 
    ADD CONSTRAINT Compra_Evento_PK PRIMARY KEY ( Cliente_RIF, Evento_evento_id ) ;

CREATE TABLE Correo_Electrónico 
    ( 
     Cliente_RIF            INTEGER , 
     Proveedor_proveedor_id INTEGER , 
     correo_id              serial  NOT NULL , 
     prefijo_correo         VARCHAR (40)  NOT NULL , 
     dominio_correo         VARCHAR (40)  NOT NULL , 
     Empleado_empleado_id   INTEGER 
    ) 
;
ALTER TABLE Correo_Electrónico 
    ADD CONSTRAINT Arc_5 CHECK ( 
        (  (Proveedor_proveedor_id IS NOT NULL) AND 
         (Empleado_empleado_id IS NULL)  AND 
         (Cliente_RIF IS NULL) ) OR 
        (  (Empleado_empleado_id IS NOT NULL) AND 
         (Proveedor_proveedor_id IS NULL)  AND 
         (Cliente_RIF IS NULL) ) OR 
        (  (Cliente_RIF IS NOT NULL) AND 
         (Proveedor_proveedor_id IS NULL)  AND 
         (Empleado_empleado_id IS NULL) )  ) 
;

ALTER TABLE Correo_Electrónico 
    ADD CONSTRAINT Correo_Electrónico_PK PRIMARY KEY ( correo_id ) ;

CREATE TABLE Crédito 
    ( 
     método_pago_id INTEGER  NOT NULL , 
     cuenta         VARCHAR (50)  NOT NULL , 
     banco          text  NOT NULL , 
     número_tarjeta VARCHAR (30)  NOT NULL 
    ) 
;

ALTER TABLE Crédito 
    ADD CONSTRAINT Crédito_PK PRIMARY KEY ( método_pago_id ) ;

CREATE TABLE Cuota 
    ( 
     cuota_id               serial  NOT NULL , 
     descripción            VARCHAR (50)  NOT NULL , 
     monto_cuota            decimal  NOT NULL , 
     periodicidad           VARCHAR (50)  NOT NULL , 
     fecha_vigencia_monto   DATE  NOT NULL , 
     Proveedor_proveedor_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Cuota 
    ADD CONSTRAINT Cuota_PK PRIMARY KEY ( cuota_id ) ;

CREATE TABLE Débito 
    ( 
     método_pago_id INTEGER  NOT NULL , 
     cuenta         VARCHAR (50)  NOT NULL , 
     banco          text  NOT NULL , 
     número_tarjeta VARCHAR (30)  NOT NULL 
    ) 
;

ALTER TABLE Débito 
    ADD CONSTRAINT Débito_PK PRIMARY KEY ( método_pago_id ) ;

CREATE TABLE Departamento 
    ( 
     departamento_id     serial  NOT NULL , 
     nombre_departamento VARCHAR (50)  NOT NULL 
    ) 
;

ALTER TABLE Departamento 
    ADD CONSTRAINT Departamento_PK PRIMARY KEY ( departamento_id ) ;

CREATE TABLE Descuento 
    ( 
     descuento_id         serial  NOT NULL , 
     porcentaje_descuento INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Descuento 
    ADD CONSTRAINT Descuento_PK PRIMARY KEY ( descuento_id ) ;

CREATE TABLE Descuento_Inventario 
    ( 
     Descuento_descuento_id   INTEGER  NOT NULL , 
     Inventario_inventario_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Descuento_Inventario 
    ADD CONSTRAINT Descuento_Inventario_PK PRIMARY KEY ( Inventario_inventario_id, Descuento_descuento_id ) ;

CREATE TABLE Detalle_Compra 
    ( 
     cantidad                                          INTEGER  NOT NULL , 
     precio_unitario                                   decimal  NOT NULL , 
     Tasa_Cambio_tasa_cambio_id                        INTEGER  NOT NULL , 
     Compra_proveedor_id                               INTEGER  NOT NULL , 
     Compra_compra_id                                  INTEGER  NOT NULL , 
     Cerveza_Presentacion_Cerveza_cerveza_id           INTEGER  NOT NULL , 
     Cerveza_Presentacion_Presentación_presentación_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Detalle_Compra 
    ADD CONSTRAINT Detalle_Compra_PK PRIMARY KEY ( Cerveza_Presentacion_Cerveza_cerveza_id, Cerveza_Presentacion_Presentación_presentación_id, Compra_proveedor_id, Compra_compra_id ) ;

CREATE TABLE Detalle_Evento 
    ( 
     Tasa_Cambio_tasa_cambio_id             INTEGER  NOT NULL , 
     detalle_evento_id                      INTEGER  NOT NULL , 
     cantidad_cerveza                       INTEGER  NOT NULL , 
     Compra_Evento_Cliente_RIF              INTEGER  NOT NULL , 
     Compra_Evento_Evento_evento_id         INTEGER  NOT NULL , 
     Inventario_E_Cerveza_P_evento_id       INTEGER  NOT NULL , 
     Inventario_E_Cerveza_P_cerveza_id      INTEGER  NOT NULL , 
     Inventario_E_Cerveza_P_presentación_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Detalle_Evento 
    ADD CONSTRAINT Detalle_Evento_PK PRIMARY KEY ( detalle_evento_id, Inventario_E_Cerveza_P_evento_id, Inventario_E_Cerveza_P_cerveza_id, Inventario_E_Cerveza_P_presentación_id, Compra_Evento_Cliente_RIF, Compra_Evento_Evento_evento_id ) ;

CREATE TABLE Detalle_Física 
    ( 
     Venta_fisica_id INTEGER NOT NULL ,
     precio_unitario               decimal  NOT NULL , 
     cantidad                      INTEGER  NOT NULL , 
     Venta_Física_tienda_fisica_id INTEGER  NOT NULL , 
     Venta_Física_usuario_id       INTEGER  NOT NULL , 
     Tasa_Cambio_tasa_cambio_id    INTEGER  NOT NULL , 
     Inventario_inventario_id      INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Detalle_Física 
    ADD CONSTRAINT Detalle_Física_PK PRIMARY KEY (Venta_fisica_id, Inventario_inventario_id, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id ) ;

CREATE TABLE Detalle_Online 
    ( 
     venta_online_id		   Integer  NOT NULL ,
     precio_unitario               decimal  NOT NULL , 
     cantidad                      INTEGER  NOT NULL , 
     Venta_Online_tienda_online_id INTEGER  NOT NULL , 
     Venta_Online_usuario_id       INTEGER  NOT NULL , 
     Tasa_Cambio_tasa_cambio_id    INTEGER  NOT NULL , 
     Inventario_inventario_id      INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Detalle_Online 
    ADD CONSTRAINT Detalle_Online_PK PRIMARY KEY ( venta_online_id, Inventario_inventario_id, Venta_Online_tienda_online_id, Venta_Online_usuario_id ) ;

CREATE TABLE Detalle_VentaE 
    ( 
     cantidad                                          INTEGER  NOT NULL , 
     precio_unitario                                   decimal  NOT NULL , 
     Venta_Evento_Proveedor_proveedor_id               INTEGER  NOT NULL , 
     Venta_Evento_Evento_evento_id                     INTEGER  NOT NULL , 
     Cerveza_Presentacion_Cerveza_cerveza_id           INTEGER  NOT NULL , 
     Cerveza_Presentacion_Presentación_presentación_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Detalle_VentaE 
    ADD CONSTRAINT Detalle_VentaE_PK PRIMARY KEY ( Venta_Evento_Proveedor_proveedor_id, Venta_Evento_Evento_evento_id, Cerveza_Presentacion_Cerveza_cerveza_id, Cerveza_Presentacion_Presentación_presentación_id ) ;

CREATE TABLE Efectivo 
    ( 
     método_pago_id INTEGER  NOT NULL , 
     tipo_divisa    VARCHAR (50)  NOT NULL 
    ) 
;

ALTER TABLE Efectivo 
    ADD CONSTRAINT Efectivo_PK PRIMARY KEY ( método_pago_id ) ;

CREATE TABLE Empleado 
    ( 
     empleado_id      serial  NOT NULL , 
     cédula_identidad VARCHAR (50)  NOT NULL , 
     primer_nombre    VARCHAR (50)  NOT NULL , 
     segundo_nombre   VARCHAR (50) , 
     primer_apellido  VARCHAR (50)  NOT NULL , 
     segundo_apellido VARCHAR (50) , 
     fecha_ingreso    DATE  NOT NULL , 
     salario          decimal  NOT NULL 
    ) 
;

ALTER TABLE Empleado 
    ADD CONSTRAINT Empleado_PK PRIMARY KEY ( empleado_id ) ;

CREATE TABLE Empleado_Beneficio 
    ( 
     Empleado_empleado_id   INTEGER  NOT NULL , 
     Beneficio_beneficio_id INTEGER  NOT NULL , 
     empleado_beneficio_id  INTEGER  NOT NULL , 
     fecha_asignación       DATE  NOT NULL , 
     monto_beneficio        decimal 
    ) 
;

ALTER TABLE Empleado_Beneficio 
    ADD CONSTRAINT Empleado_Beneficio_PK PRIMARY KEY ( Empleado_empleado_id, Beneficio_beneficio_id ) ;

CREATE TABLE Entrada_Evento 
    ( 
     entrada_evento_id              serial  NOT NULL , 
     fecha_evento                   DATE  NOT NULL , 
     Evento_evento_id               INTEGER  NOT NULL , 
     Venta_Entrada_Cliente_RIF      INTEGER  NOT NULL , 
     Venta_Entrada_Evento_evento_id INTEGER  NOT NULL , 
     Venta_Entrada_venta_entrada_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Entrada_Evento 
    ADD CONSTRAINT Entrada_Evento_PK PRIMARY KEY ( entrada_evento_id, Venta_Entrada_Cliente_RIF, Venta_Entrada_Evento_evento_id, Venta_Entrada_venta_entrada_id, Evento_evento_id ) ;

CREATE TABLE Estatus 
    ( 
     estatus_id          serial  NOT NULL , 
     estatus_nombre      VARCHAR (50)  NOT NULL , 
     descripción_estatus text 
    ) 
;

ALTER TABLE Estatus 
    ADD CONSTRAINT Estatus_PK PRIMARY KEY ( estatus_id ) ;

CREATE TABLE Evento 
    ( 
     evento_id                  INTEGER  NOT NULL , 
     nombre_evento              VARCHAR (50)  NOT NULL , 
     fecha_inicio               DATE  NOT NULL , 
     fecha_fin                  DATE , 
     descripción_evento         text  NOT NULL , 
     requiere_entrada_paga      CHAR (1) , 
     Tipo_Evento_tipo_evento_id INTEGER  NOT NULL , 
     direccion_evento           text  NOT NULL , 
     Lugar_lugar_id             integer  NOT NULL 
    ) 
;

ALTER TABLE Evento 
    ADD CONSTRAINT Evento_PK PRIMARY KEY ( evento_id ) ;

CREATE TABLE Horario 
    ( 
     horario_id            serial  NOT NULL , 
     dias_semana           VARCHAR (50)  NOT NULL , 
     hora_entrada_esperada TIME  NOT NULL , 
     hora_salida_esperada  TIME  NOT NULL 
    ) 
;

ALTER TABLE Horario 
    ADD CONSTRAINT Horario_PK PRIMARY KEY ( horario_id ) ;

CREATE TABLE Ingrediente 
    ( 
     ingrediente_id             serial  NOT NULL , 
     nombre_ingrediente         VARCHAR (50)  NOT NULL , 
     Ingrediente_ingrediente_id INTEGER 
    ) 
;

ALTER TABLE Ingrediente 
    ADD CONSTRAINT Ingrediente_PK PRIMARY KEY ( ingrediente_id ) ;

CREATE TABLE Instruccion 
    ( 
     instruccion_id serial  NOT NULL , 
     descripcion    text  NOT NULL 
    ) 
;

ALTER TABLE Instruccion 
    ADD CONSTRAINT Instruccion_PK PRIMARY KEY ( instruccion_id ) ;

CREATE TABLE Instruccion_Receta 
    ( 
     Instruccion_instruccion_id INTEGER  NOT NULL , 
     Receta_receta_id           INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Instruccion_Receta 
    ADD CONSTRAINT Instruccion_Receta_PK PRIMARY KEY ( Receta_receta_id, Instruccion_instruccion_id ) ;

CREATE TABLE Inventario 
    ( 
     Tienda_Online_tienda_online_id                    INTEGER  , 
     cantidad_presentaciones                           INTEGER  NOT NULL , 
     Cerveza_Presentacion_Cerveza_cerveza_id           INTEGER  NOT NULL , 
     Cerveza_Presentacion_Presentación_presentación_id INTEGER  NOT NULL , 
     inventario_id                                     serial  NOT NULL 
    ) 
;

ALTER TABLE Inventario 
    ADD CONSTRAINT Inventario_PK PRIMARY KEY ( inventario_id ) ;

CREATE TABLE Inventario_E_Cerveza_P 
    ( 
     Cerveza_Presentacion_Cerveza_cerveza_id           INTEGER  NOT NULL , 
     Cerveza_Presentacion_Presentación_presentación_id INTEGER  NOT NULL , 
     cantidad                                          INTEGER  NOT NULL ,
     Evento_evento_id                                  INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Inventario_E_Cerveza_P 
    ADD CONSTRAINT Inventario_E_Cerveza_P_PK PRIMARY KEY ( Evento_evento_id, Cerveza_Presentacion_Cerveza_cerveza_id, Cerveza_Presentacion_Presentación_presentación_id ) ;

CREATE TABLE Juez 
    ( 
     juez_id     serial  NOT NULL , 
     nombre_juez VARCHAR (50)  NOT NULL 
    ) 
;

ALTER TABLE Juez 
    ADD CONSTRAINT Juez_PK PRIMARY KEY ( juez_id ) ;

CREATE TABLE Juez_Evento 
    ( 
     Evento_evento_id INTEGER  NOT NULL , 
     Juez_juez_id     INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Juez_Evento 
    ADD CONSTRAINT Juez_Evento_PK PRIMARY KEY ( Evento_evento_id, Juez_juez_id ) ;

CREATE TABLE Jurídico 
    ( 
     RIF                    INTEGER  NOT NULL , 
     razón_social           VARCHAR (50)  NOT NULL , 
     denominación_comercial VARCHAR (50)  NOT NULL , 
     página_web             VARCHAR (60) , 
     capital_disponible     decimal  NOT NULL , 
     dirección_fiscal       text  NOT NULL , 
     dirección_fisica       text  NOT NULL , 
     Lugar_lugar_id         integer  NOT NULL ,  
     Lugar_lugar_id2        integer  NOT NULL
    ) 
;

ALTER TABLE Jurídico 
    ADD CONSTRAINT Jurídico_PK PRIMARY KEY ( RIF ) ;

CREATE TABLE Lugar 
    ( 
     lugar_id       serial  NOT NULL ,
     Nombre         VARCHAR (50)  NOT NULL , 
     Tipo           VARCHAR (50)  NOT NULL , 
     Lugar_lugar_id integer 

    ) 
;

ALTER TABLE Lugar 
    ADD CONSTRAINT Lugar_PK PRIMARY KEY ( lugar_id ) ;

CREATE TABLE Lugar_Tienda 
    ( 
     Tienda_Física_tienda_fisica_id              INTEGER  NOT NULL , 
     lugar_tienda_id                             serial  NOT NULL , 
     nombre_lugar_tienda                         VARCHAR (50)  NOT NULL , 
     tipo_lugar_tienda                           VARCHAR (50)  NOT NULL , 
     Lugar_Tienda_Tienda_Física_tienda_fisica_id INTEGER , 
     Lugar_Tienda_lugar_tienda_id                INTEGER , 
     Inventario_inventario_id                    INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Lugar_Tienda 
    ADD CONSTRAINT Lugar_Tienda_PK PRIMARY KEY ( Tienda_Física_tienda_fisica_id, lugar_tienda_id ) ;

CREATE TABLE Método_Pago 
    ( 
     método_pago_id serial  NOT NULL 
    ) 
;

ALTER TABLE Método_Pago 
    ADD CONSTRAINT Método_Pago_PK PRIMARY KEY ( método_pago_id ) ;

CREATE TABLE PersonaNatural 
    ( 
     RIF              INTEGER  NOT NULL , 
     cedula_identidad VARCHAR (12)  NOT NULL , 
     primer_nombre    VARCHAR (50)  NOT NULL , 
     segundo_nombre   VARCHAR (50) , 
     primer_apellido  VARCHAR (50)  NOT NULL , 
     segundo_apellido VARCHAR (50) , 
     Lugar_lugar_id   integer  
    ) 
;

ALTER TABLE PersonaNatural 
    ADD CONSTRAINT PersonaNatural_PK PRIMARY KEY ( RIF ) ;

CREATE TABLE Orden_Reposición 
    ( 
     Tienda_Física_tienda_fisica_id      INTEGER  NOT NULL , 
     orden_reposición_id                 serial  NOT NULL , 
     fecha_hora_generación               TIMESTAMP WITH TIME ZONE  NOT NULL , 
     cantidad_a_reponer                  INTEGER  NOT NULL , 
     fecha_hora_completada               TIMESTAMP WITH TIME ZONE , 
     TipoE_Departamento_tipo_empleado_id INTEGER  NOT NULL ,  
     TipoE_Departamento_departamento_id  INTEGER  NOT NULL , 
     TipoE_Departamento_empleado_id      INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Orden_Reposición 
    ADD CONSTRAINT Orden_Reposición_PK PRIMARY KEY ( orden_reposición_id ) ;

CREATE TABLE OrdenR_Estatus 
    ( 
     fecha_inicio                         DATE  NOT NULL , 
     fecha_fin                            DATE , 
     Orden_Reposición_orden_reposición_id INTEGER  NOT NULL , 
     Estatus_estatus_id                   INTEGER  NOT NULL 
    ) 
;

ALTER TABLE OrdenR_Estatus 
    ADD CONSTRAINT OrdenR_Estatus_PK PRIMARY KEY ( Orden_Reposición_orden_reposición_id, Estatus_estatus_id ) ;

CREATE TABLE Pago_Compra_Evento 
    ( 
     Método_Pago_método_pago_id     INTEGER  NOT NULL , 
     fecha_pago                     DATE  NOT NULL , 
     monto_pagado                   decimal  NOT NULL , 
     referencia_pago                VARCHAR (50)  NOT NULL , 
     Compra_Evento_Cliente_RIF      INTEGER  NOT NULL , 
     Compra_Evento_Evento_evento_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Pago_Compra_Evento 
    ADD CONSTRAINT Pago_Compra_Evento_PK PRIMARY KEY ( Método_Pago_método_pago_id, Compra_Evento_Cliente_RIF, Compra_Evento_Evento_evento_id ) ;

CREATE TABLE Pago_CompraP 
    ( 
     Método_Pago_método_pago_id INTEGER  NOT NULL , 
     fecha_pago                 DATE  NOT NULL , 
     monto_pagado               decimal  NOT NULL , 
     referencia_pago            VARCHAR (50)  NOT NULL , 
     Compra_proveedor_id        INTEGER  NOT NULL , 
     Compra_compra_id           INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Pago_CompraP 
    ADD CONSTRAINT Pago_CompraP_PK PRIMARY KEY ( Método_Pago_método_pago_id, Compra_proveedor_id, Compra_compra_id ) ;

CREATE TABLE Pago_Cuota 
    ( 
     Método_Pago_método_pago_id INTEGER  NOT NULL , 
     Cuota_cuota_id             INTEGER  NOT NULL , 
     fecha_pago                 DATE  NOT NULL , 
     monto_pagado               decimal  NOT NULL , 
     recibo_id                  VARCHAR (50)  NOT NULL 
    ) 
;

ALTER TABLE Pago_Cuota 
    ADD CONSTRAINT Pago_Cuota_PK PRIMARY KEY ( Método_Pago_método_pago_id, Cuota_cuota_id ) ;

CREATE TABLE Pago_Entrada 
    ( 
     Método_Pago_método_pago_id     INTEGER  NOT NULL , 
     fecha_pago                     DATE  NOT NULL , 
     monto_pagado                   decimal  NOT NULL , 
     referencia_pago                VARCHAR (50)  NOT NULL , 
     Venta_Entrada_Cliente_RIF      INTEGER  NOT NULL , 
     Venta_Entrada_Evento_evento_id INTEGER  NOT NULL , 
     Venta_Entrada_venta_entrada_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Pago_Entrada 
    ADD CONSTRAINT Pago_Entrada_PK PRIMARY KEY ( Método_Pago_método_pago_id ) ;



CREATE TABLE Pago_Online 
    ( 
     venta_online_id               Integer NOT NULL ,	
     Método_Pago_método_pago_id    INTEGER  NOT NULL , 
     fecha_pago                    DATE  NOT NULL , 
     monto_pagado                  decimal  NOT NULL , 
     referencia_pago               VARCHAR (50)  NOT NULL , 
     Venta_Online_tienda_online_id INTEGER  NOT NULL , 
     Venta_Online_usuario_id       INTEGER  NOT NULL , 
     puntos_usados                 INTEGER 
    ) 
;

ALTER TABLE Pago_Online 
    ADD CONSTRAINT Pago_Online_PK PRIMARY KEY ( venta_online_id, Método_Pago_método_pago_id, Venta_Online_tienda_online_id, Venta_Online_usuario_id ) ;

CREATE TABLE Permiso 
    ( 
     permiso_id      serial  NOT NULL , 
     fecha_solicitud DATE  NOT NULL , 
     fecha_inicio    DATE  NOT NULL , 
     fecha_fin       DATE  NOT NULL , 
     motivo          text  NOT NULL 
    ) 
;

ALTER TABLE Permiso 
    ADD CONSTRAINT Permiso_PK PRIMARY KEY ( permiso_id ) ;

CREATE TABLE Persona_Contacto 
    ( 
     Proveedor_proveedor_id INTEGER , 
     contacto_id            serial  NOT NULL , 
     nombre_contacto        VARCHAR (50)  NOT NULL , 
     cargo_contacto         VARCHAR (50)  NOT NULL , 
     teléfono_contacto      VARCHAR (50)  NOT NULL , 
     Jurídico_RIF           INTEGER 
    ) 
;
ALTER TABLE Persona_Contacto 
    ADD CONSTRAINT Arc_3 CHECK ( 
        (  (Proveedor_proveedor_id IS NOT NULL) AND 
         (Jurídico_RIF IS NULL) ) OR 
        (  (Jurídico_RIF IS NOT NULL) AND 
         (Proveedor_proveedor_id IS NULL) )  ) 
;

ALTER TABLE Persona_Contacto 
    ADD CONSTRAINT Persona_Contacto_PK PRIMARY KEY ( contacto_id ) ;

CREATE TABLE Presentación 
    ( 
     presentación_id     serial  NOT NULL , 
     nombre_presentación VARCHAR (50)  NOT NULL , 
     medida              VARCHAR (50)  NOT NULL 
    ) 
;

ALTER TABLE Presentación 
    ADD CONSTRAINT Presentación_PK PRIMARY KEY ( presentación_id ) ;

CREATE TABLE Privilegio 
    ( 
     privilegio_id          serial  NOT NULL , 
     nombre_privilegio      VARCHAR (50)  NOT NULL , 
     descripción_privilegio text  NOT NULL 
    ) 
;

ALTER TABLE Privilegio 
    ADD CONSTRAINT Privilegio_PK PRIMARY KEY ( privilegio_id ) ;

CREATE TABLE Proveedor 
    ( 
     proveedor_id                 serial  NOT NULL , 
     razón_social                 VARCHAR (50)  NOT NULL , 
     denominación_comercial       VARCHAR (50)  NOT NULL , 
     RIF                          VARCHAR (50)  NOT NULL , 
     dirección_fiscal             text  NOT NULL , 
     página_web                   VARCHAR (50)  NOT NULL , 
     fecha_afiliación             DATE  NOT NULL , 
     direccion_fisica             text  NOT NULL , 
     Lugar_lugar_id               integer NOT NULL , 
     Lugar_lugar_id2              integer NOT NULL 
    ) 
;

ALTER TABLE Proveedor 
    ADD CONSTRAINT Proveedor_PK PRIMARY KEY ( proveedor_id ) ;

CREATE TABLE Punto 
    ( 
     método_pago_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Punto 
    ADD CONSTRAINT Punto_PK PRIMARY KEY ( método_pago_id ) ;

CREATE TABLE Receta 
    ( 
     receta_id                    serial  NOT NULL , 
     nombre_receta                VARCHAR (50)  NOT NULL 
    ) 
;

ALTER TABLE Receta 
    ADD CONSTRAINT Receta_PK PRIMARY KEY ( receta_id ) ;

CREATE TABLE Receta_Ingrediente 
    ( 
     Receta_receta_id           INTEGER  NOT NULL , 
     cantidad                   decimal  NOT NULL , 
     unidad_medida              VARCHAR (50)  NOT NULL , 
     Ingrediente_ingrediente_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Receta_Ingrediente 
    ADD CONSTRAINT Receta_Ingrediente_PK PRIMARY KEY ( Receta_receta_id, Ingrediente_ingrediente_id ) ;

CREATE TABLE Rol 
    ( 
     rol_id          serial  NOT NULL , 
     nombre_rol      VARCHAR (50)  NOT NULL , 
     descripción_rol text  NOT NULL 
    ) 
;

ALTER TABLE Rol 
    ADD CONSTRAINT Rol_PK PRIMARY KEY ( rol_id ) ;

CREATE TABLE Rol_Permiso 
    ( 
     Permiso_permiso_id INTEGER  NOT NULL , 
     Rol_rol_id         INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Rol_Permiso 
    ADD CONSTRAINT Rol_Permiso_PK PRIMARY KEY ( Permiso_permiso_id, Rol_rol_id ) ;

CREATE TABLE Rol_Privilegio 
    ( 
     Rol_rol_id               INTEGER  NOT NULL , 
     Privilegio_privilegio_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Rol_Privilegio 
    ADD CONSTRAINT Rol_Privilegio_PK PRIMARY KEY ( Rol_rol_id, Privilegio_privilegio_id ) ;

CREATE TABLE Tasa_Cambio 
    ( 
     tasa_cambio_id serial  NOT NULL , 
     moneda_origen  VARCHAR (3)  NOT NULL , 
     tasa           decimal  NOT NULL , 
     fecha_vigencia DATE  NOT NULL 
    ) 
;

ALTER TABLE Tasa_Cambio 
    ADD CONSTRAINT Tasa_Cambio_PK PRIMARY KEY ( tasa_cambio_id ) ;

CREATE TABLE Teléfono 
    ( 
     Cliente_RIF            INTEGER , 
     Proveedor_proveedor_id INTEGER , 
     teléfono_id            INTEGER  NOT NULL , 
     teléfono_área          INTEGER  NOT NULL , 
     número_telefónico      INTEGER  NOT NULL , 
     Empleado_empleado_id   INTEGER 
    ) 
;
ALTER TABLE Teléfono 
    ADD CONSTRAINT Arc_7 CHECK ( 
        (  (Cliente_RIF IS NOT NULL) AND 
         (Empleado_empleado_id IS NULL)  AND 
         (Proveedor_proveedor_id IS NULL) ) OR 
        (  (Empleado_empleado_id IS NOT NULL) AND 
         (Cliente_RIF IS NULL)  AND 
         (Proveedor_proveedor_id IS NULL) ) OR 
        (  (Proveedor_proveedor_id IS NOT NULL) AND 
         (Cliente_RIF IS NULL)  AND 
         (Empleado_empleado_id IS NULL) )  ) 
;

ALTER TABLE Teléfono 
    ADD CONSTRAINT Teléfono_PK PRIMARY KEY ( teléfono_id ) ;

CREATE TABLE Tienda_Física 
    ( 
     tienda_fisica_id                     INTEGER  NOT NULL , 
     nombre_ubicación                     VARCHAR (50)  NOT NULL , 
     Orden_Reposición_orden_reposición_id INTEGER  NOT NULL , 
     Lugar_lugar_id                       integer  NOT NULL 
    ) 
;

ALTER TABLE Tienda_Física 
    ADD CONSTRAINT Tienda_Física_PK PRIMARY KEY ( tienda_fisica_id ) ;

CREATE TABLE Tienda_Online 
    ( 
     tienda_online_id         serial  NOT NULL , 
     dirección_web            VARCHAR (40)  NOT NULL 
    ) 
;

ALTER TABLE Tienda_Online 
    ADD CONSTRAINT Tienda_Online_PK PRIMARY KEY ( tienda_online_id ) ;

CREATE TABLE Tipo_Cerveza 
    ( 
     Receta_receta_id             INTEGER  NOT NULL , 
     tipo_cerveza_id              serial  NOT NULL , 
     nombre_tipo                  VARCHAR (50)  NOT NULL , 
     descripción_general          text  NOT NULL , 
     familia                      VARCHAR (50)  NOT NULL , 
     Proveedor_proveedor_id       INTEGER  NOT NULL , 
     Tipo_Cerveza_tipo_cerveza_id INTEGER 
    ) 
;

ALTER TABLE Tipo_Cerveza 
    ADD CONSTRAINT Tipo_Cerveza_PK PRIMARY KEY ( tipo_cerveza_id ) ;

CREATE TABLE Tipo_Cerveza_Caracteristica 
    ( 
     Tipo_Cerveza_tipo_cerveza_id     INTEGER  NOT NULL ,  
     Característica_característica_id INTEGER  NOT NULL , 
     descripción                      text 
    ) 
;

ALTER TABLE Tipo_Cerveza_Caracteristica 
    ADD CONSTRAINT Tipo_Cerveza_Caracteristica_PK PRIMARY KEY ( Tipo_Cerveza_tipo_cerveza_id, Característica_característica_id ) ;

CREATE TABLE Tipo_Empleado 
    ( 
     tipo_empleado_id               serial  NOT NULL , 
     nombre_cargo                   VARCHAR (50)  NOT NULL , 
     descripción_cargo              text , 
     Tipo_Empleado_tipo_empleado_id INTEGER 
    ) 
;

ALTER TABLE Tipo_Empleado 
    ADD CONSTRAINT Tipo_Empleado_PK PRIMARY KEY ( tipo_empleado_id ) ;

CREATE TABLE Tipo_Evento 
    ( 
     tipo_evento_id             serial  NOT NULL , 
     nombre_tipo_evento         VARCHAR (50)  NOT NULL , 
     descripción_evento         text  NOT NULL , 
     Tipo_Evento_tipo_evento_id INTEGER 
    ) 
;

ALTER TABLE Tipo_Evento 
    ADD CONSTRAINT Tipo_Evento_PK PRIMARY KEY ( tipo_evento_id ) ;

CREATE TABLE TipoE_Departamento 
    ( 
     Tipo_Empleado_tipo_empleado_id       INTEGER  NOT NULL , 
     Departamento_departamento_id         INTEGER  NOT NULL , 
     nombre_departamento                  VARCHAR (50)  NOT NULL , 
     Empleado_empleado_id                 INTEGER  NOT NULL 
    ) 
;

ALTER TABLE TipoE_Departamento 
    ADD CONSTRAINT TipoE_Departamento_PK PRIMARY KEY ( Tipo_Empleado_tipo_empleado_id, Departamento_departamento_id, Empleado_empleado_id ) ;

CREATE TABLE TipoED_Horario 
    ( 
     Horario_horario_id                                INTEGER  NOT NULL , 
     TipoE_Departamento_Tipo_Empleado_tipo_empleado_id INTEGER  NOT NULL ,  
     TipoE_Departamento_Departamento_departamento_id   INTEGER  NOT NULL ,  
     TipoE_Departamento_Empleado_empleado_id           INTEGER  NOT NULL 
    ) 
;

ALTER TABLE TipoED_Horario 
    ADD CONSTRAINT TipoED_Horario_PK PRIMARY KEY ( Horario_horario_id, TipoE_Departamento_Tipo_Empleado_tipo_empleado_id, TipoE_Departamento_Departamento_departamento_id, TipoE_Departamento_Empleado_empleado_id ) ;

CREATE TABLE Usuario 
    ( 
     Cliente_RIF            INTEGER , 
     Proveedor_proveedor_id INTEGER , 
     usuario_id             serial  NOT NULL , 
     contraseña_usuario     VARCHAR (50)  NOT NULL , 
     Empleado_empleado_id   INTEGER , 
     Rol_rol_id             INTEGER  NOT NULL , 
     nombre_usuario         VARCHAR (50)  NOT NULL 
    ) 
;
ALTER TABLE Usuario 
    ADD CONSTRAINT Arc_8 CHECK ( 
        (  (Empleado_empleado_id IS NOT NULL) AND 
         (Cliente_RIF IS NULL)  AND 
         (Proveedor_proveedor_id IS NULL) ) OR 
        (  (Cliente_RIF IS NOT NULL) AND 
         (Empleado_empleado_id IS NULL)  AND 
         (Proveedor_proveedor_id IS NULL) ) OR 
        (  (Proveedor_proveedor_id IS NOT NULL) AND 
         (Empleado_empleado_id IS NULL)  AND 
         (Cliente_RIF IS NULL) )  ) 
;

ALTER TABLE Usuario 
    ADD CONSTRAINT Usuario_PK PRIMARY KEY ( usuario_id ) ;

CREATE TABLE Vacación 
    ( 
     Empleado_empleado_id INTEGER  NOT NULL , 
     vacación_id          serial  NOT NULL , 
     fecha_inicio         DATE  NOT NULL , 
     fecha_fin            DATE  NOT NULL 
    ) 
;

ALTER TABLE Vacación 
    ADD CONSTRAINT Vacación_PK PRIMARY KEY ( vacación_id ) ;

CREATE TABLE Vacacion_Estatus 
    ( 
     fecha_inicio         DATE  NOT NULL , 
     fecha_fin            DATE  , 
     Estatus_estatus_id   INTEGER  NOT NULL , 
     Vacación_vacación_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Vacacion_Estatus 
    ADD CONSTRAINT Vacacion_Estatus_PK PRIMARY KEY ( Estatus_estatus_id, Vacación_vacación_id ) ;

CREATE TABLE Venta_Entrada 
    ( 
     Cliente_RIF      INTEGER  NOT NULL , 
     Evento_evento_id INTEGER  NOT NULL , 
     venta_entrada_id INTEGER  NOT NULL , 
     fecha_venta      TIMESTAMP WITH TIME ZONE  NOT NULL , 
     total            decimal  NOT NULL 
    ) 
;

ALTER TABLE Venta_Entrada 
    ADD CONSTRAINT Venta_Entrada_PK PRIMARY KEY ( Cliente_RIF, Evento_evento_id, venta_entrada_id ) ;

CREATE TABLE Venta_Evento 
    ( 
     Proveedor_proveedor_id INTEGER  NOT NULL , 
     Evento_evento_id       INTEGER  NOT NULL , 
     cantidad               INTEGER  NOT NULL , 
     precio_unitatio_pagado decimal  NOT NULL , 
     fecha_hora_venta       TIMESTAMP WITH TIME ZONE  NOT NULL
    ) 
;

ALTER TABLE Venta_Evento 
    ADD CONSTRAINT Venta_Evento_PK PRIMARY KEY ( Proveedor_proveedor_id, Evento_evento_id ) ;

CREATE TABLE Venta_Física 
    ( 
     Venta_id SERIAL NOT NULL, 
     Tienda_Física_tienda_fisica_id INTEGER  NOT NULL , 
     Usuario_usuario_id             INTEGER  NOT NULL , 
     fecha_hora_venta               TIMESTAMP WITH TIME ZONE  NOT NULL , 
     monto_total                    decimal  NOT NULL 
    ) 
;

ALTER TABLE Venta_Física 
    ADD CONSTRAINT Venta_Física_PK PRIMARY KEY (Venta_id, Tienda_Física_tienda_fisica_id, Usuario_usuario_id ) ;

CREATE TABLE Venta_Online 
    ( 
     venta_id                      SERIAL NOT NULL ,
     Tienda_Online_tienda_online_id INTEGER  NOT NULL , 
     Usuario_usuario_id             INTEGER  NOT NULL ,  
     fecha_hora_venta               TIMESTAMP WITH TIME ZONE  NOT NULL , 
     monto_total                    decimal  NOT NULL 
    ) 
;

ALTER TABLE Venta_Online 
    ADD CONSTRAINT Venta_Online_PK PRIMARY KEY ( venta_id, Tienda_Online_tienda_online_id, Usuario_usuario_id ) ;

CREATE TABLE VentaF_Estatus 
    ( 
	 Venta_fisica_id INTEGER NOT NULL,
     fecha_inicio                                DATE  NOT NULL , 
     fecha_fin                                   DATE  , 
     Estatus_estatus_id                          INTEGER  NOT NULL , 
     Venta_Física_Tienda_Física_tienda_fisica_id INTEGER  NOT NULL , 
     Venta_Física_Usuario_usuario_id             INTEGER  NOT NULL 
    ) 
;

ALTER TABLE VentaF_Estatus 
    ADD CONSTRAINT VentaF_Estatus_PK PRIMARY KEY ( Venta_fisica_id, Estatus_estatus_id, Venta_Física_Tienda_Física_tienda_fisica_id, Venta_Física_Usuario_usuario_id ) ;


CREATE TABLE VentaO_Estatus 
    ( 
     venta_online_id                             INTEGER NOT NULL,
     fecha_inicio                                DATE  NOT NULL , 
     fecha_fin                                   DATE  , 
     Venta_Online_Tienda_Online_tienda_online_id INTEGER  NOT NULL ,  
     Venta_Online_Usuario_usuario_id             INTEGER  NOT NULL , 
     Estatus_estatus_id                          INTEGER  NOT NULL 
    ) 
;

ALTER TABLE VentaO_Estatus 
    ADD CONSTRAINT VentaO_Estatus_PK PRIMARY KEY ( venta_online_id, Venta_Online_Tienda_Online_tienda_online_id, Venta_Online_Usuario_usuario_id, Estatus_estatus_id ) ;

CREATE TABLE Pago_Fisica 
(
    Venta_fisica_id  INTEGER NOT NULL,  
    fecha_pago DATE NOT NULL, 
    monto_pagado DECIMAL NOT NULL, 
    referencia_pago VARCHAR(50) NOT NULL, 
    Venta_Física_tienda_fisica_id INTEGER NOT NULL, 
    Venta_Física_usuario_id INTEGER NOT NULL, 
    Método_Pago_método_pago_id INTEGER NOT NULL, 
    puntos_usuados INTEGER DEFAULT  0,

    -- Definir la clave primaria compuesta
    CONSTRAINT Pago_Fisica_PK PRIMARY KEY ( Venta_fisica_id, Venta_Física_tienda_fisica_id, Método_Pago_método_pago_id),

    -- Clave foránea para el usuario
    CONSTRAINT Pago_Fisica_FK_Usuario FOREIGN KEY (Venta_Física_usuario_id) 
    REFERENCES Usuario (usuario_id)

);

ALTER TABLE Asistencia 
    ADD CONSTRAINT Asistencia_Empleado_FK FOREIGN KEY 
    ( 
     Empleado_empleado_id
    ) 
    REFERENCES Empleado 
    ( 
     empleado_id
    ) 
;

ALTER TABLE Cerveza_Caracteristica 
    ADD CONSTRAINT Cerveza_Caracteristica_Característica_FK FOREIGN KEY 
    ( 
     Característica_característica_id
    ) 
    REFERENCES Característica 
    ( 
     característica_id
    ) 
;

ALTER TABLE Cerveza_Caracteristica 
    ADD CONSTRAINT Cerveza_Caracteristica_Cerveza_FK FOREIGN KEY 
    (Cerveza_cerveza_id) 
    REFERENCES Cerveza 
    ( 
     cerveza_id
    ) 
;

ALTER TABLE Cerveza_Presentacion 
    ADD CONSTRAINT Cerveza_Presentacion_Cerveza_FK FOREIGN KEY 
    ( 
     Cerveza_cerveza_id
    ) 
    REFERENCES Cerveza 
    ( 
     cerveza_id
    ) 
;
 
ALTER TABLE Cerveza_Presentacion 
    ADD CONSTRAINT Cerveza_Presentacion_Presentación_FK FOREIGN KEY 
    ( 
     Presentación_presentación_id
    ) 
    REFERENCES Presentación 
    ( 
     presentación_id
    ) 
;

ALTER TABLE Cerveza 
    ADD CONSTRAINT Cerveza_Tipo_Cerveza_FK FOREIGN KEY 
    ( 
     Tipo_Cerveza_tipo_cerveza_id
    ) 
    REFERENCES Tipo_Cerveza 
    ( 
     tipo_cerveza_id
    ) 
;

ALTER TABLE Cheque 
    ADD CONSTRAINT Cheque_Método_Pago_FK FOREIGN KEY 
    ( 
     método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;


ALTER TABLE Cliente_Punto 
    ADD CONSTRAINT Cliente_Punto_Cliente_FK FOREIGN KEY 
    ( 
     Cliente_RIF
    ) 
    REFERENCES Cliente 
    ( 
     RIF
    ) 
;

ALTER TABLE Cliente_Punto 
    ADD CONSTRAINT Cliente_Punto_Punto_FK FOREIGN KEY 
    ( 
     Punto_método_pago_id
    ) 
    REFERENCES Punto 
    ( 
     método_pago_id
    ) 
;

ALTER TABLE Compra_Estatus 
    ADD CONSTRAINT Compra_Estatus_Compra_FK FOREIGN KEY 
    ( 
     Compra_proveedor_id,
     Compra_compra_id
    ) 
    REFERENCES Compra 
    ( 
     Proveedor_proveedor_id,
     compra_id
    ) 
;

ALTER TABLE Compra_Estatus 
    ADD CONSTRAINT Compra_Estatus_Estatus_FK FOREIGN KEY 
    ( 
     Estatus_estatus_id
    ) 
    REFERENCES Estatus 
    ( 
     estatus_id
    ) 
;

ALTER TABLE Compra_Evento 
    ADD CONSTRAINT Compra_Evento_Cliente_FK FOREIGN KEY 
    ( 
     Cliente_RIF
    ) 
    REFERENCES Cliente 
    ( 
     RIF
    ) 
;

ALTER TABLE Compra_Evento 
    ADD CONSTRAINT Compra_Evento_Evento_FK FOREIGN KEY 
    ( 
     Evento_evento_id
    ) 
    REFERENCES Evento 
    ( 
     evento_id
    ) 
;

ALTER TABLE Compra 
    ADD CONSTRAINT Compra_Proveedor_FK FOREIGN KEY 
    ( 
     Proveedor_proveedor_id
    ) 
    REFERENCES Proveedor 
    ( 
     proveedor_id
    ) 
;

ALTER TABLE Compra 
    ADD CONSTRAINT Compra_TipoE_Departamento_FK FOREIGN KEY 
    ( 
     TipoE_Departamento_tipo_empleado_id,
     TipoE_Departamento_departamento_id,
     TipoE_Departamento_empleado_id
    ) 
    REFERENCES TipoE_Departamento 
    ( 
     Tipo_Empleado_tipo_empleado_id,
     Departamento_departamento_id,
     Empleado_empleado_id
    ) 
;

ALTER TABLE Correo_Electrónico 
    ADD CONSTRAINT Correo_Electrónico_Cliente_FK FOREIGN KEY 
    ( 
     Cliente_RIF
    ) 
    REFERENCES Cliente 
    ( 
     RIF
    ) 
;

ALTER TABLE Correo_Electrónico 
    ADD CONSTRAINT Correo_Electrónico_Empleado_FK FOREIGN KEY 
    ( 
     Empleado_empleado_id
    ) 
    REFERENCES Empleado 
    ( 
     empleado_id
    ) 
;
 
ALTER TABLE Correo_Electrónico 
    ADD CONSTRAINT Correo_Electrónico_Proveedor_FK FOREIGN KEY 
    ( 
     Proveedor_proveedor_id
    ) 
    REFERENCES Proveedor 
    ( 
     proveedor_id
    ) 
;

ALTER TABLE Crédito 
    ADD CONSTRAINT Crédito_Método_Pago_FK FOREIGN KEY 
    ( 
     método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;

ALTER TABLE Cuota 
    ADD CONSTRAINT Cuota_Proveedor_FK FOREIGN KEY 
    ( 
     Proveedor_proveedor_id
    ) 
    REFERENCES Proveedor 
    ( 
     proveedor_id
    ) 
;

ALTER TABLE Débito 
    ADD CONSTRAINT Débito_Método_Pago_FK FOREIGN KEY 
    ( 
     método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;

ALTER TABLE Descuento_Inventario 
    ADD CONSTRAINT Descuento_Inventario_Descuento_FK FOREIGN KEY 
    ( 
     Descuento_descuento_id
    ) 
    REFERENCES Descuento 
    ( 
     descuento_id
    ) 
;
 
ALTER TABLE Descuento_Inventario 
    ADD CONSTRAINT Descuento_Inventario_Inventario_FK FOREIGN KEY 
    ( 
     Inventario_inventario_id
    ) 
    REFERENCES Inventario 
    ( 
     inventario_id
    ) 
;

ALTER TABLE Detalle_Compra 
    ADD CONSTRAINT Detalle_Compra_Cerveza_Presentacion_FK FOREIGN KEY 
    ( 
     Cerveza_Presentacion_Cerveza_cerveza_id,
     Cerveza_Presentacion_Presentación_presentación_id
    ) 
    REFERENCES Cerveza_Presentacion 
    ( 
     Cerveza_cerveza_id,
     Presentación_presentación_id
    ) 
;

ALTER TABLE Detalle_Compra 
    ADD CONSTRAINT Detalle_Compra_Compra_FK FOREIGN KEY 
    ( 
     Compra_proveedor_id,
     Compra_compra_id
    ) 
    REFERENCES Compra 
    ( 
     Proveedor_proveedor_id,
     compra_id
    ) 
;

ALTER TABLE Detalle_Compra 
    ADD CONSTRAINT Detalle_Compra_Tasa_Cambio_FK FOREIGN KEY 
    ( 
     Tasa_Cambio_tasa_cambio_id
    ) 
    REFERENCES Tasa_Cambio 
    ( 
     tasa_cambio_id
    ) 
;

ALTER TABLE Detalle_Evento 
    ADD CONSTRAINT Detalle_Evento_Compra_Evento_FK FOREIGN KEY 
    ( 
     Compra_Evento_Cliente_RIF,
     Compra_Evento_Evento_evento_id
    ) 
    REFERENCES Compra_Evento 
    ( 
     Cliente_RIF,
     Evento_evento_id
    ) 
;

ALTER TABLE Detalle_Evento 
    ADD CONSTRAINT Detalle_Evento_Inventario_E_Cerveza_P_FK FOREIGN KEY 
    ( 
     Inventario_E_Cerveza_P_evento_id,
     Inventario_E_Cerveza_P_cerveza_id,
     Inventario_E_Cerveza_P_presentación_id
    ) 
    REFERENCES Inventario_E_Cerveza_P 
    ( 
     Evento_evento_id,
     Cerveza_Presentacion_Cerveza_cerveza_id,
     Cerveza_Presentacion_Presentación_presentación_id
    ) 
;

ALTER TABLE Detalle_Evento 
    ADD CONSTRAINT Detalle_Evento_Tasa_Cambio_FK FOREIGN KEY 
    ( 
     Tasa_Cambio_tasa_cambio_id
    ) 
    REFERENCES Tasa_Cambio 
    ( 
     tasa_cambio_id
    ) 
;

ALTER TABLE Detalle_Física 
    ADD CONSTRAINT Detalle_Física_Inventario_FK FOREIGN KEY 
    ( 
     Inventario_inventario_id
    ) 
    REFERENCES Inventario 
    ( 
     inventario_id
    ) 
;

ALTER TABLE Detalle_Física 
    ADD CONSTRAINT Detalle_Física_Tasa_Cambio_FK FOREIGN KEY 
    ( 
     Tasa_Cambio_tasa_cambio_id
    ) 
    REFERENCES Tasa_Cambio 
    ( 
     tasa_cambio_id
    ) 
;

ALTER TABLE Detalle_Física 
    ADD CONSTRAINT Detalle_Física_Venta_Física_FK FOREIGN KEY 
    ( 
     Venta_Física_tienda_fisica_id,
     Venta_Física_usuario_id,
     Venta_fisica_id
    ) 
    REFERENCES Venta_Física 
    ( 
     Tienda_Física_tienda_fisica_id,
     Usuario_usuario_id,
	 venta_id
    ) 
;




ALTER TABLE Detalle_Online 
    ADD CONSTRAINT Detalle_Online_Inventario_FK FOREIGN KEY 
    ( 
     Inventario_inventario_id
    ) 
    REFERENCES Inventario 
    ( 
     inventario_id
    ) 
;

ALTER TABLE Detalle_Online 
    ADD CONSTRAINT Detalle_Online_Tasa_Cambio_FK FOREIGN KEY 
    ( 
     Tasa_Cambio_tasa_cambio_id
    ) 
    REFERENCES Tasa_Cambio 
    ( 
     tasa_cambio_id
    ) 
;

ALTER TABLE Detalle_Online 
    ADD CONSTRAINT Detalle_Online_Venta_Online_FK FOREIGN KEY 
    ( 
     Venta_Online_tienda_online_id,
     Venta_Online_usuario_id,
     venta_online_id
    ) 
    REFERENCES Venta_Online 
    ( 
     Tienda_Online_tienda_online_id,
     Usuario_usuario_id,
     venta_id
    ) 
;
 
ALTER TABLE Detalle_VentaE 
    ADD CONSTRAINT Detalle_VentaE_Cerveza_Presentacion_FK FOREIGN KEY 
    ( 
     Cerveza_Presentacion_Cerveza_cerveza_id,
     Cerveza_Presentacion_Presentación_presentación_id
    ) 
    REFERENCES Cerveza_Presentacion 
    ( 
     Cerveza_cerveza_id,
     Presentación_presentación_id
    ) 
;

ALTER TABLE Detalle_VentaE 
    ADD CONSTRAINT Detalle_VentaE_Venta_Evento_FK FOREIGN KEY 
    ( 
     Venta_Evento_Proveedor_proveedor_id,
     Venta_Evento_Evento_evento_id
    ) 
    REFERENCES Venta_Evento 
    ( 
     Proveedor_proveedor_id,
     Evento_evento_id
    ) 
;

ALTER TABLE Efectivo 
    ADD CONSTRAINT Efectivo_Método_Pago_FK FOREIGN KEY 
    ( 
     método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;

ALTER TABLE Empleado_Beneficio 
    ADD CONSTRAINT Empleado_Beneficio_Beneficio_FK FOREIGN KEY 
    ( 
     Beneficio_beneficio_id
    ) 
    REFERENCES Beneficio 
    ( 
     beneficio_id
    ) 
;

ALTER TABLE Empleado_Beneficio 
    ADD CONSTRAINT Empleado_Beneficio_Empleado_FK FOREIGN KEY 
    ( 
     Empleado_empleado_id
    ) 
    REFERENCES Empleado 
    ( 
     empleado_id
    ) 
;

ALTER TABLE Entrada_Evento 
    ADD CONSTRAINT Entrada_Evento_Evento_FK FOREIGN KEY 
    ( 
     Evento_evento_id
    ) 
    REFERENCES Evento 
    ( 
     evento_id
    ) 
;

ALTER TABLE Entrada_Evento 
    ADD CONSTRAINT Entrada_Evento_Venta_Entrada_FK FOREIGN KEY 
    ( 
     Venta_Entrada_Cliente_RIF,
     Venta_Entrada_Evento_evento_id,
     Venta_Entrada_venta_entrada_id
    ) 
    REFERENCES Venta_Entrada 
    ( 
     Cliente_RIF,
     Evento_evento_id,
     venta_entrada_id
    ) 
;

ALTER TABLE Evento 
    ADD CONSTRAINT Evento_Lugar_FK FOREIGN KEY 
    ( 
     Lugar_lugar_id
    ) 
    REFERENCES Lugar 
    ( 
     lugar_id
    ) 
;

ALTER TABLE Evento 
    ADD CONSTRAINT Evento_Tipo_Evento_FK FOREIGN KEY 
    ( 
     Tipo_Evento_tipo_evento_id
    ) 
    REFERENCES Tipo_Evento 
    ( 
     tipo_evento_id
    ) 
;

ALTER TABLE Ingrediente 
    ADD CONSTRAINT Ingrediente_Ingrediente_FK FOREIGN KEY 
    ( 
     Ingrediente_ingrediente_id
    ) 
    REFERENCES Ingrediente 
    ( 
     ingrediente_id
    ) 
;

ALTER TABLE Instruccion_Receta 
    ADD CONSTRAINT Instruccion_Receta_Instruccion_FK FOREIGN KEY 
    ( 
     Instruccion_instruccion_id
    ) 
    REFERENCES Instruccion 
    ( 
     instruccion_id
    ) 
;

ALTER TABLE Instruccion_Receta 
    ADD CONSTRAINT Instruccion_Receta_Receta_FK FOREIGN KEY 
    ( 
     Receta_receta_id
    ) 
    REFERENCES Receta 
    ( 
     receta_id
    ) 
;

ALTER TABLE Inventario 
    ADD CONSTRAINT Inventario_Cerveza_Presentacion_FK FOREIGN KEY 
    ( 
     Cerveza_Presentacion_Cerveza_cerveza_id,
     Cerveza_Presentacion_Presentación_presentación_id
    ) 
    REFERENCES Cerveza_Presentacion 
    ( 
     Cerveza_cerveza_id,
     Presentación_presentación_id
    ) 
;

ALTER TABLE Inventario_E_Cerveza_P 
    ADD CONSTRAINT Inventario_E_Cerveza_P_Cerveza_Presentacion_FK FOREIGN KEY 
    ( 
     Cerveza_Presentacion_Cerveza_cerveza_id,
     Cerveza_Presentacion_Presentación_presentación_id
    ) 
    REFERENCES Cerveza_Presentacion 
    ( 
     Cerveza_cerveza_id,
     Presentación_presentación_id
    ) 
;

ALTER TABLE Inventario_E_Cerveza_P 
    ADD CONSTRAINT Inventario_E_Cerveza_P_Evento_FK FOREIGN KEY 
    ( 
     Evento_evento_id
    ) 
    REFERENCES Evento 
    ( 
     evento_id
    ) 
;

ALTER TABLE Inventario 
    ADD CONSTRAINT Inventario_Tienda_Online_FK FOREIGN KEY 
    ( 
     Tienda_Online_tienda_online_id
    ) 
    REFERENCES Tienda_Online 
    ( 
     tienda_online_id
    ) 
;

ALTER TABLE Juez_Evento 
    ADD CONSTRAINT Juez_Evento_Evento_FK FOREIGN KEY 
    ( 
     Evento_evento_id
    ) 
    REFERENCES Evento 
    ( 
     evento_id
    ) 
;

ALTER TABLE Juez_Evento 
    ADD CONSTRAINT Juez_Evento_Juez_FK FOREIGN KEY 
    ( 
     Juez_juez_id
    ) 
    REFERENCES Juez 
    ( 
     juez_id
    ) 
;

ALTER TABLE Jurídico 
    ADD CONSTRAINT Jurídico_Cliente_FK FOREIGN KEY 
    ( 
     RIF
    ) 
    REFERENCES Cliente 
    ( 
     RIF
    ) 
;

ALTER TABLE Jurídico 
    ADD CONSTRAINT Jurídico_Lugar_FK FOREIGN KEY 
    ( 
     Lugar_lugar_id
    ) 
    REFERENCES Lugar 
    ( 
     lugar_id
    ) 
;

ALTER TABLE Jurídico 
    ADD CONSTRAINT Jurídico_Lugar_FKv2 FOREIGN KEY 
    ( 
     Lugar_lugar_id2
    ) 
    REFERENCES Lugar 
    ( 
     lugar_id
    ) 
;

ALTER TABLE Lugar 
    ADD CONSTRAINT Lugar_Lugar_FK FOREIGN KEY 
    ( 
     Lugar_lugar_id
    ) 
    REFERENCES Lugar 
    ( 
     lugar_id
    ) 
;

ALTER TABLE Lugar_Tienda 
    ADD CONSTRAINT Lugar_Tienda_Inventario_FK FOREIGN KEY 
    ( 
     Inventario_inventario_id
    ) 
    REFERENCES Inventario 
    ( 
     inventario_id
    ) 
;


ALTER TABLE Lugar_Tienda 
    ADD CONSTRAINT Lugar_Tienda_Lugar_Tienda_FK FOREIGN KEY 
    ( 
     Lugar_Tienda_Tienda_Física_tienda_fisica_id,
     Lugar_Tienda_lugar_tienda_id
    ) 
    REFERENCES Lugar_Tienda 
    ( 
     Tienda_Física_tienda_fisica_id,
     lugar_tienda_id
    ) 
;

ALTER TABLE Lugar_Tienda 
    ADD CONSTRAINT Lugar_Tienda_Tienda_Física_FK FOREIGN KEY 
    ( 
     Tienda_Física_tienda_fisica_id
    ) 
    REFERENCES Tienda_Física 
    ( 
     tienda_fisica_id
    ) 
;

ALTER TABLE PersonaNatural 
    ADD CONSTRAINT PersonaNatural_Cliente_FK FOREIGN KEY 
    ( 
     RIF
    ) 
    REFERENCES Cliente 
    ( 
     RIF
    ) 
;

ALTER TABLE PersonaNatural 
    ADD CONSTRAINT PersonaNatural_Lugar_FK FOREIGN KEY 
    ( 
     Lugar_lugar_id
    ) 
    REFERENCES Lugar 
    ( 
     lugar_id
    ) 
;

ALTER TABLE Orden_Reposición 
    ADD CONSTRAINT Orden_Reposición_Tienda_Física_FK FOREIGN KEY 
    ( 
     Tienda_Física_tienda_fisica_id
    ) 
    REFERENCES Tienda_Física 
    ( 
     tienda_fisica_id
    ) 
;

ALTER TABLE Orden_Reposición 
    ADD CONSTRAINT Orden_Reposición_TipoE_Departamento_FK FOREIGN KEY 
    ( 
     TipoE_Departamento_tipo_empleado_id,
     TipoE_Departamento_departamento_id,
     TipoE_Departamento_empleado_id
    ) 
    REFERENCES TipoE_Departamento 
    ( 
     Tipo_Empleado_tipo_empleado_id,
     Departamento_departamento_id,
     Empleado_empleado_id
    ) 
;

ALTER TABLE OrdenR_Estatus 
    ADD CONSTRAINT OrdenR_Estatus_Estatus_FK FOREIGN KEY 
    ( 
     Estatus_estatus_id
    ) 
    REFERENCES Estatus 
    ( 
     estatus_id
    ) 
;

ALTER TABLE OrdenR_Estatus 
    ADD CONSTRAINT OrdenR_Estatus_Orden_Reposición_FK FOREIGN KEY 
    ( 
     Orden_Reposición_orden_reposición_id
    ) 
    REFERENCES Orden_Reposición 
    ( 
     orden_reposición_id
    ) 
;

ALTER TABLE Pago_Compra_Evento 
    ADD CONSTRAINT Pago_Compra_Evento_Compra_Evento_FK FOREIGN KEY 
    ( 
     Compra_Evento_Cliente_RIF,
     Compra_Evento_Evento_evento_id
    ) 
    REFERENCES Compra_Evento 
    ( 
     Cliente_RIF,
     Evento_evento_id
    ) 
;

ALTER TABLE Pago_Compra_Evento 
    ADD CONSTRAINT Pago_Compra_Evento_Método_Pago_FK FOREIGN KEY 
    ( 
     Método_Pago_método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;

ALTER TABLE Pago_CompraP 
    ADD CONSTRAINT Pago_CompraP_Compra_FK FOREIGN KEY 
    ( 
     Compra_proveedor_id,
     Compra_compra_id
    ) 
    REFERENCES Compra 
    ( 
     Proveedor_proveedor_id,
     compra_id
    ) 
;

ALTER TABLE Pago_CompraP 
    ADD CONSTRAINT Pago_CompraP_Método_Pago_FK FOREIGN KEY 
    ( 
     Método_Pago_método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;

ALTER TABLE Pago_Cuota 
    ADD CONSTRAINT Pago_Cuota_Cuota_FK FOREIGN KEY 
    ( 
     Cuota_cuota_id
    ) 
    REFERENCES Cuota 
    ( 
     cuota_id
    ) 
;

ALTER TABLE Pago_Cuota 
    ADD CONSTRAINT Pago_Cuota_Método_Pago_FK FOREIGN KEY 
    ( 
     Método_Pago_método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;

ALTER TABLE Pago_Entrada 
    ADD CONSTRAINT Pago_Entrada_Método_Pago_FK FOREIGN KEY 
    ( 
     Método_Pago_método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;

ALTER TABLE Pago_Entrada 
    ADD CONSTRAINT Pago_Entrada_Venta_Entrada_FK FOREIGN KEY 
    ( 
     Venta_Entrada_Cliente_RIF,
     Venta_Entrada_Evento_evento_id,
     Venta_Entrada_venta_entrada_id
    ) 
    REFERENCES Venta_Entrada 
    ( 
     Cliente_RIF,
     Evento_evento_id,
     venta_entrada_id
    ) 
;

ALTER TABLE Pago_Fisica 
    ADD CONSTRAINT Pago_Fisica_Método_Pago_FK FOREIGN KEY 
    ( 
     Método_Pago_método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;

ALTER TABLE Pago_Fisica 
    ADD CONSTRAINT Pago_Fisica_Venta_Física_FK FOREIGN KEY 
    ( 
     Venta_Física_tienda_fisica_id,
     Venta_Física_usuario_id,
	 Venta_fisica_id
    ) 
    REFERENCES Venta_Física 
    ( 
     Tienda_Física_tienda_fisica_id,
     Usuario_usuario_id,
	 Venta_id
    ) 
;

ALTER TABLE Pago_Online 
    ADD CONSTRAINT Pago_Online_Método_Pago_FK FOREIGN KEY 
    ( 
     Método_Pago_método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;

ALTER TABLE Pago_Online 
    ADD CONSTRAINT Pago_Online_Venta_Online_FK FOREIGN KEY 
    ( 
     Venta_Online_tienda_online_id,
     Venta_Online_usuario_id,
	venta_online_id
    ) 
    REFERENCES Venta_Online 
    ( 
     Tienda_Online_tienda_online_id,
     Usuario_usuario_id,
	venta_id
    ) 
;

ALTER TABLE Persona_Contacto 
    ADD CONSTRAINT Persona_Contacto_Jurídico_FK FOREIGN KEY 
    ( 
     Jurídico_RIF
    ) 
    REFERENCES Jurídico 
    ( 
     RIF
    ) 
;

ALTER TABLE Persona_Contacto 
    ADD CONSTRAINT Persona_Contacto_Proveedor_FK FOREIGN KEY 
    ( 
     Proveedor_proveedor_id
    ) 
    REFERENCES Proveedor 
    ( 
     proveedor_id
    ) 
;

ALTER TABLE Proveedor 
    ADD CONSTRAINT Proveedor_Lugar_FK FOREIGN KEY 
    ( 
     Lugar_lugar_id
    ) 
    REFERENCES Lugar 
    ( 
     lugar_id
    ) 
;

ALTER TABLE Proveedor 
    ADD CONSTRAINT Proveedor_Lugar_FKv2 FOREIGN KEY 
    ( 
     Lugar_lugar_id2
    ) 
    REFERENCES Lugar 
    ( 
     lugar_id
    ) 
;

ALTER TABLE Punto 
    ADD CONSTRAINT Punto_Método_Pago_FK FOREIGN KEY 
    ( 
     método_pago_id
    ) 
    REFERENCES Método_Pago 
    ( 
     método_pago_id
    ) 
;
 
ALTER TABLE Receta_Ingrediente 
    ADD CONSTRAINT Receta_Ingrediente_Ingrediente_FK FOREIGN KEY 
    ( 
     Ingrediente_ingrediente_id
    ) 
    REFERENCES Ingrediente 
    ( 
     ingrediente_id
    ) 
;

ALTER TABLE Receta_Ingrediente 
    ADD CONSTRAINT Receta_Ingrediente_Receta_FK FOREIGN KEY 
    ( 
     Receta_receta_id
    ) 
    REFERENCES Receta 
    ( 
     receta_id
    ) 
;


ALTER TABLE Rol_Permiso 
    ADD CONSTRAINT Rol_Permiso_Permiso_FK FOREIGN KEY 
    ( 
     Permiso_permiso_id
    ) 
    REFERENCES Permiso 
    ( 
     permiso_id
    ) 
;

ALTER TABLE Rol_Permiso 
    ADD CONSTRAINT Rol_Permiso_Rol_FK FOREIGN KEY 
    ( 
     Rol_rol_id
    ) 
    REFERENCES Rol 
    ( 
     rol_id
    ) 
;

ALTER TABLE Rol_Privilegio 
    ADD CONSTRAINT Rol_Privilegio_Privilegio_FK FOREIGN KEY 
    ( 
     Privilegio_privilegio_id
    ) 
    REFERENCES Privilegio 
    ( 
     privilegio_id
    ) 
;

ALTER TABLE Rol_Privilegio 
    ADD CONSTRAINT Rol_Privilegio_Rol_FK FOREIGN KEY 
    ( 
     Rol_rol_id
    ) 
    REFERENCES Rol 
    ( 
     rol_id
    ) 
;

ALTER TABLE Teléfono 
    ADD CONSTRAINT Teléfono_Cliente_FK FOREIGN KEY 
    ( 
     Cliente_RIF
    ) 
    REFERENCES Cliente 
    ( 
     RIF
    ) 
;

ALTER TABLE Teléfono 
    ADD CONSTRAINT Teléfono_Empleado_FK FOREIGN KEY 
    ( 
     Empleado_empleado_id
    ) 
    REFERENCES Empleado 
    ( 
     empleado_id
    ) 
;

ALTER TABLE Teléfono 
    ADD CONSTRAINT Teléfono_Proveedor_FK FOREIGN KEY 
    ( 
     Proveedor_proveedor_id
    ) 
    REFERENCES Proveedor 
    ( 
     proveedor_id
    ) 
;

ALTER TABLE Tienda_Física 
    ADD CONSTRAINT Tienda_Física_Lugar_FK FOREIGN KEY 
    ( 
     Lugar_lugar_id
    ) 
    REFERENCES Lugar 
    ( 
     lugar_id
    ) 
;


ALTER TABLE Tipo_Cerveza_Caracteristica 
    ADD CONSTRAINT Tipo_Cerveza_Caracteristica_Característica_FK FOREIGN KEY 
    ( 
     Característica_característica_id
    ) 
    REFERENCES Característica 
    ( 
     característica_id
    ) 
;
 
ALTER TABLE Tipo_Cerveza_Caracteristica 
    ADD CONSTRAINT Tipo_Cerveza_Caracteristica_Tipo_Cerveza_FK FOREIGN KEY 
    ( 
     Tipo_Cerveza_tipo_cerveza_id
    ) 
    REFERENCES Tipo_Cerveza 
    ( 
     tipo_cerveza_id
    ) 
;

ALTER TABLE Tipo_Cerveza 
    ADD CONSTRAINT Tipo_Cerveza_Proveedor_FK FOREIGN KEY 
    ( 
     Proveedor_proveedor_id
    ) 
    REFERENCES Proveedor 
    ( 
     proveedor_id
    ) 
;

ALTER TABLE Tipo_Cerveza 
    ADD CONSTRAINT Tipo_Cerveza_Receta_FK FOREIGN KEY 
    ( 
     Receta_receta_id
    ) 
    REFERENCES Receta 
    ( 
     receta_id
    ) 
;

ALTER TABLE Tipo_Cerveza 
    ADD CONSTRAINT Tipo_Cerveza_Tipo_Cerveza_FK FOREIGN KEY 
    ( 
     Tipo_Cerveza_tipo_cerveza_id
    ) 
    REFERENCES Tipo_Cerveza 
    ( 
     tipo_cerveza_id
    ) 
;

ALTER TABLE Tipo_Empleado 
    ADD CONSTRAINT Tipo_Empleado_Tipo_Empleado_FK FOREIGN KEY 
    ( 
     Tipo_Empleado_tipo_empleado_id
    ) 
    REFERENCES Tipo_Empleado 
    ( 
     tipo_empleado_id
    ) 
;

ALTER TABLE Tipo_Evento 
    ADD CONSTRAINT Tipo_Evento_Tipo_Evento_FK FOREIGN KEY 
    ( 
     Tipo_Evento_tipo_evento_id
    ) 
    REFERENCES Tipo_Evento 
    ( 
     tipo_evento_id
    ) 
;

ALTER TABLE TipoE_Departamento 
    ADD CONSTRAINT TipoE_Departamento_Departamento_FK FOREIGN KEY 
    ( 
     Departamento_departamento_id
    ) 
    REFERENCES Departamento 
    ( 
     departamento_id
    ) 
;

ALTER TABLE TipoE_Departamento 
    ADD CONSTRAINT TipoE_Departamento_Empleado_FK FOREIGN KEY 
    ( 
     Empleado_empleado_id
    ) 
    REFERENCES Empleado 
    ( 
     empleado_id
    ) 
;


ALTER TABLE TipoE_Departamento 
    ADD CONSTRAINT TipoE_Departamento_Tipo_Empleado_FK FOREIGN KEY 
    ( 
     Tipo_Empleado_tipo_empleado_id
    ) 
    REFERENCES Tipo_Empleado 
    ( 
     tipo_empleado_id
    ) 
;

ALTER TABLE TipoED_Horario 
    ADD CONSTRAINT TipoED_Horario_Horario_FK FOREIGN KEY 
    ( 
     Horario_horario_id
    ) 
    REFERENCES Horario 
    ( 
     horario_id
    ) 
;

ALTER TABLE TipoED_Horario 
    ADD CONSTRAINT TipoED_Horario_TipoE_Departamento_FK FOREIGN KEY 
    ( 
     TipoE_Departamento_Tipo_Empleado_tipo_empleado_id,
     TipoE_Departamento_Departamento_departamento_id,
     TipoE_Departamento_Empleado_empleado_id
    ) 
    REFERENCES TipoE_Departamento 
    ( 
     Tipo_Empleado_tipo_empleado_id,
     Departamento_departamento_id,
     Empleado_empleado_id
    ) 
;

ALTER TABLE Usuario 
    ADD CONSTRAINT Usuario_Cliente_FK FOREIGN KEY 
    ( 
     Cliente_RIF
    ) 
    REFERENCES Cliente 
    ( 
     RIF
    ) 
;

ALTER TABLE Usuario 
    ADD CONSTRAINT Usuario_Empleado_FK FOREIGN KEY 
    ( 
     Empleado_empleado_id
    ) 
    REFERENCES Empleado 
    ( 
     empleado_id
    ) 
;

ALTER TABLE Usuario 
    ADD CONSTRAINT Usuario_Proveedor_FK FOREIGN KEY 
    ( 
     Proveedor_proveedor_id
    ) 
    REFERENCES Proveedor 
    ( 
     proveedor_id
    ) 
;

ALTER TABLE Usuario 
    ADD CONSTRAINT Usuario_Rol_FK FOREIGN KEY 
    ( 
     Rol_rol_id
    ) 
    REFERENCES Rol 
    ( 
     rol_id
    ) 
;

ALTER TABLE Vacación 
    ADD CONSTRAINT Vacación_Empleado_FK FOREIGN KEY 
    ( 
     Empleado_empleado_id
    ) 
    REFERENCES Empleado 
    ( 
     empleado_id
    ) 
;

ALTER TABLE Vacacion_Estatus 
    ADD CONSTRAINT Vacacion_Estatus_Estatus_FK FOREIGN KEY 
    ( 
     Estatus_estatus_id
    ) 
    REFERENCES Estatus 
    ( 
     estatus_id
    ) 
;

ALTER TABLE Vacacion_Estatus 
    ADD CONSTRAINT Vacacion_Estatus_Vacación_FK FOREIGN KEY 
    ( 
     Vacación_vacación_id
    ) 
    REFERENCES Vacación 
    ( 
     vacación_id
    ) 
;

ALTER TABLE Venta_Entrada 
    ADD CONSTRAINT Venta_Entrada_Cliente_FK FOREIGN KEY 
    ( 
     Cliente_RIF
    ) 
    REFERENCES Cliente 
    ( 
     RIF
    ) 
;

ALTER TABLE Venta_Entrada 
    ADD CONSTRAINT Venta_Entrada_Evento_FK FOREIGN KEY 
    ( 
     Evento_evento_id
    ) 
    REFERENCES Evento 
    ( 
     evento_id
    ) 
;

ALTER TABLE Venta_Evento 
    ADD CONSTRAINT Venta_Evento_Evento_FK FOREIGN KEY 
    ( 
     Evento_evento_id
    ) 
    REFERENCES Evento 
    ( 
     evento_id
    ) 
;

ALTER TABLE Venta_Evento 
    ADD CONSTRAINT Venta_Evento_Proveedor_FK FOREIGN KEY 
    ( 
     Proveedor_proveedor_id
    ) 
    REFERENCES Proveedor 
    ( 
     proveedor_id
    ) 
;

ALTER TABLE Venta_Física 
    ADD CONSTRAINT Venta_Física_Tienda_Física_FK FOREIGN KEY 
    ( 
     Tienda_Física_tienda_fisica_id
    ) 
    REFERENCES Tienda_Física 
    ( 
     tienda_fisica_id
    ) 
;

ALTER TABLE Venta_Física 
    ADD CONSTRAINT Venta_Física_Usuario_FK FOREIGN KEY 
    ( 
     Usuario_usuario_id
    ) 
    REFERENCES Usuario 
    ( 
     usuario_id
    ) 
;

ALTER TABLE Venta_Online 
    ADD CONSTRAINT Venta_Online_Tienda_Online_FK FOREIGN KEY 
    ( 
     Tienda_Online_tienda_online_id
    ) 
    REFERENCES Tienda_Online 
    ( 
     tienda_online_id
    ) 
;

ALTER TABLE Venta_Online 
    ADD CONSTRAINT Venta_Online_Usuario_FK FOREIGN KEY 
    ( 
     Usuario_usuario_id
    ) 
    REFERENCES Usuario 
    ( 
     usuario_id
    ) 
;

ALTER TABLE VentaF_Estatus 
    ADD CONSTRAINT VentaF_Estatus_Estatus_FK FOREIGN KEY 
    ( 
     Estatus_estatus_id
    ) 
    REFERENCES Estatus 
    ( 
     estatus_id
    ) 
;

ALTER TABLE VentaF_Estatus 
    ADD CONSTRAINT VentaF_Estatus_Venta_Física_FK FOREIGN KEY 
    ( 
     Venta_Física_Tienda_Física_tienda_fisica_id,
     Venta_Física_Usuario_usuario_id,
	 Venta_fisica_id
    ) 
    REFERENCES Venta_Física 
    ( 
     Tienda_Física_tienda_fisica_id,
     Usuario_usuario_id,
	 venta_id
    ) 
;

ALTER TABLE VentaO_Estatus 
    ADD CONSTRAINT VentaO_Estatus_Estatus_FK FOREIGN KEY 
    ( 
     Estatus_estatus_id
    ) 
    REFERENCES Estatus 
    ( 
     estatus_id
    ) 
;

ALTER TABLE VentaO_Estatus 
    ADD CONSTRAINT VentaO_Estatus_Venta_Online_FK FOREIGN KEY 
    ( 
     Venta_Online_Tienda_Online_tienda_online_id,
     Venta_Online_Usuario_usuario_id,
	venta_online_id
    ) 
    REFERENCES Venta_Online 
    ( 
     Tienda_Online_tienda_online_id,
     Usuario_usuario_id,
	venta_id
    ) 
;


-- Agregar la nueva columna para la tienda física
ALTER TABLE Inventario 
ADD COLUMN Tienda_Física_tienda_fisica_id INTEGER NOT NULL;

-- Establecer la relación con Tienda_Física
ALTER TABLE Inventario
ADD CONSTRAINT Inventario_Tienda_Física_FK FOREIGN KEY (Tienda_Física_tienda_fisica_id) 
REFERENCES Tienda_Física (tienda_fisica_id);


