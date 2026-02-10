-- ===================================================
-- PASO 4: PROYECTOS Y DOCUMENTOS
-- ===================================================

-- TABLA: proyectos
CREATE TABLE proyectos (
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

-- TABLA: documentos
CREATE TABLE documentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    proyecto_id UUID REFERENCES proyectos(id) ON DELETE CASCADE,
    tipo_documento TEXT,
    titulo TEXT,
    estado TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_documentos_proyecto ON documentos(proyecto_id);

-- TABLA: evidencias
CREATE TABLE evidencias (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    proyecto_id UUID REFERENCES proyectos(id) ON DELETE CASCADE,
    tipo TEXT,
    descripcion TEXT,
    ruta_archivo TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_evidencias_proyecto ON evidencias(proyecto_id);

-- Verificar
SELECT 'Tablas creadas' as status;
SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename IN ('proyectos', 'documentos', 'evidencias');
