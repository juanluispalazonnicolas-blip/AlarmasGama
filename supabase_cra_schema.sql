-- ============================================
-- SCRIPTS SQL PARA CRA IBERSEGUR - SUPABASE
-- ============================================
-- Autor: Antigravity AI
-- Fecha: 2026-02-10
-- Versión: 1.0
-- Descripción: Tablas necesarias para gestión completa de CRA
-- ============================================

-- ============================================
-- 1. TABLA: incidencias_cra
-- Gestión completa de incidencias de la CRA
-- ============================================

CREATE TABLE IF NOT EXISTS incidencias_cra (
    -- Identificadores
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_incidencia TEXT UNIQUE, -- Autogenerado: INC/2026/0001
    
    -- Relaciones
    cliente_id UUID REFERENCES clientes(id) ON DELETE SET NULL,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE SET NULL,
    proyecto_id UUID REFERENCES proyectos(id) ON DELETE SET NULL,
    
    -- Clasificación
    tipo_incidencia TEXT NOT NULL CHECK (tipo_incidencia IN (
        'salto_alarma',
        'sin_video',
        'fallo_tecnico',
        'conexion_perdida',
        'camara_averiada',
        'aviso_tecnico',
        'otros'
    )),
    
    origen TEXT DEFAULT 'manual' CHECK (origen IN (
        'ajax',
        'manual',
        'automatico',
        'cliente',
        'sistema'
    )),
    
    prioridad TEXT DEFAULT 'normal' CHECK (prioridad IN (
        'baja',
        'normal',
        'alta',
        'critica'
    )),
    
    estado TEXT DEFAULT 'borrador' CHECK (estado IN (
        'borrador',
        'en_curso',
        'resuelto',
        'cerrado',
        'cancelado'
    )),
    
    -- Contenido
    titulo TEXT,
    descripcion TEXT,
    notas_resolucion TEXT,
    ubicacion_afectada TEXT, -- Ej: "Cámara 3 - Entrada principal"
    
    -- Asignación
    asignado_a TEXT, -- Nombre del técnico o receptora
    
    -- Fechas y tiempos
    fecha_incidencia TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_asignacion TIMESTAMP WITH TIME ZONE,
    fecha_resolucion TIMESTAMP WITH TIME ZONE,
    tiempo_resolucion_minutos INTEGER GENERATED ALWAYS AS (
        EXTRACT(EPOCH FROM (fecha_resolucion - fecha_incidencia)) / 60
    ) STORED,
    
    -- Metadata
    datos_adicionales JSONB, -- Para almacenar info específica de Ajax, etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para rendimiento
CREATE INDEX idx_incidencias_cliente ON incidencias_cra(cliente_id);
CREATE INDEX idx_incidencias_ubicacion ON incidencias_cra(ubicacion_id);
CREATE INDEX idx_incidencias_estado ON incidencias_cra(estado);
CREATE INDEX idx_incidencias_prioridad ON incidencias_cra(prioridad);
CREATE INDEX idx_incidencias_fecha ON incidencias_cra(fecha_incidencia DESC);
CREATE INDEX idx_incidencias_numero ON incidencias_cra(numero_incidencia);

-- Trigger para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_incidencias_updated_at BEFORE UPDATE ON incidencias_cra
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Función para generar número de incidencia
CREATE OR REPLACE FUNCTION generar_numero_incidencia()
RETURNS TRIGGER AS $$
DECLARE
    year_actual TEXT;
    siguiente_numero INTEGER;
BEGIN
    IF NEW.numero_incidencia IS NULL OR NEW.numero_incidencia = '' THEN
        year_actual := TO_CHAR(CURRENT_DATE, 'YYYY');
        
        SELECT COALESCE(MAX(CAST(SUBSTRING(numero_incidencia FROM '\d+$') AS INTEGER)), 0) + 1
        INTO siguiente_numero
        FROM incidencias_cra
        WHERE numero_incidencia LIKE 'INC/' || year_actual || '/%';
        
        NEW.numero_incidencia := 'INC/' || year_actual || '/' || LPAD(siguiente_numero::TEXT, 4, '0');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generar_numero_incidencia_trigger BEFORE INSERT ON incidencias_cra
FOR EACH ROW EXECUTE FUNCTION generar_numero_incidencia();

-- ============================================
-- 2. TABLA: partes_trabajo_cra
-- Gestión de partes de trabajo de técnicos
-- ============================================

CREATE TABLE IF NOT EXISTS partes_trabajo_cra (
    -- Identificadores
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_parte TEXT UNIQUE, -- Autogenerado: PARTE/2026/0001
    
    -- Relaciones
    cliente_id UUID REFERENCES clientes(id) ON DELETE SET NULL,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE SET NULL,
    proyecto_id UUID REFERENCES proyectos(id) ON DELETE SET NULL,
    incidencia_id UUID REFERENCES incidencias_cra(id) ON DELETE SET NULL,
    
    -- Técnicos
    tecnicos JSONB NOT NULL DEFAULT '[]', -- Array: [{"nombre": "Juan", "id": "..."}, ...]
    tecnico_principal TEXT, -- Nombre del técnico responsable
    
    -- Clasificación
    tipo_trabajo TEXT CHECK (tipo_trabajo IN (
        'instalacion',
        'mantenimiento',
        'reparacion',
        'revision',
        'urgente',
        'preventivo'
    )),
    
    estado TEXT DEFAULT 'borrador' CHECK (estado IN (
        'borrador',
        'en_proceso',
        'completado',
        'facturado',
        'cancelado'
    )),
    
    -- Fechas y tiempos
    fecha_trabajo DATE NOT NULL DEFAULT CURRENT_DATE,
    hora_inicio TIME,
    hora_fin TIME,
    horas_trabajadas NUMERIC(5,2),
    
    -- Trabajo realizado
    trabajo_realizado TEXT,
    observaciones TEXT,
    materiales_usados JSONB DEFAULT '[]', -- [{"material": "...", "cantidad": 1, "precio": 10}]
    coste_materiales NUMERIC(10,2),
    coste_mano_obra NUMERIC(10,2),
    coste_total NUMERIC(10,2) GENERATED ALWAYS AS (
        COALESCE(coste_materiales, 0) + COALESCE(coste_mano_obra, 0)
    ) STORED,
    
    -- Firma y documentación
    firma_cliente TEXT, -- Base64 de la firma digital
    fecha_firma TIMESTAMP WITH TIME ZONE,
    fotos JSONB DEFAULT '[]', -- [{"url": "...", "descripcion": "..."}]
    
    -- Facturación
    albaran_id UUID REFERENCES documentos(id),
    facturado BOOLEAN DEFAULT FALSE,
    fecha_facturacion DATE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_partes_cliente ON partes_trabajo_cra(cliente_id);
CREATE INDEX idx_partes_ubicacion ON partes_trabajo_cra(ubicacion_id);
CREATE INDEX idx_partes_incidencia ON partes_trabajo_cra(incidencia_id);
CREATE INDEX idx_partes_estado ON partes_trabajo_cra(estado);
CREATE INDEX idx_partes_fecha ON partes_trabajo_cra(fecha_trabajo DESC);
CREATE INDEX idx_partes_facturado ON partes_trabajo_cra(facturado);

-- Trigger updated_at
CREATE TRIGGER update_partes_updated_at BEFORE UPDATE ON partes_trabajo_cra
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Función para generar número de parte
CREATE OR REPLACE FUNCTION generar_numero_parte()
RETURNS TRIGGER AS $$
DECLARE
    year_actual TEXT;
    siguiente_numero INTEGER;
BEGIN
    IF NEW.numero_parte IS NULL OR NEW.numero_parte = '' THEN
        year_actual := TO_CHAR(CURRENT_DATE, 'YYYY');
        
        SELECT COALESCE(MAX(CAST(SUBSTRING(numero_parte FROM '\d+$') AS INTEGER)), 0) + 1
        INTO siguiente_numero
        FROM partes_trabajo_cra
        WHERE numero_parte LIKE 'PARTE/' || year_actual || '/%';
        
        NEW.numero_parte := 'PARTE/' || year_actual || '/' || LPAD(siguiente_numero::TEXT, 4, '0');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generar_numero_parte_trigger BEFORE INSERT ON partes_trabajo_cra
FOR EACH ROW EXECUTE FUNCTION generar_numero_parte();

-- ============================================
-- 3. TABLA: protocolos_cliente_cra
-- Protocolos específicos por cliente
-- ============================================

CREATE TABLE IF NOT EXISTS protocolos_cliente_cra (
    -- Identificadores
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relaciones
    cliente_id UUID REFERENCES clientes(id) ON DELETE CASCADE,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE CASCADE,
    
    -- Información básica
    nombre_protocolo TEXT NOT NULL,
    descripcion TEXT,
    
    -- Clasificación
    tipo_servicio TEXT CHECK (tipo_servicio IN (
        'salon_juego',
        'campo_solar',
        'empresa',
        'industrial',
        'residencial',
        'otro'
    )),
    
    criticidad TEXT DEFAULT 'normal' CHECK (criticidad IN (
        'normal',
        'prioritario',
        'critico'
    )),
    
    -- Protocolos y checklists
    checklist JSONB DEFAULT '[]', -- [{"item": "...", "obligatorio": true}]
    acciones_incidencia JSONB DEFAULT '{}', -- {"tipo_alarma": {"accion": "...", "contactar": "..."}}
    
    -- Contactos
    contactos_emergencia JSONB DEFAULT '[]', -- [{"nombre": "...", "tel": "...", "rol": "..."}]
    
    -- Horarios
    horarios_operacion JSONB DEFAULT '{}', -- {"lunes": {"inicio": "08:00", "fin": "20:00"}}
    
    -- Garantía
    fecha_inicio_garantia DATE,
    fecha_fin_garantia DATE,
    dentro_garantia BOOLEAN GENERATED ALWAYS AS (
        CASE 
            WHEN fecha_fin_garantia IS NULL THEN FALSE
            WHEN fecha_fin_garantia >= CURRENT_DATE THEN TRUE
            ELSE FALSE
        END
    ) STORED,
    dias_restantes_garantia INTEGER GENERATED ALWAYS AS (
        CASE 
            WHEN fecha_fin_garantia IS NULL THEN 0
            WHEN fecha_fin_garantia >= CURRENT_DATE THEN 
                (fecha_fin_garantia - CURRENT_DATE)
            ELSE 0
        END
    ) STORED,
    
    -- Notas y configuración
    notas TEXT,
    configuracion_adicional JSONB DEFAULT '{}',
    activo BOOLEAN DEFAULT TRUE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_protocolos_cliente ON protocolos_cliente_cra(cliente_id);
CREATE INDEX idx_protocolos_ubicacion ON protocolos_cliente_cra(ubicacion_id);
CREATE INDEX idx_protocolos_garantia ON protocolos_cliente_cra(dentro_garantia);
CREATE INDEX idx_protocolos_criticidad ON protocolos_cliente_cra(criticidad);
CREATE INDEX idx_protocolos_activo ON protocolos_cliente_cra(activo);

-- Trigger updated_at
CREATE TRIGGER update_protocolos_updated_at BEFORE UPDATE ON protocolos_cliente_cra
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 4. TABLA: sistemas_visionado
-- Control de los 58 salones y sistemas CCTV
-- ============================================

CREATE TABLE IF NOT EXISTS sistemas_visionado (
    -- Identificadores
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relaciones
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE CASCADE,
    cliente_id UUID REFERENCES clientes(id) ON DELETE CASCADE,
    
    -- Identificación del salón
    numero_salon INTEGER UNIQUE, -- 1 a 58
    abonado TEXT,
    nombre_salon TEXT,
    
    -- Estado del sistema
    estado_visionado TEXT DEFAULT 'no_visible' CHECK (estado_visionado IN (
        'visible',
        'no_visible',
        'intermitente',
        'en_mantenimiento'
    )),
    
    -- Configuración de red
    ip_dominio TEXT,
    puerto_http INTEGER,
    puerto_rtsp INTEGER,
    puerto_servidor INTEGER,
    p2p_id TEXT,
    
    -- Acceso al sistema
    usuario_dvr TEXT,
    password_dvr TEXT, -- IMPORTANTE: Encriptar en producción
    
    -- Equipo
    modelo_dvr TEXT,
    marca_dvr TEXT,
    fabricante TEXT,
    firmware_version TEXT,
    
    -- Cámaras
    num_camaras_total INTEGER,
    num_camaras_funcionando INTEGER,
    detalle_camaras JSONB DEFAULT '[]', -- [{"id": 1, "ubicacion": "...", "estado": "ok"}]
    
    -- Software y conectividad
    software_visionado TEXT CHECK (software_visionado IN (
        'NVMS',
        'EZView',
        'Smart PSS',
        'Safire Control',
        'AJAX',
        'Babyware',
        'Xtralis',
        'Otro'
    )),
    
    proveedor_internet TEXT,
    velocidad_internet TEXT,
    ip_publica TEXT,
    
    -- Diagnóstico
    ultima_conexion TIMESTAMP WITH TIME ZONE,
    dias_sin_conexion INTEGER GENERATED ALWAYS AS (
        CASE 
            WHEN ultima_conexion IS NULL THEN NULL
            ELSE EXTRACT(DAY FROM (NOW() - ultima_conexion))::INTEGER
        END
    ) STORED,
    
    problemas_detectados TEXT,
    acciones_requeridas TEXT,
    
    -- Priorización
    prioridad TEXT DEFAULT 'media' CHECK (prioridad IN (
        'baja',
        'media',
        'alta',
        'critica'
    )),
    
    -- Garantía
    en_garantia BOOLEAN DEFAULT FALSE,
    fecha_fin_garantia DATE,
    
    -- Auditoría
    auditado BOOLEAN DEFAULT FALSE,
    fecha_auditoria DATE,
    auditado_por TEXT,
    notas_auditoria TEXT,
    
    -- Notas generales
    notas TEXT,
    historial_cambios JSONB DEFAULT '[]', -- Log de cambios importantes
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_sistemas_cliente ON sistemas_visionado(cliente_id);
CREATE INDEX idx_sistemas_ubicacion ON sistemas_visionado(ubicacion_id);
CREATE INDEX idx_sistemas_estado ON sistemas_visionado(estado_visionado);
CREATE INDEX idx_sistemas_auditado ON sistemas_visionado(auditado);
CREATE INDEX idx_sistemas_prioridad ON sistemas_visionado(prioridad);
CREATE INDEX idx_sistemas_numero ON sistemas_visionado(numero_salon);

-- Trigger updated_at
CREATE TRIGGER update_sistemas_updated_at BEFORE UPDATE ON sistemas_visionado
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- VISTAS ÚTILES
-- ============================================

-- Vista: Dashboard de sistemas de visionado
CREATE OR REPLACE VIEW v_dashboard_sistemas AS
SELECT 
    s.numero_salon,
    c.nombre as cliente,
    u.nombre as ubicacion,
    s.estado_visionado,
    s.num_camaras_total,
    s.num_camaras_funcionando,
    s.software_visionado,
    s.ultima_conexion,
    s.dias_sin_conexion,
    s.prioridad,
    s.auditado,
    s.en_garantia
FROM sistemas_visionado s
LEFT JOIN clientes c ON s.cliente_id = c.id
LEFT JOIN ubicaciones u ON s.ubicacion_id = u.id
ORDER BY s.numero_salon;

-- Vista: Incidencias pendientes
CREATE OR REPLACE VIEW v_incidencias_pendientes AS
SELECT 
    i.numero_incidencia,
    c.nombre as cliente,
    u.nombre as ubicacion,
    i.tipo_incidencia,
    i.prioridad,
    i.estado,
    i.fecha_incidencia,
    i.asignado_a,
    EXTRACT(HOUR FROM (NOW() - i.fecha_incidencia))::INTEGER as horas_abierta
FROM incidencias_cra i
LEFT JOIN clientes c ON i.cliente_id = c.id
LEFT JOIN ubicaciones u ON i.ubicacion_id = u.id
WHERE i.estado NOT IN ('resuelto', 'cerrado', 'cancelado')
ORDER BY 
    CASE i.prioridad
        WHEN 'critica' THEN 1
        WHEN 'alta' THEN 2
        WHEN 'normal' THEN 3
        WHEN 'baja' THEN 4
    END,
    i.fecha_incidencia ASC;

-- Vista: Partes pendientes de facturación
CREATE OR REPLACE VIEW v_partes_pendientes_facturacion AS
SELECT 
    p.numero_parte,
    c.nombre as cliente,
    p.fecha_trabajo,
    p.tecnico_principal,
    p.coste_total,
    p.estado
FROM partes_trabajo_cra p
LEFT JOIN clientes c ON p.cliente_id = c.id
WHERE p.facturado = FALSE AND p.estado = 'completado'
ORDER BY p.fecha_trabajo ASC;

-- ============================================
-- POLÍTICAS RLS (Row Level Security) - OPCIONAL
-- Descomentar si quieres activar seguridad a nivel de fila
-- ============================================

-- ALTER TABLE incidencias_cra ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE partes_trabajo_cra ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE protocolos_cliente_cra ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE sistemas_visionado ENABLE ROW LEVEL SECURITY;

-- ============================================
-- DATOS DE EJEMPLO (OPCIONAL - COMENTADO)
-- ============================================

-- Ejemplo de incidencia
/*
INSERT INTO incidencias_cra (
    cliente_id,
    tipo_incidencia,
    origen,
    prioridad,
    titulo,
    descripcion
) VALUES (
    (SELECT id FROM clientes LIMIT 1),
    'sin_video',
    'manual',
    'alta',
    'Salón sin visionado',
    'El salón no muestra video desde las 14:00'
);
*/

-- Ejemplo de parte de trabajo
/*
INSERT INTO partes_trabajo_cra (
    cliente_id,
    tecnicos,
    tipo_trabajo,
    fecha_trabajo,
    trabajo_realizado
) VALUES (
    (SELECT id FROM clientes LIMIT 1),
    '[{"nombre": "Juan Pérez", "id": "tech_001"}]'::jsonb,
    'mantenimiento',
    CURRENT_DATE,
    'Revisión completa del sistema de visionado'
);
*/

-- ============================================
-- FIN DEL SCRIPT
-- ============================================

-- Para ejecutar este script en Supabase:
-- 1. Ve a SQL Editor en tu dashboard de Supabase
-- 2. Pega todo este contenido
-- 3. Haz clic en "Run" o presiona Ctrl+Enter
-- 4. Verifica que las tablas se crearon correctamente
