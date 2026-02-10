-- ===============================================
-- INSERTAR PLANTILLA MAESTRA DE PROTOCOLOS
-- ===============================================
-- Esta es la plantilla base que se duplicará y personalizará para cada cliente

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
    '🔹 PLANTILLA MAESTRA - NO USAR DIRECTAMENTE',
    'Plantilla base universal con roles definidos: Vigilantes, Receptora y Acudas. DUPLICAR y personalizar para cada cliente.',
    'otro',
    'critico',
    
    -- CHECKLIST POR ROL
    '[
        {
            "rol": "VIGILANTE",
            "fase": "Salto Alarma",
            "orden": 1,
            "tarea": "Recibir notificación de alarma (0 seg)",
            "tiempo_objetivo_seg": 0,
            "critico": true
        },
        {
            "rol": "VIGILANTE",
            "fase": "Salto Alarma",
            "orden": 2,
            "tarea": "Localizar cámara(s) afectada(s) (10 seg)",
            "tiempo_objetivo_seg": 10,
            "critico": true
        },
        {
            "rol": "VIGILANTE",
            "fase": "Salto Alarma",
            "orden": 3,
            "tarea": "Revisar grabación 2 min antes del salto (30 seg)",
            "tiempo_objetivo_seg": 30,
            "critico": true
        },
        {
            "rol": "VIGILANTE",
            "fase": "Salto Alarma",
            "orden": 4,
            "tarea": "Analizar imágenes en tiempo real (1 min)",
            "tiempo_objetivo_seg": 60,
            "critico": true
        },
        {
            "rol": "VIGILANTE",
            "fase": "Salto Alarma",
            "orden": 5,
            "tarea": "Decidir: Falsa alarma / Sin video / Alarma real (2 min)",
            "tiempo_objetivo_seg": 120,
            "critico": true,
            "decision_point": true
        },
        {
            "rol": "RECEPTORA",
            "fase": "Alarma Verificada",
            "orden": 6,
            "tarea": "Recibir alerta de Vigilante (2 min)",
            "tiempo_objetivo_seg": 120,
            "critico": true
        },
        {
            "rol": "RECEPTORA",
            "fase": "Alarma Verificada",
            "orden": 7,
            "tarea": "Llamar CONTACTO 1 del cliente (2 min 15 seg)",
            "tiempo_objetivo_seg": 135,
            "critico": true,
            "script_llamada": true
        },
        {
            "rol": "RECEPTORA",
            "fase": "Alarma Verificada",
            "orden": 8,
            "tarea": "Si no contesta: Llamar CONTACTO 2 y 3 (3 intentos)",
            "critico": true
        },
        {
            "rol": "RECEPTORA",
            "fase": "Alarma Verificada",
            "orden": 9,
            "tarea": "Crear incidencia en Odoo + enviar capturas",
            "critico": true
        },
        {
            "rol": "ACUDAS",
            "fase": "Verificación Presencial",
            "orden": 10,
            "tarea": "Recibir notificación de Receptora (5 min)",
            "tiempo_objetivo_min": 5,
            "critico": true
        },
        {
            "rol": "ACUDAS",
            "fase": "Verificación Presencial",
            "orden": 11,
            "tarea": "Revisar datos del cliente en app",
            "tiempo_objetivo_min": 5,
            "critico": true
        },
        {
            "rol": "ACUDAS",
            "fase": "Verificación Presencial",
            "orden": 12,
            "tarea": "Desplazamiento al lugar (10-20 min urbano)",
            "tiempo_objetivo_min": 20,
            "critico": true
        },
        {
            "rol": "ACUDAS",
            "fase": "Verificación Presencial",
            "orden": 13,
            "tarea": "Inspección visual perímetro (NO ENTRAR si peligro)",
            "critico": true,
            "seguridad_personal": true
        },
        {
            "rol": "ACUDAS",
            "fase": "Verificación Presencial",
            "orden": 14,
            "tarea": "Documentar con fotos/video",
            "critico": true
        },
        {
            "rol": "ACUDAS",
            "fase": "Verificación Presencial",
            "orden": 15,
            "tarea": "Completar parte de trabajo en Odoo",
            "critico": true
        }
    ]'::jsonb,
    
    -- ACCIONES POR EVENTO Y ROL
    '{
        "evento_salto_alarma": {
            "tiempo_objetivo_total_min": 5,
            "roles": {
                "vigilante": {
                    "tiempo_objetivo_min": 2,
                    "decisiones": {
                        "falsa_alarma": {
                            "accion": "Marcar como falsa alarma + anotar causa",
                            "escalar": false,
                            "fin_procedimiento": true
                        },
                        "sin_video": {
                            "accion": "Escalar INMEDIATAMENTE a Receptora",
                            "escalar": true,
                            "siguiente_rol": "receptora",
                            "tipo_escalado": "sin_video"
                        },
                        "alarma_real": {
                            "accion": "Escalar INMEDIATAMENTE + capturar pantallazos + mantener vigilancia",
                            "escalar": true,
                            "siguiente_rol": "receptora",
                            "tipo_escalado": "alarma_verificada",
                            "datos_requeridos": ["Nº personas", "Características", "Vehículo", "Punto entrada"]
                        }
                    }
                },
                "receptora": {
                    "tiempo_objetivo_min": 3,
                    "script_llamada_verificada": "Buenos días/tardes, [NOMBRE]. Soy [TU NOMBRE] de CRA Ibersegur. A las [HORA EXACTA] se activó alarma en [UBICACIÓN]. Hemos verificado las imágenes: [DESCRIPCIÓN]. ¿Está al corriente?",
                    "script_llamada_sin_video": "Buenos días/tardes, [NOMBRE]. Soy [TU NOMBRE] de CRA Ibersegur. A las [HORA EXACTA] se activó alarma en [UBICACIÓN]. NO PODEMOS VERIFICAR por fallo en el sistema de video. ¿Puede confirmar si está todo correcto?",
                    "intentos_contacto": 3,
                    "tiempo_entre_intentos_seg": 30,
                    "escalado_si_no_contesta": {
                        "robo_en_curso": "Llamar 112/Policía Local + Activar Acudas",
                        "intrusion_sin_robo": "SMS + Email + WhatsApp + Activar Acudas"
                    },
                    "tareas_obligatorias": [
                        "Crear incidencia en Odoo",
                        "Enviar WhatsApp con capturas",
                        "Documentar respuesta cliente"
                    ]
                },
                "acudas": {
                    "tiempo_objetivo_llegada_urbano_min": 20,
                    "tiempo_objetivo_llegada_rural_min": 40,
                    "seguridad_personal": {
                        "no_entrar_si": ["Peligro evidente", "Robo activo", "Personas armadas"],
                        "accion_peligro": "NO ENTRAR + Mantenerse a distancia + Llamar 112 + Informar Receptora"
                    },
                    "documentacion_obligatoria": [
                        "Foto cuentakilómetros llegada",
                        "Fotos perímetro",
                        "Foto cuentakilómetros salida",
                        "Parte trabajo Odoo mismo día"
                    ],
                    "datos_revisar_antes": [
                        "Dirección exacta",
                        "Teléfonos contacto",
                        "Código acceso/alarma",
                        "Plano ubicación",
                        "Puntos de acceso"
                    ]
                }
            }
        },
        "evento_perdida_video": {
            "tiempo_objetivo_total_min": 15,
            "roles": {
                "vigilante": {
                    "tiempo_objetivo_min": 5,
                    "diagnostico": {
                        "verificar": ["¿1 cámara o todas?", "¿Solo este cliente o varios?", "¿Conectividad red?"],
                        "si_problema_general": "Escalar soporte técnico interno + NO llamar clientes",
                        "si_problema_especifico": "Esperar 3-5 min reconexión + Si persiste escalar Receptora"
                    }
                },
                "receptora": {
                    "tiempo_objetivo_min": 10,
                    "contactar": "CONTACTO TÉCNICO (no responsable principal)",
                    "crear_incidencia": {
                        "si_causa_conocida": "Prioridad MEDIA + Seguimiento 2h",
                        "si_causa_desconocida": "Prioridad ALTA + Visita técnica 24h"
                    }
                },
                "acudas": {
                    "solo_activar_si": [
                        "Cliente prioritario/crítico",
                        "Más 24h sin video",
                        "Cliente solicita específicamente",
                        "Sospecha sabotaje/robo"
                    ]
                }
            }
        },
        "evento_visita_tecnica": {
            "roles": {
                "vigilante": {
                    "aplica": false
                },
                "receptora": {
                    "dia_anterior": [
                        "Confirmar cita WhatsApp/SMS",
                        "Asignar técnico disponible",
                        "Enviar datos al técnico"
                    ],
                    "dia_visita": [
                        "Recordatorio mañana al cliente",
                        "Disponible para consultas técnico",
                        "Verificar parte completado post-visita"
                    ]
                },
                "acudas_tecnico": {
                    "pre_visita": [
                        "Revisar Odoo cliente + historial",
                        "Verificar materiales necesarios",
                        "Cargar herramientas",
                        "Confirmar GPS"
                    ],
                    "durante": [
                        "Foto cuentakilómetros llegada",
                        "Diagnóstico completo",
                        "Fotos ANTES/DESPUÉS",
                        "Explicar al cliente",
                        "Firma digital cliente",
                        "Foto cuentakilómetros salida"
                    ],
                    "post_visita_mismo_dia": [
                        "Subir fotos a Odoo",
                        "Completar parte trabajo",
                        "Adjuntar albarán si hay materiales",
                        "Marcar incidencia resuelta",
                        "Email automático a cliente"
                    ],
                    "si_no_resuelto": {
                        "documentar": "Qué se intentó + Qué se necesita",
                        "agendar": "Segunda visita",
                        "informar": "Receptora + Supervisor"
                    },
                    "metricas": {
                        "resolucion_primera_visita": ">80%",
                        "tiempo_medio_visita": "<2 horas",
                        "partes_completados_mismo_dia": "100%"
                    }
                }
            }
        }
    }'::jsonb,
    
    -- CONTACTOS POR ROL (Plantilla)
    '[
        {
            "para_rol": "VIGILANTE",
            "contactos": [
                {"rol": "Supervisor Turno", "telefono": "XXX XXX XXX", "disponible": "24/7"},
                {"rol": "Soporte Técnico Interno", "telefono": "XXX XXX XXX", "disponible": "24/7"},
                {"rol": "Receptora Backup", "telefono": "XXX XXX XXX", "disponible": "24/7"}
            ]
        },
        {
            "para_rol": "RECEPTORA",
            "contactos": [
                {"rol": "Cliente Contacto 1", "telefono": "PERSONALIZAR POR CLIENTE", "orden_llamada": 1},
                {"rol": "Cliente Contacto 2", "telefono": "PERSONALIZAR POR CLIENTE", "orden_llamada": 2},
                {"rol": "Cliente Técnico", "telefono": "PERSONALIZAR POR CLIENTE", "orden_llamada": 3},
                {"rol": "Coordinador Acudas", "telefono": "XXX XXX XXX", "disponible": "24/7"},
                {"rol": "Policía Local", "telefono": "092 / Específico cliente", "orden_llamada": 99},
                {"rol": "Emergencias", "telefono": "112", "orden_llamada": 100}
            ]
        },
        {
            "para_rol": "ACUDAS",
            "contactos": [
                {"rol": "Receptora Turno", "telefono": "XXX XXX XXX", "disponible": "24/7"},
                {"rol": "Coordinador Técnico", "telefono": "XXX XXX XXX", "horario": "L-V 9-18h"},
                {"rol": "Proveedor Materiales", "telefono": "XXX XXX XXX", "horario": "L-V 8-20h"},
                {"rol": "Cliente Contacto", "telefono": "PERSONALIZAR POR CLIENTE"}
            ]
        }
    ]'::jsonb,
    
    -- HORARIOS (Plantilla genérica)
    '{
        "personalizar_por_cliente": true,
        "ejemplo_lunes_viernes": {
            "apertura": "09:00",
            "cierre": "18:00",
            "vigilancia_fuera_horario": true
        },
        "ejemplo_sabado": {
            "apertura": "10:00",
            "cierre": "14:00",
            "vigilancia_fuera_horario": true
        },
        "ejemplo_domingo": {
            "cerrado": true,
            "vigilancia_fuera_horario": true
        },
        "tiempos_objetivo_acudas": {
            "urbano_min": 20,
            "rural_min": 40
        },
        "turnos_vigilancia": "24/7 rotativos",
        "turnos_receptora": "24/7 rotativos"
    }'::jsonb,
    
    'PLANTILLA MAESTRA - DUPLICAR para cada cliente. Personalizar: Contactos, Horarios, Particularidades. Formación obligatoria: Vigilantes (identificar alarmas), Receptora (scripts + Odoo), Acudas (seguridad personal + documentación). Métricas: Vigilante <2min, Receptora <3min, Acudas urbano <20min. Revisión cada 90 días.',
    
    false  -- INACTIVA - Es plantilla, no se usa directamente
);

-- Verificar que se creó
SELECT 
    nombre_protocolo,
    tipo_servicio,
    criticidad,
    activo,
    'Plantilla creada - Duplicar para usar' as instrucciones
FROM protocolos_cliente_cra
WHERE nombre_protocolo LIKE '%PLANTILLA MAESTRA%';
