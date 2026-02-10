-- ============================================
-- SCRIPTS SQL COMPLETO PARA CRA IBERSEGUR
-- ============================================
-- Autor: Antigravity AI
-- Fecha: 2026-02-10
-- Versión: 2.0 - COMPLETO DESDE CERO
-- ============================================

-- Habilitar extensión UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TABLAS BASE (que no existían)
-- ============================================

-- 1. TABLA: clientes
CREATE TABLE IF NOT EXISTS clientes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tipo_cliente TEXT NOT NULL,
    nombre TEXT NOT NULL,
    direccion TEXT,
    localidad TEXT,
    provincia TEXT,
    pais TEXT DEFAULT 'España',
    email TEXT,
    telefono TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_clientes_tipo ON clientes(tipo_cliente);
CREATE INDEX idx_clientes_nombre ON clientes(nombre);

-- 2. TABLA: ubicaciones
CREATE TABLE IF NOT EXISTS ubicaciones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cliente_id UUID REFERENCES clientes(id) ON DELETE CASCADE,
    nombre TEXT,
    direccion TEXT,
    localidad TEXT,
    provincia TEXT,
    tipo_instalacion TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_ubicaciones_cliente ON ubicaciones(cliente_id);
CREATE INDEX idx_ubicaciones_tipo ON ubicaciones(tipo_instalacion);

-- 3. TABLA: proyectos
CREATE TABLE IF NOT EXISTS proyectos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cliente_id UUID REFERENCES clientes(id) ON DELETE SET NULL,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE SET NULL,
    tipo_proyecto TEXT,
    descripcion TEXT,
    estado TEXT DEFAULT 'borrador',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_proyectos_cliente ON proyectos(cliente_id);
CREATE INDEX idx_proyectos_estado ON proyectos(estado);

-- 4. TABLA: documentos
CREATE TABLE IF NOT EXISTS documentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    proyecto_id UUID REFERENCES proyectos(id) ON DELETE CASCADE,
    tipo_documento TEXT,
    titulo TEXT,
    estado TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_documentos_proyecto ON documentos(proyecto_id);

-- 5. TABLA: evidencias
CREATE TABLE IF NOT EXISTS evidencias (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    proyecto_id UUID REFERENCES proyectos(id) ON DELETE CASCADE,
    tipo TEXT,
    descripcion TEXT,
    ruta_archivo TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_evidencias_proyecto ON evidencias(proyecto_id);

-- 6. TABLA: registros (auditoría)
CREATE TABLE IF NOT EXISTS registros (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    accion TEXT,
    entidad TEXT,
    entidad_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_registros_created ON registros(created_at DESC);

-- ============================================
-- TABLAS CRA ESPECÍFICAS
-- ============================================

-- Trigger para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 1. TABLA: incidencias_cra
CREATE TABLE IF NOT EXISTS incidencias_cra (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_incidencia TEXT UNIQUE,
    
    cliente_id UUID REFERENCES clientes(id) ON DELETE SET NULL,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE SET NULL,
    proyecto_id UUID REFERENCES proyectos(id) ON DELETE SET NULL,
    
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
    
    titulo TEXT,
    descripcion TEXT,
    notas_resolucion TEXT,
    ubicacion_afectada TEXT,
    
    asignado_a TEXT,
    
    fecha_incidencia TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_asignacion TIMESTAMP WITH TIME ZONE,
    fecha_resolucion TIMESTAMP WITH TIME ZONE,
    tiempo_resolucion_minutos INTEGER GENERATED ALWAYS AS (
        EXTRACT(EPOCH FROM (fecha_resolucion - fecha_incidencia)) / 60
    ) STORED,
    
    datos_adicionales JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_incidencias_cliente ON incidencias_cra(cliente_id);
CREATE INDEX idx_incidencias_ubicacion ON incidencias_cra(ubicacion_id);
CREATE INDEX idx_incidencias_estado ON incidencias_cra(estado);
CREATE INDEX idx_incidencias_prioridad ON incidencias_cra(prioridad);
CREATE INDEX idx_incidencias_fecha ON incidencias_cra(fecha_incidencia DESC);
CREATE INDEX idx_incidencias_numero ON incidencias_cra(numero_incidencia);

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

-- 2. TABLA: partes_trabajo_cra
CREATE TABLE IF NOT EXISTS partes_trabajo_cra (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_parte TEXT UNIQUE,
    
    cliente_id UUID REFERENCES clientes(id) ON DELETE SET NULL,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE SET NULL,
    proyecto_id UUID REFERENCES proyectos(id) ON DELETE SET NULL,
    incidencia_id UUID REFERENCES incidencias_cra(id) ON DELETE SET NULL,
    
    tecnicos JSONB NOT NULL DEFAULT '[]',
    tecnico_principal TEXT,
    
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
    
    fecha_trabajo DATE NOT NULL DEFAULT CURRENT_DATE,
    hora_inicio TIME,
    hora_fin TIME,
    horas_trabajadas NUMERIC(5,2),
    
    trabajo_realizado TEXT,
    observaciones TEXT,
    materiales_usados JSONB DEFAULT '[]',
    coste_materiales NUMERIC(10,2),
    coste_mano_obra NUMERIC(10,2),
    coste_total NUMERIC(10,2) GENERATED ALWAYS AS (
        COALESCE(coste_materiales, 0) + COALESCE(coste_mano_obra, 0)
    ) STORED,
    
    firma_cliente TEXT,
    fecha_firma TIMESTAMP WITH TIME ZONE,
    fotos JSONB DEFAULT '[]',
    
    albaran_id UUID REFERENCES documentos(id),
    facturado BOOLEAN DEFAULT FALSE,
    fecha_facturacion DATE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_partes_cliente ON partes_trabajo_cra(cliente_id);
CREATE INDEX idx_partes_ubicacion ON partes_trabajo_cra(ubicacion_id);
CREATE INDEX idx_partes_incidencia ON partes_trabajo_cra(incidencia_id);
CREATE INDEX idx_partes_estado ON partes_trabajo_cra(estado);
CREATE INDEX idx_partes_fecha ON partes_trabajo_cra(fecha_trabajo DESC);
CREATE INDEX idx_partes_facturado ON partes_trabajo_cra(facturado);

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

-- 3. TABLA: protocolos_cliente_cra
CREATE TABLE IF NOT EXISTS protocolos_cliente_cra (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    cliente_id UUID REFERENCES clientes(id) ON DELETE CASCADE,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE CASCADE,
    
    nombre_protocolo TEXT NOT NULL,
    descripcion TEXT,
    
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
    
    checklist JSONB DEFAULT '[]',
    acciones_incidencia JSONB DEFAULT '{}',
    
    contactos_emergencia JSONB DEFAULT '[]',
    
    horarios_operacion JSONB DEFAULT '{}',
    
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
    
    notas TEXT,
    configuracion_adicional JSONB DEFAULT '{}',
    activo BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_protocolos_cliente ON protocolos_cliente_cra(cliente_id);
CREATE INDEX idx_protocolos_ubicacion ON protocolos_cliente_cra(ubicacion_id);
CREATE INDEX idx_protocolos_garantia ON protocolos_cliente_cra(dentro_garantia);
CREATE INDEX idx_protocolos_criticidad ON protocolos_cliente_cra(criticidad);
CREATE INDEX idx_protocolos_activo ON protocolos_cliente_cra(activo);

CREATE TRIGGER update_protocolos_updated_at BEFORE UPDATE ON protocolos_cliente_cra
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 4. TABLA: sistemas_visionado (Los 58 salones)
CREATE TABLE IF NOT EXISTS sistemas_visionado (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE CASCADE,
    cliente_id UUID REFERENCES clientes(id) ON DELETE CASCADE,
    
    numero_salon INTEGER UNIQUE,
    abonado TEXT,
    nombre_salon TEXT,
    
    estado_visionado TEXT DEFAULT 'no_visible' CHECK (estado_visionado IN (
        'visible',
        'no_visible',
        'intermitente',
        'en_mantenimiento'
    )),
    
    ip_dominio TEXT,
    puerto_http INTEGER,
    puerto_rtsp INTEGER,
    puerto_servidor INTEGER,
    p2p_id TEXT,
    
    usuario_dvr TEXT,
    password_dvr TEXT,
    
    modelo_dvr TEXT,
    marca_dvr TEXT,
    fabricante TEXT,
    firmware_version TEXT,
    
    num_camaras_total INTEGER,
    num_camaras_funcionando INTEGER,
    detalle_camaras JSONB DEFAULT '[]',
    
    software_visionado TEXT,
    
    proveedor_internet TEXT,
    velocidad_internet TEXT,
    ip_publica TEXT,
    
    ultima_conexion TIMESTAMP WITH TIME ZONE,
    dias_sin_conexion INTEGER GENERATED ALWAYS AS (
        CASE 
            WHEN ultima_conexion IS NULL THEN NULL
            ELSE EXTRACT(DAY FROM (NOW() - ultima_conexion))::INTEGER
        END
    ) STORED,
    
    problemas_detectados TEXT,
    acciones_requeridas TEXT,
    
    prioridad TEXT DEFAULT 'media' CHECK (prioridad IN (
        'baja',
        'media',
        'alta',
        'critica'
    )),
    
    en_garantia BOOLEAN DEFAULT FALSE,
    fecha_fin_garantia DATE,
    
    auditado BOOLEAN DEFAULT FALSE,
    fecha_auditoria DATE,
    auditado_por TEXT,
    notas_auditoria TEXT,
    
    notas TEXT,
    historial_cambios JSONB DEFAULT '[]',
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sistemas_cliente ON sistemas_visionado(cliente_id);
CREATE INDEX idx_sistemas_ubicacion ON sistemas_visionado(ubicacion_id);
CREATE INDEX idx_sistemas_estado ON sistemas_visionado(estado_visionado);
CREATE INDEX idx_sistemas_auditado ON sistemas_visionado(auditado);
CREATE INDEX idx_sistemas_prioridad ON sistemas_visionado(prioridad);
CREATE INDEX idx_sistemas_numero ON sistemas_visionado(numero_salon);

CREATE TRIGGER update_sistemas_updated_at BEFORE UPDATE ON sistemas_visionado
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- VISTAS ÚTILES
-- ============================================

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
-- FIN DEL SCRIPT
-- ============================================

-- Verificar tablas creadas
SELECT 
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN (
    'clientes',
    'ubicaciones',
    'proyectos',
    'documentos',
    'evidencias',
    'registros',
    'incidencias_cra',
    'partes_trabajo_cra',
    'protocolos_cliente_cra',
    'sistemas_visionado'
  )
ORDER BY tablename;
