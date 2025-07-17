import pg from 'pg';
const { Pool } = pg;

const pool = new Pool({
    host: 'localhost',
    port: 5432,
    database: 'ACAUCAB',
    user: 'postgres',
    password: '1234'
});

async function fixTriggers() {
    try {
        console.log('🔧 Verificando y corrigiendo triggers de puntos...');

        // 1. Verificar triggers existentes
        const triggers = await pool.query(`
            SELECT trigger_name, event_manipulation, event_object_table 
            FROM information_schema.triggers 
            WHERE trigger_name LIKE '%puntos%'
        `);
        console.log('📊 Triggers existentes:', triggers.rows);

        // 2. Eliminar triggers problemáticos
        console.log('🗑️ Eliminando triggers problemáticos...');
        await pool.query('DROP TRIGGER IF EXISTS trigger_actualizar_puntos ON Pago_Fisica');
        await pool.query('DROP TRIGGER IF EXISTS trigger_actualizar_puntos_online ON Pago_Online');
        await pool.query('DROP FUNCTION IF EXISTS actualizar_puntos_cliente()');
        await pool.query('DROP FUNCTION IF EXISTS actualizar_puntos_cliente_online()');
        console.log('✅ Triggers eliminados');

        // 3. Crear nueva función para pagos físicos
        console.log('🔧 Creando nueva función para pagos físicos...');
        await pool.query(`
            CREATE OR REPLACE FUNCTION actualizar_puntos_cliente()
            RETURNS TRIGGER AS $$
            DECLARE
                v_cliente_rif INTEGER;
            BEGIN
                -- Buscar el RIF del cliente a partir del usuario
                SELECT cliente_rif INTO v_cliente_rif
                FROM usuario
                WHERE usuario_id = NEW.venta_física_usuario_id;

                IF v_cliente_rif IS NOT NULL THEN
                    UPDATE cliente_punto
                    SET cantidad_puntos = cantidad_puntos + (NEW.monto_pagado / 100)
                    WHERE cliente_rif = v_cliente_rif;
                END IF;

                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;
        `);

        // 4. Crear trigger para pagos físicos
        await pool.query(`
            CREATE TRIGGER trigger_actualizar_puntos
            AFTER INSERT ON Pago_Fisica
            FOR EACH ROW EXECUTE FUNCTION actualizar_puntos_cliente();
        `);

        // 5. Crear nueva función para pagos online
        console.log('🔧 Creando nueva función para pagos online...');
        await pool.query(`
            CREATE OR REPLACE FUNCTION actualizar_puntos_cliente_online()
            RETURNS TRIGGER AS $$
            DECLARE
                v_cliente_rif INTEGER;
            BEGIN
                -- Buscar el RIF del cliente a partir del usuario
                SELECT cliente_rif INTO v_cliente_rif
                FROM usuario
                WHERE usuario_id = NEW.venta_online_usuario_id;

                IF v_cliente_rif IS NOT NULL THEN
                    UPDATE cliente_punto
                    SET cantidad_puntos = cantidad_puntos + (NEW.monto_pagado / 100)
                    WHERE cliente_rif = v_cliente_rif;
                END IF;

                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;
        `);

        // 6. Crear trigger para pagos online
        await pool.query(`
            CREATE TRIGGER trigger_actualizar_puntos_online
            AFTER INSERT ON Pago_Online
            FOR EACH ROW EXECUTE FUNCTION actualizar_puntos_cliente_online();
        `);

        console.log('✅ Triggers corregidos exitosamente');

        // 7. Verificar triggers corregidos
        const newTriggers = await pool.query(`
            SELECT trigger_name, event_manipulation, event_object_table 
            FROM information_schema.triggers 
            WHERE trigger_name LIKE '%puntos%'
        `);
        console.log('📊 Triggers corregidos:', newTriggers.rows);

    } catch (error) {
        console.error('❌ Error corrigiendo triggers:', error.message);
    } finally {
        await pool.end();
    }
}

fixTriggers(); 