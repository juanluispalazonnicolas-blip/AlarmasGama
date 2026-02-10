-- ===============================================
-- PASO 11: INSERTAR PROTOCOLOS BASE (7 protocolos)
-- ===============================================
-- Estos son los protocolos esenciales para operar la CRA
-- Basados en PLANTILLAS_PROTOCOLOS.md

-- 1. PROTOCOLO GENERAL SALONES DE JUEGO
INSERT INTO protocolos_cliente_cra (
    nombre_protocolo,
    descripcion,
    tipo_servicio,
    criticidad,
    checklist,
    acciones_incidencia,
    contactos_emergencia,
    horarios_operacion,
    notas,
    activo
) VALUES (
    'Protocolo General Salones de Juego',
    'Protocolo estándar para todos los salones de juego. Personalizar por cada cliente.',
    'salon_juego',
    'prioritario',
    '[
        {"orden": 1, "tarea": "Verificar visionado en tiempo real", "critico": true},
        {"orden": 2, "tarea": "Revisar grabación últimas 24h", "critico": false},
        {"orden": 3, "tarea": "Comprobar todas las cámaras (caja/TPVs)", "critico": true},
        {"orden": 4, "tarea": "Verificar conexión a internet", "critico": true},
        {"orden": 5, "tarea": "Comprobar estado del DVR/NVR", "critico": true}
    ]'::jsonb,
    '{
        "salto_alarma": {
            "paso_1": "Verificar video (máximo 2 minutos)",
            "paso_2": "Si NO hay video: Llamar responsable",
            "paso_3": "Si HAY video y es falsa alarma: Marcar en sistema",
            "paso_4": "Si HAY video y es real: Llamar responsable + policía + crear incidencia",
            "tiempo_maximo_min": 2
        },
        "sin_video": {
            "paso_1": "Llamar al responsable inmediatamente",
            "paso_2": "Crear incidencia técnica",
            "paso_3": "Agendar visita técnica si procede"
        }
    }'::jsonb,
    '[
        {"rol": "Responsable", "nombre": "A definir por cliente", "telefono_1": "", "orden_llamada": 1, "horario_disponible": "24/7"},
        {"rol": "Policía Local", "telefono_1": "092", "orden_llamada": 3},
        {"rol": "Emergencias", "telefono_1": "112", "orden_llamada": 4}
    ]'::jsonb,
    '{
        "lunes_viernes": {"apertura": "08:00", "cierre": "22:00", "vigilancia_fuera_horario": true},
        "sabado": {"apertura": "10:00", "cierre": "20:00", "vigilancia_fuera_horario": true},
        "domingo": {"cerrado": true, "vigilancia_fuera_horario": true}
    }'::jsonb,
    'PLANTILLA BASE - Duplicar y personalizar para cada salón de juego. Criticidad ALTA por dinero en efectivo.',
    true
);

-- 2. PROTOCOLO GENERAL CAMPOS SOLARES
INSERT INTO protocolos_cliente_cra (
    nombre_protocolo,
    descripcion,
    tipo_servicio,
    criticidad,
    checklist,
    acciones_incidencia,
    contactos_emergencia,
    horarios_operacion,
    notas,
    activo
) VALUES (
    'Protocolo General Campos Solares',
    'Protocolo para instalaciones fotovoltaicas y campos solares.',
    'campo_solar',
    'normal',
    '[
        {"orden": 1, "tarea": "Verificar cámaras perimetrales", "critico": true},
        {"orden": 2, "tarea": "Revisar eventos de movimiento nocturnos", "critico": true},
        {"orden": 3, "tarea": "Comprobar barreras infrarrojos si aplica", "critico": false},
        {"orden": 4, "tarea": "Verificar iluminación nocturna", "critico": false}
    ]'::jsonb,
    '{
        "intrusion": {
            "paso_1": "Verificar video de perímetro",
            "paso_2": "Identificar: ¿Están robando material? ¿Cerca de equipos críticos?",
            "paso_3": "Llamar a responsable",
            "paso_4": "Si es robo activo: Policía + Seguridad",
            "paso_5": "Documentar: hora, punto entrada, número intrusos, vehículo",
            "tiempo_maximo_min": 5
        }
    }'::jsonb,
    '[
        {"rol": "Responsable", "nombre": "A definir", "telefono_1": "", "orden_llamada": 1, "horario_disponible": "24/7"},
        {"rol": "Seguridad 24h", "nombre": "A definir", "telefono_1": "", "orden_llamada": 2},
        {"rol": "Policía", "telefono_1": "112", "orden_llamada": 3}
    ]'::jsonb,
    '{
        "vigilancia_24h": true,
        "especial_atencion_horario": "22:00-06:00",
        "notas": "Mayor riesgo de robo material en horario nocturno"
    }'::jsonb,
    'PLANTILLA BASE - Bajo riesgo personal, alto riesgo material. Enfoque en protección perímetro.',
    true
);

-- 3. PROTOCOLO GENERAL EMPRESAS
INSERT INTO protocolos_cliente_cra (
    nombre_protocolo,
    descripcion,
    tipo_servicio,
    criticidad,
    checklist,
    acciones_incidencia,
    contactos_emergencia,
    horarios_operacion,
    notas,
    activo
) VALUES (
    'Protocolo General Empresas',
    'Protocolo estándar para empresas, oficinas y comercios.',
    'empresa',
    'normal',
    '[
        {"orden": 1, "tarea": "Verificar cámaras de acceso principal", "critico": true},
        {"orden": 2, "tarea": "Revisar áreas sensibles (caja, almacén)", "critico": true},
        {"orden": 3, "tarea": "Comprobar horario de apertura/cierre", "critico": false},
        {"orden": 4, "tarea": "Verificar armado/desarmado según protocolo", "critico": true}
    ]'::jsonb,
    '{
        "durante_horario_laboral": {
            "verificar_solo_si": "Hay alarma específica",
            "no_molestar_por": "Eventos menores",
            "actuar_si": "Movimiento en zonas restringidas"
        },
        "fuera_horario": {
            "cualquier_movimiento": "Sospechoso",
            "accion": "Verificar inmediatamente + llamar responsable",
            "tiempo_maximo_min": 3
        }
    }'::jsonb,
    '[
        {"rol": "Gerente", "nombre": "A definir", "telefono_1": "", "email": "", "orden_llamada": 1},
        {"rol": "Encargado", "nombre": "A definir", "telefono_1": "", "orden_llamada": 2},
        {"rol": "Mantenimiento", "telefono_1": "", "orden_llamada": 3}
    ]'::jsonb,
    '{
        "lunes_viernes": {"apertura": "09:00", "cierre": "18:00", "vigilancia_fuera_horario": true},
        "sabado_domingo": {"cerrado": true, "vigilancia_fuera_horario": true}
    }'::jsonb,
    'PLANTILLA BASE - Criticidad varía según sector. Distinguir entre horario laboral y fuera de horario.',
    true
);

-- 4. PROTOCOLO COMUNICACIÓN CLIENTE
INSERT INTO protocolos_cliente_cra (
    nombre_protocolo,
    descripcion,
    tipo_servicio,
    criticidad,
    checklist,
    acciones_incidencia,
    contactos_emergencia,
    horarios_operacion,
    notas,
    activo
) VALUES (
    'Protocolo Comunicación Cliente',
    'Guía de cómo y cuándo comunicarse con clientes.',
    'otro',
    'normal',
    '[
        {"tarea": "Usar tono profesional en llamadas"},
        {"tarea": "Ser directo y conciso"},
        {"tarea": "Documentar todas las comunicaciones"},
        {"tarea": "Confirmar que cliente entendió el mensaje"}
    ]'::jsonb,
    '{
        "cuando_llamar": {
            "si": ["Alarma verificada con video", "Problema técnico que afecta servicio", "Cliente pidió ser notificado siempre"],
            "no": ["Eventos menores sin video", "Consultas no urgentes", "Actualizaciones de estado"]
        },
        "script_llamada": "Buenos días/tardes, soy [Nombre] de CRA Ibersegur. Le llamamos porque a las [HORA] se activó una alarma en [UBICACIÓN]. Hemos verificado las imágenes y [DESCRIPCIÓN]. ¿Está al corriente? ¿Quiere que avisemos a la policía?",
        "canales": {
            "llamada": "Alarmas urgentes, problemas críticos",
            "email": "Informes, documentación, no urgente",
            "whatsapp": "Confirmaciones rápidas, actualizaciones"
        }
    }'::jsonb,
    '[]'::jsonb,
    '{
        "disponibilidad_receptora": "24/7",
        "tiempo_respuesta_objetivo": 2,
        "notas": "Siempre documentar en Odoo cada comunicación"
    }'::jsonb,
    'PROTOCOLO OPERATIVO - No es cliente-específico, sino interno para el equipo CRA.',
    true
);

-- 5. PROTOCOLO ESCALADO INCIDENCIAS
INSERT INTO protocolos_cliente_cra (
    nombre_protocolo,
    descripcion,
    tipo_servicio,
    criticidad,
    checklist,
    acciones_incidencia,
    contactos_emergencia,
    horarios_operacion,
    notas,
    activo
) VALUES (
    'Protocolo Escalado Incidencias',
    'Cuándo y cómo escalar incidencias entre niveles.',
    'otro',
    'prioritario',
    '[
        {"tarea": "Identificar nivel adecuado"},
        {"tarea": "Documentar antes de escalar"},
        {"tarea": "Comunicar claramente el problema"},
        {"tarea": "Seguir hasta resolución"}
    ]'::jsonb,
    '{
        "nivel_1_receptora": {
            "puede_resolver": ["Verificación alarmas", "Llamadas clientes", "Creación incidencias", "Coordinación básica"],
            "tiempo_resolucion": "5 minutos",
            "escalar_si": "No puede resolver por teléfono o incidencia >30 min sin resolver"
        },
        "nivel_2_tecnico": {
            "puede_resolver": ["Configuración remota", "Soporte técnico avanzado", "Visitas en campo", "Instalaciones"],
            "tiempo_resolucion": "24 horas",
            "escalar_si": "Problema requiere inversión >500€ o cliente amenaza baja o problema recurrente (>3 veces mismo mes)"
        },
        "nivel_3_supervisor": {
            "interviene_en": ["Problemas recurrentes", "Clientes muy insatisfechos", "Decisiones de inversión", "Cambios de protocolo"],
            "tiempo_resolucion": "72 horas"
        }
    }'::jsonb,
    '[
        {"rol": "Supervisor Turno", "telefono_1": "Por definir", "disponible": "24/7"},
        {"rol": "Gerente Técnico", "telefono_1": "Por definir", "disponible": "L-V 9-18h"},
        {"rol": "Dirección", "telefono_1": "Por definir", "disponible": "Solo emergencias"}
    ]'::jsonb,
    '{
        "disponibilidad_receptora": "24/7",
        "disponibilidad_tecnicos": "L-V 9-18h + guardia urgencias 24/7",
        "disponibilidad_supervision": "24/7 via móvil"
    }'::jsonb,
    'PROTOCOLO OPERATIVO CRÍTICO - Define la cadena de escalado. Cumplir estrictamente los tiempos.',
    true
);

-- 6. PROTOCOLO TURNO NOCHE
INSERT INTO protocolos_cliente_cra (
    nombre_protocolo,
    descripcion,
    tipo_servicio,
    criticidad,
    checklist,
    acciones_incidencia,
    contactos_emergencia,
    horarios_operacion,
    notas,
    activo
) VALUES (
    'Protocolo Turno Noche',
    'Qué puede y no puede hacer el turno de noche.',
    'otro',
    'prioritario',
    '[
        {"orden": 1, "tarea": "Revisar log de turno anterior", "critico": true},
        {"orden": 2, "tarea": "Verificar incidencias pendientes", "critico": true},
        {"orden": 3, "tarea": "Confirmar contactos emergencia disponibles", "critico": true},
        {"orden": 4, "tarea": "Probar software visionado", "critico": true},
        {"orden": 5, "tarea": "Al terminar: Pasar log a turno siguiente", "critico": true}
    ]'::jsonb,
    '{
        "puede_hacer": [
            "Marcar incidencias en sistema",
            "Notificar a responsables según protocolo",
            "Reflejar eventos en log",
            "Coordinar con policía si es emergencia",
            "Tomar capturas de video"
        ],
        "no_puede_hacer_sin_aprobacion": [
            "Resolver incidencias técnicas",
            "Modificar configuración de sistemas",
            "Hacer compromisos con clientes",
            "Agendar visitas técnicas",
            "Cambiar protocolos de actuación"
        ],
        "emergencia_real": {
            "orden": ["1. Policía/Bomberos", "2. Cliente", "3. Supervisor"],
            "definicion": "Robo en curso, fuego, riesgo personal"
        },
        "problema_tecnico": {
            "accion": ["1. Marcar en sistema", "2. Dejar nota para turno día", "3. NO intentar resolver solo"]
        }
    }'::jsonb,
    '[
        {"rol": "Supervisor Noche", "telefono_1": "Por definir", "disponible": "22:00-08:00"},
        {"rol": "Técnico Guardia", "telefono_1": "Por definir", "disponible": "Solo urgencias críticas"},
        {"rol": "Emergencias", "telefono_1": "112", "disponible": "24/7"}
    ]'::jsonb,
    '{
        "turno_noche": "22:00-08:00",
        "turnos_especiales": "Festivos completos",
        "notas": "Si hay duda, llamar a supervisor. Mejor preguntar que equivocarse."
    }'::jsonb,
    'PROTOCOLO OPERATIVO CRÍTICO - El turno noche debe saber exactamente sus límites y cuándo escalar.',
    true
);

-- 7. PROTOCOLO VISITAS TÉCNICAS
INSERT INTO protocolos_cliente_cra (
    nombre_protocolo,
    descripcion,
    tipo_servicio,
    criticidad,
    checklist,
    acciones_incidencia,
    contactos_emergencia,
    horarios_operacion,
    notas,
    activo
) VALUES (
    'Protocolo Visitas Técnicas',
    'Proceso completo antes, durante y después de una visita técnica.',
    'otro',
    'normal',
    '[
        {"fase": "Pre-visita", "orden": 1, "tarea": "Confirmar cita con cliente (día anterior)", "critico": true},
        {"fase": "Pre-visita", "orden": 2, "tarea": "Revisar historial de incidencias", "critico": true},
        {"fase": "Pre-visita", "orden": 3, "tarea": "Preparar materiales necesarios", "critico": true},
        {"fase": "Pre-visita", "orden": 4, "tarea": "Cargar herramientas en furgoneta", "critico": false},
        {"fase": "Pre-visita", "orden": 5, "tarea": "Verificar ubicación GPS", "critico": false},
        {"fase": "Durante", "orden": 6, "tarea": "Llegada: Foto contador horario", "critico": true},
        {"fase": "Durante", "orden": 7, "tarea": "Revisar sistema completo", "critico": true},
        {"fase": "Durante", "orden": 8, "tarea": "Documentar problemas encontrados", "critico": true},
        {"fase": "Durante", "orden": 9, "tarea": "Explicar al cliente qué se hizo", "critico": true},
        {"fase": "Durante", "orden": 10, "tarea": "Firma del cliente en parte digital", "critico": true},
        {"fase": "Durante", "orden": 11, "tarea": "Salida: Foto contador horario", "critico": true},
        {"fase": "Post-visita", "orden": 12, "tarea": "Subir fotos a Odoo (mismo día)", "critico": true},
        {"fase": "Post-visita", "orden": 13, "tarea": "Completar parte de trabajo", "critico": true},
        {"fase": "Post-visita", "orden": 14, "tarea": "Si hay materiales: Adjuntar albarán", "critico": true},
        {"fase": "Post-visita", "orden": 15, "tarea": "Marcar incidencia como resuelta", "critico": true},
        {"fase": "Post-visita", "orden": 16, "tarea": "Enviar resumen al cliente por email", "critico": false}
    ]'::jsonb,
    '{
        "problema_no_resuelto": {
            "paso_1": "Documentar EXACTAMENTE qué se intentó",
            "paso_2": "Especificar qué se necesita: Material adicional / Ayuda otro técnico / Fabricante",
            "paso_3": "Agendar segunda visita si procede",
            "paso_4": "Comunicar a receptora y supervisor"
        },
        "metricas_objetivo": {
            "problemas_resueltos_primera_visita": ">80%",
            "tiempo_medio_visita": "<2 horas",
            "partes_completados_mismo_dia": "100%"
        }
    }'::jsonb,
    '[]'::jsonb,
    '{
        "horario_visitas": "L-V 9:00-18:00",
        "urgencias_fuera_horario": "Solo con aprobación supervisor y recargo",
        "tiempo_desplazamiento": "Incluir en parte de trabajo"
    }'::jsonb,
    'PROTOCOLO OPERATIVO - Seguir rigurosamente. La firma del cliente y fotos son OBLIGATORIAS.',
    true
);

-- Verificar que se insertaron correctamente
SELECT 
    nombre_protocolo,
    tipo_servicio,
    criticidad,
    activo,
    LENGTH(checklist::text) as tam_checklist,
    LENGTH(acciones_incidencia::text) as tam_acciones
FROM protocolos_cliente_cra
ORDER BY created_at DESC;

-- Debería mostrar 7 protocolos
SELECT COUNT(*) as total_protocolos FROM protocolos_cliente_cra;
