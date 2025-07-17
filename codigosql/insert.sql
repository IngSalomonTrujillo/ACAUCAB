-- 1. Tabla Beneficio
INSERT INTO Beneficio (nombre_beneficio, descripción_beneficio) VALUES
('Seguro médico', 'Cobertura médica completa para el empleado'),
('Vale de comida', 'Vale diario para comida en restaurantes afiliados'),
('Bonificación anual', 'Bonificación equivalente a un mes de salario'),
('Días libres', 'Días adicionales de vacaciones'),
('Capacitación', 'Cursos y talleres de desarrollo profesional');

-- 2. Tabla Característica
INSERT INTO Característica (nombre_característica, descripción_caracteristica) VALUES
('Amargor', 'Nivel de amargor de la cerveza en IBUs'),
('Alcohol', 'Porcentaje de alcohol por volumen'),
('Color', 'Color de la cerveza en SRM'),
('Aroma', 'Notas aromáticas principales'),
('Cuerpo', 'Textura y sensación en boca');

-- 3. Tabla Departamento
INSERT INTO Departamento (nombre_departamento) VALUES
('Ventas'),
('Compras'),
('Logística'),
('Marketing'),
('Recursos Humanos'),
('Producción'),
('Calidad'),
('Finanzas'),
('TI'),
('Eventos');

-- 4. Tabla Estatus
INSERT INTO Estatus (estatus_nombre, descripción_estatus) VALUES
('Pendiente', 'En espera de procesamiento'),
('En proceso', 'Actualmente siendo atendido'),
('Completado', 'Finalizado exitosamente'),
('Cancelado', 'No se completó'),
('Rechazado', 'No aprobado');

-- 5. Tabla Horario
INSERT INTO Horario (dias_semana, hora_entrada_esperada, hora_salida_esperada) VALUES
('Lunes-Viernes', '08:00:00', '17:00:00'),
('Lunes-Sábado', '09:00:00', '18:00:00'),
('Turno mañana', '06:00:00', '14:00:00'),
('Turno tarde', '14:00:00', '22:00:00'),
('Turno noche', '22:00:00', '06:00:00');

-- 6. Tabla Ingrediente
INSERT INTO Ingrediente (nombre_ingrediente, Ingrediente_ingrediente_id) VALUES
('Malta Pale Ale', NULL),
('Malta Munich', NULL),
('Malta Caramel', NULL),
('Lúpulo Cascade', NULL),
('Lúpulo Columbus', NULL),
('Levadura Ale', NULL),
('Levadura Lager', NULL),
('Agua', NULL),
('Trigo', NULL),
('Azúcar candy', NULL);

-- 7. Tabla Instruccion
INSERT INTO Instruccion (descripcion) VALUES
('Macerar a 66°C por 60 minutos'),
('Lavar granos a 76°C'),
('Hervir por 60 minutos añadiendo lúpulos según horario'),
('Enfriar rápidamente a 20°C'),
('Fermentar a 18-20°C por 7 días'),
('Madurar en frío por 2 semanas'),
('Carbonatar a 2.5 volúmenes de CO2'),
('Embotellar y dejar reposar 1 semana'),
('Filtrar antes de envasar'),
('Pasteurizar a 60°C por 15 minutos');

-- 8. Tabla Juez
INSERT INTO Juez (nombre_juez) VALUES
('Carlos Mendoza'),
('Ana López'),
('Pedro Rivas'),
('María González'),
('José Pérez'),
('Luisa Fernández'),
('Juan Martínez'),
('Sofía Ramírez'),
('Ricardo Díaz'),
('Carmen Suárez');

-- 9. Tabla Lugar
INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
('Venezuela', 'País', NULL),
('Distrito Capital', 'Distrito Capital', 1),
('Amazonas', 'Estado', 1),
('Anzoátegui', 'Estado', 1),
('Apure', 'Estado', 1),
('Aragua', 'Estado', 1),
('Barinas', 'Estado', 1),
('Bolívar', 'Estado', 1),
('Carabobo', 'Estado', 1),
('Cojedes', 'Estado', 1),
('Delta Amacuro', 'Estado', 1),
('Falcón', 'Estado', 1),
('Guárico', 'Estado', 1),
('Lara', 'Estado', 1),
('Mérida', 'Estado', 1),
('Miranda', 'Estado', 1),
('Monagas', 'Estado', 1),
('Nueva Esparta', 'Estado', 1),
('Portuguesa', 'Estado', 1),
('Sucre', 'Estado', 1),
('Táchira', 'Estado', 1),
('Trujillo', 'Estado', 1),
('La Guaira', 'Estado', 1), -- Anteriormente conocido como Vargas
('Yaracuy', 'Estado', 1),
('Zulia', 'Estado', 1),
('Dependencias Federales', 'Estado', 1),
--------------------------------------distrito capital 
('Altagracia', 'Parroquia', 2),
('Antímano', 'Parroquia', 2),
('Candelaria', 'Parroquia', 2),
('Caricuao', 'Parroquia', 2),
('Catedral', 'Parroquia', 2),
('Coche', 'Parroquia', 2),
('El Junquito', 'Parroquia', 2),
('El Paraíso', 'Parroquia', 2),
('El Recreo', 'Parroquia', 2),
('El Valle', 'Parroquia', 2),
('La Pastora', 'Parroquia', 2),
('La Vega', 'Parroquia', 2),
('Macarao', 'Parroquia', 2),
('San Agustín', 'Parroquia', 2),
('San Bernardino', 'Parroquia', 2),
('San José', 'Parroquia', 2),
('San Juan', 'Parroquia', 2),
('San Pedro', 'Parroquia', 2),
('Santa Rosalía', 'Parroquia', 2),
('Santa Teresa', 'Parroquia', 2),
('Sucre (Catia)', 'Parroquia', 2),
('23 de Enero', 'Parroquia', 2);
--------------------------------------amazonas
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Amazonas' es 3. AJUSTA ESTE VALOR SI ES DIFERENTE EN TUDB.
DO $$
DECLARE
    amazonas_id INTEGER := 3; -- ID del estado Amazonas
    alto_orinoco_id INTEGER;
    atabapo_id INTEGER;
    atures_id INTEGER;
    autana_id INTEGER;
    manapiare_id INTEGER;
    maroa_id INTEGER;
    rio_negro_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Amazonas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Alto Orinoco', 'Municipio', amazonas_id) RETURNING lugar_id INTO alto_orinoco_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Atabapo', 'Municipio', amazonas_id) RETURNING lugar_id INTO atabapo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Atures', 'Municipio', amazonas_id) RETURNING lugar_id INTO atures_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Autana', 'Municipio', amazonas_id) RETURNING lugar_id INTO autana_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Manapiare', 'Municipio', amazonas_id) RETURNING lugar_id INTO manapiare_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Maroa', 'Municipio', amazonas_id) RETURNING lugar_id INTO maroa_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Río Negro', 'Municipio', amazonas_id) RETURNING lugar_id INTO rio_negro_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Alto Orinoco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Huachamacare', 'Parroquia', alto_orinoco_id),
    ('Marawaka', 'Parroquia', alto_orinoco_id),
    ('Mavaca', 'Parroquia', alto_orinoco_id),
    ('Sierra Parima', 'Parroquia', alto_orinoco_id),
    ('La Esmeralda', 'Parroquia', alto_orinoco_id);

    -- Municipio Atabapo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ucata', 'Parroquia', atabapo_id),
    ('Yapacana', 'Parroquia', atabapo_id),
    ('Caname', 'Parroquia', atabapo_id);

    -- Municipio Atures
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Fernando Girón Tovar', 'Parroquia', atures_id),
    ('Pintado', 'Parroquia', atures_id),
    ('Samariapo', 'Parroquia', atures_id),
    ('Platanillal', 'Parroquia', atures_id),
    ('San Juan de Manapiare', 'Parroquia', atures_id),
    ('Cacuri', 'Parroquia', atures_id),
    ('San Fernando de Atabapo', 'Parroquia', atures_id);

    -- Municipio Autana
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Samariapo', 'Parroquia', autana_id),
    ('Sipapo', 'Parroquia', autana_id),
    ('Munduapo', 'Parroquia', autana_id),
    ('Guayapo', 'Parroquia', autana_id);

    -- Municipio Manapiare
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Juan de Manapiare', 'Parroquia', manapiare_id),
    ('Cacuri', 'Parroquia', manapiare_id),
    ('San Fernando de Atabapo', 'Parroquia', manapiare_id);

    -- Municipio Maroa
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Maroa', 'Parroquia', maroa_id),
    ('Victorino', 'Parroquia', maroa_id),
    ('Comunidad', 'Parroquia', maroa_id);

    -- Municipio Río Negro
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Carlos de Río Negro', 'Parroquia', rio_negro_id),
    ('Solano', 'Parroquia', rio_negro_id),
    ('Casiquiare', 'Parroquia', rio_negro_id);

END $$;

--------------------------------------Anzoátegui 
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Anzoátegui' es 4. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    anzoategui_id INTEGER := 4; -- ID del estado Anzoátegui
    anaco_id INTEGER;
    aragua_id INTEGER;
    bolivar_id INTEGER;
    bruzual_id INTEGER;
    cajigal_id INTEGER;
    carvajal_id INTEGER;
    diego_bautista_urbaneja_id INTEGER;
    freites_id INTEGER;
    guanipa_id INTEGER;
    guanta_id INTEGER;
    independencia_id INTEGER;
    libertad_id INTEGER;
    mcgregor_id INTEGER;
    miranda_id INTEGER;
    monagas_id INTEGER;
    penalver_id INTEGER;
    piritu_id INTEGER;
    san_juan_de_capistrano_id INTEGER;
    santa_ana_id INTEGER;
    simon_rodriguez_id INTEGER;
    sotillo_id INTEGER;
    -- Nota: Algunos municipios tienen nombres largos o duplicados en la lista original,
    -- se usarán los nombres cortos o más comunes para las variables.
    sir_arthur_mcgregor_id INTEGER; -- Alias para McGregor si es diferente
    urbaneja_id INTEGER; -- Alias para Diego Bautista Urbaneja si es diferente
    pedro_maria_freites_id INTEGER; -- Alias para Freites si es diferente
    francisco_de_miranda_id INTEGER; -- Alias para Miranda si es diferente
    jose_gregorio_monagas_id INTEGER; -- Alias para Monagas si es diferente

BEGIN
    -- 1. Insertar Municipios del Estado Anzoátegui
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Anaco', 'Municipio', anzoategui_id) RETURNING lugar_id INTO anaco_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aragua', 'Municipio', anzoategui_id) RETURNING lugar_id INTO aragua_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bolívar', 'Municipio', anzoategui_id) RETURNING lugar_id INTO bolivar_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bruzual', 'Municipio', anzoategui_id) RETURNING lugar_id INTO bruzual_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cajigal', 'Municipio', anzoategui_id) RETURNING lugar_id INTO cajigal_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Carvajal', 'Municipio', anzoategui_id) RETURNING lugar_id INTO carvajal_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Diego Bautista Urbaneja', 'Municipio', anzoategui_id) RETURNING lugar_id INTO diego_bautista_urbaneja_id;
    urbaneja_id := diego_bautista_urbaneja_id; -- Asignar alias si se usa en parroquias

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Freites', 'Municipio', anzoategui_id) RETURNING lugar_id INTO freites_id;
    pedro_maria_freites_id := freites_id; -- Asignar alias si se usa en parroquias

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guanipa', 'Municipio', anzoategui_id) RETURNING lugar_id INTO guanipa_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guanta', 'Municipio', anzoategui_id) RETURNING lugar_id INTO guanta_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Independencia', 'Municipio', anzoategui_id) RETURNING lugar_id INTO independencia_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertad', 'Municipio', anzoategui_id) RETURNING lugar_id INTO libertad_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('McGregor', 'Municipio', anzoategui_id) RETURNING lugar_id INTO mcgregor_id;
    sir_arthur_mcgregor_id := mcgregor_id; -- Asignar alias si se usa en parroquias

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Miranda', 'Municipio', anzoategui_id) RETURNING lugar_id INTO miranda_id;
    francisco_de_miranda_id := miranda_id; -- Asignar alias si se usa en parroquias

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Monagas', 'Municipio', anzoategui_id) RETURNING lugar_id INTO monagas_id;
    jose_gregorio_monagas_id := monagas_id; -- Asignar alias si se usa en parroquias

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Peñalver', 'Municipio', anzoategui_id) RETURNING lugar_id INTO penalver_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Píritu', 'Municipio', anzoategui_id) RETURNING lugar_id INTO piritu_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Juan de Capistrano', 'Municipio', anzoategui_id) RETURNING lugar_id INTO san_juan_de_capistrano_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Ana', 'Municipio', anzoategui_id) RETURNING lugar_id INTO santa_ana_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Simón Rodríguez', 'Municipio', anzoategui_id) RETURNING lugar_id INTO simon_rodriguez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sotillo', 'Municipio', anzoategui_id) RETURNING lugar_id INTO sotillo_id;


    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Anaco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Anaco', 'Parroquia', anaco_id),
    ('San Joaquín', 'Parroquia', anaco_id),
    ('San Mateo', 'Parroquia', anaco_id);

    -- Municipio Aragua
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aragua de Barcelona', 'Parroquia', aragua_id),
    ('Cachipo', 'Parroquia', aragua_id);

    -- Municipio Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bergantín', 'Parroquia', bolivar_id),
    ('Caigua', 'Parroquia', bolivar_id),
    ('El Carmen', 'Parroquia', bolivar_id),
    ('El Pilar', 'Parroquia', bolivar_id),
    ('Naricual', 'Parroquia', bolivar_id),
    ('San Cristóbal', 'Parroquia', bolivar_id);

    -- Municipio Bruzual
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Clarines', 'Parroquia', bruzual_id),
    ('Guanape', 'Parroquia', bruzual_id),
    ('Sabana de Uchire', 'Parroquia', bruzual_id);

    -- Municipio Cajigal
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Onoto', 'Parroquia', cajigal_id),
    ('San Lorenzo', 'Parroquia', cajigal_id);

    -- Municipio Carvajal
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Valle de Guanape', 'Parroquia', carvajal_id),
    ('Santa Bárbara', 'Parroquia', carvajal_id);

    -- Municipio Diego Bautista Urbaneja
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Lechería', 'Parroquia', diego_bautista_urbaneja_id),
    ('El Morro', 'Parroquia', diego_bautista_urbaneja_id);

    -- Municipio Freites
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cantaura', 'Parroquia', freites_id),
    ('Libertador', 'Parroquia', freites_id),
    ('Santa Rosa', 'Parroquia', freites_id),
    ('Urica', 'Parroquia', freites_id);

    -- Municipio Guanipa
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San José de Guanipa', 'Parroquia', guanipa_id);

    -- Municipio Guanta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guanta', 'Parroquia', guanta_id),
    ('Chorrerón', 'Parroquia', guanta_id);

    -- Municipio Independencia
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Soledad', 'Parroquia', independencia_id),
    ('Mamo', 'Parroquia', independencia_id);

    -- Municipio Libertad
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Diego de Cabrutica', 'Parroquia', libertad_id),
    ('Santa Clara', 'Parroquia', libertad_id),
    ('Uverito', 'Parroquia', libertad_id);

    -- Municipio McGregor
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Chaparro', 'Parroquia', mcgregor_id),
    ('Tomoporo', 'Parroquia', mcgregor_id);

    -- Municipio Miranda
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Atapirire', 'Parroquia', miranda_id),
    ('Boca del Pao', 'Parroquia', miranda_id),
    ('El Pao', 'Parroquia', miranda_id),
    ('Pariaguán', 'Parroquia', miranda_id);

    -- Municipio Monagas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mapire', 'Parroquia', monagas_id),
    ('Piar', 'Parroquia', monagas_id),
    ('San Diego de Cabrutica', 'Parroquia', monagas_id),
    ('Santa Clara', 'Parroquia', monagas_id),
    ('Uverito', 'Parroquia', monagas_id);

    -- Municipio Peñalver
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Puerto Píritu', 'Parroquia', penalver_id),
    ('San Miguel', 'Parroquia', penalver_id),
    ('San Francisco', 'Parroquia', penalver_id);

    -- Municipio Píritu
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Píritu', 'Parroquia', piritu_id),
    ('San Francisco', 'Parroquia', piritu_id);

    -- Municipio San Juan de Capistrano
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Boca de Uchire', 'Parroquia', san_juan_de_capistrano_id),
    ('Puerto Píritu', 'Parroquia', san_juan_de_capistrano_id);

    -- Municipio Santa Ana
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Ana', 'Parroquia', santa_ana_id),
    ('Pueblo Nuevo', 'Parroquia', santa_ana_id);

    -- Municipio Simón Rodríguez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Tigre', 'Parroquia', simon_rodriguez_id),
    ('Edmundo Barrios', 'Parroquia', simon_rodriguez_id);

    -- Municipio Sotillo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Puerto La Cruz', 'Parroquia', sotillo_id),
    ('Pozuelos', 'Parroquia', sotillo_id);

END $$;
--------------------------------------Apure
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Apure' es 5. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    apure_id INTEGER := 5; -- ID del estado Apure
    achaguas_id INTEGER;
    biruaca_id INTEGER;
    munoz_id INTEGER;
    paez_id INTEGER;
    pedro_camejo_id INTEGER;
    romulo_gallegos_id INTEGER;
    san_fernando_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Apure
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Achaguas', 'Municipio', apure_id) RETURNING lugar_id INTO achaguas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Biruaca', 'Municipio', apure_id) RETURNING lugar_id INTO biruaca_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Muñoz', 'Municipio', apure_id) RETURNING lugar_id INTO munoz_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Páez', 'Municipio', apure_id) RETURNING lugar_id INTO paez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pedro Camejo', 'Municipio', apure_id) RETURNING lugar_id INTO pedro_camejo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Rómulo Gallegos', 'Municipio', apure_id) RETURNING lugar_id INTO romulo_gallegos_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Fernando', 'Municipio', apure_id) RETURNING lugar_id INTO san_fernando_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Achaguas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Achaguas', 'Parroquia', achaguas_id),
    ('Apurito', 'Parroquia', achaguas_id),
    ('El Yagual', 'Parroquia', achaguas_id),
    ('Guachara', 'Parroquia', achaguas_id),
    ('Mucuritas', 'Parroquia', achaguas_id),
    ('Queseras del Medio', 'Parroquia', achaguas_id);

    -- Municipio Biruaca
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Biruaca', 'Parroquia', biruaca_id);

    -- Municipio Muñoz
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bruzual', 'Parroquia', munoz_id),
    ('Mantecal', 'Parroquia', munoz_id),
    ('Quintero', 'Parroquia', munoz_id),
    ('San Vicente', 'Parroquia', munoz_id),
    ('La Trinidad', 'Parroquia', munoz_id);

    -- Municipio Páez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guasdualito', 'Parroquia', paez_id),
    ('Aramendi', 'Parroquia', paez_id),
    ('El Amparo', 'Parroquia', paez_id),
    ('San Camilo', 'Parroquia', paez_id),
    ('Urdaneta', 'Parroquia', paez_id);

    -- Municipio Pedro Camejo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Juan de Payara', 'Parroquia', pedro_camejo_id),
    ('Codazzi', 'Parroquia', pedro_camejo_id),
    ('Cunaviche', 'Parroquia', pedro_camejo_id);

    -- Municipio Rómulo Gallegos
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Elorza', 'Parroquia', romulo_gallegos_id);

    -- Municipio San Fernando
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Fernando', 'Parroquia', san_fernando_id),
    ('El Recreo', 'Parroquia', san_fernando_id),
    ('Peñalver', 'Parroquia', san_fernando_id),
    ('San Rafael de Atamaica', 'Parroquia', san_fernando_id),
    ('Ciudad de Nutrias', 'Parroquia', san_fernando_id);

END $$;
--------------------------------------Aragua
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Aragua' es 6. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    aragua_estado_id INTEGER := 6; -- ID del estado Aragua
    bolivar_m_id INTEGER;
    camatagua_id INTEGER;
    francisco_linares_alcantara_id INTEGER;
    girardot_id INTEGER;
    jose_angel_lamas_id INTEGER;
    jose_felix_ribas_id INTEGER;
    jose_rafael_revenga_id INTEGER;
    libertador_m_id INTEGER;
    mario_briceno_iragorry_id INTEGER;
    ocumare_costa_oro_id INTEGER;
    san_casimiro_id INTEGER;
    san_sebastian_id INTEGER;
    santiago_marino_id INTEGER;
    santos_michelena_id INTEGER;
    sucre_m_id INTEGER;
    tovar_id INTEGER;
    urdaneta_m_id INTEGER;
    zamora_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Aragua
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bolívar', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO bolivar_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Camatagua', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO camatagua_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Francisco Linares Alcántara', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO francisco_linares_alcantara_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Girardot', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO girardot_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('José Ángel Lamas', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO jose_angel_lamas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('José Félix Ribas', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO jose_felix_ribas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('José Rafael Revenga', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO jose_rafael_revenga_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertador', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO libertador_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mario Briceño Iragorry', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO mario_briceno_iragorry_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ocumare de la Costa de Oro', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO ocumare_costa_oro_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Casimiro', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO san_casimiro_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Sebastián', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO san_sebastian_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santiago Mariño', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO santiago_marino_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santos Michelena', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO santos_michelena_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tovar', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO tovar_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Urdaneta', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO urdaneta_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Zamora', 'Municipio', aragua_estado_id) RETURNING lugar_id INTO zamora_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Mateo', 'Parroquia', bolivar_m_id);

    -- Municipio Camatagua
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Camatagua', 'Parroquia', camatagua_id),
    ('Carmen de Cura', 'Parroquia', camatagua_id);

    -- Municipio Francisco Linares Alcántara
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Francisco Linares Alcántara', 'Parroquia', francisco_linares_alcantara_id),
    ('Monseñor Feliciano González', 'Parroquia', francisco_linares_alcantara_id),
    ('Santa Rita', 'Parroquia', francisco_linares_alcantara_id);

    -- Municipio Girardot
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Andrés Eloy Blanco', 'Parroquia', girardot_id),
    ('Choroní', 'Parroquia', girardot_id),
    ('Las Delicias', 'Parroquia', girardot_id),
    ('Pedro José Ovalles', 'Parroquia', girardot_id),
    ('Joaquín Crespo', 'Parroquia', girardot_id),
    ('José Casanova Godoy', 'Parroquia', girardot_id),
    ('Madre María de San José', 'Parroquia', girardot_id),
    ('Santiago Mariño', 'Parroquia', girardot_id),
    ('Los Tacariguas', 'Parroquia', girardot_id);

    -- Municipio José Ángel Lamas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Cruz', 'Parroquia', jose_angel_lamas_id);

    -- Municipio José Félix Ribas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Castor Nieves Ríos', 'Parroquia', jose_felix_ribas_id),
    ('Las Mercedes', 'Parroquia', jose_felix_ribas_id),
    ('Pao de Zárate', 'Parroquia', jose_felix_ribas_id),
    ('Zuata', 'Parroquia', jose_felix_ribas_id),
    ('La Victoria', 'Parroquia', jose_felix_ribas_id);

    -- Municipio José Rafael Revenga
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Consejo', 'Parroquia', jose_rafael_revenga_id);

    -- Municipio Libertador
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Palo Negro', 'Parroquia', libertador_m_id),
    ('San Martín de Porres', 'Parroquia', libertador_m_id);

    -- Municipio Mario Briceño Iragorry
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Limón', 'Parroquia', mario_briceno_iragorry_id),
    ('Caña de Azúcar', 'Parroquia', mario_briceno_iragorry_id);

    -- Municipio Ocumare de la Costa de Oro
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ocumare de la Costa', 'Parroquia', ocumare_costa_oro_id);

    -- Municipio San Casimiro
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Casimiro', 'Parroquia', san_casimiro_id),
    ('Güiripa', 'Parroquia', san_casimiro_id),
    ('Ollas de Caramacate', 'Parroquia', san_casimiro_id),
    ('Valle Morín', 'Parroquia', san_casimiro_id);

    -- Municipio San Sebastián
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Sebastián', 'Parroquia', san_sebastian_id);

    -- Municipio Santiago Mariño
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aragua', 'Parroquia', santiago_marino_id),
    ('Chuao', 'Parroquia', santiago_marino_id),
    ('Samán de Güere', 'Parroquia', santiago_marino_id),
    ('Alfredo Pacheco Miranda', 'Parroquia', santiago_marino_id),
    ('Pedro Arévalo Aponte', 'Parroquia', santiago_marino_id);

    -- Municipio Santos Michelena
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santos Michelena', 'Parroquia', santos_michelena_id),
    ('Tiara', 'Parroquia', santos_michelena_id);

    -- Municipio Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cagua', 'Parroquia', sucre_m_id),
    ('Bella Vista', 'Parroquia', sucre_m_id);

    -- Municipio Tovar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tovar', 'Parroquia', tovar_id);

    -- Municipio Urdaneta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Urdaneta', 'Parroquia', urdaneta_m_id),
    ('Las Peñitas', 'Parroquia', urdaneta_m_id),
    ('San Francisco de Cara', 'Parroquia', urdaneta_m_id),
    ('Taguay', 'Parroquia', urdaneta_m_id);

    -- Municipio Zamora
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Augusto Mijares', 'Parroquia', zamora_id),
    ('Magdaleno', 'Parroquia', zamora_id),
    ('San Francisco de Asís', 'Parroquia', zamora_id),
    ('Valles de Tucutunemo', 'Parroquia', zamora_id),
    ('Villa de Cura', 'Parroquia', zamora_id);

END $$;

--------------------------------------barinas
 -- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Barinas' es 7. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    barinas_estado_id INTEGER := 7; -- ID del estado Barinas
    alberto_arvelo_torrealba_id INTEGER;
    antonio_jose_de_sucre_id INTEGER;
    barinas_m_id INTEGER;
    bolivar_m_id INTEGER;
    cruz_paredes_id INTEGER;
    ezequiel_zamora_id INTEGER;
    obispos_id INTEGER;
    pedraza_id INTEGER;
    rojas_id INTEGER;
    sosa_id INTEGER;
    sucre_m_id INTEGER; -- Sucre (municipio)
    andres_eloy_blanco_m_id INTEGER; -- Andrés Eloy Blanco (municipio)
BEGIN
    -- 1. Insertar Municipios del Estado Barinas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Alberto Arvelo Torrealba', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO alberto_arvelo_torrealba_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Antonio José de Sucre', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO antonio_jose_de_sucre_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Barinas', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO barinas_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bolívar', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO bolivar_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cruz Paredes', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO cruz_paredes_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ezequiel Zamora', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO ezequiel_zamora_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Obispos', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO obispos_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pedraza', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO pedraza_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Rojas', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO rojas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sosa', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO sosa_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Andrés Eloy Blanco', 'Municipio', barinas_estado_id) RETURNING lugar_id INTO andres_eloy_blanco_m_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Alberto Arvelo Torrealba
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sabaneta', 'Parroquia', alberto_arvelo_torrealba_id),
    ('Rodríguez Domínguez', 'Parroquia', alberto_arvelo_torrealba_id);

    -- Municipio Antonio José de Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ticoporo', 'Parroquia', antonio_jose_de_sucre_id),
    ('Andrés Bello', 'Parroquia', antonio_jose_de_sucre_id),
    ('Nicolás Pulido', 'Parroquia', antonio_jose_de_sucre_id);

    -- Municipio Barinas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Alfredo Briceño', 'Parroquia', barinas_m_id),
    ('Alto Barinas', 'Parroquia', barinas_m_id),
    ('Barinas', 'Parroquia', barinas_m_id),
    ('Corazón de Jesús', 'Parroquia', barinas_m_id),
    ('El Carmen', 'Parroquia', barinas_m_id),
    ('Don Samuel', 'Parroquia', barinas_m_id),
    ('Manuel Palacio Fajardo', 'Parroquia', barinas_m_id),
    ('Ramón Ignacio Méndez', 'Parroquia', barinas_m_id),
    ('Rómulo Betancourt', 'Parroquia', barinas_m_id),
    ('San Silvestre', 'Parroquia', barinas_m_id),
    ('Santa Inés', 'Parroquia', barinas_m_id),
    ('Santa Lucía', 'Parroquia', barinas_m_id),
    ('Torunos', 'Parroquia', barinas_m_id);

    -- Municipio Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Barinitas', 'Parroquia', bolivar_m_id),
    ('Altamira', 'Parroquia', bolivar_m_id),
    ('Calderas', 'Parroquia', bolivar_m_id);

    -- Municipio Cruz Paredes
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Barrancas', 'Parroquia', cruz_paredes_id),
    ('El Socorro', 'Parroquia', cruz_paredes_id),
    ('Masparrito', 'Parroquia', cruz_paredes_id);

    -- Municipio Ezequiel Zamora
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Bárbara', 'Parroquia', ezequiel_zamora_id),
    ('José Ignacio del Pumar', 'Parroquia', ezequiel_zamora_id),
    ('Pedro Briceño', 'Parroquia', ezequiel_zamora_id),
    ('Ramón Ignacio Méndez', 'Parroquia', ezequiel_zamora_id);

    -- Municipio Obispos
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Obispos', 'Parroquia', obispos_id),
    ('El Real', 'Parroquia', obispos_id),
    ('La Luz', 'Parroquia', obispos_id),
    ('Los Guasimitos', 'Parroquia', obispos_id);

    -- Municipio Pedraza
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ciudad Bolivia', 'Parroquia', pedraza_id),
    ('Ignacio Briceño', 'Parroquia', pedraza_id),
    ('José Antonio Páez', 'Parroquia', pedraza_id),
    ('San Antonio', 'Parroquia', pedraza_id);

    -- Municipio Rojas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertad', 'Parroquia', rojas_id),
    ('Dolores', 'Parroquia', rojas_id),
    ('Santa Cruz de Rojas', 'Parroquia', rojas_id),
    ('Palacios Fajardo', 'Parroquia', rojas_id);

    -- Municipio Sosa
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ciudad de Nutrias', 'Parroquia', sosa_id),
    ('Boconó', 'Parroquia', sosa_id),
    ('Puerto de Nutrias', 'Parroquia', sosa_id),
    ('Santa Catalina', 'Parroquia', sosa_id),
    ('Simón Bolívar', 'Parroquia', sosa_id),
    ('Veguitas', 'Parroquia', sosa_id);

    -- Municipio Sucre (Barinas)
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ciudad de Nutrias', 'Parroquia', sucre_m_id), -- Nota: Esta parroquia también aparece en Sosa. Verificar si es un error o si hay dos con el mismo nombre.
    ('Boconó', 'Parroquia', sucre_m_id),
    ('Puerto de Nutrias', 'Parroquia', sucre_m_id),
    ('Santa Catalina', 'Parroquia', sucre_m_id),
    ('Simón Bolívar', 'Parroquia', sucre_m_id),
    ('Veguitas', 'Parroquia', sucre_m_id);

    -- Municipio Andrés Eloy Blanco (Barinas)
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Cantón', 'Parroquia', andres_eloy_blanco_m_id),
    ('Santa Cruz de Guacas', 'Parroquia', andres_eloy_blanco_m_id),
    ('Puerto Vivas', 'Parroquia', andres_eloy_blanco_m_id);

END $$;

--------------------------------------bolivar 
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Bolívar' es 8. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    bolivar_estado_id INTEGER := 8; -- ID del estado Bolívar
    angostura_del_orinoco_id INTEGER;
    caroni_id INTEGER;
    cedeno_id INTEGER;
    el_callao_id INTEGER;
    gran_sabana_id INTEGER;
    piar_id INTEGER;
    roscio_id INTEGER;
    sifontes_id INTEGER;
    sucre_m_id INTEGER;
    padre_pedro_chien_id INTEGER;
    angostura_m_id INTEGER; -- Para el municipio Angostura (anteriormente Raúl Leoni)
    general_manuel_cedeno_id INTEGER; -- Para el municipio General Manuel Cedeño (si es distinto de Cedeño)
BEGIN
    -- 1. Insertar Municipios del Estado Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Angostura del Orinoco', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO angostura_del_orinoco_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Caroní', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO caroni_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cedeño', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO cedeno_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Callao', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO el_callao_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Gran Sabana', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO gran_sabana_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Piar', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO piar_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Roscio', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO roscio_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sifontes', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO sifontes_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Padre Pedro Chien', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO padre_pedro_chien_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Angostura', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO angostura_m_id;

    -- Si "General Manuel Cedeño" es un municipio distinto de "Cedeño", descomentar y usar:
    -- INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    -- ('General Manuel Cedeño', 'Municipio', bolivar_estado_id) RETURNING lugar_id INTO general_manuel_cedeno_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Angostura del Orinoco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Agua Salada', 'Parroquia', angostura_del_orinoco_id),
    ('Catedral', 'Parroquia', angostura_del_orinoco_id),
    ('José Antonio Páez', 'Parroquia', angostura_del_orinoco_id),
    ('La Sabanita', 'Parroquia', angostura_del_orinoco_id),
    ('Marhuanta', 'Parroquia', angostura_del_orinoco_id),
    ('Panapana', 'Parroquia', angostura_del_orinoco_id),
    ('Vista Hermosa', 'Parroquia', angostura_del_orinoco_id),
    ('Zea', 'Parroquia', angostura_del_orinoco_id);

    -- Municipio Caroní
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cachamay', 'Parroquia', caroni_id),
    ('Chirica', 'Parroquia', caroni_id),
    ('Dalla Costa', 'Parroquia', caroni_id),
    ('Once de Abril', 'Parroquia', caroni_id),
    ('Simón Bolívar', 'Parroquia', caroni_id),
    ('Unare', 'Parroquia', caroni_id),
    ('Universidad', 'Parroquia', caroni_id),
    ('Vista al Sol', 'Parroquia', caroni_id),
    ('Pozo Verde', 'Parroquia', caroni_id),
    ('Yocoima', 'Parroquia', caroni_id),
    ('Cinco de Julio', 'Parroquia', caroni_id);

    -- Municipio Cedeño
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Caicara del Orinoco', 'Parroquia', cedeno_id),
    ('Altagracia', 'Parroquia', cedeno_id),
    ('Ascensión Farreras', 'Parroquia', cedeno_id),
    ('Guaniamo', 'Parroquia', cedeno_id),
    ('La Urbana', 'Parroquia', cedeno_id),
    ('Pijiguaos', 'Parroquia', cedeno_id);

    -- Municipio El Callao
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Callao', 'Parroquia', el_callao_id);

    -- Municipio Gran Sabana
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ikabarú', 'Parroquia', gran_sabana_id),
    ('Santa Elena de Uairén', 'Parroquia', gran_sabana_id);

    -- Municipio Piar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Upata', 'Parroquia', piar_id),
    ('Andrés Eloy Blanco', 'Parroquia', piar_id),
    ('Pedro Cova', 'Parroquia', piar_id);

    -- Municipio Roscio
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guasipati', 'Parroquia', roscio_id),
    ('Salom', 'Parroquia', roscio_id),
    ('San Isidro', 'Parroquia', roscio_id);

    -- Municipio Sifontes
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tumeremo', 'Parroquia', sifontes_id),
    ('Dalla Costa', 'Parroquia', sifontes_id),
    ('San Isidro', 'Parroquia', sifontes_id),
    ('Las Claritas', 'Parroquia', sifontes_id);

    -- Municipio Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Maripa', 'Parroquia', sucre_m_id),
    ('Guarataro', 'Parroquia', sucre_m_id),
    ('Las Majadas', 'Parroquia', sucre_m_id),
    ('Moitaco', 'Parroquia', sucre_m_id);

    -- Municipio Padre Pedro Chien
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Palmar', 'Parroquia', padre_pedro_chien_id),
    ('Andrés Bello', 'Parroquia', padre_pedro_chien_id);

    -- Municipio Angostura (anteriormente Raúl Leoni)
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ciudad Piar', 'Parroquia', angostura_m_id),
    ('Barceloneta', 'Parroquia', angostura_m_id),
    ('Santa Bárbara', 'Parroquia', angostura_m_id);

    -- Si "General Manuel Cedeño" es un municipio distinto de "Cedeño", descomentar y usar:
    -- INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    -- ('Caicara del Orinoco', 'Parroquia', general_manuel_cedeno_id),
    -- ('Altagracia', 'Parroquia', general_manuel_cedeno_id),
    -- ('Ascensión Farreras', 'Parroquia', general_manuel_cedeno_id),
    -- ('Guaniamo', 'Parroquia', general_manuel_cedeno_id),
    -- ('La Urbana', 'Parroquia', general_manuel_cedeno_id),
    -- ('Pijiguaos', 'Parroquia', general_manuel_cedeno_id);

END $$;
--------------------------------------carabobo  
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Carabobo' es 9. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    carabobo_estado_id INTEGER := 9; -- ID del estado Carabobo
    acosta_id INTEGER; -- Anteriormente Diego Ibarra
    bejuma_id INTEGER;
    carlos_arvelo_id INTEGER;
    diego_ibarra_id INTEGER; -- Si se mantiene como nombre de municipio
    guacara_id INTEGER;
    juan_jose_mora_id INTEGER;
    libertador_m_id INTEGER;
    los_guayos_id INTEGER;
    miranda_m_id INTEGER;
    montalban_id INTEGER;
    naguanagua_id INTEGER;
    puerto_cabello_id INTEGER;
    san_diego_id INTEGER;
    san_joaquin_id INTEGER;
    valencia_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Carabobo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Acosta', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO acosta_id;
    -- Si Diego Ibarra se mantiene como un municipio separado y no es solo un cambio de nombre para Acosta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Diego Ibarra', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO diego_ibarra_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bejuma', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO bejuma_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Carlos Arvelo', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO carlos_arvelo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guacara', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO guacara_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Juan José Mora', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO juan_jose_mora_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertador', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO libertador_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Los Guayos', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO los_guayos_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Miranda', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO miranda_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Montalbán', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO montalban_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Naguanagua', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO naguanagua_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Puerto Cabello', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO puerto_cabello_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Diego', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO san_diego_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Joaquín', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO san_joaquin_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Valencia', 'Municipio', carabobo_estado_id) RETURNING lugar_id INTO valencia_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Acosta (anteriormente Diego Ibarra)
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mariara', 'Parroquia', acosta_id),
    ('Aguas Calientes', 'Parroquia', acosta_id);

    -- Municipio Bejuma
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bejuma', 'Parroquia', bejuma_id),
    ('Canoabo', 'Parroquia', bejuma_id),
    ('Simón Bolívar', 'Parroquia', bejuma_id);

    -- Municipio Carlos Arvelo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Güigüe', 'Parroquia', carlos_arvelo_id),
    ('Belén', 'Parroquia', carlos_arvelo_id),
    ('Tacarigua', 'Parroquia', carlos_arvelo_id);

    -- Municipio Diego Ibarra (si es un municipio distinto de Acosta)
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mariara', 'Parroquia', diego_ibarra_id),
    ('Aguas Calientes', 'Parroquia', diego_ibarra_id);

    -- Municipio Guacara
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guacara', 'Parroquia', guacara_id),
    ('Ciudad Alianza', 'Parroquia', guacara_id),
    ('Yagua', 'Parroquia', guacara_id);

    -- Municipio Juan José Mora
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Morón', 'Parroquia', juan_jose_mora_id),
    ('Urama', 'Parroquia', juan_jose_mora_id);

    -- Municipio Libertador
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tocuyito', 'Parroquia', libertador_m_id),
    ('Independencia', 'Parroquia', libertador_m_id);

    -- Municipio Los Guayos
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Los Guayos', 'Parroquia', los_guayos_id);

    -- Municipio Miranda
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Miranda', 'Parroquia', miranda_m_id);

    -- Municipio Montalbán
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Montalbán', 'Parroquia', montalban_id);

    -- Municipio Naguanagua
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Naguanagua', 'Parroquia', naguanagua_id);

    -- Municipio Puerto Cabello
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bartolomé Salom', 'Parroquia', puerto_cabello_id),
    ('Democracia', 'Parroquia', puerto_cabello_id),
    ('Fraternidad', 'Parroquia', puerto_cabello_id),
    ('Goaigoaza', 'Parroquia', puerto_cabello_id),
    ('Juan José Flores', 'Parroquia', puerto_cabello_id),
    ('Unión', 'Parroquia', puerto_cabello_id),
    ('Borburata', 'Parroquia', puerto_cabello_id),
    ('Patanemo', 'Parroquia', puerto_cabello_id);

    -- Municipio San Diego
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Diego', 'Parroquia', san_diego_id);

    -- Municipio San Joaquín
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Joaquín', 'Parroquia', san_joaquin_id);

    -- Municipio Valencia
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Candelaria', 'Parroquia', valencia_id),
    ('Catedral', 'Parroquia', valencia_id),
    ('El Socorro', 'Parroquia', valencia_id),
    ('Miguel Peña', 'Parroquia', valencia_id),
    ('Rafael Urdaneta', 'Parroquia', valencia_id),
    ('San Blas', 'Parroquia', valencia_id),
    ('San José', 'Parroquia', valencia_id),
    ('Santa Rosa', 'Parroquia', valencia_id),
    ('Negro Primero', 'Parroquia', valencia_id);

END $$;
--------------------------------------cojedes
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Cojedes' es 10. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    cojedes_estado_id INTEGER := 10; -- ID del estado Cojedes
    anzoategui_m_id INTEGER;
    falcon_id INTEGER;
    girardot_m_id INTEGER;
    lima_blanco_id INTEGER;
    pao_de_san_juan_bautista_id INTEGER;
    ricaurte_id INTEGER;
    romulo_gallegos_id INTEGER;
    san_carlos_id INTEGER;
    tinaco_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Cojedes
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Anzoátegui', 'Municipio', cojedes_estado_id) RETURNING lugar_id INTO anzoategui_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Falcón', 'Municipio', cojedes_estado_id) RETURNING lugar_id INTO falcon_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Girardot', 'Municipio', cojedes_estado_id) RETURNING lugar_id INTO girardot_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Lima Blanco', 'Municipio', cojedes_estado_id) RETURNING lugar_id INTO lima_blanco_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pao de San Juan Bautista', 'Municipio', cojedes_estado_id) RETURNING lugar_id INTO pao_de_san_juan_bautista_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ricaurte', 'Municipio', cojedes_estado_id) RETURNING lugar_id INTO ricaurte_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Rómulo Gallegos', 'Municipio', cojedes_estado_id) RETURNING lugar_id INTO romulo_gallegos_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Carlos', 'Municipio', cojedes_estado_id) RETURNING lugar_id INTO san_carlos_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tinaco', 'Municipio', cojedes_estado_id) RETURNING lugar_id INTO tinaco_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Anzoátegui
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cojedes', 'Parroquia', anzoategui_m_id),
    ('Juan de Mata Suárez', 'Parroquia', anzoategui_m_id);

    -- Municipio Falcón
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tinaquillo', 'Parroquia', falcon_id);

    -- Municipio Girardot
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Baúl', 'Parroquia', girardot_m_id),
    ('Sucre', 'Parroquia', girardot_m_id);

    -- Municipio Lima Blanco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Macapo', 'Parroquia', lima_blanco_id),
    ('La Aguadita', 'Parroquia', lima_blanco_id);

    -- Municipio Pao de San Juan Bautista
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Pao', 'Parroquia', pao_de_san_juan_bautista_id);

    -- Municipio Ricaurte
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertad de Cojedes', 'Parroquia', ricaurte_id),
    ('Monagas', 'Parroquia', ricaurte_id);

    -- Municipio Rómulo Gallegos
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Las Vegas', 'Parroquia', romulo_gallegos_id);

    -- Municipio San Carlos
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Carlos de Austria', 'Parroquia', san_carlos_id),
    ('Juan Ángel Bravo', 'Parroquia', san_carlos_id),
    ('Manuel Manrique', 'Parroquia', san_carlos_id);

    -- Municipio Tinaco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('General en Jefe José Laurencio Silva', 'Parroquia', tinaco_id);

END $$;
  
--------------------------------------delta amacuro
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Delta Amacuro' es 11. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    delta_amacuro_estado_id INTEGER := 11; -- ID del estado Delta Amacuro
    antonio_diaz_id INTEGER;
    casacoima_id INTEGER;
    pedernales_id INTEGER;
    tucupita_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Delta Amacuro
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Antonio Díaz', 'Municipio', delta_amacuro_estado_id) RETURNING lugar_id INTO antonio_diaz_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Casacoima', 'Municipio', delta_amacuro_estado_id) RETURNING lugar_id INTO casacoima_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pedernales', 'Municipio', delta_amacuro_estado_id) RETURNING lugar_id INTO pedernales_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tucupita', 'Municipio', delta_amacuro_estado_id) RETURNING lugar_id INTO tucupita_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Antonio Díaz
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Curiapo', 'Parroquia', antonio_diaz_id),
    ('Almirante Luis Brión', 'Parroquia', antonio_diaz_id),
    ('Francisco Aniceto Lugo', 'Parroquia', antonio_diaz_id),
    ('Manuel Renaud', 'Parroquia', antonio_diaz_id),
    ('Padre Barral', 'Parroquia', antonio_diaz_id),
    ('Santos de Abelgas', 'Parroquia', antonio_diaz_id);

    -- Municipio Casacoima
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Imataca', 'Parroquia', casacoima_id),
    ('Cinco de Julio', 'Parroquia', casacoima_id),
    ('Juan Bautista Arismendi', 'Parroquia', casacoima_id),
    ('Manuel Piar', 'Parroquia', casacoima_id),
    ('Rómulo Gallegos', 'Parroquia', casacoima_id);

    -- Municipio Pedernales
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pedernales', 'Parroquia', pedernales_id),
    ('Luis Beltrán Prieto Figueroa', 'Parroquia', pedernales_id);

    -- Municipio Tucupita
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tucupita', 'Parroquia', tucupita_id),
    ('Antonio José de Sucre', 'Parroquia', tucupita_id),
    ('José Vidal Marcano', 'Parroquia', tucupita_id),
    ('Juan Millán', 'Parroquia', tucupita_id),
    ('Leonardo Ruíz Pineda', 'Parroquia', tucupita_id),
    ('Mariscal Antonio José de Sucre', 'Parroquia', tucupita_id),
    ('San José', 'Parroquia', tucupita_id),
    ('Tres de Febrero', 'Parroquia', tucupita_id);

END $$;  
--------------------------------------falcon
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Falcón' es 12. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    falcon_estado_id INTEGER := 12; -- ID del estado Falcón
    acosta_m_id INTEGER;
    bolivar_m_id INTEGER;
    buchivacoa_id INTEGER;
    cacique_manaure_id INTEGER;
    carirubana_id INTEGER;
    colina_id INTEGER;
    dabajuro_id INTEGER;
    democracia_id INTEGER;
    falcon_m_id INTEGER;
    federacion_id INTEGER;
    jacura_id INTEGER;
    los_taques_id INTEGER;
    mauroa_id INTEGER;
    miranda_m_id INTEGER;
    monsenor_iturriza_id INTEGER;
    palmasola_id INTEGER;
    petit_id INTEGER;
    piritu_id INTEGER;
    san_francisco_id INTEGER;
    silva_id INTEGER;
    sucre_m_id INTEGER;
    union_id INTEGER;
    urumaco_id INTEGER;
    zamora_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Falcón
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Acosta', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO acosta_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bolívar', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO bolivar_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Buchivacoa', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO buchivacoa_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cacique Manaure', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO cacique_manaure_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Carirubana', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO carirubana_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Colina', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO colina_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Dabajuro', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO dabajuro_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Democracia', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO democracia_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Falcón', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO falcon_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Federación', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO federacion_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Jacura', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO jacura_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Los Taques', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO los_taques_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mauroa', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO mauroa_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Miranda', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO miranda_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Monseñor Iturriza', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO monsenor_iturriza_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Palmasola', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO palmasola_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Petit', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO petit_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Píritu', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO piritu_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Francisco', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO san_francisco_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Silva', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO silva_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Unión', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO union_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Urumaco', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO urumaco_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Zamora', 'Municipio', falcon_estado_id) RETURNING lugar_id INTO zamora_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Acosta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Juan de los Cayos', 'Parroquia', acosta_m_id),
    ('Capadare', 'Parroquia', acosta_m_id),
    ('La Pastora', 'Parroquia', acosta_m_id);

    -- Municipio Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Luis', 'Parroquia', bolivar_m_id),
    ('Aracua', 'Parroquia', bolivar_m_id),
    ('La Peña', 'Parroquia', bolivar_m_id);

    -- Municipio Buchivacoa
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Capatárida', 'Parroquia', buchivacoa_id),
    ('Bariro', 'Parroquia', buchivacoa_id),
    ('Borojó', 'Parroquia', buchivacoa_id),
    ('Goajiro', 'Parroquia', buchivacoa_id),
    ('San José de la Costa', 'Parroquia', buchivacoa_id),
    ('Seque', 'Parroquia', buchivacoa_id);

    -- Municipio Cacique Manaure
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Yaracal', 'Parroquia', cacique_manaure_id);

    -- Municipio Carirubana
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Carirubana', 'Parroquia', carirubana_id),
    ('Norte', 'Parroquia', carirubana_id),
    ('Punta Cardón', 'Parroquia', carirubana_id);

    -- Municipio Colina
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Vela de Coro', 'Parroquia', colina_id),
    ('Acurigua', 'Parroquia', colina_id),
    ('Guzmán Guillermo', 'Parroquia', colina_id),
    ('La Esperanza', 'Parroquia', colina_id),
    ('La Sierra', 'Parroquia', colina_id);

    -- Municipio Dabajuro
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Dabajuro', 'Parroquia', dabajuro_id);

    -- Municipio Democracia
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pedregal', 'Parroquia', democracia_id),
    ('Agua Larga', 'Parroquia', democracia_id),
    ('Churuguara', 'Parroquia', democracia_id),
    ('Piedra Grande', 'Parroquia', democracia_id),
    ('Purureche', 'Parroquia', democracia_id);

    -- Municipio Falcón
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pueblo Nuevo', 'Parroquia', falcon_m_id),
    ('Adícora', 'Parroquia', falcon_m_id),
    ('Baraived', 'Parroquia', falcon_m_id),
    ('Buena Vista', 'Parroquia', falcon_m_id),
    ('Jadacaquiva', 'Parroquia', falcon_m_id),
    ('Moruy', 'Parroquia', falcon_m_id),
    ('Hayes', 'Parroquia', falcon_m_id),
    ('El Vínculo', 'Parroquia', falcon_m_id),
    ('El Hato', 'Parroquia', falcon_m_id);

    -- Municipio Federación
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Churuguara', 'Parroquia', federacion_id),
    ('Agua Larga', 'Parroquia', federacion_id),
    ('El Paují', 'Parroquia', federacion_id),
    ('Independencia', 'Parroquia', federacion_id),
    ('Mapararí', 'Parroquia', federacion_id);

    -- Municipio Jacura
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Jacura', 'Parroquia', jacura_id),
    ('Agua Salada', 'Parroquia', jacura_id),
    ('Araurima', 'Parroquia', jacura_id);

    -- Municipio Los Taques
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Los Taques', 'Parroquia', los_taques_id),
    ('Judibana', 'Parroquia', los_taques_id);

    -- Municipio Mauroa
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mene Mauroa', 'Parroquia', mauroa_id),
    ('Casigua', 'Parroquia', mauroa_id),
    ('San Félix', 'Parroquia', mauroa_id);

    -- Municipio Miranda
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Miranda', 'Parroquia', miranda_m_id),
    ('Guzmán Guillermo', 'Parroquia', miranda_m_id),
    ('La Vela de Coro', 'Parroquia', miranda_m_id),
    ('San Antonio', 'Parroquia', miranda_m_id),
    ('San Gabriel', 'Parroquia', miranda_m_id),
    ('Santa Ana', 'Parroquia', miranda_m_id);

    -- Municipio Monseñor Iturriza
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Chichiriviche', 'Parroquia', monsenor_iturriza_id),
    ('Boca de Aroa', 'Parroquia', monsenor_iturriza_id),
    ('Tocuyo de la Costa', 'Parroquia', monsenor_iturriza_id);

    -- Municipio Palmasola
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Palmasola', 'Parroquia', palmasola_id);

    -- Municipio Petit
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cabure', 'Parroquia', petit_id),
    ('Colina', 'Parroquia', petit_id),
    ('Curimagua', 'Parroquia', petit_id),
    ('San Miguel', 'Parroquia', petit_id),
    ('Zazárida', 'Parroquia', petit_id);

    -- Municipio Píritu
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Píritu', 'Parroquia', piritu_id),
    ('San José de la Costa', 'Parroquia', piritu_id);

    -- Municipio San Francisco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mirimire', 'Parroquia', san_francisco_id),
    ('Agua Salada', 'Parroquia', san_francisco_id),
    ('San Juan de los Cayos', 'Parroquia', san_francisco_id);

    -- Municipio Silva
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tucacas', 'Parroquia', silva_id),
    ('Boca de Aroa', 'Parroquia', silva_id);

    -- Municipio Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Cruz de Taratara', 'Parroquia', sucre_m_id),
    ('Agua Salada', 'Parroquia', sucre_m_id),
    ('Churuguara', 'Parroquia', sucre_m_id),
    ('San Juan de los Cayos', 'Parroquia', sucre_m_id);

    -- Municipio Unión
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Cruz de Bucaral', 'Parroquia', union_id),
    ('Agua Larga', 'Parroquia', union_id),
    ('El Charal', 'Parroquia', union_id);

    -- Municipio Urumaco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Urumaco', 'Parroquia', urumaco_id),
    ('Bruzual', 'Parroquia', urumaco_id);

    -- Municipio Zamora
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Puerto Cumarebo', 'Parroquia', zamora_id),
    ('La Ciénaga', 'Parroquia', zamora_id),
    ('La Soledad', 'Parroquia', zamora_id),
    ('Pueblo Cumarebo', 'Parroquia', zamora_id),
    ('Zazárida', 'Parroquia', zamora_id);

END $$;
  
--------------------------------------guarico
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Guárico' es 13. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    guarico_estado_id INTEGER := 13; -- ID del estado Guárico
    camaguan_id INTEGER;
    chaguaramas_id INTEGER;
    el_socorro_id INTEGER;
    francisco_de_miranda_id INTEGER;
    jose_felix_ribas_id INTEGER;
    jose_tadeo_monagas_id INTEGER;
    juan_german_roscio_id INTEGER;
    julian_mellado_id INTEGER;
    las_mercedes_id INTEGER;
    leonardo_infante_id INTEGER;
    ortiz_id INTEGER;
    san_geronimo_de_guayabal_id INTEGER;
    san_jose_de_guaribe_id INTEGER;
    santa_maria_de_ipire_id INTEGER;
    zaraza_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Guárico
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Camaguán', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO camaguan_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Chaguaramas', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO chaguaramas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Socorro', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO el_socorro_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Francisco de Miranda', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO francisco_de_miranda_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('José Félix Ribas', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO jose_felix_ribas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('José Tadeo Monagas', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO jose_tadeo_monagas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Juan Germán Roscio', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO juan_german_roscio_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Julián Mellado', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO julian_mellado_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Las Mercedes', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO las_mercedes_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Leonardo Infante', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO leonardo_infante_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ortiz', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO ortiz_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Gerónimo de Guayabal', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO san_geronimo_de_guayabal_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San José de Guaribe', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO san_jose_de_guaribe_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa María de Ipire', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO santa_maria_de_ipire_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Zaraza', 'Municipio', guarico_estado_id) RETURNING lugar_id INTO zaraza_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Camaguán
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Camaguán', 'Parroquia', camaguan_id),
    ('Puerto Miranda', 'Parroquia', camaguan_id),
    ('Uverito', 'Parroquia', camaguan_id);

    -- Municipio Chaguaramas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Chaguaramas', 'Parroquia', chaguaramas_id);

    -- Municipio El Socorro
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Socorro', 'Parroquia', el_socorro_id);

    -- Municipio Francisco de Miranda
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Calabozo', 'Parroquia', francisco_de_miranda_id),
    ('El Calvario', 'Parroquia', francisco_de_miranda_id),
    ('El Rastro', 'Parroquia', francisco_de_miranda_id),
    ('Guardatinajas', 'Parroquia', francisco_de_miranda_id);

    -- Municipio José Félix Ribas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tucupido', 'Parroquia', jose_felix_ribas_id),
    ('San Rafael de Laya', 'Parroquia', jose_felix_ribas_id);

    -- Municipio José Tadeo Monagas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Altagracia de Orituco', 'Parroquia', jose_tadeo_monagas_id),
    ('Lezama', 'Parroquia', jose_tadeo_monagas_id),
    ('Paso Real de Macaira', 'Parroquia', jose_tadeo_monagas_id),
    ('San Francisco de Macaira', 'Parroquia', jose_tadeo_monagas_id),
    ('San Rafael de Orituco', 'Parroquia', jose_tadeo_monagas_id),
    ('Soublette', 'Parroquia', jose_tadeo_monagas_id);

    -- Municipio Juan Germán Roscio
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Juan de los Morros', 'Parroquia', juan_german_roscio_id),
    ('Cantagallo', 'Parroquia', juan_german_roscio_id),
    ('Parapara', 'Parroquia', juan_german_roscio_id);

    -- Municipio Julián Mellado
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Sombrero', 'Parroquia', julian_mellado_id),
    ('Sosa', 'Parroquia', julian_mellado_id);

    -- Municipio Las Mercedes
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Las Mercedes', 'Parroquia', las_mercedes_id),
    ('Cabruta', 'Parroquia', las_mercedes_id),
    ('Santa Rita de Manapire', 'Parroquia', las_mercedes_id);

    -- Municipio Leonardo Infante
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Valle de la Pascua', 'Parroquia', leonardo_infante_id),
    ('Espino', 'Parroquia', leonardo_infante_id);

    -- Municipio Ortiz
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ortiz', 'Parroquia', ortiz_id),
    ('San Francisco de Tiznados', 'Parroquia', ortiz_id),
    ('San José de Tiznados', 'Parroquia', ortiz_id),
    ('San Lorenzo de Tiznados', 'Parroquia', ortiz_id);

    -- Municipio San Gerónimo de Guayabal
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guayabal', 'Parroquia', san_geronimo_de_guayabal_id),
    ('Cazorla', 'Parroquia', san_geronimo_de_guayabal_id);

    -- Municipio San José de Guaribe
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San José de Guaribe', 'Parroquia', san_jose_de_guaribe_id);

    -- Municipio Santa María de Ipire
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa María de Ipire', 'Parroquia', santa_maria_de_ipire_id),
    ('Altamira', 'Parroquia', santa_maria_de_ipire_id);

    -- Municipio Zaraza
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Zaraza', 'Parroquia', zaraza_id),
    ('San José de Unare', 'Parroquia', zaraza_id);

END $$;
  
--------------------------------------lara  
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Lara' es 14. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    lara_estado_id INTEGER := 14; -- ID del estado Lara
    andres_eloy_blanco_m_id INTEGER;
    crespo_id INTEGER;
    iribarren_id INTEGER;
    jimenez_id INTEGER;
    moran_id INTEGER;
    palavecino_id INTEGER;
    simon_planas_id INTEGER;
    torres_id INTEGER;
    urdaneta_m_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Lara
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Andrés Eloy Blanco', 'Municipio', lara_estado_id) RETURNING lugar_id INTO andres_eloy_blanco_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Crespo', 'Municipio', lara_estado_id) RETURNING lugar_id INTO crespo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Iribarren', 'Municipio', lara_estado_id) RETURNING lugar_id INTO iribarren_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Jiménez', 'Municipio', lara_estado_id) RETURNING lugar_id INTO jimenez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Morán', 'Municipio', lara_estado_id) RETURNING lugar_id INTO moran_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Palavecino', 'Municipio', lara_estado_id) RETURNING lugar_id INTO palavecino_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Simón Planas', 'Municipio', lara_estado_id) RETURNING lugar_id INTO simon_planas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Torres', 'Municipio', lara_estado_id) RETURNING lugar_id INTO torres_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Urdaneta', 'Municipio', lara_estado_id) RETURNING lugar_id INTO urdaneta_m_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Andrés Eloy Blanco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sanare', 'Parroquia', andres_eloy_blanco_m_id),
    ('Pío Tamayo', 'Parroquia', andres_eloy_blanco_m_id),
    ('Yacambú', 'Parroquia', andres_eloy_blanco_m_id);

    -- Municipio Crespo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Duaca', 'Parroquia', crespo_id),
    ('Anzoátegui', 'Parroquia', crespo_id);

    -- Municipio Iribarren
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aguedo Felipe Alvarado', 'Parroquia', iribarren_id),
    ('Buena Vista', 'Parroquia', iribarren_id),
    ('Catedral', 'Parroquia', iribarren_id),
    ('Concepción', 'Parroquia', iribarren_id),
    ('El Cují', 'Parroquia', iribarren_id),
    ('Juan de Villegas', 'Parroquia', iribarren_id),
    ('Santa Rosa', 'Parroquia', iribarren_id),
    ('Tamaca', 'Parroquia', iribarren_id),
    ('Unión', 'Parroquia', iribarren_id),
    ('Juares', 'Parroquia', iribarren_id);

    -- Municipio Jiménez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Quíbor', 'Parroquia', jimenez_id),
    ('Coronel Mariano Peraza', 'Parroquia', jimenez_id),
    ('Diego de Lozada', 'Parroquia', jimenez_id),
    ('Paraíso de San José', 'Parroquia', jimenez_id),
    ('Tintorero', 'Parroquia', jimenez_id);

    -- Municipio Morán
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Tocuyo', 'Parroquia', moran_id),
    ('Anzoátegui', 'Parroquia', moran_id),
    ('Guaríco', 'Parroquia', moran_id),
    ('Hilario Luna y Luna', 'Parroquia', moran_id),
    ('Humocaro Bajo', 'Parroquia', moran_id),
    ('Humocaro Alto', 'Parroquia', moran_id),
    ('La Candelaria', 'Parroquia', moran_id),
    ('Morán', 'Parroquia', moran_id);

    -- Municipio Palavecino
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cabudare', 'Parroquia', palavecino_id),
    ('José Gregorio Bastidas', 'Parroquia', palavecino_id),
    ('Agua Viva', 'Parroquia', palavecino_id);

    -- Municipio Simón Planas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sarare', 'Parroquia', simon_planas_id),
    ('Buría', 'Parroquia', simon_planas_id),
    ('Gustavo Vegas León', 'Parroquia', simon_planas_id);

    -- Municipio Torres
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Alfredro Peñaloza', 'Parroquia', torres_id),
    ('Antonio Díaz', 'Parroquia', torres_id),
    ('Camacaro', 'Parroquia', torres_id),
    ('Castañeda', 'Parroquia', torres_id),
    ('Cecilio Zubillaga', 'Parroquia', torres_id),
    ('Chiquinquirá', 'Parroquia', torres_id),
    ('El Blanco', 'Parroquia', torres_id),
    ('Espinoza de los Monteros', 'Parroquia', torres_id),
    ('Lara', 'Parroquia', torres_id),
    ('Las Mercedes', 'Parroquia', torres_id),
    ('Manuel Morillo', 'Parroquia', torres_id),
    ('Montaña Verde', 'Parroquia', torres_id),
    ('Montes de Oca', 'Parroquia', torres_id),
    ('Reyes Vargas', 'Parroquia', torres_id),
    ('San Miguel', 'Parroquia', torres_id),
    ('Tintorero', 'Parroquia', torres_id),
    ('Trinidad Samuel', 'Parroquia', torres_id);

    -- Municipio Urdaneta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Siquisique', 'Parroquia', urdaneta_m_id),
    ('Moroturo', 'Parroquia', urdaneta_m_id),
    ('San Miguel', 'Parroquia', urdaneta_m_id),
    ('Xaguas', 'Parroquia', urdaneta_m_id);

END $$;
--------------------------------------merida 
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Mérida' es 15. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    merida_estado_id INTEGER := 15; -- ID del estado Mérida
    alberto_adriani_id INTEGER;
    andres_bello_m_id INTEGER;
    antonio_pinto_salinas_id INTEGER;
    aricagua_id INTEGER;
    arzobispo_chacon_id INTEGER;
    campo_elias_id INTEGER;
    caracciolo_parra_olmedo_id INTEGER;
    cardenal_quintero_id INTEGER;
    guaraque_id INTEGER;
    julio_cesar_salas_id INTEGER;
    justo_briceno_id INTEGER;
    libertador_m_id INTEGER;
    miranda_m_id INTEGER;
    obispo_ramos_de_lora_id INTEGER;
    padre_noguera_id INTEGER;
    pueblo_llano_id INTEGER;
    rangel_id INTEGER;
    rivas_davila_id INTEGER;
    santos_marquina_id INTEGER;
    sucre_m_id INTEGER;
    tovar_id INTEGER;
    tulio_febres_cordero_id INTEGER;
    zea_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Mérida
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Alberto Adriani', 'Municipio', merida_estado_id) RETURNING lugar_id INTO alberto_adriani_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Andrés Bello', 'Municipio', merida_estado_id) RETURNING lugar_id INTO andres_bello_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Antonio Pinto Salinas', 'Municipio', merida_estado_id) RETURNING lugar_id INTO antonio_pinto_salinas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aricagua', 'Municipio', merida_estado_id) RETURNING lugar_id INTO aricagua_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Arzobispo Chacón', 'Municipio', merida_estado_id) RETURNING lugar_id INTO arzobispo_chacon_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Campo Elías', 'Municipio', merida_estado_id) RETURNING lugar_id INTO campo_elias_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Caracciolo Parra Olmedo', 'Municipio', merida_estado_id) RETURNING lugar_id INTO caracciolo_parra_olmedo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cardenal Quintero', 'Municipio', merida_estado_id) RETURNING lugar_id INTO cardenal_quintero_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guaraque', 'Municipio', merida_estado_id) RETURNING lugar_id INTO guaraque_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Julio César Salas', 'Municipio', merida_estado_id) RETURNING lugar_id INTO julio_cesar_salas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Justo Briceño', 'Municipio', merida_estado_id) RETURNING lugar_id INTO justo_briceno_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertador', 'Municipio', merida_estado_id) RETURNING lugar_id INTO libertador_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Miranda', 'Municipio', merida_estado_id) RETURNING lugar_id INTO miranda_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Obispo Ramos de Lora', 'Municipio', merida_estado_id) RETURNING lugar_id INTO obispo_ramos_de_lora_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Padre Noguera', 'Municipio', merida_estado_id) RETURNING lugar_id INTO padre_noguera_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pueblo Llano', 'Municipio', merida_estado_id) RETURNING lugar_id INTO pueblo_llano_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Rangel', 'Municipio', merida_estado_id) RETURNING lugar_id INTO rangel_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Rivas Dávila', 'Municipio', merida_estado_id) RETURNING lugar_id INTO rivas_davila_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santos Marquina', 'Municipio', merida_estado_id) RETURNING lugar_id INTO santos_marquina_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', merida_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tovar', 'Municipio', merida_estado_id) RETURNING lugar_id INTO tovar_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tulio Febres Cordero', 'Municipio', merida_estado_id) RETURNING lugar_id INTO tulio_febres_cordero_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Zea', 'Municipio', merida_estado_id) RETURNING lugar_id INTO zea_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Alberto Adriani
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Héctor Amable Mora', 'Parroquia', alberto_adriani_id),
    ('Gabriel Picón González', 'Parroquia', alberto_adriani_id),
    ('José Nucete Sardi', 'Parroquia', alberto_adriani_id),
    ('Pulido Méndez', 'Parroquia', alberto_adriani_id),
    ('Rómulo Gallegos', 'Parroquia', alberto_adriani_id),
    ('Simón Rodríguez', 'Parroquia', alberto_adriani_id),
    ('Presidente Betancourt', 'Parroquia', alberto_adriani_id);

    -- Municipio Andrés Bello
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Azulita', 'Parroquia', andres_bello_m_id),
    ('Quebrada del Agua', 'Parroquia', andres_bello_m_id),
    ('Mesa de Las Palmas', 'Parroquia', andres_bello_m_id);

    -- Municipio Antonio Pinto Salinas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Cruz de Mora', 'Parroquia', antonio_pinto_salinas_id),
    ('Mesa Bolívar', 'Parroquia', antonio_pinto_salinas_id),
    ('Mesa de Las Palmas', 'Parroquia', antonio_pinto_salinas_id);

    -- Municipio Aricagua
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aricagua', 'Parroquia', aricagua_id),
    ('San Antonio', 'Parroquia', aricagua_id);

    -- Municipio Arzobispo Chacón
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Canaguá', 'Parroquia', arzobispo_chacon_id),
    ('Capurí', 'Parroquia', arzobispo_chacon_id),
    ('Chacantá', 'Parroquia', arzobispo_chacon_id),
    ('El Molino', 'Parroquia', arzobispo_chacon_id),
    ('Mucutuy', 'Parroquia', arzobispo_chacon_id),
    ('Mucuchachí', 'Parroquia', arzobispo_chacon_id);

    -- Municipio Campo Elías
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Fernández Peña', 'Parroquia', campo_elias_id),
    ('Jají', 'Parroquia', campo_elias_id),
    ('La Mesa', 'Parroquia', campo_elias_id),
    ('San José de Acequias', 'Parroquia', campo_elias_id),
    ('Acequias', 'Parroquia', campo_elias_id),
    ('Montalbán', 'Parroquia', campo_elias_id);

    -- Municipio Caracciolo Parra Olmedo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tulio Febres Cordero', 'Parroquia', caracciolo_parra_olmedo_id),
    ('Independencia', 'Parroquia', caracciolo_parra_olmedo_id),
    ('Mariano Picón Salas', 'Parroquia', caracciolo_parra_olmedo_id);

    -- Municipio Cardenal Quintero
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santo Domingo', 'Parroquia', cardenal_quintero_id),
    ('Las Piedras', 'Parroquia', cardenal_quintero_id);

    -- Municipio Guaraque
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guaraque', 'Parroquia', guaraque_id),
    ('Mesa de Quintero', 'Parroquia', guaraque_id),
    ('Río Negro', 'Parroquia', guaraque_id);

    -- Municipio Julio César Salas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Arapuey', 'Parroquia', julio_cesar_salas_id),
    ('Palmira', 'Parroquia', julio_cesar_salas_id),
    ('San José de Palmira', 'Parroquia', julio_cesar_salas_id);

    -- Municipio Justo Briceño
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Justo Briceño', 'Parroquia', justo_briceno_id),
    ('San Rafael', 'Parroquia', justo_briceno_id),
    ('Las Piedras', 'Parroquia', justo_briceno_id);

    -- Municipio Libertador
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Antonio Spinetti Dini', 'Parroquia', libertador_m_id),
    ('Arias', 'Parroquia', libertador_m_id),
    ('Caracciolo Parra Pérez', 'Parroquia', libertador_m_id),
    ('Domingo Peña', 'Parroquia', libertador_m_id),
    ('El Llano', 'Parroquia', libertador_m_id),
    ('Gonzalo Picón Febres', 'Parroquia', libertador_m_id),
    ('Jacinto Plaza', 'Parroquia', libertador_m_id),
    ('Juan Rodríguez Suárez', 'Parroquia', libertador_m_id),
    ('Lasso de la Vega', 'Parroquia', libertador_m_id),
    ('Mariano Picón Salas', 'Parroquia', libertador_m_id),
    ('Milla', 'Parroquia', libertador_m_id),
    ('Osuna Rodríguez', 'Parroquia', libertador_m_id),
    ('Sagrario', 'Parroquia', libertador_m_id),
    ('El Morro', 'Parroquia', libertador_m_id),
    ('Los Nevados', 'Parroquia', libertador_m_id);

    -- Municipio Miranda
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Timotes', 'Parroquia', miranda_m_id),
    ('Chachopo', 'Parroquia', miranda_m_id),
    ('La Venta', 'Parroquia', miranda_m_id);

    -- Municipio Obispo Ramos de Lora
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Elena de Arenales', 'Parroquia', obispo_ramos_de_lora_id),
    ('Eloy Paredes', 'Parroquia', obispo_ramos_de_lora_id),
    ('San Rafael de Alcázar', 'Parroquia', obispo_ramos_de_lora_id);

    -- Municipio Padre Noguera
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa María de Caparo', 'Parroquia', padre_noguera_id),
    ('Pueblo Nuevo', 'Parroquia', padre_noguera_id);

    -- Municipio Pueblo Llano
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pueblo Llano', 'Parroquia', pueblo_llano_id);

    -- Municipio Rangel
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mucuchíes', 'Parroquia', rangel_id),
    ('Cacute', 'Parroquia', rangel_id),
    ('Gavidia', 'Parroquia', rangel_id),
    ('La Toma', 'Parroquia', rangel_id),
    ('San Rafael', 'Parroquia', rangel_id);

    -- Municipio Rivas Dávila
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bailadores', 'Parroquia', rivas_davila_id),
    ('La Playa', 'Parroquia', rivas_davila_id);

    -- Municipio Santos Marquina
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tabay', 'Parroquia', santos_marquina_id);

    -- Municipio Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Lagunillas', 'Parroquia', sucre_m_id),
    ('San Juan', 'Parroquia', sucre_m_id),
    ('El Páramo', 'Parroquia', sucre_m_id),
    ('La Trampa', 'Parroquia', sucre_m_id),
    ('Pueblo Nuevo del Sur', 'Parroquia', sucre_m_id),
    ('Chacantá', 'Parroquia', sucre_m_id);

    -- Municipio Tovar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tovar', 'Parroquia', tovar_id),
    ('El Amparo', 'Parroquia', tovar_id),
    ('San Francisco', 'Parroquia', tovar_id),
    ('Vigía', 'Parroquia', tovar_id);

    -- Municipio Tulio Febres Cordero
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Nueva Bolivia', 'Parroquia', tulio_febres_cordero_id),
    ('Independencia', 'Parroquia', tulio_febres_cordero_id),
    ('María de la Concepción Palacios Blanco', 'Parroquia', tulio_febres_cordero_id),
    ('Santa Apolonia', 'Parroquia', tulio_febres_cordero_id);

    -- Municipio Zea
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Zea', 'Parroquia', zea_id),
    ('Caño El Tigre', 'Parroquia', zea_id);

END $$;  
--------------------------------------miranda   
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Miranda' es 3. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    miranda_estado_id INTEGER := 16; -- ID del estado Miranda
    acevedo_id INTEGER;
    andres_bello_m_id INTEGER;
    baruta_id INTEGER;
    brion_id INTEGER;
    buroz_m_id INTEGER;
    carrizal_id INTEGER;
    chacao_id INTEGER;
    cristobal_rojas_id INTEGER;
    el_hatillo_id INTEGER;
    guaicaipuro_id INTEGER;
    independencia_m_id INTEGER;
    lander_id INTEGER;
    los_salias_id INTEGER;
    paez_id INTEGER;
    paz_castillo_id INTEGER;
    pedro_gual_id INTEGER;
    plaza_id INTEGER;
    simon_bolivar_m_id INTEGER;
    sucre_m_id INTEGER;
    urdaneta_m_id INTEGER;
    zamora_m_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Miranda
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Acevedo', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO acevedo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Andrés Bello', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO andres_bello_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Baruta', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO baruta_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Brión', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO brion_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Buroz', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO buroz_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Carrizal', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO carrizal_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Chacao', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO chacao_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cristóbal Rojas', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO cristobal_rojas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Hatillo', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO el_hatillo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guaicaipuro', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO guaicaipuro_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Independencia', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO independencia_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Lander', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO lander_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Los Salias', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO los_salias_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Páez', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO paez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Paz Castillo', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO paz_castillo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pedro Gual', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO pedro_gual_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Plaza', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO plaza_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Simón Bolívar', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO simon_bolivar_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Urdaneta', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO urdaneta_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Zamora', 'Municipio', miranda_estado_id) RETURNING lugar_id INTO zamora_m_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Acevedo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Caucagua', 'Parroquia', acevedo_id),
    ('Capaya', 'Parroquia', acevedo_id),
    ('Aragüita', 'Parroquia', acevedo_id),
    ('Araguita', 'Parroquia', acevedo_id), -- Nota: 'Aragüita' y 'Araguita' son diferentes en tu lista
    ('Bolívar', 'Parroquia', acevedo_id),
    ('Buroz', 'Parroquia', acevedo_id),
    ('Marizapa', 'Parroquia', acevedo_id),
    ('Panaquire', 'Parroquia', acevedo_id),
    ('Ribas', 'Parroquia', acevedo_id);

    -- Municipio Andrés Bello
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San José de Barlovento', 'Parroquia', andres_bello_m_id),
    ('Cumbo', 'Parroquia', andres_bello_m_id),
    ('San José', 'Parroquia', andres_bello_m_id);

    -- Municipio Baruta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Baruta', 'Parroquia', baruta_id),
    ('El Cafetal', 'Parroquia', baruta_id),
    ('Las Minas', 'Parroquia', baruta_id),
    ('Nuestra Señora del Rosario', 'Parroquia', baruta_id);

    -- Municipio Brión
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Higuerote', 'Parroquia', brion_id),
    ('Curiepe', 'Parroquia', brion_id),
    ('Tacarigua de la Laguna', 'Parroquia', brion_id);

    -- Municipio Buroz
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mamporal', 'Parroquia', buroz_m_id);

    -- Municipio Carrizal
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Carrizal', 'Parroquia', carrizal_id);

    -- Municipio Chacao
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Chacao', 'Parroquia', chacao_id);

    -- Municipio Cristóbal Rojas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Charallave', 'Parroquia', cristobal_rojas_id),
    ('Las Brisas', 'Parroquia', cristobal_rojas_id);

    -- Municipio El Hatillo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Hatillo', 'Parroquia', el_hatillo_id);

    -- Municipio Guaicaipuro
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Los Teques', 'Parroquia', guaicaipuro_id),
    ('Altagracia de la Montaña', 'Parroquia', guaicaipuro_id),
    ('Cecilio Acosta', 'Parroquia', guaicaipuro_id),
    ('El Jarillo', 'Parroquia', guaicaipuro_id),
    ('San Pedro', 'Parroquia', guaicaipuro_id),
    ('Tácata', 'Parroquia', guaicaipuro_id),
    ('Paracotos', 'Parroquia', guaicaipuro_id);

    -- Municipio Independencia
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Teresa', 'Parroquia', independencia_m_id),
    ('Cartanal', 'Parroquia', independencia_m_id);

    -- Municipio Lander
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ocumare del Tuy', 'Parroquia', lander_id),
    ('La Democracia', 'Parroquia', lander_id),
    ('Santa Bárbara', 'Parroquia', lander_id);

    -- Municipio Los Salias
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Antonio de los Altos', 'Parroquia', los_salias_id);

    -- Municipio Páez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Río Chico', 'Parroquia', paez_id),
    ('El Cafetal', 'Parroquia', paez_id),
    ('Paparo', 'Parroquia', paez_id),
    ('San Fernando del Guapo', 'Parroquia', paez_id),
    ('Tacarigua de la Laguna', 'Parroquia', paez_id);

    -- Municipio Paz Castillo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Lucía', 'Parroquia', paz_castillo_id);

    -- Municipio Pedro Gual
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cúpira', 'Parroquia', pedro_gual_id),
    ('Machurucuto', 'Parroquia', pedro_gual_id);

    -- Municipio Plaza
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guarenas', 'Parroquia', plaza_id),
    ('Ambrosio Plaza', 'Parroquia', plaza_id);

    -- Municipio Simón Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Francisco de Yare', 'Parroquia', simon_bolivar_m_id),
    ('San Antonio de Yare', 'Parroquia', simon_bolivar_m_id);

    -- Municipio Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Petare', 'Parroquia', sucre_m_id),
    ('Caucagüita', 'Parroquia', sucre_m_id),
    ('Filas de Mariche', 'Parroquia', sucre_m_id),
    ('La Dolorita', 'Parroquia', sucre_m_id),
    ('Leoncio Martínez', 'Parroquia', sucre_m_id);

    -- Municipio Urdaneta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cúa', 'Parroquia', urdaneta_m_id),
    ('Nueva Cúa', 'Parroquia', urdaneta_m_id);

    -- Municipio Zamora
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guatire', 'Parroquia', zamora_m_id),
    ('Bolívar', 'Parroquia', zamora_m_id),
    ('Pacairigua', 'Parroquia', zamora_m_id);

END $$;
--------------------------------------monagas  
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Monagas' es 16. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    monagas_estado_id INTEGER := 17; -- ID del estado Monagas
    acosta_m_id INTEGER;
    aguasay_id INTEGER;
    bolivar_m_id INTEGER;
    caripe_id INTEGER;
    cedeno_id INTEGER;
    ezequiel_zamora_id INTEGER;
    libertador_m_id INTEGER;
    maturin_id INTEGER;
    piar_id INTEGER;
    punceres_id INTEGER;
    santa_barbara_m_id INTEGER;
    sotillo_id INTEGER;
    uracoa_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Monagas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Acosta', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO acosta_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aguasay', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO aguasay_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bolívar', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO bolivar_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Caripe', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO caripe_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cedeño', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO cedeno_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ezequiel Zamora', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO ezequiel_zamora_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertador', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO libertador_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Maturín', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO maturin_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Piar', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO piar_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Punceres', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO punceres_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Bárbara', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO santa_barbara_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sotillo', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO sotillo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Uracoa', 'Municipio', monagas_estado_id) RETURNING lugar_id INTO uracoa_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Acosta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Antonio de Capayacuar', 'Parroquia', acosta_m_id),
    ('Punceres', 'Parroquia', acosta_m_id),
    ('San Francisco', 'Parroquia', acosta_m_id);

    -- Municipio Aguasay
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aguasay', 'Parroquia', aguasay_id);

    -- Municipio Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Caripito', 'Parroquia', bolivar_m_id);

    -- Municipio Caripe
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Caripe', 'Parroquia', caripe_id),
    ('El Guácharo', 'Parroquia', caripe_id),
    ('La Guanota', 'Parroquia', caripe_id),
    ('Sabana de Piedra', 'Parroquia', caripe_id),
    ('San Agustín', 'Parroquia', caripe_id);

    -- Municipio Cedeño
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Caicara', 'Parroquia', cedeno_id),
    ('Areo', 'Parroquia', cedeno_id),
    ('San Félix', 'Parroquia', cedeno_id);

    -- Municipio Ezequiel Zamora
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Punta de Mata', 'Parroquia', ezequiel_zamora_id),
    ('El Tejero', 'Parroquia', ezequiel_zamora_id);

    -- Municipio Libertador
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Temblador', 'Parroquia', libertador_m_id),
    ('Chaguaramas', 'Parroquia', libertador_m_id),
    ('Las Alhuacas', 'Parroquia', libertador_m_id),
    ('Tabasca', 'Parroquia', libertador_m_id);

    -- Municipio Maturín
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Alto de Los Godos', 'Parroquia', maturin_id),
    ('Boquerón', 'Parroquia', maturin_id),
    ('Las Cocuizas', 'Parroquia', maturin_id),
    ('San Simón', 'Parroquia', maturin_id),
    ('Santa Cruz', 'Parroquia', maturin_id),
    ('El Corozo', 'Parroquia', maturin_id),
    ('El Furrial', 'Parroquia', maturin_id),
    ('Jusepín', 'Parroquia', maturin_id),
    ('La Pica', 'Parroquia', maturin_id),
    ('San Vicente', 'Parroquia', maturin_id),
    ('Aguas Nuevas', 'Parroquia', maturin_id),
    ('El Colorado', 'Parroquia', maturin_id),
    ('San Rafael de Maturín', 'Parroquia', maturin_id);

    -- Municipio Piar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aragua', 'Parroquia', piar_id),
    ('Aparicio', 'Parroquia', piar_id),
    ('Chaguaramas', 'Parroquia', piar_id),
    ('La Toscana', 'Parroquia', piar_id);

    -- Municipio Punceres
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Quiriquire', 'Parroquia', punceres_id),
    ('Santa Bárbara', 'Parroquia', punceres_id);

    -- Municipio Santa Bárbara
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Bárbara', 'Parroquia', santa_barbara_m_id),
    ('Tabasca', 'Parroquia', santa_barbara_m_id);

    -- Municipio Sotillo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Barrancas', 'Parroquia', sotillo_id),
    ('Chaguaramas', 'Parroquia', sotillo_id),
    ('Los Barrancos de Fajardo', 'Parroquia', sotillo_id);

    -- Municipio Uracoa
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Uracoa', 'Parroquia', uracoa_id);

END $$;
--------------------------------------nueva Esparta 
  -- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Nueva Esparta' es 17. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    nueva_esparta_estado_id INTEGER := 18; -- ID del estado Nueva Esparta
    antolin_del_campo_id INTEGER;
    arismendi_m_id INTEGER;
    diaz_id INTEGER;
    garcia_id INTEGER;
    gomez_id INTEGER;
    maneiro_id INTEGER;
    marcano_id INTEGER;
    marino_id INTEGER;
    macanao_id INTEGER;
    tubores_id INTEGER;
    villalba_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Nueva Esparta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Antolín del Campo', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO antolin_del_campo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Arismendi', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO arismendi_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Díaz', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO diaz_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('García', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO garcia_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Gómez', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO gomez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Maneiro', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO maneiro_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Marcano', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO marcano_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mariño', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO marino_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Macanao', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO macanao_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tubores', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO tubores_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Villalba', 'Municipio', nueva_esparta_estado_id) RETURNING lugar_id INTO villalba_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Antolín del Campo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Plaza de Paraguachí', 'Parroquia', antolin_del_campo_id),
    ('El Salado', 'Parroquia', antolin_del_campo_id);

    -- Municipio Arismendi
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Asunción', 'Parroquia', arismendi_m_id),
    ('Aguirre', 'Parroquia', arismendi_m_id);

    -- Municipio Díaz
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Juan Bautista', 'Parroquia', diaz_id),
    ('Las Guevaras', 'Parroquia', diaz_id),
    ('El Maco', 'Parroquia', diaz_id),
    ('Zabala', 'Parroquia', diaz_id);

    -- Municipio García
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Antonio', 'Parroquia', garcia_id),
    ('Francisco Fajardo', 'Parroquia', garcia_id),
    ('La Guardia', 'Parroquia', garcia_id);

    -- Municipio Gómez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Ana', 'Parroquia', gomez_id),
    ('Bolívar', 'Parroquia', gomez_id),
    ('Guevara', 'Parroquia', gomez_id),
    ('Matasiete', 'Parroquia', gomez_id),
    ('Sucre', 'Parroquia', gomez_id);

    -- Municipio Maneiro
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pampatar', 'Parroquia', maneiro_id),
    ('Aguirre', 'Parroquia', maneiro_id),
    ('Jorge Coll', 'Parroquia', maneiro_id);

    -- Municipio Marcano
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Juan Griego', 'Parroquia', marcano_id),
    ('Adrián', 'Parroquia', marcano_id),
    ('Vicente Fuentes', 'Parroquia', marcano_id);

    -- Municipio Mariño
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Porlamar', 'Parroquia', marino_id),
    ('Aguirre', 'Parroquia', marino_id),
    ('Boquerón', 'Parroquia', marino_id),
    ('Francisco Fajardo', 'Parroquia', marino_id),
    ('Las Salinas', 'Parroquia', marino_id),
    ('Los Robles', 'Parroquia', marino_id),
    ('San Francisco', 'Parroquia', marino_id),
    ('San Juan', 'Parroquia', marino_id),
    ('San Pedro', 'Parroquia', marino_id),
    ('Santa Ana', 'Parroquia', marino_id),
    ('Vicente Fuentes', 'Parroquia', marino_id);

    -- Municipio Macanao
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Boca de Río', 'Parroquia', macanao_id),
    ('San Francisco', 'Parroquia', macanao_id),
    ('San Juan', 'Parroquia', macanao_id),
    ('San Pedro', 'Parroquia', macanao_id),
    ('Santa Ana', 'Parroquia', macanao_id),
    ('Vicente Fuentes', 'Parroquia', macanao_id);

    -- Municipio Tubores
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Punta de Piedras', 'Parroquia', tubores_id),
    ('Los Robles', 'Parroquia', tubores_id),
    ('San Pedro', 'Parroquia', tubores_id);

    -- Municipio Villalba
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Pedro de Coche', 'Parroquia', villalba_id),
    ('Vicente Fuentes', 'Parroquia', villalba_id);

END $$;
--------------------------------------portuguesa  
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Portuguesa' es 18. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    portuguesa_estado_id INTEGER := 19; -- ID del estado Portuguesa
    agua_blanca_id INTEGER;
    araure_id INTEGER;
    esteller_id INTEGER;
    guanare_id INTEGER;
    guanarito_id INTEGER;
    monsenor_jose_vicente_de_unda_id INTEGER;
    ospino_id INTEGER;
    paez_id INTEGER;
    papelon_id INTEGER;
    san_genaro_de_boconito_id INTEGER;
    san_rafael_de_onoto_id INTEGER;
    santa_rosalia_id INTEGER;
    sucre_m_id INTEGER;
    turen_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Portuguesa
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Agua Blanca', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO agua_blanca_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Araure', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO araure_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Esteller', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO esteller_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guanare', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO guanare_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guanarito', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO guanarito_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Monseñor José Vicente de Unda', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO monsenor_jose_vicente_de_unda_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ospino', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO ospino_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Páez', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO paez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Papelón', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO papelon_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Genaro de Boconoíto', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO san_genaro_de_boconito_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Rafael de Onoto', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO san_rafael_de_onoto_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Rosalía', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO santa_rosalia_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Turén', 'Municipio', portuguesa_estado_id) RETURNING lugar_id INTO turen_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Agua Blanca
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Agua Blanca', 'Parroquia', agua_blanca_id);

    -- Municipio Araure
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Araure', 'Parroquia', araure_id),
    ('Río Acarigua', 'Parroquia', araure_id);

    -- Municipio Esteller
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Píritu', 'Parroquia', esteller_id),
    ('Uveral', 'Parroquia', esteller_id);

    -- Municipio Guanare
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guanare', 'Parroquia', guanare_id),
    ('Córdoba', 'Parroquia', guanare_id),
    ('San José de la Montaña', 'Parroquia', guanare_id),
    ('San Juan de Guanaguanare', 'Parroquia', guanare_id),
    ('Virgen de la Coromoto', 'Parroquia', guanare_id);

    -- Municipio Guanarito
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guanarito', 'Parroquia', guanarito_id),
    ('La Capilla', 'Parroquia', guanarito_id),
    ('Troncal 5', 'Parroquia', guanarito_id);

    -- Municipio Monseñor José Vicente de Unda
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Paraíso de Chabasquén', 'Parroquia', monsenor_jose_vicente_de_unda_id),
    ('Peña Blanca', 'Parroquia', monsenor_jose_vicente_de_unda_id);

    -- Municipio Ospino
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ospino', 'Parroquia', ospino_id),
    ('La Aparición', 'Parroquia', ospino_id),
    ('La Estación', 'Parroquia', ospino_id);

    -- Municipio Páez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Acarigua', 'Parroquia', paez_id),
    ('Payara', 'Parroquia', paez_id),
    ('Pimpinela', 'Parroquia', paez_id),
    ('Ramón Peraza', 'Parroquia', paez_id);

    -- Municipio Papelón
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Papelón', 'Parroquia', papelon_id),
    ('Caño Delgadito', 'Parroquia', papelon_id);

    -- Municipio San Genaro de Boconoíto
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Boconoíto', 'Parroquia', san_genaro_de_boconito_id);

    -- Municipio San Rafael de Onoto
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Rafael de Onoto', 'Parroquia', san_rafael_de_onoto_id),
    ('Santa Fe', 'Parroquia', san_rafael_de_onoto_id),
    ('Valle de la Pascua', 'Parroquia', san_rafael_de_onoto_id);

    -- Municipio Santa Rosalía
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Playón', 'Parroquia', santa_rosalia_id),
    ('Canelones', 'Parroquia', santa_rosalia_id);

    -- Municipio Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Biscucuy', 'Parroquia', sucre_m_id),
    ('San José de Saguaz', 'Parroquia', sucre_m_id),
    ('San Rafael de Palo Alzado', 'Parroquia', sucre_m_id),
    ('Uvencio Antonio Velásquez', 'Parroquia', sucre_m_id),
    ('Villa Rosa', 'Parroquia', sucre_m_id);

    -- Municipio Turén
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Villa Bruzual', 'Parroquia', turen_id),
    ('Canelones', 'Parroquia', turen_id),
    ('Santa Cruz', 'Parroquia', turen_id),
    ('San Rafael de Palo Alzado', 'Parroquia', turen_id);

END $$;
--------------------------------------sucre  
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Sucre' es 19. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    sucre_estado_id INTEGER := 20; -- ID del estado Sucre
    andres_eloy_blanco_m_id INTEGER;
    andres_mata_id INTEGER;
    arismendi_m_id INTEGER;
    benitez_id INTEGER;
    bermudez_id INTEGER;
    bolivar_m_id INTEGER;
    cajigal_id INTEGER;
    cruz_salmeron_acosta_id INTEGER;
    libertador_m_id INTEGER;
    marino_m_id INTEGER;
    mejia_id INTEGER;
    montes_id INTEGER;
    ribero_id INTEGER;
    sucre_m_id_municipio INTEGER; -- Renombrado para evitar conflicto con el estado
    valdez_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Andrés Eloy Blanco', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO andres_eloy_blanco_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Andrés Mata', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO andres_mata_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Arismendi', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO arismendi_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Benítez', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO benitez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bermúdez', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO bermudez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bolívar', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO bolivar_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cajigal', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO cajigal_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cruz Salmerón Acosta', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO cruz_salmeron_acosta_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertador', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO libertador_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mariño', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO marino_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mejía', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO mejia_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Montes', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO montes_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ribero', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO ribero_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO sucre_m_id_municipio;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Valdez', 'Municipio', sucre_estado_id) RETURNING lugar_id INTO valdez_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Andrés Eloy Blanco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Casanay', 'Parroquia', andres_eloy_blanco_m_id),
    ('Mariño', 'Parroquia', andres_eloy_blanco_m_id);

    -- Municipio Andrés Mata
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San José de Aerocuar', 'Parroquia', andres_mata_id),
    ('Tunapuicito', 'Parroquia', andres_mata_id);

    -- Municipio Arismendi
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Río Caribe', 'Parroquia', arismendi_m_id),
    ('Antonio José de Sucre', 'Parroquia', arismendi_m_id),
    ('El Morro de Puerto Santo', 'Parroquia', arismendi_m_id),
    ('Puerto Santo', 'Parroquia', arismendi_m_id),
    ('San Juan de Las Galdonas', 'Parroquia', arismendi_m_id);

    -- Municipio Benítez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Pilar', 'Parroquia', benitez_id),
    ('El Rincón', 'Parroquia', benitez_id),
    ('Guaraúnos', 'Parroquia', benitez_id),
    ('Tunapuí', 'Parroquia', benitez_id),
    ('Unión', 'Parroquia', benitez_id);

    -- Municipio Bermúdez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Carúpano', 'Parroquia', bermudez_id),
    ('Macarapana', 'Parroquia', bermudez_id),
    ('Santa Catalina', 'Parroquia', bermudez_id),
    ('Santa Rosa', 'Parroquia', bermudez_id),
    ('Santa Teresa', 'Parroquia', bermudez_id);

    -- Municipio Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Marigüitar', 'Parroquia', bolivar_m_id),
    ('San Antonio del Golfo', 'Parroquia', bolivar_m_id);

    -- Municipio Cajigal
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Yaguaraparo', 'Parroquia', cajigal_id),
    ('El Paujil', 'Parroquia', cajigal_id),
    ('Liberta', 'Parroquia', cajigal_id),
    ('Pedro María Freites', 'Parroquia', cajigal_id);

    -- Municipio Cruz Salmerón Acosta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Araya', 'Parroquia', cruz_salmeron_acosta_id),
    ('Chacopata', 'Parroquia', cruz_salmeron_acosta_id),
    ('Manicuare', 'Parroquia', cruz_salmeron_acosta_id);

    -- Municipio Libertador
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Tunapuy', 'Parroquia', libertador_m_id),
    ('Campo Elías', 'Parroquia', libertador_m_id),
    ('San Antonio del Golfo', 'Parroquia', libertador_m_id);

    -- Municipio Mariño
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Irapa', 'Parroquia', marino_m_id),
    ('Campo Claro', 'Parroquia', marino_m_id),
    ('Marizapa', 'Parroquia', marino_m_id);

    -- Municipio Mejía
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Antonio del Golfo', 'Parroquia', mejia_id);

    -- Municipio Montes
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cumanacoa', 'Parroquia', montes_id),
    ('Arenas', 'Parroquia', montes_id),
    ('Aricagua', 'Parroquia', montes_id),
    ('Cocollar', 'Parroquia', montes_id),
    ('San Fernando', 'Parroquia', montes_id),
    ('San Lorenzo', 'Parroquia', montes_id);

    -- Municipio Ribero
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cariaco', 'Parroquia', ribero_id),
    ('Catuaro', 'Parroquia', ribero_id),
    ('Rómulo Gallegos', 'Parroquia', ribero_id),
    ('San Fernando', 'Parroquia', ribero_id),
    ('Santa María', 'Parroquia', ribero_id);

    -- Municipio Sucre (municipio)
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ayacucho', 'Parroquia', sucre_m_id_municipio),
    ('Gran Mariscal', 'Parroquia', sucre_m_id_municipio),
    ('Raúl Leoni', 'Parroquia', sucre_m_id_municipio),
    ('Valentín Valiente', 'Parroquia', sucre_m_id_municipio),
    ('Altagracia', 'Parroquia', sucre_m_id_municipio),
    ('Antonio José de Sucre', 'Parroquia', sucre_m_id_municipio),
    ('San Juan', 'Parroquia', sucre_m_id_municipio);

    -- Municipio Valdez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Güiria', 'Parroquia', valdez_id),
    ('Cristóbal Colón', 'Parroquia', valdez_id),
    ('Irapa', 'Parroquia', valdez_id),
    ('Punta de Piedras', 'Parroquia', valdez_id),
    ('Río Caribe', 'Parroquia', valdez_id);

END $$;
--------------------------------------tachira   
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Táchira' es 20. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    tachira_estado_id INTEGER := 21; -- ID del estado Táchira
    andres_bello_m_id INTEGER;
    antonio_romulo_costa_id INTEGER;
    ayacucho_id INTEGER;
    bolivar_m_id INTEGER;
    cardenas_id INTEGER;
    cordoba_id INTEGER;
    fernandez_feo_id INTEGER;
    francisco_de_miranda_id INTEGER;
    garcia_de_hevia_id INTEGER;
    guasimos_id INTEGER;
    independencia_m_id INTEGER;
    jauregui_id INTEGER;
    jose_maria_vargas_id INTEGER;
    junin_id INTEGER;
    libertad_id INTEGER;
    libertador_m_id INTEGER;
    lobatera_id INTEGER;
    michelena_id INTEGER;
    panamericano_id INTEGER;
    pedro_maria_urena_id INTEGER;
    rafael_urdaneta_id INTEGER;
    samuel_dario_maldonado_id INTEGER;
    san_cristobal_id INTEGER;
    san_judas_tadeo_id INTEGER;
    seboruco_id INTEGER;
    simon_rodriguez_id INTEGER;
    sucre_m_id INTEGER;
    torbes_id INTEGER;
    uribante_id INTEGER;
    san_jose_de_bolivar_id INTEGER;
    vargas_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Táchira
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Andrés Bello', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO andres_bello_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Antonio Rómulo Costa', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO antonio_romulo_costa_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ayacucho', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO ayacucho_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bolívar', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO bolivar_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cárdenas', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO cardenas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Córdoba', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO cordoba_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Fernández Feo', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO fernandez_feo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Francisco de Miranda', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO francisco_de_miranda_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('García de Hevia', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO garcia_de_hevia_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guásimos', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO guasimos_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Independencia', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO independencia_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Jáuregui', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO jauregui_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('José María Vargas', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO jose_maria_vargas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Junín', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO junin_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertad', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO libertad_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertador', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO libertador_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Lobatera', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO lobatera_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Michelena', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO michelena_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Panamericano', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO panamericano_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pedro María Ureña', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO pedro_maria_urena_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Rafael Urdaneta', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO rafael_urdaneta_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Samuel Darío Maldonado', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO samuel_dario_maldonado_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Cristóbal', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO san_cristobal_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Judas Tadeo', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO san_judas_tadeo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Seboruco', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO seboruco_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Simón Rodríguez', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO simon_rodriguez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Torbes', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO torbes_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Uribante', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO uribante_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San José de Bolívar', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO san_jose_de_bolivar_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Vargas', 'Municipio', tachira_estado_id) RETURNING lugar_id INTO vargas_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Andrés Bello
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cordero', 'Parroquia', andres_bello_m_id);

    -- Municipio Antonio Rómulo Costa
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Las Mesas', 'Parroquia', antonio_romulo_costa_id),
    ('La Blanca', 'Parroquia', antonio_romulo_costa_id);

    -- Municipio Ayacucho
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Colón', 'Parroquia', ayacucho_id),
    ('La Tendida', 'Parroquia', ayacucho_id),
    ('San Pedro del Río', 'Parroquia', ayacucho_id);

    -- Municipio Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Antonio del Táchira', 'Parroquia', bolivar_m_id),
    ('Juan Vicente Gómez', 'Parroquia', bolivar_m_id),
    ('Palotal', 'Parroquia', bolivar_m_id),
    ('Ureña', 'Parroquia', bolivar_m_id);

    -- Municipio Cárdenas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Táriba', 'Parroquia', cardenas_id),
    ('Amenodoro Rangel Lamus', 'Parroquia', cardenas_id),
    ('La Florida', 'Parroquia', cardenas_id);

    -- Municipio Córdoba
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Ana del Táchira', 'Parroquia', cordoba_id);

    -- Municipio Fernández Feo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Rafael del Piñal', 'Parroquia', fernandez_feo_id),
    ('Santo Domingo', 'Parroquia', fernandez_feo_id),
    ('Chumilla', 'Parroquia', fernandez_feo_id);

    -- Municipio Francisco de Miranda
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San José de Bolívar', 'Parroquia', francisco_de_miranda_id);

    -- Municipio García de Hevia
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Fría', 'Parroquia', garcia_de_hevia_id),
    ('Boca de Grita', 'Parroquia', garcia_de_hevia_id),
    ('José Antonio Páez', 'Parroquia', garcia_de_hevia_id);

    -- Municipio Guásimos
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Palmira', 'Parroquia', guasimos_id),
    ('San Agatón', 'Parroquia', guasimos_id),
    ('San Josecito', 'Parroquia', guasimos_id);

    -- Municipio Independencia
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Capacho Nuevo', 'Parroquia', independencia_m_id),
    ('Juan Vicente Bolívar', 'Parroquia', independencia_m_id),
    ('San Pedro de Capacho', 'Parroquia', independencia_m_id);

    -- Municipio Jáuregui
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Grita', 'Parroquia', jauregui_id),
    ('Emilio Constantino Guerrero', 'Parroquia', jauregui_id),
    ('Monseñor Miguel Antonio Salas', 'Parroquia', jauregui_id);

    -- Municipio José María Vargas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Cobre', 'Parroquia', jose_maria_vargas_id);

    -- Municipio Junín
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Rubio', 'Parroquia', junin_id),
    ('Bramón', 'Parroquia', junin_id),
    ('La Petrólea', 'Parroquia', junin_id),
    ('Quinimarí', 'Parroquia', junin_id);

    -- Municipio Libertad
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Capacho Viejo', 'Parroquia', libertad_id),
    ('Cipriano Castro', 'Parroquia', libertad_id),
    ('Manuel Felipe Rugeles', 'Parroquia', libertad_id);

    -- Municipio Libertador
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Abejales', 'Parroquia', libertador_m_id),
    ('Emeterio Ochoa', 'Parroquia', libertador_m_id),
    ('Juan Pablo Peñaloza', 'Parroquia', libertador_m_id),
    ('Pregonero', 'Parroquia', libertador_m_id);

    -- Municipio Lobatera
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Lobatera', 'Parroquia', lobatera_id),
    ('Constitución', 'Parroquia', lobatera_id);

    -- Municipio Michelena
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Michelena', 'Parroquia', michelena_id);

    -- Municipio Panamericano
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Colón', 'Parroquia', panamericano_id),
    ('La Palmita', 'Parroquia', panamericano_id);

    -- Municipio Pedro María Ureña
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ureña', 'Parroquia', pedro_maria_urena_id),
    ('Nueva Arcadia', 'Parroquia', pedro_maria_urena_id);

    -- Municipio Rafael Urdaneta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Delicias', 'Parroquia', rafael_urdaneta_id),
    ('Pregonero', 'Parroquia', rafael_urdaneta_id);

    -- Municipio Samuel Darío Maldonado
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Tendida', 'Parroquia', samuel_dario_maldonado_id),
    ('Boconó', 'Parroquia', samuel_dario_maldonado_id),
    ('Hernández', 'Parroquia', samuel_dario_maldonado_id);

    -- Municipio San Cristóbal
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Cristóbal', 'Parroquia', san_cristobal_id),
    ('Dr. Francisco Romero Lobo', 'Parroquia', san_cristobal_id),
    ('La Concordia', 'Parroquia', san_cristobal_id),
    ('Pedro María Morantes', 'Parroquia', san_cristobal_id),
    ('San Juan Bautista', 'Parroquia', san_cristobal_id);

    -- Municipio San Judas Tadeo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Umuquena', 'Parroquia', san_judas_tadeo_id);

    -- Municipio Seboruco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Seboruco', 'Parroquia', seboruco_id);

    -- Municipio Simón Rodríguez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Simón', 'Parroquia', simon_rodriguez_id);

    -- Municipio Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Queniquea', 'Parroquia', sucre_m_id),
    ('La Mesa', 'Parroquia', sucre_m_id),
    ('San Pablo', 'Parroquia', sucre_m_id);

    -- Municipio Torbes
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Josecito', 'Parroquia', torbes_id);

    -- Municipio Uribante
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pregonero', 'Parroquia', uribante_id),
    ('Cárdenas', 'Parroquia', uribante_id),
    ('Juan Pablo Peñaloza', 'Parroquia', uribante_id),
    ('La Fundación', 'Parroquia', uribante_id);

    -- Municipio San José de Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San José de Bolívar', 'Parroquia', san_jose_de_bolivar_id);

    -- Municipio Vargas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Cobre', 'Parroquia', vargas_id);

END $$;
--------------------------------------trujillo 
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Trujillo' es 21. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    trujillo_estado_id INTEGER := 22; -- ID del estado Trujillo
    andres_bello_m_id INTEGER;
    bocono_id INTEGER;
    bolivar_m_id INTEGER;
    candelaria_id INTEGER;
    carache_id INTEGER;
    escuque_id INTEGER;
    jose_felipe_marquez_canizalez_id INTEGER;
    juan_vicente_campo_elias_id INTEGER;
    la_ceiba_id INTEGER;
    miranda_m_id INTEGER;
    monte_carmelo_id INTEGER;
    motatan_id INTEGER;
    pampan_id INTEGER;
    pampanito_id INTEGER;
    rafael_rangel_id INTEGER;
    san_rafael_de_carvajal_id INTEGER;
    sucre_m_id INTEGER;
    trujillo_m_id INTEGER;
    urdaneta_m_id INTEGER;
    valera_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Trujillo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Andrés Bello', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO andres_bello_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Boconó', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO bocono_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bolívar', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO bolivar_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Candelaria', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO candelaria_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Carache', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO carache_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Escuque', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO escuque_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('José Felipe Márquez Cañizalez', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO jose_felipe_marquez_canizalez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Juan Vicente Campo Elías', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO juan_vicente_campo_elias_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Ceiba', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO la_ceiba_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Miranda', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO miranda_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Monte Carmelo', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO monte_carmelo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Motatán', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO motatan_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pampán', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO pampan_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pampanito', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO pampanito_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Rafael Rangel', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO rafael_rangel_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Rafael de Carvajal', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO san_rafael_de_carvajal_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Trujillo', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO trujillo_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Urdaneta', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO urdaneta_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Valera', 'Municipio', trujillo_estado_id) RETURNING lugar_id INTO valera_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Andrés Bello
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Isabel', 'Parroquia', andres_bello_m_id);

    -- Municipio Boconó
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Boconó', 'Parroquia', bocono_id),
    ('El Carmen', 'Parroquia', bocono_id),
    ('Mosquey', 'Parroquia', bocono_id),
    ('San Miguel', 'Parroquia', bocono_id),
    ('San Rafael', 'Parroquia', bocono_id),
    ('Burbusay', 'Parroquia', bocono_id),
    ('General Ribas', 'Parroquia', bocono_id),
    ('Guaramacal', 'Parroquia', bocono_id),
    ('La Vega de Guaramacal', 'Parroquia', bocono_id),
    ('Monseñor José Ignacio Méndez', 'Parroquia', bocono_id),
    ('Rafael Rangel', 'Parroquia', bocono_id),
    ('San José', 'Parroquia', bocono_id);

    -- Municipio Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sabana Grande', 'Parroquia', bolivar_m_id),
    ('Cheregüé', 'Parroquia', bolivar_m_id),
    ('Granados', 'Parroquia', bolivar_m_id);

    -- Municipio Candelaria
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Chejendé', 'Parroquia', candelaria_id),
    ('Carrillo', 'Parroquia', candelaria_id),
    ('La Mesa de Esnujaque', 'Parroquia', candelaria_id),
    ('San José de la Mesa', 'Parroquia', candelaria_id),
    ('San Rafael de Pallardí', 'Parroquia', candelaria_id),
    ('Santa Rosa', 'Parroquia', candelaria_id);

    -- Municipio Carache
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Carache', 'Parroquia', carache_id),
    ('La Concepción', 'Parroquia', carache_id),
    ('Cuicas', 'Parroquia', carache_id),
    ('Panamericana', 'Parroquia', carache_id);

    -- Municipio Escuque
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Escuque', 'Parroquia', escuque_id),
    ('La Unión', 'Parroquia', escuque_id),
    ('Sabana Libre', 'Parroquia', escuque_id),
    ('Santa Rita', 'Parroquia', escuque_id);

    -- Municipio José Felipe Márquez Cañizalez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Paradero', 'Parroquia', jose_felipe_marquez_canizalez_id),
    ('La Esperanza', 'Parroquia', jose_felipe_marquez_canizalez_id),
    ('Los Cedros', 'Parroquia', jose_felipe_marquez_canizalez_id);

    -- Municipio Juan Vicente Campo Elías
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Campo Elías', 'Parroquia', juan_vicente_campo_elias_id),
    ('San Rafael de Carvajal', 'Parroquia', juan_vicente_campo_elias_id);

    -- Municipio La Ceiba
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Ceiba', 'Parroquia', la_ceiba_id),
    ('El Progreso', 'Parroquia', la_ceiba_id),
    ('La Paz', 'Parroquia', la_ceiba_id),
    ('Santa Apolonia', 'Parroquia', la_ceiba_id);

    -- Municipio Miranda
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('El Dividive', 'Parroquia', miranda_m_id),
    ('Agua Santa', 'Parroquia', miranda_m_id),
    ('Agua Caliente', 'Parroquia', miranda_m_id),
    ('El Cenizo', 'Parroquia', miranda_m_id),
    ('Valmore Rodríguez', 'Parroquia', miranda_m_id);

    -- Municipio Monte Carmelo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Monte Carmelo', 'Parroquia', monte_carmelo_id),
    ('Buena Vista', 'Parroquia', monte_carmelo_id),
    ('Santa Cruz', 'Parroquia', monte_carmelo_id);

    -- Municipio Motatán
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Motatán', 'Parroquia', motatan_id),
    ('Jalisco', 'Parroquia', motatan_id),
    ('El Baño', 'Parroquia', motatan_id);

    -- Municipio Pampán
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pampán', 'Parroquia', pampan_id),
    ('Flor de Patria', 'Parroquia', pampan_id),
    ('La Paz', 'Parroquia', pampan_id),
    ('Santa Ana', 'Parroquia', pampan_id);

    -- Municipio Pampanito
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pampanito', 'Parroquia', pampanito_id),
    ('La Concepción', 'Parroquia', pampanito_id),
    ('Pampanito II', 'Parroquia', pampanito_id);

    -- Municipio Rafael Rangel
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Betijoque', 'Parroquia', rafael_rangel_id),
    ('José Gregorio Hernández', 'Parroquia', rafael_rangel_id),
    ('La Pueblita', 'Parroquia', rafael_rangel_id),
    ('Los Cedros', 'Parroquia', rafael_rangel_id);

    -- Municipio San Rafael de Carvajal
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Carvajal', 'Parroquia', san_rafael_de_carvajal_id),
    ('Campo Alegre', 'Parroquia', san_rafael_de_carvajal_id),
    ('Antonio Nicolás Briceño', 'Parroquia', san_rafael_de_carvajal_id),
    ('José Leonardo Suárez', 'Parroquia', san_rafael_de_carvajal_id);

    -- Municipio Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sabana de Mendoza', 'Parroquia', sucre_m_id),
    ('Junín', 'Parroquia', sucre_m_id),
    ('Valmore Rodríguez', 'Parroquia', sucre_m_id),
    ('El Paraíso', 'Parroquia', sucre_m_id);

    -- Municipio Trujillo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cristóbal Mendoza', 'Parroquia', trujillo_m_id),
    ('Andrés Linares', 'Parroquia', trujillo_m_id),
    ('Chiquinquirá', 'Parroquia', trujillo_m_id),
    ('Monseñor Carrillo', 'Parroquia', trujillo_m_id),
    ('Pampán', 'Parroquia', trujillo_m_id),
    ('San Luis', 'Parroquia', trujillo_m_id),
    ('Santa Rosa', 'Parroquia', trujillo_m_id);

    -- Municipio Urdaneta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Quebrada', 'Parroquia', urdaneta_m_id),
    ('Jajó', 'Parroquia', urdaneta_m_id),
    ('La Mesa de Esnujaque', 'Parroquia', urdaneta_m_id),
    ('Santiago', 'Parroquia', urdaneta_m_id),
    ('Tuñame', 'Parroquia', urdaneta_m_id),
    ('La Esperanza', 'Parroquia', urdaneta_m_id);

    -- Municipio Valera
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mercedes Díaz', 'Parroquia', valera_id),
    ('San Luis', 'Parroquia', valera_id),
    ('La Beatriz', 'Parroquia', valera_id),
    ('La Puerta', 'Parroquia', valera_id),
    ('Mendoza Fría', 'Parroquia', valera_id),
    ('Carvajal', 'Parroquia', valera_id),
    ('San Rafael de Carvajal', 'Parroquia', valera_id),
    ('Santa Cruz', 'Parroquia', valera_id),
    ('La Paz', 'Parroquia', valera_id),
    ('La Unión', 'Parroquia', valera_id);

END $$;
--------------------------------------la guaira   
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'La Guaira' es 22. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    la_guaira_estado_id INTEGER := 23; -- ID del estado La Guaira
    vargas_m_id INTEGER;
BEGIN
    -- 1. Insertar el único Municipio del Estado La Guaira
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Vargas', 'Municipio', la_guaira_estado_id) RETURNING lugar_id INTO vargas_m_id;

    -- 2. Insertar Parroquias, relacionándolas con el Municipio Vargas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Guaira', 'Parroquia', vargas_m_id),
    ('Caraballeda', 'Parroquia', vargas_m_id),
    ('Carayaca', 'Parroquia', vargas_m_id),
    ('Carlos Soublette', 'Parroquia', vargas_m_id),
    ('Catia La Mar', 'Parroquia', vargas_m_id),
    ('El Junko', 'Parroquia', vargas_m_id),
    ('Macuto', 'Parroquia', vargas_m_id),
    ('Maiquetía', 'Parroquia', vargas_m_id),
    ('Naiguatá', 'Parroquia', vargas_m_id),
    ('Urimare', 'Parroquia', vargas_m_id),
    ('Raúl Leoni', 'Parroquia', vargas_m_id);

END $$;
--------------------------------------yaracuy 
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Yaracuy' es 23. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    yaracuy_estado_id INTEGER := 24; -- ID del estado Yaracuy
    aristides_bastidas_id INTEGER;
    bolivar_m_id INTEGER;
    bruzual_id INTEGER;
    cocorote_id INTEGER;
    independencia_m_id INTEGER;
    jose_antonio_paez_id INTEGER;
    la_trinidad_id INTEGER;
    manuel_monge_id INTEGER;
    nirgua_id INTEGER;
    pena_id INTEGER;
    san_felipe_id INTEGER;
    sucre_m_id INTEGER;
    urachiche_m_id INTEGER;
    veroes_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Yaracuy
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aristides Bastidas', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO aristides_bastidas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bolívar', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO bolivar_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bruzual', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO bruzual_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cocorote', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO cocorote_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Independencia', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO independencia_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('José Antonio Páez', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO jose_antonio_paez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Trinidad', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO la_trinidad_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Manuel Monge', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO manuel_monge_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Nirgua', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO nirgua_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Peña', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO pena_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Felipe', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO san_felipe_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Urachiche', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO urachiche_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Veroes', 'Municipio', yaracuy_estado_id) RETURNING lugar_id INTO veroes_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Aristides Bastidas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Pablo', 'Parroquia', aristides_bastidas_id);

    -- Municipio Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Aroa', 'Parroquia', bolivar_m_id);

    -- Municipio Bruzual
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Chivacoa', 'Parroquia', bruzual_id),
    ('Campo Elías', 'Parroquia', bruzual_id),
    ('Urachiche', 'Parroquia', bruzual_id);

    -- Municipio Cocorote
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cocorote', 'Parroquia', cocorote_id);

    -- Municipio Independencia
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Independencia', 'Parroquia', independencia_m_id),
    ('Campo Elías', 'Parroquia', independencia_m_id);

    -- Municipio José Antonio Páez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sabana de Parra', 'Parroquia', jose_antonio_paez_id);

    -- Municipio La Trinidad
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Boraure', 'Parroquia', la_trinidad_id);

    -- Municipio Manuel Monge
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Yumare', 'Parroquia', manuel_monge_id);

    -- Municipio Nirgua
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Nirgua', 'Parroquia', nirgua_id),
    ('Salom', 'Parroquia', nirgua_id),
    ('Temerla', 'Parroquia', nirgua_id);

    -- Municipio Peña
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Yaritagua', 'Parroquia', pena_id),
    ('San Andrés', 'Parroquia', pena_id);

    -- Municipio San Felipe
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Felipe', 'Parroquia', san_felipe_id),
    ('Albarico', 'Parroquia', san_felipe_id),
    ('San Javier', 'Parroquia', san_felipe_id);

    -- Municipio Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Guama', 'Parroquia', sucre_m_id);

    -- Municipio Urachiche
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Urachiche', 'Parroquia', urachiche_m_id);

    -- Municipio Veroes
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Farriar', 'Parroquia', veroes_id),
    ('El Guayabo', 'Parroquia', veroes_id);

END $$;
--------------------------------------zulia   
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Zulia' es 24. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    zulia_estado_id INTEGER := 25; -- ID del estado Zulia
    almirante_padilla_id INTEGER;
    baralt_id INTEGER;
    cabimas_id INTEGER;
    catatumbo_id INTEGER;
    colon_id INTEGER;
    francisco_javier_pulgar_id INTEGER;
    jesus_enrique_lossada_id INTEGER;
    jesus_maria_semprun_id INTEGER;
    la_canada_de_urdaneta_id INTEGER;
    lagunillas_id INTEGER;
    machiques_de_perija_id INTEGER;
    mara_id INTEGER;
    maracaibo_id INTEGER;
    miranda_m_id INTEGER;
    rosario_de_perija_id INTEGER;
    san_francisco_id INTEGER;
    santa_rita_id INTEGER;
    simon_bolivar_id INTEGER;
    sucre_m_id INTEGER;
    valmore_rodriguez_id INTEGER;
    la_guajira_id INTEGER;
    canada_de_urdaneta_id INTEGER;
BEGIN
    -- 1. Insertar Municipios del Estado Zulia
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Almirante Padilla', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO almirante_padilla_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Baralt', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO baralt_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cabimas', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO cabimas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Catatumbo', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO catatumbo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Colón', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO colon_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Francisco Javier Pulgar', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO francisco_javier_pulgar_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Jesús Enrique Lossada', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO jesus_enrique_lossada_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Jesús María Semprún', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO jesus_maria_semprun_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Cañada de Urdaneta', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO la_canada_de_urdaneta_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Lagunillas', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO lagunillas_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Machiques de Perijá', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO machiques_de_perija_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Mara', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO mara_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Maracaibo', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO maracaibo_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Miranda', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO miranda_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Rosario de Perijá', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO rosario_de_perija_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Francisco', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO san_francisco_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Rita', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO santa_rita_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Simón Bolívar', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO simon_bolivar_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sucre', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO sucre_m_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Valmore Rodríguez', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO valmore_rodriguez_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Guajira', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO la_guajira_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cañada de Urdaneta', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO canada_de_urdaneta_id;

    -- 2. Insertar Parroquias, relacionándolas con sus Municipios
    -- Municipio Almirante Padilla
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Isla de Toas', 'Parroquia', almirante_padilla_id),
    ('Monagas', 'Parroquia', almirante_padilla_id);

    -- Municipio Baralt
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Timoteo', 'Parroquia', baralt_id),
    ('General Urdaneta', 'Parroquia', baralt_id),
    ('Manuel Manrique', 'Parroquia', baralt_id),
    ('Rafael María Baralt', 'Parroquia', baralt_id),
    ('Libertador', 'Parroquia', baralt_id);

    -- Municipio Cabimas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ambrosio', 'Parroquia', cabimas_id),
    ('Carmen Herrera', 'Parroquia', cabimas_id),
    ('La Rosa', 'Parroquia', cabimas_id),
    ('Punta Gorda', 'Parroquia', cabimas_id),
    ('Arístides Calvani', 'Parroquia', cabimas_id),
    ('Germán Ríos Linares', 'Parroquia', cabimas_id),
    ('San Benito', 'Parroquia', cabimas_id),
    ('Rómulo Betancourt', 'Parroquia', cabimas_id),
    ('Jorge Hernández', 'Parroquia', cabimas_id);

    -- Municipio Catatumbo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Encontrados', 'Parroquia', catatumbo_id),
    ('Udón Pérez', 'Parroquia', catatumbo_id);

    -- Municipio Colón
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Carlos del Zulia', 'Parroquia', colon_id),
    ('Santa Cruz del Zulia', 'Parroquia', colon_id),
    ('Santa Bárbara', 'Parroquia', colon_id),
    ('Urribarrí', 'Parroquia', colon_id),
    ('Moralito', 'Parroquia', colon_id);

    -- Municipio Francisco Javier Pulgar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Pueblo Nuevo El Chivo', 'Parroquia', francisco_javier_pulgar_id),
    ('Carlos Quevedo', 'Parroquia', francisco_javier_pulgar_id),
    ('Francisco Javier Pulgar', 'Parroquia', francisco_javier_pulgar_id),
    ('Simón Rodríguez', 'Parroquia', francisco_javier_pulgar_id);

    -- Municipio Jesús Enrique Lossada
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Concepción', 'Parroquia', jesus_enrique_lossada_id),
    ('San José', 'Parroquia', jesus_enrique_lossada_id),
    ('Mariano Parra León', 'Parroquia', jesus_enrique_lossada_id),
    ('Idelfonso Vásquez', 'Parroquia', jesus_enrique_lossada_id);

    -- Municipio Jesús María Semprún
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Casigua El Cubo', 'Parroquia', jesus_maria_semprun_id),
    ('Barí', 'Parroquia', jesus_maria_semprun_id);

    -- Municipio La Cañada de Urdaneta
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Concepción', 'Parroquia', la_canada_de_urdaneta_id),
    ('Andrés Bello', 'Parroquia', la_canada_de_urdaneta_id),
    ('Chiquinquirá', 'Parroquia', la_canada_de_urdaneta_id),
    ('El Carmelo', 'Parroquia', la_canada_de_urdaneta_id),
    ('Potreritos', 'Parroquia', la_canada_de_urdaneta_id);

    -- Municipio Lagunillas
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Ambrosio', 'Parroquia', lagunillas_id),
    ('La Rosa', 'Parroquia', lagunillas_id),
    ('Campo Lara', 'Parroquia', lagunillas_id),
    ('El Danto', 'Parroquia', lagunillas_id),
    ('Venezuela', 'Parroquia', lagunillas_id);

    -- Municipio Machiques de Perijá
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Libertad', 'Parroquia', machiques_de_perija_id),
    ('San José', 'Parroquia', machiques_de_perija_id),
    ('Las Piedras', 'Parroquia', machiques_de_perija_id),
    ('Machiques', 'Parroquia', machiques_de_perija_id),
    ('Fray Pedro de Berja', 'Parroquia', machiques_de_perija_id);

    -- Municipio Mara
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Rafael de El Moján', 'Parroquia', mara_id),
    ('Ricaurte', 'Parroquia', mara_id),
    ('Luis de Vicente', 'Parroquia', mara_id),
    ('Monseñor Marcos Sergio Godoy', 'Parroquia', mara_id),
    ('La Sierrita', 'Parroquia', mara_id),
    ('Las Parcelas', 'Parroquia', mara_id),
    ('Tamare', 'Parroquia', mara_id);

    -- Municipio Maracaibo
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bolívar', 'Parroquia', maracaibo_id),
    ('Cacique Mara', 'Parroquia', maracaibo_id),
    ('Caracciolo Parra Pérez', 'Parroquia', maracaibo_id),
    ('Cecilio Acosta', 'Parroquia', maracaibo_id),
    ('Cristo de Aranza', 'Parroquia', maracaibo_id),
    ('Coquivacoa', 'Parroquia', maracaibo_id),
    ('Chiquinquirá', 'Parroquia', maracaibo_id),
    ('Francisco Eugenio Bustamante', 'Parroquia', maracaibo_id),
    ('Idelfonso Vásquez', 'Parroquia', maracaibo_id),
    ('Juana de Ávila', 'Parroquia', maracaibo_id),
    ('Luis Hurtado Higuera', 'Parroquia', maracaibo_id),
    ('Manuel Dagnino', 'Parroquia', maracaibo_id),
    ('Olegario Villalobos', 'Parroquia', maracaibo_id),
    ('Raúl Leoni', 'Parroquia', maracaibo_id),
    ('Santa Lucía', 'Parroquia', maracaibo_id),
    ('Venancio Pulgar', 'Parroquia', maracaibo_id),
    ('Antonio Borjas Romero', 'Parroquia', maracaibo_id),
    ('San Isidro', 'Parroquia', maracaibo_id);

    -- Municipio Miranda
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Altagracia', 'Parroquia', miranda_m_id),
    ('Farra', 'Parroquia', miranda_m_id),
    ('Ana María Campos', 'Parroquia', miranda_m_id),
    ('San Antonio', 'Parroquia', miranda_m_id),
    ('San José', 'Parroquia', miranda_m_id);

    -- Municipio Rosario de Perijá
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('La Villa del Rosario', 'Parroquia', rosario_de_perija_id),
    ('El Rosario', 'Parroquia', rosario_de_perija_id),
    ('Sixto Zambrano', 'Parroquia', rosario_de_perija_id);

    -- Municipio San Francisco
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('San Francisco', 'Parroquia', san_francisco_id),
    ('Francisco Ochoa', 'Parroquia', san_francisco_id),
    ('Los Cortijos', 'Parroquia', san_francisco_id),
    ('Marcial Hernández', 'Parroquia', san_francisco_id),
    ('Domitila Flores', 'Parroquia', san_francisco_id),
    ('El Bajo', 'Parroquia', san_francisco_id),
    ('Luis Aparicio', 'Parroquia', san_francisco_id);

    -- Municipio Santa Rita
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Santa Rita', 'Parroquia', santa_rita_id),
    ('El Mene', 'Parroquia', santa_rita_id),
    ('Pedro Lucas Urribarrí', 'Parroquia', santa_rita_id),
    ('José Cenobio Urribarrí', 'Parroquia', santa_rita_id);

    -- Municipio Simón Bolívar
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Manuel Manrique', 'Parroquia', simon_bolivar_id),
    ('Rafael María Baralt', 'Parroquia', simon_bolivar_id),
    ('Rafael Urdaneta', 'Parroquia', simon_bolivar_id);

    -- Municipio Sucre
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Gibraltar', 'Parroquia', sucre_m_id),
    ('Heras', 'Parroquia', sucre_m_id),
    ('Monseñor Arturo Celestino Álvarez', 'Parroquia', sucre_m_id),
    ('Rómulo Gallegos', 'Parroquia', sucre_m_id),
    ('Bobures', 'Parroquia', sucre_m_id);

    -- Municipio Valmore Rodríguez
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Bachaquero', 'Parroquia', valmore_rodriguez_id),
    ('La Victoria', 'Parroquia', valmore_rodriguez_id),
    ('Rafael Rodríguez', 'Parroquia', valmore_rodriguez_id);

    -- Municipio La Guajira
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Sinamaica', 'Parroquia', la_guajira_id),
    ('Alta Guajira', 'Parroquia', la_guajira_id),
    ('Elías Sánchez Rubio', 'Parroquia', la_guajira_id),
    ('Guajira', 'Parroquia', la_guajira_id),
    ('Luis de Vicente', 'Parroquia', la_guajira_id);

    -- Municipio Cañada de Urdaneta (Duplicado en la lista original, se asume que es el mismo que 'La Cañada de Urdaneta')
    -- Si son diferentes, se necesitaría un nuevo lugar_id para este municipio.
    -- Por ahora, se asume que es un error en la lista y se omite la inserción duplicada del municipio.
    -- Las parroquias se insertarán bajo el municipio 'La Cañada de Urdaneta' si no se especifica lo contrario.
    -- Si se desea insertar como un municipio separado, se debe crear una nueva variable y un nuevo INSERT INTO Lugar para el municipio.
     INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
     ('Cañada de Urdaneta', 'Municipio', zulia_estado_id) RETURNING lugar_id INTO canada_de_urdaneta_id;

    -- Parroquias para el municipio 'Cañada de Urdaneta' (si se considera diferente a 'La Cañada de Urdaneta')
    -- Si se considera el mismo, estas parroquias ya estarían cubiertas por 'La Cañada de Urdaneta'
     INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
     ('Concepción', 'Parroquia', canada_de_urdaneta_id),
     ('Andrés Bello', 'Parroquia', canada_de_urdaneta_id),
     ('Chiquinquirá', 'Parroquia', canada_de_urdaneta_id),
     ('El Carmelo', 'Parroquia', canada_de_urdaneta_id),
    ('Potreritos', 'Parroquia', canada_de_urdaneta_id);

END $$;
--------------------------------------dependencias federales 
-- DECLARACIÓN DE VARIABLES PARA LOS IDs DE LOS LUGARES
-- Asume que el lugar_id para 'Dependencias Federales' es 25. AJUSTA ESTE VALOR SI ES DIFERENTE EN TU DB.
DO $$
DECLARE
    dependencias_federales_estado_id INTEGER := 26; -- ID de Dependencias Federales
    los_monjes_id INTEGER;
    la_tortuga_id INTEGER;
    la_orchila_id INTEGER;
    la_blanquilla_id INTEGER;
    isla_de_aves_id INTEGER;
    los_hermanos_id INTEGER;
    los_roques_id INTEGER;
    los_testigos_id INTEGER;
    los_frailes_id INTEGER;
    la_sola_id INTEGER;
    isla_de_patos_id INTEGER;
BEGIN
    -- 1. Insertar las principales islas/archipiélagos como "Municipios" o "Territorios Insulares"
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Archipiélago Los Monjes', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO los_monjes_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Isla La Tortuga', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO la_tortuga_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Isla La Orchila', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO la_orchila_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Isla La Blanquilla', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO la_blanquilla_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Isla de Aves', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO isla_de_aves_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Archipiélago Los Hermanos', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO los_hermanos_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Archipiélago Los Roques', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO los_roques_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Archipiélago Los Testigos', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO los_testigos_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Archipiélago Los Frailes', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO los_frailes_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Isla La Sola', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO la_sola_id;

    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Isla de Patos', 'Territorio Insular', dependencias_federales_estado_id) RETURNING lugar_id INTO isla_de_patos_id;

    -- 2. Insertar subdivisiones (si aplican) como "Parroquias" o "Islas/Cayos"
    -- Isla La Tortuga
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Cayos de Herradura', 'Cayo', la_tortuga_id),
    ('Isla Los Tortuguillos', 'Isla', la_tortuga_id);

    -- Archipiélago Los Roques
    INSERT INTO Lugar (Nombre, Tipo, Lugar_lugar_id) VALUES
    ('Gran Roque', 'Isla', los_roques_id),
    ('Cayo Sal', 'Cayo', los_roques_id),
    ('Dos Mosquises', 'Cayo', los_roques_id),
    ('Cayo de Agua', 'Cayo', los_roques_id);

END $$; 















-- 10. Tabla Método_Pago
INSERT INTO Método_Pago (método_pago_id) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
(11), (12), (13), (14), (15), (16), (17), (18), (19), (20);

-- 11. Tabla Presentación
INSERT INTO Presentación (nombre_presentación, medida) VALUES
('Botella 330ml', '330 ml'),
('Botella 500ml', '500 ml'),
('Botella 750ml', '750 ml'),
('Lata 355ml', '355 ml'),
('Lata 473ml', '473 ml'),
('Barril 5L', '5 litros'),
('Barril 10L', '10 litros'),
('Barril 20L', '20 litros'),
('Growler 1L', '1 litro'),
('Growler 2L', '2 litros');

-- 12. Tabla Privilegio
INSERT INTO Privilegio (nombre_privilegio, descripción_privilegio) VALUES
('Crear', 'Permite crear nuevos registros'),
('Leer', 'Permite ver información'),
('Actualizar', 'Permite modificar registros'),
('Eliminar', 'Permite borrar registros'),
('Reportes', 'Generar reportes del sistema'),
('Configuración', 'Modificar parámetros del sistema'),
('Usuarios', 'Administrar usuarios y permisos'),
('Inventario', 'Gestionar inventario completo'),
('Ventas', 'Realizar operaciones de venta'),
('Compras', 'Realizar operaciones de compra');

-- 13. Tabla Rol
INSERT INTO Rol (nombre_rol, descripción_rol) VALUES
('Administrador', 'Acceso completo al sistema'),
('Gerente', 'Gestión de departamentos'),
('Supervisor', 'Supervisión de operaciones'),
('Vendedor', 'Atención al cliente y ventas'),
('Comprador', 'Gestión de compras a proveedores'),
('Almacenista', 'Control de inventario'),
('RRHH', 'Gestión de personal'),
('Marketing', 'Promoción y eventos'),
('Contabilidad', 'Gestión financiera'),
('TI', 'Soporte técnico');

-- 14. Tabla Tasa_Cambio
INSERT INTO Tasa_Cambio (moneda_origen, tasa, fecha_vigencia) VALUES
('USD', 36.50, '2025-01-01'),
('EUR', 39.80, '2025-01-01'),
('USD', 37.20, '2025-02-01'),
('EUR', 40.10, '2025-02-01'),
('USD', 36.80, '2025-03-01'),
('EUR', 39.50, '2025-03-01'),
('USD', 37.50, '2025-04-01'),
('EUR', 40.30, '2025-04-01'),
('USD', 36.20, '2025-05-01'),
('EUR', 39.20, '2025-05-01');

-- 15. Tabla Tipo_Empleado
INSERT INTO Tipo_Empleado (nombre_cargo, descripción_cargo, Tipo_Empleado_tipo_empleado_id) VALUES
('Gerente General', 'Responsable de toda la operación', NULL),
('Gerente de Ventas', 'Encargado del área comercial', NULL),
('Gerente de Compras', 'Encargado de adquisiciones', NULL),
('Supervisor', 'Supervisa operaciones diarias', NULL),
('Asistente', 'Apoyo administrativo', NULL),
('Vendedor', 'Atención directa al cliente', NULL),
('Almacenista', 'Manejo de inventario', NULL),
('Cajero', 'Procesamiento de pagos', NULL),
('Analista', 'Análisis de datos', NULL),
('Soporte', 'Asistencia técnica', NULL);

-- 16. Tabla Tipo_Evento
INSERT INTO Tipo_Evento (nombre_tipo_evento, descripción_evento, Tipo_Evento_tipo_evento_id) VALUES
('Degustación', 'Evento para probar diferentes cervezas', NULL),
('Concurso', 'Competencia de cervezas artesanales', NULL),
('Taller', 'Aprendizaje sobre elaboración de cerveza', NULL),
('Feria', 'Exposición de productos cerveceros', NULL),
('Concierto', 'Evento musical con cerveza artesanal', NULL),
('Charla', 'Conferencia sobre cultura cervecera', NULL),
('Cena', 'Maridaje de cerveza con comida', NULL),
('Festival', 'Celebración con múltiples actividades', NULL),
('Lanzamiento', 'Presentación de nuevos productos', NULL),
('Networking', 'Encuentro de profesionales del sector', NULL);

-- 20. Tabla Cheque (1 FK: Método_Pago)
INSERT INTO Cheque (método_pago_id, número_cuenta, banco, número_cheque) VALUES
(1, 123456789, 'Banco de Venezuela', 'CH-10001'),
(2, 987654321, 'Banesco', 'CH-10002'),
(3, 555555555, 'Mercantil', 'CH-10003'),
(4, 111111111, 'Provincial', 'CH-10004'),
(5, 999999999, 'BOD', 'CH-10005');

-- 21. Tabla Cliente (1 FK: Correo_Electrónico)
INSERT INTO Cliente (RIF, tipo_cliente, número_carnet) VALUES
(123456789, 'Jurídico', 'CLI00001'),
(987654321, 'Jurídico', 'CLI00002'),
(555555555, 'Jurídico', 'CLI00003'),
(111111111, 'Jurídico', 'CLI00004'),
(999999999, 'Jurídico', 'CLI00005'),
(123456780, 'Natural', 'CLI00006'),
(987654320, 'Natural', 'CLI00007'),
(555555550, 'Natural', 'CLI00008'),
(111111110, 'Natural', 'CLI00009'),
(999999990, 'Natural', 'CLI00010');

-- 22. Tabla Correo_Electrónico (1 FK: Cliente, Proveedor o Empleado)
INSERT INTO Correo_Electrónico (Cliente_RIF, Proveedor_proveedor_id, Empleado_empleado_id, correo_id, prefijo_correo, dominio_correo) VALUES
(123456789, NULL, NULL, 1, 'cliente1', 'acaucab.com'),
(987654321, NULL, NULL, 2, 'cliente2', 'acaucab.com'),
(555555555, NULL, NULL, 3, 'cliente3', 'acaucab.com'),
(111111111, NULL, NULL, 4, 'cliente4', 'acaucab.com'),
(999999999, NULL, NULL, 5, 'cliente5', 'acaucab.com'),
(123456780, NULL, NULL, 6, 'cliente6', 'acaucab.com'),
(987654320, NULL, NULL, 7, 'cliente7', 'acaucab.com'),
(555555550, NULL, NULL, 8, 'cliente8', 'acaucab.com'),
(111111110, NULL, NULL, 9, 'cliente9', 'acaucab.com'),
(999999990, NULL, NULL, 10, 'cliente10', 'acaucab.com');

-- 23. Tabla Crédito (1 FK: Método_Pago)
INSERT INTO Crédito (método_pago_id, cuenta, banco, número_tarjeta) VALUES
(6, '1234567890123456', 'Banco de Venezuela', '4111111111111111'),
(7, '9876543210987654', 'Banesco', '5500000000000004'),
(8, '5555555555555555', 'Mercantil', '340000000000009'),
(9, '1111111111111111', 'Provincial', '30000000000004'),
(10, '9999999999999999', 'BOD', '6011000000000004');

-- 24. Tabla Débito (1 FK: Método_Pago)
INSERT INTO Débito (método_pago_id, cuenta, banco, número_tarjeta) VALUES
(11, '1234567890123456', 'Banco de Venezuela', '4111111111111111'),
(12, '9876543210987654', 'Banesco', '5500000000000004'),
(13, '5555555555555555', 'Mercantil', '340000000000009'),
(14, '1111111111111111', 'Provincial', '30000000000004'),
(15, '9999999999999999', 'BOD', '6011000000000004');

-- 25. Tabla Efectivo (1 FK: Método_Pago)
INSERT INTO Efectivo (método_pago_id, tipo_divisa) VALUES
(16, 'VES'),
(17, 'USD'),
(18, 'EUR'),
(19, 'VES'),
(20, 'USD');

-- 26. Tabla Empleado (sin FK)
INSERT INTO Empleado (empleado_id, cédula_identidad, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_ingreso, salario) VALUES
(1, 'V12345678', 'Juan', 'Carlos', 'Pérez', 'González', '2020-01-15', 5000000),
(2, 'V23456789', 'María', 'Alejandra', 'López', 'Mendoza', '2020-03-20', 4800000),
(3, 'V34567890', 'Pedro', NULL, 'Gómez', 'Rojas', '2020-05-10', 4500000),
(4, 'V45678901', 'Ana', 'Isabel', 'Martínez', NULL, '2020-07-05', 4600000),
(5, 'V56789012', 'Luis', 'Alberto', 'Rodríguez', 'Paredes', '2020-09-15', 4700000),
(6, 'V67890123', 'Carlos', 'Andrés', 'Hernández', 'Suárez', '2021-01-10', 4200000),
(7, 'V78901234', 'Sofía', NULL, 'Díaz', 'Fernández', '2021-03-05', 4300000),
(8, 'V89012345', 'José', 'Gregorio', 'Ramírez', 'Gutiérrez', '2021-05-20', 4400000),
(9, 'V90123456', 'Laura', 'Patricia', 'García', 'Morales', '2021-07-15', 4100000),
(10, 'V01234567', 'Ricardo', NULL, 'Torres', 'Blanco', '2021-09-01', 4000000);

-- 27. Tabla Jurídico (1 FK: Cliente, 2 FK: Lugar)
INSERT INTO Jurídico (RIF, razón_social, denominación_comercial, página_web, capital_disponible, dirección_fiscal, dirección_fisica, Lugar_lugar_id, Lugar_lugar_id2) VALUES
(123456789, 'Cervecería Destilo CA', 'Destilo', 'destilo.com.ve', 1000000000, 'Av. Principal de La Castellana', 'Av. Principal de La Castellana', 4, 4),
(987654321, 'Benitz Brewing CA', 'Benitz', 'benitz.com.ve', 800000000, 'Calle California con Av. San Juan', 'Calle California con Av. San Juan', 5, 5),
(555555555, 'Mito Brewhouse CA', 'Mito', 'mitobrewhouse.com.ve', 750000000, 'Centro Comercial Paseo Las Mercedes', 'Centro Comercial Paseo Las Mercedes', 6, 6),
(111111111, 'Cervecería Lago CA', 'Lago', 'cervecerialago.com.ve', 900000000, 'Av. Francisco de Miranda', 'Av. Francisco de Miranda', 7, 7),
(999999999, 'Aldarra Brewing CA', 'Aldarra', 'aldarra.com.ve', 600000000, 'Calle Los Mangos', 'Calle Los Mangos', 8, 8);

-- 28. Tabla PersonaNatural (1 FK: Cliente, 1 FK: Lugar)
INSERT INTO PersonaNatural (RIF, cedula_identidad, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, Lugar_lugar_id) VALUES
(123456780, 'V12345670', 'Carlos', 'Andrés', 'Pérez', 'González', 4),
(987654320, 'V23456780', 'Ana', 'María', 'López', 'Mendoza', 5),
(555555550, 'V34567890', 'Pedro', NULL, 'Gómez', 'Rojas', 6),
(111111110, 'V45678900', 'María', 'Isabel', 'Martínez', NULL, 7),
(999999990, 'V56789010', 'Luis', 'Alberto', 'Rodríguez', 'Paredes', 8);

-- 29. Tabla Proveedor (1 FK: Persona_Contacto, 2 FK: Lugar)
INSERT INTO Proveedor (proveedor_id, razón_social, denominación_comercial, RIF, dirección_fiscal, página_web, fecha_afiliación, direccion_fisica, Lugar_lugar_id, Lugar_lugar_id2) VALUES
(1, 'Cervecería Destilo CA', 'Destilo', 'J-123456789', 'Av. Principal de La Castellana', 'destilo.com.ve', '2015-01-10', 'Av. Principal de La Castellana', 4, 4),
(2, 'Benitz Brewing CA', 'Benitz', 'J-987654321', 'Calle California con Av. San Juan', 'benitz.com.ve', '2015-03-15', 'Calle California con Av. San Juan', 5, 5),
(3, 'Mito Brewhouse CA', 'Mito', 'J-555555555', 'Centro Comercial Paseo Las Mercedes', 'mitobrewhouse.com.ve', '2015-05-20', 'Centro Comercial Paseo Las Mercedes', 6, 6),
(4, 'Cervecería Lago CA', 'Lago', 'J-111111111', 'Av. Francisco de Miranda', 'cervecerialago.com.ve', '2015-07-25', 'Av. Francisco de Miranda', 7, 7),
(5, 'Aldarra Brewing CA', 'Aldarra', 'J-999999999', 'Calle Los Mangos', 'aldarra.com.ve', '2015-09-30', 'Calle Los Mangos', 8, 8);

-- 30. Tabla Persona_Contacto (1 FK: Proveedor o Jurídico)
INSERT INTO Persona_Contacto (Proveedor_proveedor_id, Jurídico_RIF, contacto_id, nombre_contacto, cargo_contacto, teléfono_contacto) VALUES
(1, NULL, 1, 'Carlos Mendoza', 'Gerente General', '04141234567'),
(2, NULL, 2, 'Ana López', 'Directora Comercial', '04142345678'),
(3, NULL, 3, 'Pedro Rivas', 'Jefe de Producción', '04143456789'),
(4, NULL, 4, 'María González', 'Gerente de Ventas', '04144567890'),
(5, NULL, 5, 'José Pérez', 'Coordinador Logístico', '04145678901'),
(NULL, 123456789, 6, 'Luisa Fernández', 'Asistente', '04146789012'),
(NULL, 987654321, 7, 'Juan Martínez', 'Contador', '04147890123'),
(NULL, 555555555, 8, 'Sofía Ramírez', 'Marketing', '04148901234'),
(NULL, 111111111, 9, 'Ricardo Díaz', 'RRHH', '04149012345'),
(NULL, 999999999, 10, 'Carmen Suárez', 'Logística', '04140123456');

-- 31. Tabla Receta 
INSERT INTO Receta (receta_id, nombre_receta) VALUES
(1, 'Receta Destilo Amber'),
(2, 'Receta Benitz Pale Ale'),
(3, 'Receta Mito Candileja'),
(4, 'Receta Ángel o Demonio'),
(5, 'Receta Aldarra Mantuana'),
(6, 'Receta Latin American IPA'),
(7, 'Receta Tovar Stout'),
(8, 'Receta UCAB Lager'),
(9, 'Receta Caracas Porter'),
(10, 'Receta Avila Wheat');

-- 32. Tabla Teléfono (1 FK: Cliente, Proveedor o Empleado)
INSERT INTO Teléfono (Cliente_RIF, Proveedor_proveedor_id, Empleado_empleado_id, teléfono_id, teléfono_área, número_telefónico) VALUES
(123456789, NULL, NULL, 1, 212, 5551111),
(987654321, NULL, NULL, 2, 212, 5552222),
(555555555, NULL, NULL, 3, 212, 5553333),
(111111111, NULL, NULL, 4, 212, 5554444),
(999999999, NULL, NULL, 5, 212, 5555555),
(123456780, NULL, NULL, 6, 212, 5556666),
(987654320, NULL, NULL, 7, 212, 5557777),
(555555550, NULL, NULL, 8, 212, 5558888),
(111111110, NULL, NULL, 9, 212, 5559999),
(999999990, NULL, NULL, 10, 212, 5550000),
(NULL, 1, NULL, 11, 212, 5551234),
(NULL, 2, NULL, 12, 212, 5552345),
(NULL, 3, NULL, 13, 212, 5553456),
(NULL, 4, NULL, 14, 212, 5554567),
(NULL, 5, NULL, 15, 212, 5555678),
(NULL, NULL, 1, 16, 212, 5556789),
(NULL, NULL, 2, 17, 212, 5557890),
(NULL, NULL, 3, 18, 212, 5558901),
(NULL, NULL, 4, 19, 212, 5559012),
(NULL, NULL, 5, 20, 212, 5550123);

-- 33. Tabla Usuario (1 FK: Cliente, Proveedor o Empleado, 1 FK: Rol)
INSERT INTO Usuario (Cliente_RIF, Proveedor_proveedor_id, Empleado_empleado_id, usuario_id, contraseña_usuario, Rol_rol_id, nombre_usuario) VALUES
(123456789, NULL, NULL, 1, 'cliente1pass', 4, 'cliente1'),
(987654321, NULL, NULL, 2, 'cliente2pass', 4, 'cliente2'),
(555555555, NULL, NULL, 3, 'cliente3pass', 4, 'cliente3'),
(111111111, NULL, NULL, 4, 'cliente4pass', 4, 'cliente4'),
(999999999, NULL, NULL, 5, 'cliente5pass', 4, 'cliente5'),
(123456780, NULL, NULL, 6, 'cliente6pass', 4, 'cliente6'),
(987654320, NULL, NULL, 7, 'cliente7pass', 4, 'cliente7'),
(555555550, NULL, NULL, 8, 'cliente8pass', 4, 'cliente8'),
(111111110, NULL, NULL, 9, 'cliente9pass', 4, 'cliente9'),
(999999990, NULL, NULL, 10, 'cliente10pass', 4, 'cliente10'),
(NULL, 1, NULL, 11, 'proveedor1pass', 5, 'proveedor1'),
(NULL, 2, NULL, 12, 'proveedor2pass', 5, 'proveedor2'),
(NULL, 3, NULL, 13, 'proveedor3pass', 5, 'proveedor3'),
(NULL, 4, NULL, 14, 'proveedor4pass', 5, 'proveedor4'),
(NULL, 5, NULL, 15, 'proveedor5pass', 5, 'proveedor5'),
(NULL, NULL, 1, 16, 'empleado1pass', 1, 'empleado1'),
(NULL, NULL, 2, 17, 'empleado2pass', 2, 'empleado2'),
(NULL, NULL, 3, 18, 'empleado3pass', 3, 'empleado3'),
(NULL, NULL, 4, 19, 'empleado4pass', 6, 'empleado4'),
(NULL, NULL, 5, 20, 'empleado5pass', 7, 'empleado5');

-- 34. Tabla Tipo_Cerveza (1 FK: Proveedor, 1 FK: Receta)
INSERT INTO Tipo_Cerveza (Receta_receta_id, tipo_cerveza_id, nombre_tipo, descripción_general, familia, Proveedor_proveedor_id, Tipo_Cerveza_tipo_cerveza_id) VALUES
(1, 1, 'Amber Ale', 'Cerveza ámbar con buen balance maltalúpulo', 'Ale', 1, NULL),
(2, 2, 'Pale Ale', 'Ale pálida con carácter lupulizado', 'Ale', 2, NULL),
(3, 3, 'Dubbel', 'Ale belga oscura con notas frutales', 'Ale', 3, NULL),
(4, 4, 'Golden Strong', 'Ale dorada fuerte y compleja', 'Ale', 4, NULL),
(5, 5, 'Blonde Ale', 'Ale rubia fácil de beber', 'Ale', 5, NULL),
(6, 6, 'IPA', 'Ale muy lupulizada y amarga', 'Ale', 1, NULL),
(7, 7, 'Stout', 'Ale oscura con sabores a café', 'Ale', 2, NULL),
(8, 8, 'Lager', 'Cerveza de fermentación baja', 'Lager', 3, NULL),
(9, 9, 'Porter', 'Ale oscura con chocolate y caramelo', 'Ale', 4, NULL),
(10, 10, 'Weissbier', 'Ale de trigo con carácter frutal', 'Ale', 5, NULL);

-- 17. Tabla Cerveza (1 FK: Tipo_Cerveza)
INSERT INTO Cerveza (nombre_cerveza, descripción, Tipo_Cerveza_tipo_cerveza_id, presentación_id) VALUES
('Destilo Amber', 'Cerveza ámbar premium con cuerpo medio', 1, 1),
('Benitz Pale Ale', 'Pale Ale artesanal con buen balance maltalúpulo', 2, 2),
('Mito Candileja', 'Cerveza de abadía con notas a caramelo y frutas', 3, 3),
('Ángel o Demonio', 'Dorada fuerte con espuma blanca persistente', 4, 4),
('Aldarra Mantuana', 'Blonde Ale ligera con aroma tropical', 5, 5),
('Latin American IPA', 'IPA con lúpulos americanos y carácter cítrico', 6, 6),
('Tovar Stout', 'Stout negra cremosa con notas a café', 7, 7),
('UCAB Lager', 'Lager suave y refrescante', 8, 8),
('Caracas Porter', 'Porter robusta con chocolate y café', 9, 9),
('Avila Wheat', 'Weissbier con notas a plátano y clavo', 10, 10);

-- 18. Tabla Cerveza_Caracteristica (2 FK: Cerveza y Característica)
INSERT INTO Cerveza_Caracteristica (Cerveza_cerveza_id, Característica_característica_id, descripción) VALUES
(1, 1, '25 IBUs - Amargor medio-bajo'),
(1, 2, '5.8% ABV - Alcohol medio'),
(2, 1, '35 IBUs - Amargor notable'),
(2, 3, '12 SRM - Color ámbar'),
(3, 2, '7.5% ABV - Alcohol alto'),
(3, 4, 'Aroma a caramelo y frutas secas'),
(4, 2, '8.5% ABV - Muy alcohólica'),
(4, 5, 'Cuerpo medio-alto'),
(5, 1, '20 IBUs - Poco amarga'),
(5, 3, '6 SRM - Dorado pálido');

-- 19. Tabla Cerveza_Presentacion (2 FK: Cerveza y Presentación)
INSERT INTO Cerveza_Presentacion (Presentación_presentación_id, Cerveza_cerveza_id, precio_unitario) VALUES
(1, 1, 12.50),   -- Destilo Amber - Botella 330ml
(2, 2, 15.00),   -- Destilo Amber - Lata 473ml
(3, 3, 14.00),   -- Benitz Pale Ale - Botella 330ml
(4, 4, 16.50),   -- Benitz Pale Ale - Lata 473ml
(5, 5, 13.75),   -- Mito Candileja - Botella 330ml
(6, 6, 15.25),   -- Mito Candileja - Lata 473ml
(7, 7, 14.50),   -- Ángel o Demonio - Botella 330ml
(8, 8, 17.00),   -- Ángel o Demonio - Lata 473ml
(9, 9, 12.00),   -- Aldarra Mantuana - Botella 330ml
(10, 10, 14.50);  -- Aldarra Mantuana - Lata 473ml

-- 35. Tabla Empleado_Beneficio (2 FK: Empleado y Beneficio)
INSERT INTO Empleado_Beneficio (Empleado_empleado_id, Beneficio_beneficio_id, empleado_beneficio_id, fecha_asignación, monto_beneficio) VALUES
(1, 1, 1, '2025-01-01', NULL),
(1, 2, 2, '2025-01-01', 500000),
(2, 1, 3, '2025-01-01', NULL),
(2, 3, 4, '2025-01-01', 450000),
(3, 2, 5, '2025-01-01', 300000),
(4, 4, 6, '2025-01-01', NULL),
(4, 1, 7, '2025-01-01', NULL),
(5, 5, 8, '2025-01-01', NULL),
(6, 2, 9, '2025-01-01', 250000),
(7, 3, 10, '2025-01-01', 400000);

-- 36. Tabla Evento (2 FK: Tipo_Evento y Lugar)
-- Eventos para el Estado Amazonas (ID: 1)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(1, 'Festival Cerveza Amazónica', '2025-08-10', '2025-08-12', 'Celebración de cervezas artesanales con ingredientes locales de la Amazonía.', 'S', 8, 'Centro Convenciones Pto Ayacucho', 2),
(2, 'Taller Elaboración Frutas Tropicales', '2025-09-05', NULL, 'Aprende a incorporar frutas exóticas en tus recetas de cerveza.', 'S', 3, 'Hacienda El Edén, Pto Ayacucho', 2),
(3, 'Degustación Cervezas Nativas', '2025-10-20', NULL, 'Exploración de sabores únicos con cervezas inspiradas en la cultura indígena.', 'N', 1, 'Plaza Bolívar, Pto Ayacucho', 2),
(4, 'Concurso Cerveza Artesanal "Río Negro"', '2025-11-15', '2025-11-16', 'Competencia para cerveceros caseros y microcervecerías de la región.', 'S', 2, 'Club Social Amazonas, Pto Ayacucho', 2),
(5, 'Charla: Sostenibilidad Cervecería Amazónica', '2025-12-01', NULL, 'Discusión sobre prácticas ecológicas en la producción de cerveza artesanal.', 'N', 6, 'Auditorio Gobernación, Pto Ayacucho', 2);

-- Eventos para el Estado Anzoátegui (ID: 2)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(6, 'Anzoátegui Beer Fest', '2025-07-20', '2025-07-22', 'Gran festival de cerveza artesanal con expositores nacionales e internacionales.', 'S', 8, 'Paseo Colón, Pto La Cruz', 3),
(7, 'Lanzamiento "Cerveza del Morro"', '2025-08-25', NULL, 'Presentación de una nueva cerveza inspirada en los paisajes costeros.', 'S', 9, 'Hotel Maremares, Lechería', 3),
(8, 'Cena Maridaje Oriental', '2025-09-10', NULL, 'Experiencia gastronómica con maridaje de cervezas y platos típicos de la región.', 'S', 7, 'Restaurante El Fogón, Barcelona', 3),
(9, 'Taller Cata Cervezas Costeras', '2025-10-05', NULL, 'Sesión interactiva para aprender a identificar perfiles de sabor en cervezas.', 'S', 3, 'CC Plaza Mayor, Lechería', 3),
(10, 'Feria Emprendedores Cerveceros', '2025-11-01', '2025-11-03', 'Exposición y venta de productos de nuevos emprendimientos cerveceros.', 'N', 4, 'Parque Andrés Eloy Blanco, Pto La Cruz', 3);

-- Eventos para el Estado Apure (ID: 3)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(11, 'Festival Llanero de la Cerveza', '2025-06-15', '2025-06-17', 'Celebración de la cultura llanera y la cerveza artesanal.', 'S', 8, 'Manga de Coleo, San Fernando', 4),
(12, 'Charla: Cerveza y Joropo', '2025-07-01', NULL, 'Explorando la conexión entre la bebida y la música tradicional llanera.', 'N', 6, 'Casa de la Cultura, San Fernando', 4),
(13, 'Degustación Cervezas Ahumadas', '2025-08-05', NULL, 'Experiencia sensorial con cervezas de perfiles ahumados y robustos.', 'S', 1, 'Hato El Cedral, Achaguas', 4),
(14, 'Concurso Cerveza Casera "Río Apure"', '2025-09-20', '2025-09-21', 'Competencia amistosa para cerveceros aficionados de la región.', 'S', 2, 'Club Caza y Pesca, San Fernando', 4),
(15, 'Networking Cervecero Apureño', '2025-10-10', NULL, 'Encuentro para profesionales y entusiastas de la cerveza en Apure.', 'S', 10, 'Hotel La Estancia, San Fernando', 4);

-- Eventos para el Estado Aragua (ID: 4)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(16, 'Aragua Beer Fest', '2025-07-05', '2025-07-07', 'Festival anual de cerveza artesanal en el corazón de Aragua.', 'S', 8, 'Parque Ferias San Jacinto, Maracay', 5),
(17, 'Taller Maridaje Chocolates Chuao', '2025-08-15', NULL, 'Descubre la armonía entre cervezas y los famosos chocolates de Aragua.', 'S', 3, 'Hacienda Santa Teresa, El Consejo', 5),
(18, 'Lanzamiento "Cerveza de la Colonia"', '2025-09-01', NULL, 'Presentación de una cerveza inspirada en la tradición alemana de la Colonia Tovar.', 'S', 9, 'Cervecería La Colonia, Tovar', 5),
(19, 'Concierto "Rock & Beer Aragua"', '2025-10-12', NULL, 'Noche de música en vivo y las mejores cervezas artesanales.', 'S', 5, 'Concha Acústica de Maracay', 5),
(20, 'Feria Gastronómica y Cervecera', '2025-11-20', '2025-11-22', 'Combinación de la oferta culinaria local con la variedad de cervezas artesanales.', 'N', 4, 'Boulevard Pérez Almarza, Maracay', 5);

-- Eventos para el Estado Barinas (ID: 5)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(21, 'Barinas Beer & Food Fest', '2025-08-01', '2025-08-03', 'Festival que une la gastronomía barinesa con la cerveza artesanal.', 'S', 8, 'Parque La Federación, Barinas', 6),
(22, 'Charla: Agua en Cerveza Llanera', '2025-09-10', NULL, 'Importancia de la calidad del agua en la elaboración de cerveza en los llanos.', 'N', 6, 'Auditorio UNELLEZ, Barinas', 6),
(23, 'Degustación Cervezas con Café', '2025-10-05', NULL, 'Exploración de cervezas con adiciones de café de la región andina-llanera.', 'S', 1, 'Café Barinas, Barinas', 6),
(24, 'Taller Iniciación Cerveza Artesanal', '2025-11-15', NULL, 'Curso básico para quienes desean empezar a elaborar su propia cerveza.', 'S', 3, 'Centro Emprendimiento, Barinas', 6),
(25, 'Concurso Etiquetas Cerveceras', '2025-12-01', NULL, 'Competencia de diseño para las mejores etiquetas de cerveza artesanal.', 'N', 2, 'Galería Arte Municipal, Barinas', 6);

-- Eventos para el Estado Bolívar (ID: 6)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(26, 'Bolívar Craft Beer Fest', '2025-07-15', '2025-07-17', 'Gran festival de cerveza artesanal en la región de Guayana.', 'S', 8, 'Parque La Llovizna, Pto Ordaz', 7),
(27, 'Cena Maridaje "Sabores Guayana"', '2025-08-20', NULL, 'Experiencia culinaria que fusiona la gastronomía local con cervezas artesanales.', 'S', 7, 'Restaurante Casa Grande, Cdad Bolívar', 7),
(28, 'Lanzamiento "Cerveza del Caroní"', '2025-09-05', NULL, 'Presentación de una nueva cerveza inspirada en la majestuosidad del río Caroní.', 'S', 9, 'Club Italo Venezolano, Pto Ordaz', 7),
(29, 'Taller Elaboración Ingredientes Amazónicos', '2025-10-10', NULL, 'Aprende a usar ingredientes de la selva en tus creaciones cerveceras.', 'S', 3, 'UNEG, Pto Ordaz', 7),
(30, 'Feria Cerveza y Emprendimiento Minero', '2025-11-01', '2025-11-03', 'Exposición de cervezas y productos de emprendedores de la zona minera.', 'N', 4, 'Plaza Miranda, Cdad Bolívar', 7);

-- Eventos para el Estado Carabobo (ID: 7)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(31, 'Carabobo Beer Week', '2025-09-01', '2025-09-07', 'Semana dedicada a la cerveza artesanal con eventos en toda la ciudad.', 'S', 8, 'Parque Negra Hipólita, Valencia', 8),
(32, 'Concurso Nacional Cervezas Artesanales', '2025-10-10', '2025-10-12', 'La competencia más importante para cerveceros de todo el país.', 'S', 2, 'Hotel Hesperia WTC, Valencia', 8),
(33, 'Charla: Historia Cerveza Venezuela', '2025-11-05', NULL, 'Recorrido por los orígenes y evolución de la cerveza en el país.', 'N', 6, 'Ateneo de Valencia', 8),
(34, 'Degustación Cervezas Belgas', '2025-12-01', NULL, 'Exploración de los complejos y variados estilos de cerveza belga.', 'S', 1, 'Restaurante La Estancia, Naguanagua', 8),
(35, 'Concierto "Birra y Rock en el Fuerte"', '2025-06-20', NULL, 'Noche de música y cerveza en un ambiente histórico.', 'S', 5, 'Fuerte San Felipe, Pto Cabello', 8);

-- Eventos para el Estado Cojedes (ID: 8)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(36, 'Cojedes Beer & Grill Fest', '2025-07-25', '2025-07-27', 'Festival de cerveza artesanal y parrillas llaneras.', 'S', 8, 'Parque de Ferias, San Carlos', 9),
(37, 'Taller Elaboración Cerveza con Maíz', '2025-08-10', NULL, 'Aprende a usar maíz como adjunto en tus recetas de cerveza.', 'S', 3, 'Centro Producción Agrícola, Tinaquillo', 9),
(38, 'Degustación Cervezas Refrescantes', '2025-09-05', NULL, 'Exploración de estilos ligeros y refrescantes ideales para el clima llanero.', 'N', 1, 'Plaza Bolívar, San Carlos', 9),
(39, 'Networking Cervecero Cojedeño', '2025-10-01', NULL, 'Encuentro para conectar a productores, distribuidores y amantes de la cerveza.', 'S', 10, 'Hotel La Granja, San Carlos', 9),
(40, 'Feria Productos Artesanales y Cerveza', '2025-11-10', '2025-11-12', 'Exposición de artesanías locales y cervezas de la región.', 'N', 4, 'Boulevard de San Carlos', 9);

-- Eventos para el Estado Delta Amacuro (ID: 9)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(41, 'Delta Beer & Nature Fest', '2025-08-05', '2025-08-07', 'Festival de cerveza artesanal en un entorno natural único del Delta.', 'S', 8, 'Malecón de Tucupita', 10),
(42, 'Charla: Ingredientes Exóticos del Delta', '2025-09-15', NULL, 'Descubre cómo los sabores del Delta pueden enriquecer la cerveza.', 'N', 6, 'Auditorio Gobernación, Tucupita', 10),
(43, 'Degustación Cervezas Frutas Amazónicas', '2025-10-01', NULL, 'Experiencia con cervezas que incorporan frutas de la selva y el río.', 'S', 1, 'Campamento Turístico Orinoco, Tucupita', 10),
(44, 'Taller Fermentación Salvaje', '2025-11-20', NULL, 'Exploración de técnicas de fermentación con levaduras autóctonas.', 'S', 3, 'Centro Investigación Delta, Tucupita', 10),
(45, 'Concurso Cerveza Artesanal "Caño Mánamo"', '2025-12-10', '2025-12-11', 'Competencia para destacar las mejores cervezas de la región deltaica.', 'S', 2, 'Club Náutico Tucupita', 10);

-- Eventos para el Distrito Capital (ID: 10)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(46, 'Caracas Beer Festival', '2025-07-10', '2025-07-13', 'El festival de cerveza artesanal más grande de la capital.', 'S', 8, 'Terraza del CCCT, Caracas', 11),
(47, 'Cena Maridaje "Sabores Caracas"', '2025-08-01', NULL, 'Experiencia gastronómica con maridaje de cervezas y platos caraqueños.', 'S', 7, 'Restaurante Alto, Caracas', 11),
(48, 'Lanzamiento "Cerveza Ávila"', '2025-09-15', NULL, 'Presentación de una nueva cerveza inspirada en la icónica montaña de Caracas.', 'S', 9, 'Hotel Eurobuilding, Caracas', 11),
(49, 'Taller Avanzado Cata Cervezas', '2025-10-05', NULL, 'Curso intensivo para profundizar en el análisis sensorial de la cerveza.', 'S', 3, 'ACAUCA B, Chacao', 11),
(50, 'Concierto "Birra y Rock en la Plaza"', '2025-11-22', NULL, 'Noche de música en vivo y cerveza artesanal en un espacio público.', 'S', 5, 'Plaza Altamira, Caracas', 11);

-- Eventos para el Estado Falcón (ID: 11)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(51, 'Falcón Beer & Beach Fest', '2025-08-20', '2025-08-22', 'Festival de cerveza artesanal en las playas de Falcón.', 'S', 8, 'Médanos de Coro, Coro', 12),
(52, 'Charla: Cerveza y Cacao Paraguaná', '2025-09-10', NULL, 'Explorando la combinación de cerveza con el cacao local.', 'N', 6, 'Centro Convenciones, Pto Fijo', 12),
(53, 'Degustación Cervezas Sal Marina', '2025-10-01', NULL, 'Experiencia con cervezas que incorporan toques salinos de la costa.', 'S', 1, 'Salinas Las Cumaraguas, Paraguaná', 12),
(54, 'Taller Elaboración Cerveza con Dátiles', '2025-11-05', NULL, 'Aprende a usar dátiles, un fruto típico de la región, en tus recetas.', 'S', 3, 'UNEFM, Coro', 12),
(55, 'Feria Artesanía y Cerveza Falconiana', '2025-12-15', '2025-12-17', 'Exposición de artesanías y cervezas producidas en Falcón.', 'N', 4, 'Paseo Talavera, Coro', 12);

-- Eventos para el Estado Guárico (ID: 12)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(56, 'Guárico Beer & Folklore Fest', '2025-07-01', '2025-07-03', 'Festival que celebra la cerveza artesanal y las tradiciones llaneras.', 'S', 8, 'Parque Rómulo Gallegos, San Juan', 13),
(57, 'Charla: Agua en Cerveza Llanera', '2025-08-10', NULL, 'Análisis de la influencia del agua en el perfil de la cerveza en los llanos.', 'N', 6, 'Auditorio Unerg, San Juan', 13),
(58, 'Degustación Cervezas con Miel Abeja', '2025-09-05', NULL, 'Exploración de cervezas con adiciones de miel de la región.', 'S', 1, 'Hacienda La Escondida, Calabozo', 13),
(59, 'Taller Elaboración Cerveza Casera', '2025-10-20', NULL, 'Curso práctico para iniciarse en el mundo de la elaboración de cerveza.', 'S', 3, 'Centro Formación, Valle Pascua', 13),
(60, 'Concurso Cerveza Artesanal "Los Morros"', '2025-11-15', '2025-11-16', 'Competencia para cerveceros de la región guariqueña.', 'S', 2, 'Club Social San Juan, San Juan', 13);

-- Eventos para el Estado Lara (ID: 13)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(61, 'Lara Beer Fest', '2025-09-10', '2025-09-12', 'Gran festival de cerveza artesanal en la capital musical de Venezuela.', 'S', 8, 'Complejo Ferial Barquisimeto', 14),
(62, 'Cena Maridaje "Sabores Larenses"', '2025-10-01', NULL, 'Experiencia culinaria que fusiona la gastronomía larense con cervezas artesanales.', 'S', 7, 'Restaurante El Cardenal, Barquisimeto', 14),
(63, 'Lanzamiento "Cerveza del Obelisco"', '2025-11-05', NULL, 'Presentación de una nueva cerveza inspirada en el icónico Obelisco de Barquisimeto.', 'S', 9, 'Hotel Trinitarias Suites, Barquisimeto', 14),
(64, 'Taller Cata Cervezas y Quesos', '2025-12-01', NULL, 'Sesión interactiva para maridar cervezas con la variedad de quesos larenses.', 'S', 3, 'Bodegón La Cava, Barquisimeto', 14),
(65, 'Concierto "Rock & Beer Crepuscular"', '2025-06-25', NULL, 'Noche de música en vivo y las mejores cervezas artesanales al atardecer.', 'S', 5, 'Anfiteatro de Barquisimeto', 14);

-- Eventos para el Estado Mérida (ID: 14)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(66, 'Mérida Beer & Mountain Fest', '2025-08-01', '2025-08-03', 'Festival de cerveza artesanal en el hermoso paisaje andino.', 'S', 8, 'Parque Ciudad de Mérida, Mérida', 15),
(67, 'Charla: Cerveza y Clima Andino', '2025-09-10', NULL, 'Impacto del clima de altura en la elaboración y maduración de la cerveza.', 'N', 6, 'ULA, Mérida', 15),
(68, 'Degustación Cervezas Frutas Andinas', '2025-10-05', NULL, 'Exploración de cervezas con adiciones de frutas típicas de los Andes.', 'S', 1, 'Mercado Principal, Mérida', 15),
(69, 'Taller Elaboración Cerveza Trigo Andino', '2025-11-15', NULL, 'Aprende a usar trigo cultivado en los Andes en tus recetas de cerveza.', 'S', 3, 'Hacienda La Victoria, Tabay', 15),
(70, 'Feria Productores Artesanales y Cerveza', '2025-12-01', '2025-12-03', 'Exposición de productos artesanales y cervezas de la región andina.', 'N', 4, 'Plaza Bolívar, Mérida', 15);

-- Eventos para el Estado Miranda (ID: 15)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(71, 'Miranda Beer Fest', '2025-07-20', '2025-07-22', 'Festival de cerveza artesanal en los Valles del Tuy.', 'S', 8, 'Parque Gral Fco Miranda, Caracas', 16),
(72, 'Cena Maridaje "Sabores Mirandinos"', '2025-08-10', NULL, 'Experiencia culinaria que fusiona la gastronomía mirandina con cervezas artesanales.', 'S', 7, 'Restaurante El Hatillo, El Hatillo', 16),
(73, 'Lanzamiento "Cerveza de Barlovento"', '2025-09-01', NULL, 'Presentación de una nueva cerveza inspirada en la cultura y sabores de Barlovento.', 'S', 9, 'Club Playa Grande, Higuerote', 16),
(74, 'Taller Elaboración Cerveza con Cacao', '2025-10-15', NULL, 'Aprende a usar cacao de Barlovento en tus recetas de cerveza.', 'S', 3, 'Hacienda Cacao, Río Chico', 16),
(75, 'Concierto "Birra y Tambor"', '2025-11-05', NULL, 'Noche de música afrovenezolana y cerveza artesanal.', 'S', 5, 'Plaza Bolívar, Ocumare del Tuy', 16);

-- Eventos para el Estado Monagas (ID: 16)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(76, 'Monagas Beer & Sabana Fest', '2025-08-15', '2025-08-17', 'Festival de cerveza artesanal en los paisajes de Monagas.', 'S', 8, 'Parque La Guaricha, Maturín', 17),
(77, 'Charla: Cerveza y Petróleo', '2025-09-01', NULL, 'Discusión sobre la relación entre la industria cervecera y la petrolera en la región.', 'N', 6, 'Auditorio PDVSA, Maturín', 17),
(78, 'Degustación Cervezas Frutas Orientales', '2025-10-10', NULL, 'Exploración de cervezas con adiciones de frutas típicas de Monagas.', 'S', 1, 'Mercado de Maturín', 17),
(79, 'Taller Elaboración Cerveza con Yuca', '2025-11-05', NULL, 'Aprende a usar yuca como ingrediente en tus recetas de cerveza.', 'S', 3, 'UDO, Maturín', 17),
(80, 'Feria Emprendedores y Cerveza Monaguense', '2025-12-01', '2025-12-03', 'Exposición de productos de emprendedores y cervezas de Monagas.', 'N', 4, 'Plaza Piar, Maturín', 17);

-- Eventos para el Estado Nueva Esparta (ID: 17)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(81, 'Margarita Beer Fest', '2025-07-01', '2025-07-03', 'El festival de cerveza artesanal más esperado en la Isla de Margarita.', 'S', 8, 'CC Sambil, Pampatar', 18),
(82, 'Cena Maridaje "Sabores Insulares"', '2025-08-05', NULL, 'Experiencia culinaria que fusiona la gastronomía margariteña con cervezas artesanales.', 'S', 7, 'Restaurante La Casa de Esther, Porlamar', 18),
(83, 'Lanzamiento "Cerveza del Faro"', '2025-09-10', NULL, 'Presentación de una nueva cerveza inspirada en los faros de la isla.', 'S', 9, 'Hotel Wyndham Concorde, Porlamar', 18),
(84, 'Taller Elaboración Cerveza Agua de Mar', '2025-10-20', NULL, 'Aprende a usar agua de mar tratada en tus recetas de cerveza.', 'S', 3, 'UNIMAR, Porlamar', 18),
(85, 'Concierto "Birra y Playa"', '2025-11-15', NULL, 'Noche de música en vivo y cerveza artesanal en la playa.', 'S', 5, 'Playa El Agua, Margarita', 18);

-- Eventos para el Estado Portuguesa (ID: 18)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(86, 'Portuguesa Beer & Agro Fest', '2025-08-05', '2025-08-07', 'Festival de cerveza artesanal y productos agrícolas de Portuguesa.', 'S', 8, 'Parque de Ferias, Acarigua', 19),
(87, 'Charla: Arroz en Cerveza Llanera', '2025-09-15', NULL, 'Explorando el uso del arroz, cultivo principal de la región, en la cerveza.', 'N', 6, 'UNELLEZ, Guanare', 19),
(88, 'Degustación Cervezas Cereales Locales', '2025-10-01', NULL, 'Exploración de cervezas con adiciones de cereales cultivados en Portuguesa.', 'S', 1, 'Agropecuaria La Bendición, Araure', 19),
(89, 'Taller Elaboración Cerveza con Panela', '2025-11-20', NULL, 'Aprende a usar panela, un endulzante tradicional, en tus recetas de cerveza.', 'S', 3, 'Centro Formación Agrícola, Guanare', 18),
(90, 'Concurso Cerveza Artesanal "Río Guanare"', '2025-12-10', '2025-12-11', 'Competencia para destacar las mejores cervezas de la región llanera.', 'S', 2, 'Club Social Guanare', 19);

-- Eventos para el Estado Sucre (ID: 19)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(91, 'Sucre Beer & Mar Fest', '2025-07-10', '2025-07-12', 'Festival de cerveza artesanal en las costas de Sucre.', 'S', 8, 'Playa San Luis, Cumaná', 20),
(92, 'Charla: Pescado y Cerveza', '2025-08-01', NULL, 'Maridaje de cervezas con productos del mar sucrense.', 'N', 6, 'UDO, Cumaná', 20),
(93, 'Degustación Cervezas con Coco', '2025-09-05', NULL, 'Exploración de cervezas con adiciones de coco, fruto abundante en la región.', 'S', 1, 'Mercado Municipal, Carúpano', 20),
(94, 'Taller Elaboración Cerveza Ají Dulce', '2025-10-20', NULL, 'Aprende a usar ají dulce, un ingrediente emblemático, en tus recetas de cerveza.', 'S', 3, 'Escuela de Cocina, Cumaná', 20),
(95, 'Feria Emprendedores y Cerveza Sucrense', '2025-11-15', '2025-11-17', 'Exposición de productos de emprendedores y cervezas de Sucre.', 'N', 4, 'Paseo Ribereño, Cumaná', 20);

-- Eventos para el Estado Táchira (ID: 20)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(96, 'Táchira Beer & Montaña Fest', '2025-08-01', '2025-08-03', 'Festival de cerveza artesanal en el paisaje andino tachirense.', 'S', 8, 'Complejo Ferial San Cristóbal', 21),
(97, 'Charla: Café en Cerveza Andina', '2025-09-10', NULL, 'Explorando la combinación de cerveza con el café de altura del Táchira.', 'N', 6, 'UNET, San Cristóbal', 21),
(98, 'Degustación Cervezas con Mora', '2025-10-05', NULL, 'Exploración de cervezas con adiciones de mora, fruto típico de la región.', 'S', 1, 'Mercado de La Grita', 21),
(99, 'Taller Elaboración Cerveza Panela Andina', '2025-11-15', NULL, 'Aprende a usar panela, un endulzante tradicional, en tus recetas de cerveza.', 'S', 3, 'Hacienda Cafetera, Rubio', 21),
(100, 'Concurso Cerveza Artesanal "Pico El Águila"', '2025-12-01', '2025-12-02', 'Competencia para destacar las mejores cervezas de la región andina.', 'S', 2, 'Club Demócrata, San Cristóbal', 21);

-- Eventos para el Estado Trujillo (ID: 21)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(101, 'Trujillo Beer & Andes Fest', '2025-07-20', '2025-07-22', 'Festival de cerveza artesanal en el corazón de los Andes trujillanos.', 'S', 8, 'Parque La Trujillanidad, Trujillo', 22),
(102, 'Charla: Cerveza e Historia Trujillo', '2025-08-10', NULL, 'Recorrido por la historia de la cerveza en el contexto de Trujillo.', 'N', 6, 'Casa de los Tratados, Trujillo', 22),
(103, 'Degustación Cervezas con Durazno', '2025-09-05', NULL, 'Exploración de cervezas con adiciones de durazno, fruto típico de la región.', 'S', 1, 'Mercado de Boconó', 22),
(104, 'Taller Elaboración Cerveza con Papelón', '2025-10-20', NULL, 'Aprende a usar papelón, un endulzante tradicional, en tus recetas de cerveza.', 'S', 3, 'Hacienda El Recreo, Valera', 22),
(105, 'Feria Emprendedores y Cerveza Trujillana', '2025-11-15', '2025-11-17', 'Exposición de productos de emprendedores y cervezas de Trujillo.', 'N', 4, 'Plaza Bolívar, Valera', 22);

-- Eventos para el Estado La Guaira (ID: 22)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(106, 'La Guaira Beer & Sol Fest', '2025-08-01', '2025-08-03', 'Festival de cerveza artesanal en las playas de La Guaira.', 'S', 8, 'Playa Los Corales, Caraballeda', 23),
(107, 'Charla: Cerveza y Mar Caribe', '2025-09-10', NULL, 'Discusión sobre la influencia del ambiente costero en la cerveza.', 'N', 6, 'Hotel Marriott, Catia La Mar', 23),
(108, 'Degustación Cervezas Frutos del Mar', '2025-10-05', NULL, 'Exploración de maridajes de cervezas con productos marinos.', 'S', 1, 'Mercado de Maiquetía', 23),
(109, 'Taller Elaboración Cerveza Sal Marina', '2025-11-15', NULL, 'Aprende a usar sal marina en tus recetas de cerveza.', 'S', 3, 'Escuela de Gastronomía, Macuto', 23),
(110, 'Concierto "Birra y Salsa en la Costa"', '2025-12-01', NULL, 'Noche de música caribeña y cerveza artesanal.', 'S', 5, 'Paseo La Marina, La Guaira', 23);

-- Eventos para el Estado Yaracuy (ID: 23)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(111, 'Yaracuy Beer & Montaña Fest', '2025-07-25', '2025-07-27', 'Festival de cerveza artesanal en los paisajes montañosos de Yaracuy.', 'S', 8, 'Parque Exposición, San Felipe', 24),
(112, 'Charla: Cerveza y Caña de Azúcar', '2025-08-15', NULL, 'Explorando el uso de la caña de azúcar en la elaboración de cerveza.', 'N', 6, 'UPTY, San Felipe', 24),
(113, 'Degustación Cervezas con Papelón', '2025-09-01', NULL, 'Exploración de cervezas con adiciones de papelón, producto típico de la región.', 'S', 1, 'Mercado de Chivacoa', 24),
(114, 'Taller Elaboración Cerveza Frutas Cítricas', '2025-10-10', NULL, 'Aprende a usar frutas cítricas, abundantes en Yaracuy, en tus recetas.', 'S', 3, 'Hacienda La Victoria, Nirgua', 24),
(115, 'Feria Emprendedores y Cerveza Yaracuyana', '2025-11-05', '2025-11-07', 'Exposición de productos de emprendedores y cervezas de Yaracuy.', 'N', 4, 'Plaza Bolívar, Yaritagua', 24);

-- Eventos para el Estado Zulia (ID: 24)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(116, 'Zulia Beer & Lago Fest', '2025-08-10', '2025-08-12', 'Gran festival de cerveza artesanal a orillas del Lago de Maracaibo.', 'S', 8, 'Palacio Eventos Maracaibo', 25),
(117, 'Cena Maridaje "Sabores Zulianos"', '2025-09-01', NULL, 'Experiencia culinaria que fusiona la gastronomía zuliana con cervezas artesanales.', 'S', 7, 'Restaurante El Barroso, Maracaibo', 25),
(118, 'Lanzamiento "Cerveza del Relámpago"', '2025-10-05', NULL, 'Presentación de una nueva cerveza inspirada en el fenómeno del Catatumbo.', 'S', 9, 'Hotel Intercontinental, Maracaibo', 25),
(119, 'Taller Elaboración Cerveza con Plátano', '2025-11-15', NULL, 'Aprende a usar plátano, un ingrediente icónico del Zulia, en tus recetas.', 'S', 3, 'LUZ, Maracaibo', 25),
(120, 'Concierto "Gaita y Birra"', '2025-12-05', NULL, 'Noche de gaita zuliana y cerveza artesanal.', 'S', 5, 'Plaza de la República, Maracaibo', 25);

-- Eventos para las Dependencias Federales (ID: 25)
INSERT INTO Evento (evento_id, nombre_evento, fecha_inicio, fecha_fin, descripción_evento, requiere_entrada_paga, Tipo_Evento_tipo_evento_id, direccion_evento, Lugar_lugar_id) VALUES
(121, 'Roques Beer & Coral Fest', '2025-09-01', '2025-09-03', 'Festival de cerveza artesanal en el paradisíaco Archipiélago Los Roques.', 'S', 8, 'Gran Roque, Los Roques', 26),
(122, 'Charla: Cerveza y Conservación Marina', '2025-10-10', NULL, 'Discusión sobre el rol de la cerveza artesanal en la sostenibilidad de los ecosistemas marinos.', 'N', 6, 'Estación Científica Los Roques', 26),
(123, 'Degustación Cervezas Tropicales', '2025-11-05', NULL, 'Exploración de cervezas con perfiles de sabor tropicales y refrescantes.', 'S', 1, 'Cayo de Agua, Los Roques', 26),
(124, 'Taller Elaboración Cerveza Frutos del Mar', '2025-12-01', NULL, 'Aprende a usar ingredientes marinos en tus recetas de cerveza (ej. ostras).', 'S', 3, 'Posada La Gaviota, Gran Roque', 26),
(125, 'Concierto "Birra y Atardecer Caribeño"', '2025-06-15', NULL, 'Noche de música en vivo y cerveza artesanal con vistas al mar.', 'S', 5, 'Isla La Tortuga', 26);

-- 37. Tabla Instruccion_Receta (2 FK: Instruccion y Receta)
INSERT INTO Instruccion_Receta (Instruccion_instruccion_id, Receta_receta_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1),
(1, 2), (2, 2), (3, 2), (4, 2), (6, 2),
(1, 3), (2, 3), (3, 3), (4, 3), (7, 3),
(1, 4), (2, 4), (3, 4), (4, 4), (8, 4),
(1, 5), (2, 5), (3, 5), (4, 5), (5, 5);

-- 38. Tabla Receta_Ingrediente (2 FK: Receta y Ingrediente)
INSERT INTO Receta_Ingrediente (Receta_receta_id, Ingrediente_ingrediente_id, cantidad, unidad_medida) VALUES
(1, 1, 5, 'kg'), (1, 4, 50, 'g'), (1, 6, 1, 'paquete'),
(2, 1, 4.5, 'kg'), (2, 3, 0.5, 'kg'), (2, 5, 60, 'g'), (2, 6, 1, 'paquete'),
(3, 1, 6, 'kg'), (3, 2, 1, 'kg'), (3, 10, 0.5, 'kg'), (3, 6, 1, 'paquete'),
(4, 1, 7, 'kg'), (4, 10, 1, 'kg'), (4, 6, 1, 'paquete'),
(5, 1, 4, 'kg'), (5, 9, 1, 'kg'), (5, 4, 30, 'g'), (5, 6, 1, 'paquete');

-- 39. Tabla Tipo_Cerveza_Caracteristica (2 FK: Tipo_Cerveza y Característica)
INSERT INTO Tipo_Cerveza_Caracteristica (Tipo_Cerveza_tipo_cerveza_id, Característica_característica_id, descripción) VALUES
(1, 1, '20-30 IBUs'), (1, 2, '4.5-6.2% ABV'), (1, 3, '10-17 SRM'),
(2, 1, '30-50 IBUs'), (2, 2, '4.5-6% ABV'), (2, 3, '5-14 SRM'),
(3, 2, '6-7.5% ABV'), (3, 3, '14-20 SRM'), (3, 4, 'Frutos secos'),
(4, 2, '8-11% ABV'), (4, 3, '3-6 SRM'), (4, 5, 'Cuerpo medio'),
(5, 1, '15-25 IBUs'), (5, 2, '4.5-6% ABV'), (5, 3, '3-5 SRM');

-- 40. Tabla Rol_Privilegio (2 FK: Rol y Privilegio)
INSERT INTO Rol_Privilegio (Rol_rol_id, Privilegio_privilegio_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7),
(2, 2), (2, 3), (2, 5), (2, 8),
(3, 2), (3, 3), (3, 8),
(4, 2), (4, 9),
(5, 2), (5, 5), (5, 10),
(6, 2), (6, 3), (6, 8),
(7, 2), (7, 7),
(8, 2), (8, 3), (8, 5),
(9, 2), (9, 5),
(10, 2), (10, 6);

-- 41. Tabla Venta_Entrada (2 FK: Cliente y Evento)
INSERT INTO Venta_Entrada (Cliente_RIF, Evento_evento_id, venta_entrada_id, fecha_venta, total) VALUES
(123456789, 1, 1, '2025-07-01 10:00:00', 500000),
(987654321, 1, 2, '2025-07-02 11:30:00', 500000),
(555555555, 1, 3, '2025-07-03 09:15:00', 500000),
(123456780, 1, 4, '2025-07-04 15:45:00', 500000),
(987654320, 1, 5, '2025-07-05 16:30:00', 500000),
(555555550, 3, 6, '2025-08-01 14:00:00', 300000),
(123456789, 3, 7, '2025-08-02 12:30:00', 300000),
(987654321, 4, 8, '2025-05-15 10:00:00', 400000),
(555555555, 4, 9, '2025-05-20 11:00:00', 400000),
(123456780, 5, 10, '2025-06-10 09:00:00', 600000);

-- 42. Tabla Entrada_Evento (2 FK: Venta_Entrada y Evento)
INSERT INTO Entrada_Evento (entrada_evento_id, fecha_evento, Evento_evento_id, Venta_Entrada_Cliente_RIF, Venta_Entrada_Evento_evento_id, Venta_Entrada_venta_entrada_id) VALUES
(1, '2025-07-10', 1, 123456789, 1, 1),
(2, '2025-07-10', 1, 987654321, 1, 2),
(3, '2025-07-11', 1, 555555555, 1, 3),
(4, '2025-07-10', 1, 123456780, 1, 4),
(5, '2025-07-11', 1, 987654320, 1, 5),
(6, '2025-08-20', 3, 555555550, 3, 6),
(7, '2025-08-21', 3, 123456789, 3, 7),
(8, '2025-05-30', 4, 987654321, 4, 8),
(9, '2025-05-30', 4, 555555555, 4, 9),
(10, '2025-06-25', 5, 123456780, 5, 10);

-- 76. Tabla Departamento 
INSERT INTO Departamento (nombre_departamento) VALUES ('Ventas'), ('Compras'), ('Logística'), ('Marketing'), ('Recursos Humanos'), ('Producción'), ('Calidad'), ('Finanzas'), ('TI'), ('Eventos');

-- 77. Tabla tienda online 
INSERT INTO Tienda_Online (dirección_web) VALUES ('https://www.acaucab-principal.express' ), ('https://www.templodelacerveza.online'), ('https://www.acaucab-chacao.com'), ('https://www.rutaartesanal-valencia.ve'), ('https://www.birroteca-naguanagua.store'), ('https://www.refugiolupulo.com'), ('https://www.estacioncerveza-petare.net'), ('https://www.acaucab-altagracia.org'), ('https://www.bodegonlasdelicias.com'), ('https://www.casadelamalta.store');
-- 78. Tabla tienda física 
INSERT INTO Tienda_Física (tienda_fisica_id, nombre_ubicación, Orden_Reposición_orden_reposición_id, Lugar_lugar_id) VALUES
(1, 'ACAUCAB Principal', 1, 4), -- Caracas
(2, 'ACAUCAB Chacao', 2, 5), -- Baruta
(3, 'ACAUCAB Las Mercedes', 3, 6), -- Chacao
(4, 'ACAUCAB La Castellana', 4, 4), -- Caracas
(5, 'ACAUCAB San Ignacio', 5, 5), -- Baruta
(6, 'ACAUCAB El Hatillo', 6, 7), -- El Hatillo
(7, 'ACAUCAB Los Salias', 7, 9), -- Los Salias
(8, 'ACAUCAB Sucre', 8, 10), -- Sucre
(9, 'ACAUCAB Libertador', 9, 8), -- Libertador
(10, 'ACAUCAB Paseo Las Mercedes', 10, 6); -- Chacao

-- 48 Insertar 10 registros de ejemplo para Inventario
-- Inventario para 4 tiendas físicas (todas con tienda física, algunas con tienda online también)
INSERT INTO Inventario (
    cantidad_presentaciones,
    Tienda_Física_tienda_fisica_id,
    Tienda_Online_tienda_online_id,
    Cerveza_Presentacion_Cerveza_cerveza_id,
    Cerveza_Presentacion_Presentación_presentación_id
) VALUES
-- Tienda Física 1 (ACAUCAB Principal) - Con tienda online
(150, 1, 1, 1, 1),  -- Destilo Amber Botella
(75, 1, 1, 2, 2),   -- Destilo Amber Lata
(120, 1, NULL, 3, 3),  -- Benitz Pale Ale Botella (solo física)
(60, 1, NULL, 4, 4),   -- Benitz Pale Ale Lata (solo física)

-- Tienda Física 2 (ACAUCAB Centro) - Sin tienda online
(200, 2, NULL, 1, 1),  -- Destilo Amber Botella
(100, 2, NULL, 2, 2),  -- Destilo Amber Lata
(180, 2, NULL, 3, 3),  -- Benitz Pale Ale Botella
(90, 2, NULL, 4, 4),   -- Benitz Pale Ale Lata

-- Tienda Física 3 (ACAUCAB Este) - Con tienda online para algunos productos
(100, 3, 2, 5, 5),  -- Mito Candileja Botella (con online)
(50, 3, 2, 6, 6),   -- Mito Candileja Lata (con online)
(80, 3, NULL, 7, 7),  -- Ángel o Demonio Botella (solo física)
(40, 3, NULL, 8, 8),  -- Ángel o Demonio Lata (solo física)

-- Tienda Física 4 (ACAUCAB Oeste) - Solo productos físicos
(110, 4, NULL, 9, 9),  -- Aldarra Mantuana Botella
(55, 4, NULL, 10, 10);  -- Aldarra Mantuana Lata

-- 79. Tabla Lugar tienda
INSERT INTO Lugar_Tienda (Tienda_Física_tienda_fisica_id, lugar_tienda_id, nombre_lugar_tienda, tipo_lugar_tienda, Lugar_Tienda_lugar_tienda_id, Inventario_inventario_id) VALUES
(1, 1, 'Almacén Principal', 'Almacén', NULL, 1),
(2, 1, 'Mostrador Chacao', 'Exhibición',  NULL, 2),
(3, 1, 'Bodega Las Mercedes', 'Almacén',  NULL, 3),
(4, 1, 'Área VIP Castellana', 'Exhibición', NULL, 4),
(5, 1, 'Pasillo San Ignacio', 'Exhibición', NULL, 5),
(6, 1, 'Bodega El Hatillo', 'Almacén', NULL ,6),
(7, 1, 'Mostrador Los Salias', 'Exhibición',  NULL, 7),
(8, 1, 'Área Fría Sucre', 'Almacén', NULL,  8),
(9, 1, 'Pasillo Libertador', 'Exhibición',  NULL, 9),
(10, 1, 'Bodega Paseo', 'Almacén', NULL, 10);



-- 44. Tabla TipoE_Departamento (3 FK: Tipo_Empleado, Departamento, Empleado)
INSERT INTO TipoE_Departamento (Tipo_Empleado_tipo_empleado_id, Departamento_departamento_id, nombre_departamento, Empleado_empleado_id) VALUES
(1, 11,  'Gerencia General', 1),
(2, 12,  'Ventas', 2),
(3, 13,  'Compras', 3),
(4, 14,  'Logística', 4),
(5, 15,  'Marketing', 5),
(6, 16,  'RRHH', 6),
(7, 17,  'Producción', 7),
(8, 18,  'Calidad', 8),
(9, 19,  'Finanzas', 9),
(10, 20,  'TI', 10);

-- 45. Tabla Orden_Reposición (3 FK: Tienda_Física, TipoE_Departamento)
INSERT INTO Orden_Reposición (Tienda_Física_tienda_fisica_id, orden_reposición_id, fecha_hora_generación, cantidad_a_reponer, fecha_hora_completada, TipoE_Departamento_tipo_empleado_id, TipoE_Departamento_departamento_id, TipoE_Departamento_empleado_id) VALUES
(1, 1, '2025-03-01 10:00:00', 100, '2025-03-02 15:30:00', 3, 13, 3),
(1, 2, '2025-03-15 11:00:00', 50, '2025-03-16 12:00:00', 3, 13, 3),
(2, 3, '2025-04-01 09:30:00', 75, '2025-04-02 14:00:00', 3, 13, 3),
(2, 4, '2025-04-15 10:45:00', 60, '2025-04-16 11:30:00', 3, 13, 3),
(3, 5, '2025-05-01 08:00:00', 90, '2025-05-02 16:00:00', 3, 13, 3),
(3, 6, '2025-05-15 14:20:00', 80, '2025-05-16 10:00:00', 3, 13, 3),
(4, 7, '2025-06-01 16:10:00', 70, '2025-06-02 09:45:00', 3, 13, 3),
(4, 8, '2025-06-15 13:30:00', 55, '2025-06-16 15:15:00', 3, 13, 3),
(5, 9, '2025-07-01 10:15:00', 65, '2025-07-02 11:20:00', 3, 13, 3),
(5, 10, '2025-07-15 09:00:00', 85, '2025-07-16 14:00:00', 3, 13, 3);

-- 46. Tabla Compra (3 FK: Proveedor, TipoE_Departamento)
INSERT INTO Compra (compra_id, tipo_compra, monto_total, puntos_ganados, Proveedor_proveedor_id, subtotal, TipoE_Departamento_tipo_empleado_id, TipoE_Departamento_departamento_id, TipoE_Departamento_empleado_id) VALUES
(1, 'Normal', 5000000, NULL, 1, 5000000, 3, 13, 3),
(2, 'Normal', 4500000, NULL, 2, 4500000, 3, 13, 3),
(3, 'Normal', 4800000, NULL, 3, 4800000, 3, 13, 3),
(4, 'Normal', 5200000, NULL, 4, 5200000, 3, 13, 3),
(5, 'Normal', 4600000, NULL, 5, 4600000, 3, 13, 3),
(6, 'Especial', 6000000, NULL, 1, 6000000, 3, 13, 3),
(7, 'Especial', 5500000, NULL, 2, 5500000, 3, 13, 3),
(8, 'Normal', 4900000, NULL, 3, 4900000, 3, 13, 3),
(9, 'Normal', 5100000, NULL, 4, 5100000, 3, 13, 3),
(10, 'Especial', 5800000, NULL, 5, 5800000, 3, 13, 3);

-- 47. Tabla Detalle_Compra (3 FK: Compra, Cerveza_Presentacion, Tasa_Cambio)
INSERT INTO Detalle_Compra (cantidad, precio_unitario, Tasa_Cambio_tasa_cambio_id, Compra_proveedor_id, Compra_compra_id, Cerveza_Presentacion_Cerveza_cerveza_id, Cerveza_Presentacion_Presentación_presentación_id) VALUES
(100, 50000, 1, 1, 1, 1, 1),
(80, 56250, 1, 2, 2, 2, 2),
(90, 53333, 1, 3, 3, 3, 3),
(70, 74285, 1, 4, 4, 4, 4),
(85, 54117, 1, 5, 5, 5, 5),
(120, 50000, 3, 1, 6, 6, 6),
(95, 57894, 3, 2, 7, 7, 7),
(75, 65333, 3, 3, 8, 8, 8),
(65, 78461, 3, 4, 9, 9, 9),
(110, 52727, 3, 5, 10, 10, 10);


-- 49. Tabla Venta_Física (2 FK: Tienda_Física, Usuario)
INSERT INTO Venta_Física (Tienda_Física_tienda_fisica_id, Usuario_usuario_id, fecha_hora_venta, monto_total) VALUES
(1, 16, '2025-03-05 12:30:00', 1200000),
(1, 17, '2025-03-10 15:45:00', 950000),
(1, 18, '2025-03-15 18:20:00', 1500000),
(2, 16, '2025-04-02 11:15:00', 850000),
(2, 17, '2025-04-10 16:30:00', 1100000),
(2, 18, '2025-04-20 14:10:00', 1300000),
(3, 19, '2025-05-05 10:45:00', 900000),
(3, 20, '2025-05-15 17:00:00', 750000),
(4, 19, '2025-06-03 13:20:00', 1400000),
(5, 20, '2025-07-12 12:00:00', 1250000);

-- 50. Tabla Detalle_Física (3 FK: Venta_Física, Inventario, Tasa_Cambio)
INSERT INTO Detalle_Física (Venta_fisica_id, precio_unitario, cantidad, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id, Tasa_Cambio_tasa_cambio_id, Inventario_inventario_id) VALUES
(1,60000, 20, 1, 16, 1, 1),
(2,47500, 20, 1, 17, 1, 2),
(3,50000, 30, 1, 18, 1, 3),
(4,42500, 20, 2, 16, 1, 4),
(5,55000, 20, 2, 17, 1, 5),
(6,43333, 30, 2, 18, 1, 6),
(7,45000, 20, 3, 19, 3, 7),
(8,37500, 20, 3, 20, 3, 8),
(9,46666, 30, 4, 19, 3, 9),
(10,41666, 30, 5, 20, 3, 10);

INSERT INTO Venta_Online (Tienda_Online_tienda_online_id, Usuario_usuario_id, fecha_hora_venta, monto_total) VALUES
(1, 1,  '2025-03-01 08:15:00', 800000),
(1, 2,  '2025-03-10 10:30:00', 950000),
(1, 3,  '2025-04-05 14:20:00', 1200000),
(2, 4,  '2025-04-15 16:45:00', 750000),
(2, 5,  '2025-05-10 11:10:00', 1100000),
(1, 6,  '2025-05-20 09:30:00', 850000),
(2, 7,  '2025-06-05 13:15:00', 1300000),
(1, 8,  '2025-06-15 15:40:00', 900000),
(2, 9,  '2025-07-01 10:25:00', 1400000),
(1, 10,  '2025-07-10 12:50:00', 1250000);

-- 52. Tabla Detalle_Online (3 FK: Venta_Online, Inventario, Tasa_Cambio)
INSERT INTO Detalle_Online (venta_online_id, precio_unitario, cantidad, Venta_Online_tienda_online_id, Venta_Online_usuario_id, Tasa_Cambio_tasa_cambio_id, Inventario_inventario_id) VALUES
(1, 40000, 20, 1, 1, 1, 1),
(2, 47500, 20, 1, 2, 1, 2),
(3, 40000, 30, 1, 3, 1, 3),
(4, 37500, 20, 2, 4, 1, 4),
(5, 44000, 25, 2, 5, 1, 5),
(6, 42500, 20, 1, 6, 3, 6),
(7, 43333, 30, 2, 7, 3, 7),
(8, 45000, 20, 1, 8, 3, 8),
(9, 46666, 30, 2, 9, 3, 9),
(10, 41666, 30, 1, 10, 3, 10);

-- 53. Tabla Venta_Evento (2 FK: Proveedor, Evento)
INSERT INTO Venta_Evento (Proveedor_proveedor_id, Evento_evento_id, cantidad, precio_unitatio_pagado, fecha_hora_venta) VALUES
(1, 1, 50, 40000, '2025-07-01 10:00:00'),
(2, 1, 40, 45000, '2025-07-01 11:00:00'),
(3, 1, 30, 50000, '2025-07-02 09:30:00'),
(4, 1, 35, 48000, '2025-07-02 10:30:00'),
(5, 1, 45, 42000, '2025-07-03 08:45:00'),
(1, 3, 25, 60000, '2025-08-01 14:00:00'),
(2, 3, 20, 65000, '2025-08-02 15:00:00'),
(3, 4, 15, 70000, '2025-05-15 12:30:00'),
(4, 4, 18, 68000, '2025-05-16 13:45:00'),
(5, 5, 22, 75000, '2025-06-10 11:15:00');

-- 54. Tabla Detalle_VentaE (3 FK: Venta_Evento, Cerveza_Presentacion)
INSERT INTO Detalle_VentaE (cantidad, precio_unitario, Venta_Evento_Proveedor_proveedor_id, Venta_Evento_Evento_evento_id, Cerveza_Presentacion_Cerveza_cerveza_id, Cerveza_Presentacion_Presentación_presentación_id) VALUES
(50, 40000, 1, 1, 1, 1),
(40, 45000, 2, 1, 2, 2),
(30, 50000, 3, 1, 3, 3),
(35, 48000, 4, 1, 4, 4),
(45, 42000, 5, 1, 5, 5),
(25, 60000, 1, 3, 6, 6),
(20, 65000, 2, 3, 7, 7),
(15, 70000, 3, 4, 8, 8),
(18, 68000, 4, 4, 9, 9),
(22, 75000, 5, 5, 10, 10);

-- 55. Tabla Compra_Evento (2 FK: Cliente, Evento)
INSERT INTO Compra_Evento (Cliente_RIF, Evento_evento_id, fecha, monto_total) VALUES
(123456789, 1, '2025-07-10', 2000000),
(987654321, 1, '2025-07-10', 1800000),
(555555555, 1, '2025-07-11', 1500000),
(123456780, 1, '2025-07-11', 1200000),
(987654320, 1, '2025-07-10', 1600000),
(555555550, 3, '2025-08-20', 750000),
(123456789, 3, '2025-08-21', 600000),
(987654321, 4, '2025-05-30', 900000),
(555555555, 4, '2025-05-30', 850000),
(123456780, 5, '2025-06-25', 1100000);

-- Inserts para Inventario_E_Cerveza_P (relaciona cervezas-presentación con eventos)
INSERT INTO Inventario_E_Cerveza_P (
    Cerveza_Presentacion_Cerveza_cerveza_id,
    Cerveza_Presentacion_Presentación_presentación_id,
    cantidad,
    Evento_evento_id
) VALUES
-- Para el Evento 1 (UBirra 2025)
(1, 1, 200, 1),   -- 200 Destilo Amber (botella 330ml)
(2, 2, 150, 1),   -- 150 Benitz Pale Ale (botella 500ml)
(3, 3, 100, 1),   -- 100 Mito Candileja (botella 750ml)

-- Para el Evento 2 (Taller de Iniciación)
(4, 4, 50, 2),    -- 50 Ángel o Demonio (lata 355ml)
(5, 5, 80, 2),    -- 80 Aldarra Mantuana (lata 473ml)
-- Para el Evento 3 (Concurso Cervecero)
(6, 6, 60, 3),    -- 60 Latin American IPA (barril 5L)
(7, 7, 40, 3),    -- 40 Tovar Stout (barril 10L)
-- Para el Evento 4 (Degustación Premium)
(8, 8, 30, 4),    -- 30 UCAB Lager (barril 20L)
(9, 9, 25, 4),    -- 25 Caracas Porter (growler 1L)
-- Para el Evento 5 (Cena de Maridaje)
(10, 10, 40, 5);  -- 40 Avila Wheat (growler 2L)


-- 56. Tabla Detalle_Evento (6 FK: Compra_Evento, Inventario_E_Cerveza_P, Tasa_Cambio)
INSERT INTO Detalle_Evento (Tasa_Cambio_tasa_cambio_id, detalle_evento_id, cantidad_cerveza, Compra_Evento_Cliente_RIF, Compra_Evento_Evento_evento_id, Inventario_E_Cerveza_P_evento_id, Inventario_E_Cerveza_P_cerveza_id, Inventario_E_Cerveza_P_presentación_id) VALUES
(1, 1, 20, 123456789, 1, 1, 1, 1),
(1, 2, 15, 987654321, 1, 1, 1, 1),
(1, 3, 12, 555555555, 1, 1, 1, 1),
(1, 4, 10, 123456780, 1, 1, 1, 1),
(1, 5, 18, 987654320, 1, 1, 1, 1),
(3, 6, 8, 555555550, 3, 1, 3, 3),
(3, 7, 6, 123456789, 3, 1, 3, 3),
(1, 8, 12, 987654321, 4, 2, 4, 4),
(1, 9, 10, 555555555, 4, 2, 4, 4),
(1, 10, 15, 123456780, 5, 2, 5, 5);

-- 57. Tabla Pago_Fisica (3 FK: Venta_Física, Método_Pago)
INSERT INTO Pago_Fisica (Venta_fisica_id, fecha_pago, monto_pagado, referencia_pago, Venta_Física_tienda_fisica_id, Venta_Física_usuario_id, Método_Pago_método_pago_id, puntos_usuados) VALUES
(1,'2025-03-05', 1200000, 'PAG-001', 1, 16, 16, 0),
(2,'2025-03-10', 950000, 'PAG-002', 1, 17, 11, 50000),
(3,'2025-03-15', 1500000, 'PAG-003', 1, 18, 1, 0),
(4,'2025-04-02', 850000, 'PAG-004', 2, 16, 12, 30000),
(5,'2025-04-10', 1100000, 'PAG-005', 2, 17, 17, 0),
(6,'2025-04-20', 1300000, 'PAG-006', 2, 18, 2, 0),
(7,'2025-05-05', 900000, 'PAG-007', 3, 19, 13, 40000),
(8,'2025-05-15', 750000, 'PAG-008', 3, 20, 18, 0),
(9,'2025-06-03', 1400000, 'PAG-009', 4, 19, 3, 0),
(10,'2025-07-12', 1250000, 'PAG-010', 5, 20, 14, 60000);

-- 58. Tabla Pago_Online (3 FK: Venta_Online, Método_Pago)
INSERT INTO Pago_Online (venta_online_id, Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Venta_Online_tienda_online_id, Venta_Online_usuario_id, puntos_usados) VALUES
(1, 6, '2025-03-01', 800000, 'PAG-011', 1, 1, 0),
(2, 7, '2025-03-10', 950000, 'PAG-012', 1, 2, 45000),
(3, 8, '2025-04-05', 1200000, 'PAG-013', 1, 3, 0),
(4, 9, '2025-04-15', 750000, 'PAG-014', 2, 4, 35000),
(5, 10, '2025-05-10', 1100000, 'PAG-015', 2, 5, 0),
(6, 11, '2025-05-20', 850000, 'PAG-016', 1, 6, 40000),
(7, 12, '2025-06-05', 1300000, 'PAG-017', 2, 7, 0),
(8, 13, '2025-06-15', 900000, 'PAG-018', 1, 8, 45000),
(9, 14, '2025-07-01', 1400000, 'PAG-019', 2, 9, 0),
(10, 15, '2025-07-10', 1250000, 'PAG-020', 1, 10, 60000);





-- 59. Tabla Pago_Entrada (3 FK: Venta_Entrada, Método_Pago)
--Agregar un ID extra
INSERT INTO Pago_Entrada (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Venta_Entrada_Cliente_RIF, Venta_Entrada_Evento_evento_id, Venta_Entrada_venta_entrada_id) VALUES
(1, '2025-07-01', 500000, 'ENT-001', 123456789, 1, 1),
(2, '2025-07-02', 500000, 'ENT-002', 987654321, 1, 2),
(3, '2025-07-03', 500000, 'ENT-003', 555555555, 1, 3),
(4, '2025-07-04', 500000, 'ENT-004', 123456780, 1, 4),
(5, '2025-07-05', 500000, 'ENT-005', 987654320, 1, 5),
(6, '2025-08-01', 300000, 'ENT-006', 555555550, 3, 6),
(7, '2025-08-02', 300000, 'ENT-007', 123456789, 3, 7),
(8, '2025-05-15', 400000, 'ENT-008', 987654321, 4, 8),
(9, '2025-05-20', 400000, 'ENT-009', 555555555, 4, 9),
(10, '2025-06-10', 600000, 'ENT-010', 123456780, 5, 10);

-- 60. Tabla Pago_Compra_Evento (3 FK: Compra_Evento, Método_Pago)
INSERT INTO Pago_Compra_Evento (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Compra_Evento_Cliente_RIF, Compra_Evento_Evento_evento_id) VALUES
(1, '2025-07-10', 2000000, 'PCE-001', 123456789, 1),
(2, '2025-07-10', 1800000, 'PCE-002', 987654321, 1),
(3, '2025-07-11', 1500000, 'PCE-003', 555555555, 1),
(4, '2025-07-11', 1200000, 'PCE-004', 123456780, 1),
(5, '2025-07-10', 1600000, 'PCE-005', 987654320, 1),
(6, '2025-08-20', 750000, 'PCE-006', 555555550, 3),
(7, '2025-08-21', 600000, 'PCE-007', 123456789, 3),
(8, '2025-05-30', 900000, 'PCE-008', 987654321, 4),
(9, '2025-05-30', 850000, 'PCE-009', 555555555, 4),
(10, '2025-06-25', 1100000, 'PCE-010', 123456780, 5);

-- 61. Tabla Pago_CompraP (3 FK: Compra, Método_Pago)
INSERT INTO Pago_CompraP (Método_Pago_método_pago_id, fecha_pago, monto_pagado, referencia_pago, Compra_proveedor_id, Compra_compra_id) VALUES
(1, '2025-03-05', 5000000, 'PCP-001', 1, 1),
(2, '2025-03-12', 4500000, 'PCP-002', 2, 2),
(3, '2025-03-18', 4800000, 'PCP-003', 3, 3),
(4, '2025-03-25', 5200000, 'PCP-004', 4, 4),
(5, '2025-04-02', 4600000, 'PCP-005', 5, 5),
(6, '2025-04-10', 6000000, 'PCP-006', 1, 6),
(7, '2025-04-17', 5500000, 'PCP-007', 2, 7),
(8, '2025-04-24', 4900000, 'PCP-008', 3, 8),
(9, '2025-05-01', 5100000, 'PCP-009', 4, 9),
(10, '2025-05-08', 5800000, 'PCP-010', 5, 10);

-- 62. Tabla Asistencia (1 FK: Empleado)
INSERT INTO Asistencia (asistencia_id, fecha, hora_entrada_registrada, hora_salida_registrada, Empleado_empleado_id) VALUES
(1, '2025-03-01', '2025-03-01 08:00:00', '2025-03-01 17:05:00', 1),
(2, '2025-03-01', '2025-03-01 08:05:00', '2025-03-01 17:10:00', 2),
(3, '2025-03-01', '2025-03-01 08:10:00', '2025-03-01 17:15:00', 3),
(4, '2025-03-01', '2025-03-01 08:15:00', '2025-03-01 17:20:00', 4),
(5, '2025-03-01', '2025-03-01 08:20:00', '2025-03-01 17:25:00', 5),
(6, '2025-03-02', '2025-03-02 08:00:00', '2025-03-02 17:05:00', 1),
(7, '2025-03-02', '2025-03-02 08:05:00', '2025-03-02 17:10:00', 2),
(8, '2025-03-02', '2025-03-02 08:10:00', '2025-03-02 17:15:00', 3),
(9, '2025-03-02', '2025-03-02 08:15:00', '2025-03-02 17:20:00', 4),
(10, '2025-03-02', '2025-03-02 08:20:00', '2025-03-02 17:25:00', 5);

-- 63. Tabla Vacación (1 FK: Empleado)
INSERT INTO Vacación (Empleado_empleado_id, vacación_id, fecha_inicio, fecha_fin) VALUES
(1, 1, '2025-06-01', '2025-06-15'),
(2, 2, '2025-07-01', '2025-07-15'),
(3, 3, '2025-08-01', '2025-08-15'),
(4, 4, '2025-09-01', '2025-09-15'),
(5, 5, '2025-10-01', '2025-10-15'),
(6, 6, '2025-11-01', '2025-11-15'),
(7, 7, '2025-12-01', '2025-12-15'),
(8, 8, '2026-01-01', '2026-01-15'),
(9, 9, '2026-02-01', '2026-02-15'),
(10, 10, '2026-03-01', '2026-03-15');

-- 64. Tabla Cuota (1 FK: Proveedor)
INSERT INTO Cuota (cuota_id, descripción, monto_cuota, periodicidad, fecha_vigencia_monto, Proveedor_proveedor_id) VALUES
(1, 'Cuota afiliación básica', 500000, 'Mensual', '2025-01-01', 1),
(2, 'Cuota afiliación estándar', 750000, 'Mensual', '2025-01-01', 2),
(3, 'Cuota afiliación premium', 1000000, 'Mensual', '2025-01-01', 3),
(4, 'Cuota afiliación básica', 500000, 'Mensual', '2025-01-01', 4),
(5, 'Cuota afiliación estándar', 750000, 'Mensual', '2025-01-01', 5),
(6, 'Cuota promocional', 400000, 'Mensual', '2025-06-01', 1),
(7, 'Cuota promocional', 600000, 'Mensual', '2025-06-01', 2),
(8, 'Cuota promocional', 800000, 'Mensual', '2025-06-01', 3),
(9, 'Cuota promocional', 400000, 'Mensual', '2025-06-01', 4),
(10, 'Cuota promocional', 600000, 'Mensual', '2025-06-01', 5);

-- 65. Tabla Pago_Cuota (2 FK: Cuota, Método_Pago)
INSERT INTO Pago_Cuota (Método_Pago_método_pago_id, Cuota_cuota_id, fecha_pago, monto_pagado, recibo_id) VALUES
(1, 1, '2025-01-05', 500000, 'REC-001'),
(2, 2, '2025-01-05', 750000, 'REC-002'),
(3, 3, '2025-01-05', 1000000, 'REC-003'),
(4, 4, '2025-01-05', 500000, 'REC-004'),
(5, 5, '2025-01-05', 750000, 'REC-005'),
(6, 6, '2025-06-05', 400000, 'REC-006'),
(7, 7, '2025-06-05', 600000, 'REC-007'),
(8, 8, '2025-06-05', 800000, 'REC-008'),
(9, 9, '2025-06-05', 400000, 'REC-009'),
(10, 10, '2025-06-05', 600000, 'REC-010');




--80 punto
-- Inserts para la tabla Punto (10 registros)
INSERT INTO Punto (método_pago_id) VALUES
(1),  -- Puntos asociados al método de pago 1
(2),  -- Puntos asociados al método de pago 2
(3),  -- Puntos asociados al método de pago 3
(4),  -- Puntos asociados al método de pago 4
(5),  -- Puntos asociados al método de pago 5
(6),  -- Puntos asociados al método de pago 6
(7),  -- Puntos asociados al método de pago 7
(8),  -- Puntos asociados al método de pago 8
(9),  -- Puntos asociados al método de pago 9
(10); -- Puntos asociados al método de pago 10

-- 66. Tabla Cliente_Punto (2 FK: Cliente, Punto)
INSERT INTO Cliente_Punto (cantidad_puntos, Punto_método_pago_id, Cliente_RIF) VALUES
(1000, 1, 123456789),
(800, 2, 987654321),
(1200, 3, 555555555),
(750, 4, 111111111),
(1500, 5, 999999999),
(900, 6, 123456780),
(600, 7, 987654320),
(1100, 8, 555555550),
(850, 9, 111111110),
(1300, 10, 999999990);

--81 descuento 
-- Inserts para la tabla Descuento (10 registros)
INSERT INTO Descuento (descuento_id, porcentaje_descuento) VALUES
(1, 5),   -- 5% de descuento (promoción básica)
(2, 10),  -- 10% de descuento (promoción estándar)
(3, 15),  -- 15% de descuento (promoción especial)
(4, 20),  -- 20% de descuento (liquidación)
(5, 25),  -- 25% de descuento (oferta por volumen)
(6, 30),  -- 30% de descuento (días especiales)
(7, 35),  -- 35% de descuento (miembros premium)
(8, 40),  -- 40% de descuento (temporada baja)
(9, 50),  -- 50% de descuento (oferta relámpago)
(10, 60); -- 60% de descuento (últimas unidades)

-- 67. Tabla Descuento_Inventario (2 FK: Descuento, Inventario)
INSERT INTO Descuento_Inventario (Descuento_descuento_id, Inventario_inventario_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 6),
(2, 7),
(3, 8),
(4, 9),
(5, 10);

-- 68. Tabla Juez_Evento (2 FK: Juez, Evento)
INSERT INTO Juez_Evento (Evento_evento_id, Juez_juez_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5),
(3, 6), (3, 7), (3, 8),
(4, 9), (4, 10),
(5, 1), (5, 3),
(6, 2), (6, 4),
(7, 5), (7, 7),
(8, 6), (8, 8),
(9, 9), (9, 10),
(10, 1), (10, 10);

-- 81 permiso Inserts para la tabla Permiso (10 registros)
INSERT INTO Permiso (
    permiso_id,
    fecha_solicitud,
    fecha_inicio,
    fecha_fin,
    motivo
) VALUES
-- Permiso por enfermedad
(1, '2025-03-01', '2025-03-02', '2025-03-05', 'Enfermedad con certificado médico'),

-- Permiso por asuntos personales
(2, '2025-03-10', '2025-03-15', '2025-03-15', 'Trámite personal bancario'),

-- Permiso por capacitación
(3, '2025-04-05', '2025-04-10', '2025-04-12', 'Curso de certificación cervecera'),

-- Permiso por emergencia familiar
(4, '2025-04-20', '2025-04-21', '2025-04-23', 'Emergencia familiar - hospitalización'),

-- Permiso por maternidad
(5, '2025-05-01', '2025-05-15', '2025-08-15', 'Licencia por maternidad'),

-- Permiso por examen
(6, '2025-06-10', '2025-06-15', '2025-06-15', 'Examen universitario'),

-- Permiso por duelo
(7, '2025-07-05', '2025-07-07', '2025-07-10', 'Fallecimiento de familiar directo'),

-- Permiso por vacaciones
(8, '2025-08-01', '2025-08-15', '2025-08-30', 'Vacaciones anuales programadas'),

-- Permiso por evento corporativo
(9, '2025-09-10', '2025-09-20', '2025-09-22', 'Participación en festival cervecero'),

-- Permiso por paternidad
(10, '2025-10-01', '2025-10-05', '2025-10-20', 'Licencia por paternidad');

-- 69. Tabla Rol_Permiso (2 FK: Rol, Permiso)
INSERT INTO Rol_Permiso (Permiso_permiso_id, Rol_rol_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1),
(2, 2), (3, 2), (5, 2), (8, 2),
(2, 3), (3, 3), (8, 3),
(2, 4), (9, 4),
(2, 5), (5, 5), (10, 5),
(2, 6), (3, 6), (8, 6),
(2, 7), (7, 7),
(2, 8), (3, 8), (5, 8),
(2, 9), (5, 9),
(2, 10), (6, 10);

-- 70. Tabla TipoED_Horario (4 FK: TipoE_Departamento, Horario)
INSERT INTO TipoED_Horario (Horario_horario_id, TipoE_Departamento_Tipo_Empleado_tipo_empleado_id, TipoE_Departamento_Departamento_departamento_id, TipoE_Departamento_Empleado_empleado_id) VALUES
(1, 1, 11, 1),
(1, 2, 12, 2),
(1, 3, 13, 3),
(2, 4, 14, 4),
(2, 5, 15, 5),
(3, 6, 16, 6),
(3, 7, 17, 7),
(4, 8, 18, 8),
(4, 9, 19, 9),
(5, 10, 20, 10);

-- 71. Tabla Compra_Estatus (3 FK: Compra, Estatus)
INSERT INTO Compra_Estatus (fecha_inicio, fecha_fin, Estatus_estatus_id, Compra_proveedor_id, Compra_compra_id) VALUES
('2025-03-01', '2025-03-02', 1, 1, 1),
('2025-03-02', '2025-03-03', 2, 1, 1),
('2025-03-03', '2025-03-05', 3, 1, 1),
('2025-03-10', '2025-03-11', 1, 2, 2),
('2025-03-11', '2025-03-12', 2, 2, 2),
('2025-03-12', '2025-03-15', 3, 2, 2),
('2025-03-18', '2025-03-19', 1, 3, 3),
('2025-03-19', '2025-03-20', 2, 3, 3),
('2025-03-20', '2025-03-22', 3, 3, 3),
('2025-03-25', '2025-03-26', 1, 4, 4);

-- 72. Tabla OrdenR_Estatus (2 FK: Orden_Reposición, Estatus)
INSERT INTO OrdenR_Estatus (fecha_inicio, fecha_fin, Estatus_estatus_id, Orden_Reposición_orden_reposición_id) VALUES
('2025-03-01', '2025-03-01', 1, 1),
('2025-03-01', '2025-03-02', 2, 1),
('2025-03-02', NULL, 3, 1),
('2025-03-15', '2025-03-15', 1, 2),
('2025-03-15', '2025-03-16', 2, 2),
('2025-03-16', NULL, 3, 2),
('2025-04-01', '2025-04-01', 1, 3),
('2025-04-01', '2025-04-02', 2, 3),
('2025-04-02', NULL, 3, 3),
('2025-04-15', '2025-04-15', 1, 4);

-- 73. Tabla VentaF_Estatus (3 FK: Venta_Física, Estatus)
INSERT INTO VentaF_Estatus (Venta_fisica_id, fecha_inicio, fecha_fin, Estatus_estatus_id, Venta_Física_Tienda_Física_tienda_fisica_id, Venta_Física_Usuario_usuario_id) VALUES
(1,'2025-03-05', '2025-03-05', 1, 1, 16),
(2,'2025-03-05', '2025-03-05', 2, 1, 17),
(3,'2025-03-05', NULL, 3, 1, 18),
(4,'2025-03-10', '2025-03-10', 1, 2, 16),
(5,'2025-03-10', '2025-03-10', 2, 2, 17),
(6,'2025-03-10', NULL, 3, 2, 18),
(7,'2025-03-15', '2025-03-15', 1, 3, 19),
(8,'2025-03-15', '2025-03-15', 2, 3, 20),
(9,'2025-03-15', NULL, 3, 4, 19),
(10,'2025-04-02', '2025-04-02', 1, 5, 20);

-- 74. Tabla VentaO_Estatus (3 FK: Venta_Online, Estatus)
INSERT INTO VentaO_Estatus (venta_online_id, fecha_inicio, fecha_fin, Estatus_estatus_id, Venta_Online_Tienda_Online_tienda_online_id, Venta_Online_Usuario_usuario_id) VALUES
(1, '2025-03-01', '2025-03-01', 1, 1, 1),
(2, '2025-03-01', '2025-03-01', 2, 1, 2),
(3, '2025-03-01', NULL, 3, 1, 3),
(4, '2025-03-10', '2025-03-10', 1, 2, 4),
(5, '2025-03-10', '2025-03-10', 2, 2, 5),
(6, '2025-03-10', NULL, 3, 1, 6),
(7, '2025-04-05', '2025-04-05', 1, 2, 7),
(8, '2025-04-05', '2025-04-05', 2, 1, 8),
(9, '2025-04-05', NULL, 3, 2, 9),
(10, '2025-04-15', '2025-04-15', 1, 1, 10);

-- 75. Tabla Vacacion_Estatus (2 FK: Vacación, Estatus)
INSERT INTO Vacacion_Estatus (fecha_inicio, fecha_fin, Estatus_estatus_id, Vacación_vacación_id) VALUES
('2025-05-20', '2025-05-25', 1, 1),
('2025-05-25', '2025-05-30', 2, 1),
('2025-05-30', NULL, 3, 1),
('2025-06-20', '2025-06-25', 1, 2),
('2025-06-25', '2025-06-30', 2, 2),
('2025-06-30', NULL, 3, 2),
('2025-07-20', '2025-07-25', 1, 3),
('2025-07-25', '2025-07-30', 2, 3),
('2025-07-30', NULL, 3, 3),
('2025-08-20', '2025-08-25', 1, 4);





