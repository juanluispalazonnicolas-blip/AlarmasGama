-- ===================================================
-- PASO 9: PROTOCOLOS CLIENTE
-- ===================================================

CREATE TABLE protocolos_cliente_cra (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relaciones (OPCIONALES)
    cliente_id UUID REFERENCES clientes(id) ON DELETE CASCADE,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE CASCADE,
    
    -- Información básica
    nombre_protocolo TEXT NOT NULL,
    descripcion TEXT,
    
    -- Clasificación
    tipo_servicio TEXT CHECK (tipo_servicio IN (
        'salon_juego', 'campo_solar', 'empresa', 'industrial', 'otro'
    )),
    
    criticidad TEXT DEFAULT 'normal' CHECK (criticidad IN (
        'normal', 'prioritario', 'critico'
    )),
    
    -- Protocolos (JSON)
    checklist JSONB DEFAULT '[]',
    acciones_incidencia JSONB DEFAULT '{}',
    contactos_emergencia JSONB DEFAULT '[]',
    horarios_operacion JSONB DEFAULT '{}',
    
    -- Garantía
    fecha_inicio_garantia DATE,
    fecha_fin_garantia DATE,
    
    -- Notas
    notas TEXT,
    activo BOOLEAN DEFAULT TRUE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_protocolos_cliente ON protocolos_cliente_cra(cliente_id);
CREATE INDEX idx_protocolos_activo ON protocolos_cliente_cra(activo);

CREATE TRIGGER update_protocolos_updated_at 
BEFORE UPDATE ON protocolos_cliente_cra
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Verificar
SELECT 'Tabla protocolos_cliente_cra creada' as status, COUNT(*) as total FROM protocolos_cliente_cra;
