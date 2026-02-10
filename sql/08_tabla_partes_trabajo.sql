-- ===================================================
-- PASO 8: PARTES DE TRABAJO
-- ===================================================

CREATE TABLE partes_trabajo_cra (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_parte TEXT UNIQUE,
    
    -- Relaciones (OPCIONALES)
    cliente_id UUID REFERENCES clientes(id) ON DELETE SET NULL,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE SET NULL,
    incidencia_id UUID REFERENCES incidencias_cra(id) ON DELETE SET NULL,
    
    -- Técnicos
    tecnico_principal TEXT,
    tecnicos JSONB DEFAULT '[]',
    
    -- Clasificación
    tipo_trabajo TEXT CHECK (tipo_trabajo IN (
        'instalacion', 'mantenimiento', 'reparacion', 'revision'
    )),
    
    estado TEXT DEFAULT 'borrador' CHECK (estado IN (
        'borrador', 'en_proceso', 'completado', 'facturado'
    )),
    
    -- Fechas y tiempos
    fecha_trabajo DATE DEFAULT CURRENT_DATE,
    hora_inicio TIME,
    hora_fin TIME,
    horas_trabajadas NUMERIC(5,2),
    
    -- Trabajo realizado
    trabajo_realizado TEXT,
    observaciones TEXT,
    
    -- Costes
    coste_materiales NUMERIC(10,2),
    coste_mano_obra NUMERIC(10,2),
    
    -- Firma
    firma_cliente TEXT,
    
    -- Facturación
    facturado BOOLEAN DEFAULT FALSE,
    fecha_facturacion DATE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_partes_estado ON partes_trabajo_cra(estado);
CREATE INDEX idx_partes_fecha ON partes_trabajo_cra(fecha_trabajo DESC);
CREATE INDEX idx_partes_facturado ON partes_trabajo_cra(facturado);

CREATE TRIGGER update_partes_updated_at 
BEFORE UPDATE ON partes_trabajo_cra
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Función para autogenerar número
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

CREATE TRIGGER generar_numero_parte_trigger 
BEFORE INSERT ON partes_trabajo_cra
FOR EACH ROW EXECUTE FUNCTION generar_numero_parte();

-- Verificar
SELECT 'Tabla partes_trabajo_cra creada' as status, COUNT(*) as total FROM partes_trabajo_cra;
