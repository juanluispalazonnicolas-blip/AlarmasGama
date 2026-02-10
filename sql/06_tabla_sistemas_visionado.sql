-- ===================================================
-- PASO 6: SISTEMAS DE VISIONADO (58 salones)
-- ===================================================
-- Esta es la tabla MÁS IMPORTANTE para tu trabajo diario

CREATE TABLE sistemas_visionado (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relaciones (OPCIONAL - pueden ser NULL)
    cliente_id UUID REFERENCES clientes(id) ON DELETE SET NULL,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE SET NULL,
    
    -- Identificación del salón
    numero_salon INTEGER UNIQUE,
    abonado TEXT,
    nombre_salon TEXT,
    
    -- Estado (LO MÁS IMPORTANTE)
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
    
    -- Acceso
    usuario_dvr TEXT,
    password_dvr TEXT,
    
    -- Equipo
    modelo_dvr TEXT,
    marca_dvr TEXT,
    
    -- Cámaras
    num_camaras_total INTEGER,
    num_camaras_funcionando INTEGER,
    
    -- Software
    software_visionado TEXT,
    
    -- Internet
    proveedor_internet TEXT,
    
    -- Diagnóstico
    problemas_detectados TEXT,
    acciones_requeridas TEXT,
    
    -- Prioridad
    prioridad TEXT DEFAULT 'media' CHECK (prioridad IN (
        'baja', 'media', 'alta', 'critica'
    )),
    
    -- Auditoría
    auditado BOOLEAN DEFAULT FALSE,
    fecha_auditoria DATE,
    
    -- Notas
    notas TEXT,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sistemas_estado ON sistemas_visionado(estado_visionado);
CREATE INDEX idx_sistemas_numero ON sistemas_visionado(numero_salon);
CREATE INDEX idx_sistemas_prioridad ON sistemas_visionado(prioridad);

CREATE TRIGGER update_sistemas_updated_at 
BEFORE UPDATE ON sistemas_visionado
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Verificar
SELECT 'Tabla sistemas_visionado creada' as status, COUNT(*) as total FROM sistemas_visionado;
