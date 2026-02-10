# 📖 CÓMO USAR LA PLANTILLA MAESTRA

## 🎯 Objetivo

La plantilla maestra NO se usa directamente. Es una **referencia base** que se **duplica y personaliza** para cada cliente.

---

## 🔄 PROCESO: De Plantilla a Protocolo Específico

### PASO 1: Duplicar la Plantilla

Ejecuta en Supabase SQL Editor:

```sql
-- Crear protocolo específico para un cliente partiendo de la plantilla
INSERT INTO protocolos_cliente_cra (
    nombre_protocolo,
    cliente_id,  -- ⚠️ IMPORTANTE: Asignar cliente
    ubicacion_id,  -- ⚠️ IMPORTANTE: Asignar ubicación
    descripcion,
    tipo_servicio,
    criticidad,
    checklist,
    acciones_incidencia,
    contactos_emergencia,  -- Se editará después
    horarios_operacion,  -- Se editará después
    notas,
    activo
)
SELECT 
    'Protocolo [NOMBRE CLIENTE] - [UBICACIÓN]',  -- ✏️ PERSONALIZAR
    'UUID-DEL-CLIENTE'::uuid,  -- ✏️ PONER ID REAL
    'UUID-DE-UBICACION'::uuid,  -- ✏️ PONER ID REAL
    'Protocolo específico creado desde plantilla maestra',
    'salon_juego',  -- ✏️ CAMBIAR según tipo: salon_juego / campo_solar / empresa / industrial
    'prioritario',  -- ✏️ CAMBIAR: normal / prioritario / critico
    checklist,  -- Se copia tal cual
    acciones_incidencia,  -- Se copia tal cual
    '[]'::jsonb,  -- Contactos vacíos, los editaremos
    '{}'::jsonb,  -- Horarios vacíos, los editaremos
   'Basado en plantilla maestra. Personalizar contactos y horarios.',
    true  -- ACTIVO
FROM protocolos_cliente_cra
WHERE nombre_protocolo LIKE '%PLANTILLA MAESTRA%';
```

---

### PASO 2: Actualizar Contactos Específicos

```sql
-- Actualizar contactos con datos REALES del cliente
UPDATE protocolos_cliente_cra
SET contactos_emergencia = '[
    {
        "para_rol": "RECEPTORA",
        "contactos": [
            {
                "rol": "Responsable Principal",
                "nombre": "Juan Pérez",
                "telefono": "666 111 222",
                "telefono_backup": "666 333 444",
                "email": "juan@cliente.com",
                "horario_disponible": "24/7",
                "orden_llamada": 1,
                "idioma": "ES",
                "notas": "Preferible WhatsApp fuera horario"
            },
            {
                "rol": "Encargado",
                "nombre": "María García",
                "telefono": "666 555 666",
                "horario_disponible": "L-V 9-18h",
                "orden_llamada": 2,
                "notas": "Solo temas urgentes"
            },
            {
                "rol": "Técnico/Informático",
                "nombre": "Pedro Martínez",
                "telefono": "666 777 888",
                "horario_disponible": "L-V 10-14h",
                "orden_llamada": 3,
                "notas": "Solo para problemas técnicos DVR/Cámaras"
            },
            {
                "rol": "Policía Local",
                "telefono": "092",
                "telefono_alternativo": "956 XXX XXX",
                "orden_llamada": 99,
                "notas": "Mencionar código cliente ABO-123"
            }
        ]
    },
    {
        "para_rol": "ACUDAS",
        "contactos": [
            {
                "rol": "Contacto en sitio",
                "nombre": "Juan Pérez",
                "telefono": "666 111 222",
                "codigo_acceso": "1234#",
                "notas": "Tiene llaves del local"
            }
        ]
    }
]'::jsonb
WHERE nombre_protocolo = 'Protocolo [NOMBRE CLIENTE] - [UBICACIÓN]';
```

---

### PASO 3: Actualizar Horarios Reales

```sql
-- Actualizar horarios con los reales del cliente
UPDATE protocolos_cliente_cra
SET horarios_operacion = '{
    "lunes_viernes": {
        "apertura": "10:00",
        "cierre": "02:00",
        "vigilancia_fuera_horario": true,
        "notas": "Horario ampliado viernes hasta 03:00"
    },
    "sabado": {
        "apertura": "10:00",
        "cierre": "03:00",
        "vigilancia_fuera_horario": true
    },
    "domingo": {
        "apertura": "10:00",
        "cierre": "02:00",
        "vigilancia_fuera_horario": true
    },
    "festivos": {
        "como_domingo": true,
        "excepciones": "Cerrado 25 Dic, 1 Ene"
    },
    "limpieza_mantenimiento": {
        "dias": "Martes, Jueves",
        "horario": "06:00-08:00",
        "contacto": "Empresa Limpiezas S.L.",
        "notas": "Ignorar movimiento durante este horario"
    },
    "vacaciones_anuales": {
        "agosto": "Cerrado del 1 al 15",
        "navidad": "Abierto excepto 25 Dic y 1 Ene"
    },
    "particularidades": {
        "tienen_animales": false,
        "hacen_obras": false,
        "camaras_especiales_vigilar": ["Caja principal", "Entrada trasera", "Sala máquinas"]
    }
}'::jsonb
WHERE nombre_protocolo = 'Protocolo [NOMBRE CLIENTE] - [UBICACIÓN]';
```

---

### PASO 4: Agregar Particularidades

```sql
UPDATE protocolos_cliente_cra
SET notas = 'PARTICULARIDADES CLIENTE:
• Tienen perro guardián - Ignorar movimientos planta baja 22:00-08:00
• Cámara caja principal es CRÍTICA - Cualquier pérdida video llamar inmediatamente
• Cliente prefiere WhatsApp a llamadas (salvo emergencias)
• Código acceso acudas: 1234# + *
• Tienen sistema anti-inhibición - Si salta, es REAL
• Personal limpieza Ma-Ju 06:00-08:00
• Agosto cerrado del 1 al 15 (VIGILANCIA MÁXIMA)
• Cliente VIP - Tiempo respuesta <15 min urbano
• Servicio ACUDAS ACTIVO - Activar siempre que no contesten
• Plano ubicación: Ver adjunto en carpeta cliente
• Última incidencia recurrente: Falsa alarma detector humo cocina (ya solucionado)'
WHERE nombre_protocolo = 'Protocolo [NOMBRE CLIENTE] - [UBICACIÓN]';
```

---

## 📋 CHECKLIST PERSONALIZACIÓN

Cuando crees nuevo protocolo desde plantilla, verifica:

```
□ [OBLIGATORIO] Nombre descriptivo con cliente y ubicación
□ [OBLIGATORIO] cliente_id asignado correctamente
□ [OBLIGATORIO] ubicacion_id asignado correctamente
□ [OBLIGATORIO] tipo_servicio correcto
□ [OBLIGATORIO] criticidad apropiada

□ [CONTACTOS] Mínimo 2 contactos del cliente
□ [CONTACTOS] Teléfonos verificados (llamar para confirmar)
□ [CONTACTOS] Orden de llamada definido
□ [CONTACTOS] Horarios de disponibilidad claros

□ [HORARIOS] Horario apertura/cierre por día
□ [HORARIOS] Vigilancia fuera horario: SÍ/NO
□ [HORARIOS] Personal limpieza/mantenimiento si aplica
□ [HORARIOS] Vacaciones/cierres anuales

□ [PARTICULARIDADES] Animales
□ [PARTICULARIDADES] Códigos acceso
□ [PARTICULARIDADES] Cámaras críticas
□ [PARTICULARIDADES] Preferencias comunicación
□ [PARTICULARIDADES] Servicio acudas: SÍ/NO
□ [PARTICULARIDADES] Plano/ubicación GPS

□ [FINAL] Protocolo marcado como ACTIVO
□ [FINAL] Equipo capacitado en este protocolo específico
□ [FINAL] Cliente informado del protocolo
```

---

## 🎓 FORMACIÓN AL EQUIPO

Cuando crees un protocolo nuevo:

1. **Informar a Vigilantes:**
   - Cámaras críticas a vigilar
   - Particularidades (animales, horarios especiales)
   - Cuándo escalar vs ignorar

2. **Informar a Receptora:**
   - Contactos actualizados
   - Preferencias comunicación cliente
   - Nivel de servicio (¿llamar siempre o solo verificado?)

3. **Informar a Acudas:**
   - Códigos de acceso
   - Plano/ubicación GPS
   - Particularidades acceso
   - Tiempo respuesta comprometido

---

## 📊 EJEMPLO COMPLETO

Ver ejemplo en: `sql/13_ejemplo_protocolo_salon_juego.sql`

---

## 🔄 MANTENIMIENTO

### Revisión Mensual
```sql
-- Ver protocolos que necesitan revisión (>30 días sin actualizar)
SELECT 
    nombre_protocolo,
    updated_at,
    CURRENT_DATE - updated_at::date as dias_sin_revision
FROM protocolos_cliente_cra
WHERE activo = true
  AND updated_at < NOW() - INTERVAL '30 days'
ORDER BY updated_at ASC;
```

### Actualizar Protocolo
```sql
-- Al actualizar, incrementar versión en notas
UPDATE protocolos_cliente_cra
SET 
    contactos_emergencia = '[...]'::jsonb,  -- Nuevos contactos
    updated_at = NOW(),
    notas = CONCAT(notas, E'\n\nACTUALIZACIÓN ', NOW()::date, ': [Describir cambios]')
WHERE id = 'uuid-del-protocolo';
```

### Desactivar Protocolo (Cliente da de baja)
```sql
UPDATE protocolos_cliente_cra
SET 
    activo = false,
    notas = CONCAT(notas, E'\n\nDESACTIVADO ', NOW()::date, ': Cliente dado de baja')
WHERE id = 'uuid-del-protocolo';
```

---

**RECUERDA:** La plantilla maestra es solo una guía. Cada cliente debe tener su protocolo personalizado y actualizado.
