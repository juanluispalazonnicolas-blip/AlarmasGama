-- ===================================================
-- PASO 7: INCIDENCIAS CRA
-- ===================================================

CREATE TABLE incidencias_cra (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_incidencia TEXT UNIQUE,
    
    -- Relaciones (OPCIONALES)
    cliente_id UUID REFERENCES clientes(id) ON DELETE SET NULL,
    ubicacion_id UUID REFERENCES ubicaciones(id) ON DELETE SET NULL,
    
    -- Clasificación
    tipo_incidencia TEXT NOT NULL CHECK (tipo_incidencia IN (
        'salto_alarma',
        'sin_video',
        'fallo_tecnico',
        'conexion_perdida',
        'camara_averiada',
        'otros'
    )),
    
    prioridad TEXT DEFAULT 'normal' CHECK (prioridad IN (
        'baja', 'normal', 'alta', 'critica'
    )),
    
    estado TEXT DEFAULT 'borrador' CHECK (estado IN (
        'borrador', 'en_curso', 'resuelto', 'cerrado'
    )),
    
    -- Contenido
    titulo TEXT,
    descripcion TEXT,
    notas_resolucion TEXT,
    
    -- Asignación
    asignado_a TEXT,
    
    -- Fechas
    fecha_incidencia TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_resolucion TIMESTAMP WITH TIME ZONE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_incidencias_estado ON incidencias_cra(estado);
CREATE INDEX idx_incidencias_prioridad ON incidencias_cra(prioridad);
CREATE INDEX idx_incidencias_fecha ON incidencias_cra(fecha_incidencia DESC);

CREATE TRIGGER update_incidencias_updated_at 
BEFORE UPDATE ON incidencias_cra
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Función para autogenerar número
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

CREATE TRIGGER generar_numero_incidencia_trigger 
BEFORE INSERT ON incidencias_cra
FOR EACH ROW EXECUTE FUNCTION generar_numero_incidencia();

-- Verificar
SELECT 'Tabla incidencias_cra creada' as status, COUNT(*) as total FROM incidencias_cra;
