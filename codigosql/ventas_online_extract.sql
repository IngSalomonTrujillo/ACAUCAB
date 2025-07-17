-- EXTRACTO: Estructura y lógica para ventas online

-- 1. TABLA Venta_Online
DROP TABLE IF EXISTS Venta_Online CASCADE;
CREATE TABLE Venta_Online (
  venta_id SERIAL NOT NULL,
  Tienda_Online_tienda_online_id INTEGER NOT NULL,
  Usuario_usuario_id INTEGER NOT NULL,
  fecha_hora_venta TIMESTAMP WITH TIME ZONE NOT NULL,
  monto_total decimal NOT NULL
);
ALTER TABLE Venta_Online ADD CONSTRAINT Venta_Online_PK PRIMARY KEY (venta_id, Tienda_Online_tienda_online_id, Usuario_usuario_id);
ALTER TABLE Venta_Online ADD CONSTRAINT Venta_Online_Tienda_Online_FK FOREIGN KEY (Tienda_Online_tienda_online_id) REFERENCES Tienda_Online (tienda_online_id);
ALTER TABLE Venta_Online ADD CONSTRAINT Venta_Online_Usuario_FK FOREIGN KEY (Usuario_usuario_id) REFERENCES Usuario (usuario_id);

-- 2. TABLA Pago_Online
DROP TABLE IF EXISTS Pago_Online CASCADE;
CREATE TABLE Pago_Online (
  venta_online_id Integer NOT NULL,
  Método_Pago_método_pago_id INTEGER NOT NULL,
  fecha_pago DATE NOT NULL,
  monto_pagado decimal NOT NULL,
  referencia_pago VARCHAR(50) NOT NULL,
  Venta_Online_tienda_online_id INTEGER NOT NULL,
  Venta_Online_usuario_id INTEGER NOT NULL,
  puntos_usados INTEGER
);
ALTER TABLE Pago_Online ADD CONSTRAINT Pago_Online_PK PRIMARY KEY (venta_online_id, Método_Pago_método_pago_id, Venta_Online_tienda_online_id, Venta_Online_usuario_id);
ALTER TABLE Pago_Online ADD CONSTRAINT Pago_Online_Método_Pago_FK FOREIGN KEY (Método_Pago_método_pago_id) REFERENCES Método_Pago (método_pago_id);
ALTER TABLE Pago_Online ADD CONSTRAINT Pago_Online_Venta_Online_FK FOREIGN KEY (Venta_Online_tienda_online_id, Venta_Online_usuario_id, venta_online_id) REFERENCES Venta_Online (Tienda_Online_tienda_online_id, Usuario_usuario_id, venta_id);

-- 3. TABLA Detalle_Online
DROP TABLE IF EXISTS Detalle_Online CASCADE;
CREATE TABLE Detalle_Online (
  venta_online_id Integer NOT NULL,
  precio_unitario decimal NOT NULL,
  cantidad INTEGER NOT NULL,
  Venta_Online_tienda_online_id INTEGER NOT NULL,
  Venta_Online_usuario_id INTEGER NOT NULL,
  Tasa_Cambio_tasa_cambio_id INTEGER NOT NULL,
  Inventario_inventario_id INTEGER NOT NULL
);
ALTER TABLE Detalle_Online ADD CONSTRAINT Detalle_Online_PK PRIMARY KEY (venta_online_id, Inventario_inventario_id, Venta_Online_tienda_online_id, Venta_Online_usuario_id);
ALTER TABLE Detalle_Online ADD CONSTRAINT Detalle_Online_Inventario_FK FOREIGN KEY (Inventario_inventario_id) REFERENCES Inventario (inventario_id);
ALTER TABLE Detalle_Online ADD CONSTRAINT Detalle_Online_Tasa_Cambio_FK FOREIGN KEY (Tasa_Cambio_tasa_cambio_id) REFERENCES Tasa_Cambio (tasa_cambio_id);
ALTER TABLE Detalle_Online ADD CONSTRAINT Detalle_Online_Venta_Online_FK FOREIGN KEY (Venta_Online_tienda_online_id, Venta_Online_usuario_id, venta_online_id) REFERENCES Venta_Online (Tienda_Online_tienda_online_id, Usuario_usuario_id, venta_id);

-- 4. TABLA VentaO_Estatus
DROP TABLE IF EXISTS VentaO_Estatus CASCADE;
CREATE TABLE VentaO_Estatus (
  venta_online_id INTEGER NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE,
  Venta_Online_Tienda_Online_tienda_online_id INTEGER NOT NULL,
  Venta_Online_Usuario_usuario_id INTEGER NOT NULL,
  Estatus_estatus_id INTEGER NOT NULL
);
ALTER TABLE VentaO_Estatus ADD CONSTRAINT VentaO_Estatus_PK PRIMARY KEY (venta_online_id, Venta_Online_Tienda_Online_tienda_online_id, Venta_Online_Usuario_usuario_id, Estatus_estatus_id);
ALTER TABLE VentaO_Estatus ADD CONSTRAINT VentaO_Estatus_Estatus_FK FOREIGN KEY (Estatus_estatus_id) REFERENCES Estatus (estatus_id);
ALTER TABLE VentaO_Estatus ADD CONSTRAINT VentaO_Estatus_Venta_Online_FK FOREIGN KEY (Venta_Online_Tienda_Online_tienda_online_id, Venta_Online_Usuario_usuario_id, venta_online_id) REFERENCES Venta_Online (Tienda_Online_tienda_online_id, Usuario_usuario_id, venta_id);

-- 5. CAMPO NUEVO EN INVENTARIO (si no existe)
ALTER TABLE Inventario ADD COLUMN IF NOT EXISTS Tienda_Online_tienda_online_id INTEGER;
ALTER TABLE Inventario ADD CONSTRAINT IF NOT EXISTS Inventario_Tienda_Online_FK FOREIGN KEY (Tienda_Online_tienda_online_id) REFERENCES Tienda_Online (tienda_online_id);

-- 6. PROCEDIMIENTOS Y TRIGGERS PARA VENTAS ONLINE
-- (Pega aquí los CREATE OR REPLACE PROCEDURE/FUNCTION/TRIGGER de tu compañero)
-- Ejemplo:
-- CREATE OR REPLACE PROCEDURE registrar_venta_tienda_online(...)
-- ...
-- CREATE OR REPLACE PROCEDURE P_actualizar_venta_online_estatus(...)
-- ...
-- CREATE OR REPLACE FUNCTION F_trigger_venta_online_estatus()
-- ...
-- CREATE TRIGGER T_after_insert_venta_online ...

-- (Recuerda pegar los procedimientos y triggers completos que ya tienes) 