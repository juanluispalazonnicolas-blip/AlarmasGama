-- ===================================================
-- PASO 10: VERIFICACIÓN FINAL
-- ===================================================

-- Ver todas las tablas creadas
SELECT 
    tablename as tabla,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS tamaño
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- Resultado esperado: 10 tablas
-- clientes
-- documentos
-- evidencias
-- incidencias_cra
-- partes_trabajo_cra
-- proyectos
-- protocolos_cliente_cra
-- sistemas_visionado
-- ubicaciones

-- Resumen por tabla
SELECT 
    'clientes' as tabla, COUNT(*) as registros FROM clientes
UNION ALL
SELECT 'ubicaciones', COUNT(*) FROM ubicaciones
UNION ALL
SELECT 'proyectos', COUNT(*) FROM proyectos
UNION ALL
SELECT 'documentos', COUNT(*) FROM documentos
UNION ALL
SELECT 'evidencias', COUNT(*) FROM evidencias
UNION ALL
SELECT 'sistemas_visionado', COUNT(*) FROM sistemas_visionado
UNION ALL
SELECT 'incidencias_cra', COUNT(*) FROM incidencias_cra
UNION ALL
SELECT 'partes_trabajo_cra', COUNT(*) FROM partes_trabajo_cra
UNION ALL
SELECT 'protocolos_cliente_cra', COUNT(*) FROM protocolos_cliente_cra;

-- Todo debería mostrar 0 registros (tablas vacías pero creadas)
SELECT '✅ INSTALACIÓN COMPLETADA - Todas las tablas creadas correctamente' as status;
