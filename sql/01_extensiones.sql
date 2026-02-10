-- ===================================================
-- PASO 1: HABILITAR EXTENSIONES
-- ===================================================
-- Ejecuta esto PRIMERO, solo una vez

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Verificar que se instaló correctamente
SELECT * FROM pg_extension WHERE extname = 'uuid-ossp';

-- Deberías ver una fila con "uuid-ossp"
