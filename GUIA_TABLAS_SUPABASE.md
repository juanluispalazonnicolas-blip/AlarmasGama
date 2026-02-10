# 📚 GUÍA DE FUNCIONES - TABLAS SUPABASE CRA

## 🎯 Propósito de este Documento

Esta guía explica **para qué sirve cada tabla** y **cómo usarlas en el día a día** de la CRA.

---

## 📊 TABLA 1: `incidencias_cra`

### ¿Para qué sirve?
Registrar **todas las incidencias** que recibe la CRA: saltos de alarma, problemas técnicos, pérdida de visionado, etc.

### ¿Cuándo se usa?
- **Cada vez que llega una alarma de Ajax**
- **Cuando un cliente llama reportando un problema**
- **Cuando la receptora detecta que un salón no tiene video**
- **Cuando hay un fallo técnico**

### Campos más importantes

| Campo | Qué es | Ejemplo |
|-------|--------|---------|
| `numero_incidencia` | ID único autogenerado | INC/2026/0001 |
| `tipo_incidencia` | Tipo de problema | `salto_alarma`, `sin_video` |
| `origen` | De dónde viene | `ajax`, `manual`, `cliente` |
| `prioridad` | Qué tan urgente es | `critica`, `alta`, `normal`, `baja` |
| `estado` | En qué estado está | `borrador`, `en_curso`, `resuelto` |
| `cliente_id` | Qué cliente | Link a tabla `clientes` |
| `ubicacion_id` | Qué ubicación específica | Link a tabla `ubicaciones` |
| `descripcion` | Qué pasó | "Salto de alarma en puerta principal" |
| `asignado_a` | Quién lo está resolviendo | "Juan Técnico" |
| `fecha_incidencia` | Cuándo ocurrió | 2026-02-10 14:30:00 |
| `fecha_resolucion` | Cuándo se resolvió | 2026-02-10 15:45:00 |
| `tiempo_resolucion_minutos` | Cuánto tardó | 75 minutos (calculado automáticamente) |

### Ejemplo de uso diario

**Scenario 1: Llega alarma de Ajax**
```sql
-- El sistema Ajax envía automáticamente:
INSERT INTO incidencias_cra (
    cliente_id, 
    ubicacion_id,
    tipo_incidencia, 
    origen, 
    prioridad, 
    titulo,
    descripcion,
    datos_adicionales
) VALUES (
    'uuid-del-cliente',
    'uuid-de-la-ubicacion',
    'salto_alarma',
    'ajax',
    'critica',
    'Alarma en Salón Golden Palace',
    'Detección de movimiento en zona de caja',
    '{"device_id": "sensor_001", "zone": "caja"}'::jsonb
);
```

**Scenario 2: Receptora crea incidencia manualmente**
```sql
INSERT INTO incidencias_cra (
    cliente_id,
    tipo_incidencia,
    origen,
    prioridad,
    descripcion
) VALUES (
    'uuid-del-cliente',
    'sin_video',
    'manual',
    'alta',
    'Cliente llama diciendo que no tiene video desde esta mañana'
);
```

**Scenario 3: Resolver incidencia**
```sql
UPDATE incidencias_cra
SET 
    estado = 'resuelto',
    fecha_resolucion = NOW(),
    notas_resolucion = 'Se reinició el DVR y se verificó conexión. Todo OK.',
    asignado_a = 'Lucía Receptora'
WHERE numero_incidencia = 'INC/2026/0001';
```

---

## 🔧 TABLA 2: `partes_trabajo_cra`

### ¿Para qué sirve?
Registrar **cada visita técnica** que hacen los técnicos, incluyendo qué hicieron, cuánto tiempo tardaron, qué materiales usaron y si el cliente lo firmó.

### ¿Cuándo se usa?
- **Antes de una visita técnica** (crear parte en "borrador")
- **Durante la visita** (el técnico completa datos desde app móvil)
- **Después de la visita** (marcar como completado y adjuntar firma)
- **Para facturación** (agrupar partes completados)

### Campos más importantes

| Campo | Qué es | Ejemplo |
|-------|--------|---------|
| `numero_parte` | ID único autogenerado | PARTE/2026/0001 |
| `cliente_id` | Para qué cliente | Link a `clientes` |
| `ubicacion_id` | En qué ubicación | Link a `ubicaciones` |
| `incidencia_id` | Si resuelve una incidencia | Link a `incidencias_cra` |
| `tecnicos` | Quiénes fueron | `[{"nombre": "Juan"}, {"nombre": "Pedro"}]` |
| `tipo_trabajo` | Qué tipo de trabajo | `mantenimiento`, `reparacion`, `instalacion` |
| `estado` | En qué fase está | `borrador`, `en_proceso`, `completado` |
| `fecha_trabajo` | Qué día fue | 2026-02-10 |
| `hora_inicio` | A qué hora empezó | 14:00 |
| `hora_fin` | A qué hora terminó | 16:30 |
| `horas_trabajadas` | Total de horas | 2.5 |
| `trabajo_realizado` | Qué se hizo | "Se cambió cámara 3, se configuró nuevo DVR..." |
| `materiales_usados` | Qué se gastó | `[{"material": "Cámara IP", "cantidad": 1, "precio": 150}]` |
| `firma_cliente` | Firma digital | (Base64 de la firma) |
| `facturado` | Si ya se facturó | `true` / `false` |

### Ejemplo de uso diario

**Scenario 1: Crear parte antes de visita**
```sql
INSERT INTO partes_trabajo_cra (
    cliente_id,
    ubicacion_id,
    incidencia_id,
    tecnicos,
    tipo_trabajo,
    fecha_trabajo
) VALUES (
    'uuid-cliente',
    'uuid-ubicacion',
    'uuid-incidencia',
    '[{"nombre": "Juan Técnico", "id": "tech_001"}]'::jsonb,
    'reparacion',
    '2026-02-11'
);
```

**Scenario 2: Técnico completa el parte después de visita**
```sql
UPDATE partes_trabajo_cra
SET 
    estado = 'completado',
    hora_inicio = '14:00',
    hora_fin = '16:30',
    horas_trabajadas = 2.5,
    trabajo_realizado = 'Se reemplazó cámara defectuosa, se verificó grabación',
    materiales_usados = '[
        {"material": "Cámara IP Hikvision", "cantidad": 1, "precio": 150},
        {"material": "Cable UTP Cat6", "cantidad": 20, "precio": 0.5}
    ]'::jsonb,
    coste_materiales = 160,
    coste_mano_obra = 75,
    firma_cliente = 'data:image/png;base64,...',
    fecha_firma = NOW()
WHERE numero_parte = 'PARTE/2026/0001';
```

**Scenario 3: Marcar como facturado**
```sql
UPDATE partes_trabajo_cra
SET 
    facturado = TRUE,
    fecha_facturacion = CURRENT_DATE
WHERE numero_parte IN ('PARTE/2026/0001', 'PARTE/2026/0002');
```

---

## 📋 TABLA 3: `protocolos_cliente_cra`

### ¿Para qué sirve?
Guardar **las instrucciones específicas** de cada cliente: a quién llamar, qué hacer ante cada tipo de alarma, horarios, contactos, garantías, etc.

### ¿Cuándo se usa?
- **Cuando hay una incidencia** (consultar qué hacer)
- **Onboarding de nuevo cliente** (crear su protocolo)
- **Cuando cliente llama** (verificar contactos y horarios)
- **Para saber si está en garantía**

### Campos más importantes

| Campo | Qué es | Ejemplo |
|-------|--------|---------|
| `nombre_protocolo` | Nombre descriptivo | "Protocolo Salón Golden Palace" |
| `cliente_id` | De qué cliente | Link a `clientes` |
| `tipo_servicio` | Tipo de instalación | `salon_juego`, `campo_solar` |
| `criticidad` | Qué tan importante es | `critico`, `prioritario`, `normal` |
| `checklist` | Lista de verificación | `[{"item": "Verificar cámaras caja", "obligatorio": true}]` |
| `acciones_incidencia` | Qué hacer en cada caso | Ver ejemplo abajo |
| `contactos_emergencia` | A quién llamar | `[{"nombre": "Juan", "tel": "600..."}, ...]` |
| `horarios_operacion` | Cuándo está abierto | `{"lunes": {"inicio": "14:00", "fin": "04:00"}}` |
| `dentro_garantia` | Si está cubierto | `true` / `false` (calculado auto) |
| `dias_restantes_garantia` | Días que quedan | 45 días (calculado auto) |

### Ejemplo: Protocolo completo de un salón

```sql
INSERT INTO protocolos_cliente_cra (
    cliente_id,
    ubicacion_id,
    nombre_protocolo,
    tipo_servicio,
    criticidad,
    checklist,
    acciones_incidencia,
    contactos_emergencia,
    horarios_operacion,
    fecha_inicio_garantia,
    fecha_fin_garantia
) VALUES (
    'uuid-cliente',
    'uuid-ubicacion',
    'Protocolo Salón Golden Palace - Madrid',
    'salon_juego',
    'critico',
    
    -- Checklist de verificación
    '[
        {"item": "Verificar cámara de caja fuerte", "obligatorio": true},
        {"item": "Verificar cámaras TPVs (mínimo 2)", "obligatorio": true},
        {"item": "Comprobar grabación últimas 24h", "obligatorio": true},
        {"item": "Verificar iluminación nocturna", "obligatorio": false}
    ]'::jsonb,
    
    -- Qué hacer ante cada tipo de incidencia
    '{
        "salto_alarma": {
            "accion": "Verificar video inmediatamente, llamar a responsable",
            "contactar": "responsable_primario",
            "si_no_contesta": "llamar_policia"
        },
        "sin_video": {
            "accion": "Intentar conexión remota, si falla llamar",
            "contactar": "informatico",
            "urgencia": "alta"
        }
    }'::jsonb,
    
    -- Contactos de emergencia
    '[
        {"nombre": "Juan García", "rol": "Responsable", "tel": "600123456", "prioridad": 1},
        {"nombre": "María López", "rol": "Encargada", "tel": "600789012", "prioridad": 2},
        {"nombre": "Pedro IT", "rol": "Informático", "tel": "600345678", "prioridad": 3}
    ]'::jsonb,
    
    -- Horarios de operación
    '{
        "lunes": {"inicio": "14:00", "fin": "04:00"},
        "martes": {"inicio": "14:00", "fin": "04:00"},
        "miercoles": {"inicio": "14:00", "fin": "04:00"},
        "jueves": {"inicio": "14:00", "fin": "04:00"},
        "viernes": {"inicio": "14:00", "fin": "05:00"},
        "sabado": {"inicio": "14:00", "fin": "05:00"},
        "domingo": {"inicio": "14:00", "fin": "04:00"}
    }'::jsonb,
    
    '2025-06-01',  -- Inicio garantía
    '2026-06-01'   -- Fin garantía (dentro_garantia se calcula automáticamente)
);
```

### Cómo consultarlo en una incidencia

```sql
-- Cuando llega incidencia de tipo "salto_alarma" para un cliente
SELECT 
    p.acciones_incidencia->'salto_alarma'->>'accion' as que_hacer,
    p.contactos_emergencia,
    p.dentro_garantia
FROM protocolos_cliente_cra p
WHERE p.cliente_id = 'uuid-del-cliente-con-alarma';
```

---

## 💻 TABLA 4: `sistemas_visionado`

### ¿Para qué sirve?
Control completo de los **58 salones**: su estado actual, configuración de red, accesos, problemas detectados, etc. **Es el Excel de auditoría pero en base de datos.**

### ¿Cuándo se usa?
- **Auditoría inicial** (rellenar los 58 salones)
- **Monitorización diaria** (actualizar estado)
- **Troubleshooting** (consultar configuración)
- **Reportes** (cuántos visibles, cuántos no)

### Campos más importantes

| Campo | Qué es | Ejemplo |
|-------|--------|---------|
| `numero_salon` | Número del salón (1-58) | 17 |
| `abonado` | Código de abonado | ABO-001 |
| `estado_visionado` | Si se ve o no | `visible`, `no_visible`, `intermitente` |
| `ip_dominio` | IP o DDNS | 192.168.1.100 o salon01.ddns.net |
| `puerto_http` | Puerto web | 8000 |
| `puerto_rtsp` | Puerto streaming | 554 |
| `puerto_servidor` | Puerto servidor | 37777 |
| `p2p_id` | ID P2P si aplica | ABCD-EFGH-1234 |
| `usuario_dvr` | Usuario de acceso | admin |
| `password_dvr` | Contraseña | ●●●●●●●● (¡encriptar!) |
| `modelo_dvr` | Marca y modelo | Hikvision DS-7608 |
| `num_camaras_total` | Total instaladas | 8 |
| `num_camaras_funcionando` | Operativas | 6 |
| `software_visionado` | Con qué se ve | NVMS, EZView, etc. |
| `ultima_conexion` | Última vez conectado | 2026-02-10 15:30:00 |
| `dias_sin_conexion` | Días offline | 3 (calculado auto) |
| `problemas_detectados` | Qué falla | "Puerto 8000 cerrado, cámara 3 sin imagen" |
| `acciones_requeridas` | Qué hacer | "Abrir puerto, reemplazar cámara 3" |
| `prioridad` | Urgencia | `critica`, `alta`, `media`, `baja` |
| `auditado` | Si se revisó | `true` / `false` |

### Ejemplo: Importar desde Excel de auditoría

```sql
-- Salón 1 - No visible (de tu Excel)
INSERT INTO sistemas_visionado (
    numero_salon,
    cliente_id,
    ubicacion_id,
    abonado,
    estado_visionado,
    ip_dominio,
    puerto_http,
    puerto_rtsp,
    puerto_servidor,
    usuario_dvr,
    modelo_dvr,
    num_camaras_total,
    num_camaras_funcionando,
    software_visionado,
    proveedor_internet,
    problemas_detectados,
    acciones_requeridas,
    prioridad,
    auditado
) VALUES (
    1,
    'uuid-cliente-salon-1',
    'uuid-ubicacion-salon-1',
    'ABO-001',
    'no_visible',
    '192.168.1.100',
    8000,
    554,
    37777,
    'admin',
    'Hikvision DS-7608NI-K2',
    8,
    0,
    'NVMS',
    'Movistar',
    'Puerto 8000 bloqueado por ISP, no se puede conectar',
    'Cambiar puerto a 8888 o configurar VPN',
    'alta',
    TRUE
);

-- Salón 17 - Visible (uno de los que funciona)
INSERT INTO sistemas_visionado (
    numero_salon,
    estado_visionado,
    ip_dominio,
    puerto_http,
    usuario_dvr,
    modelo_dvr,
    num_camaras_total,
    num_camaras_funcionando,
    software_visionado,
    ultima_conexion,
    prioridad,
    auditado
) VALUES (
    17,
    'visible',
    'salon17.ddns.net',
    8000,
    'admin',
    'Dahua NVR5216-16P',
    16,
    16,
    'Smart PSS',
    NOW(),
    'baja',
    TRUE
);
```

### Queries útiles

**Ver resumen de estado:**
```sql
SELECT 
    estado_visionado,
    COUNT(*) as total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sistemas_visionado), 2) as porcentaje
FROM sistemas_visionado
GROUP BY estado_visionado;
```

**Salones sin auditar:**
```sql
SELECT numero_salon, cliente_id
FROM sistemas_visionado
WHERE auditado = FALSE
ORDER BY numero_salon;
```

**Salones con problemas críticos:**
```sql
SELECT 
    numero_salon,
    estado_visionado,
    problemas_detectados,
    prioridad
FROM sistemas_visionado
WHERE prioridad IN ('critica', 'alta') 
  AND estado_visionado = 'no_visible'
ORDER BY 
    CASE prioridad 
        WHEN 'critica' THEN 1 
        WHEN 'alta' THEN 2 
    END,
    numero_salon;
```

---

## 🔄 FLUJOS DE TRABAJO TÍPICOS

### Flujo 1: Llega alarma → Resolver → Cerrar

1. **Alarma Ajax** → Crea `incidencias_cra` (automático)
2. **Receptora verifica** video → Actualiza incidencia con notas
3. **Si necesita técnico** → Crea `partes_trabajo_cra`
4. **Técnico va y resuelve** → Actualiza parte con firma y fotos
5. **Cierra incidencia** → Marca `estado = 'resuelto'`
6. **Facturación** → Marca parte como `facturado = true`

### Flujo 2: Auditar salón → Resolver problema

1. **Auditar salón** → Rellena `sistemas_visionado`
2. **Detecta problema** → Crea `incidencias_cra`
3. **Asigna prioridad** → Marca urgencia en sistema
4. **Técnico resuelve** → Crea `partes_trabajo_cra`
5. **Actualiza sistema** → Cambia `estado_visionado = 'visible'`

### Flujo 3: Onboarding nuevo cliente

1. **Crea cliente** en tabla `clientes`
2. **Crea ubicaciones** en tabla `ubicaciones`
3. **Crea proyecto** de instalación en `proyectos`
4. **Crea protocolo** en `protocolos_cliente_cra`
5. **Añade sistema** en `sistemas_visionado`
6. **Hace instalación** → Crea `partes_trabajo_cra`
7. **Cierra proyecto** → Marca completado

---

## 📊 DASHBOARDS Y REPORTES

### KPIs principales que puedes sacar

```sql
-- KPI 1: Porcentaje de salones visibles
SELECT 
    COUNT(CASE WHEN estado_visionado = 'visible' THEN 1 END) * 100.0 / COUNT(*) as pct_visibles
FROM sistemas_visionado;

-- KPI 2: Tiempo medio de resolución de incidencias
SELECT 
    AVG(tiempo_resolucion_minutos) as minutos_promedio,
    AVG(tiempo_resolucion_minutos) / 60 as horas_promedio
FROM incidencias_cra
WHERE estado = 'resuelto';

-- KPI 3: Incidencias por prioridad
SELECT prioridad, COUNT(*) as total
FROM incidencias_cra
WHERE estado NOT IN ('resuelto', 'cerrado')
GROUP BY prioridad;

-- KPI 4: Facturación pendiente
SELECT 
    SUM(coste_total) as total_pendiente_facturar,
    COUNT(*) as num_partes
FROM partes_trabajo_cra
WHERE facturado = FALSE AND estado = 'completado';
```

---

## ✅ PRÓXIMOS PASOS

1. **Ejecuta el script SQL** (`supabase_cra_schema.sql`)
2. **Importa datos del Excel** de 58 salones a `sistemas_visionado`
3. **Crea protocolos** para clientes principales
4. **Empieza a registrar incidencias** en la nueva tabla
5. **Capacita al equipo** en el nuevo sistema

---

**¿Dudas?** Cada tabla tiene comentarios en el SQL que explican más detalles técnicos.
