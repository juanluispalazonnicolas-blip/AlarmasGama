-- ===================================================
-- PASO 2: TABLAS BASE (Sin dependencias)
-- ===================================================

-- TABLA 1: clientes (principal, no depende de nada)
CREATE TABLE clientes (
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

-- Verificar
SELECT 'Tabla clientes creada' as status, COUNT(*) as total FROM clientes;
