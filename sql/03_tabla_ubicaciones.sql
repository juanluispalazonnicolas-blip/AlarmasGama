-- ===================================================
-- PASO 3: UBICACIONES (Depende de: clientes)
-- ===================================================

CREATE TABLE ubicaciones (
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

-- Verificar
SELECT 'Tabla ubicaciones creada' as status, COUNT(*) as total FROM ubicaciones;
