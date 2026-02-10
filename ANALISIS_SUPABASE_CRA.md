# 📊 ANÁLISIS DE BASE DE DATOS SUPABASE - CRA IBERSEGUR

## 🔍 Resumen Ejecutivo

**Buenas noticias:** Ya tienes infraestructura sólida en Supabase que podemos aprovechar.

**Tablas existentes relevantes para CRA:** 6 tablas core + 3 de soporte

---

## 📋 TABLAS CORE PARA CRA

### 1. `clientes` ✅
```sql
Campos clave:
- id (uuid)
- tipo_cliente (text) ← CRÍTICO
- nombre, dirección, localidad, provincia
- email, teléfono
- created_at
```

**Análisis:**
- ✅ Estructura sólida
- ✅ Soporta múltiples tipos de cliente
- ⚠️ Falta: NIF/CIF, contacto secundario, nivel de criticidad

**Protocolo por tipo_cliente:**
```sql
-- Query para ver tipos de clientes actuales
SELECT 
    tipo_cliente, 
    COUNT(*) as total,
    COUNT(CASE WHEN email IS NOT NULL THEN 1 END) as con_email,
    COUNT(CASE WHEN telefono IS NOT NULL THEN 1 END) as con_telefono
FROM clientes
GROUP BY tipo_cliente
ORDER BY total DESC;
```

---

### 2. `ubicaciones` ✅
```sql
Campos clave:
- id (uuid)
- cliente_id (uuid) → FK a clientes
- nombre
- direccion, localidad, provincia
- tipo_instalacion ← CRÍTICO
- created_at
```

**Análisis:**
- ✅ Un cliente puede tener múltiples ubicaciones (perfecto para salones)
- ✅ Campo `tipo_instalacion` permite diferenciar

**Tipos de instalación esperados:**
- `salon_juego`
- `campo_solar`
- `oficina`
- `almacen`
- `industrial`

**Protocolo sugerido:**
```sql
-- Ver distribución de instalaciones
SELECT 
    c.tipo_cliente,
    u.tipo_instalacion,
    COUNT(*) as total_ubicaciones
FROM ubicaciones u
LEFT JOIN clientes c ON u.cliente_id = c.id
GROUP BY c.tipo_cliente, u.tipo_instalacion
ORDER BY total_ubicaciones DESC;
```

---

### 3. `proyectos` ✅
```sql
Campos clave:
- id (uuid)
- cliente_id (uuid)
- ubicacion_id (uuid)
- tipo_proyecto (text)
- descripcion
- estado (text)
- created_at
```

**Análisis:**
- ✅ Relaciona cliente + ubicación + proyecto
- ✅ Trackea estado
- ⚠️ Falta: fecha_inicio, fecha_fin_estimada, tecnico_asignado

**Estados típicos:**
- `presupuesto`
- `aprobado`
- `en_ejecucion`
- `completado`
- `mantenimiento`

---

### 4. `documentos` ✅
```sql
Campos clave:
- id (uuid)
- proyecto_id (uuid)
- tipo_documento (text)
- titulo
- estado
- created_at
```

**Análisis:**
- ✅ Sistema de documentación por proyecto
- ✅ Control de versiones via `versiones_del_documento`

**Tipos de documento sugeridos:**
- `contrato`
- `ficha_tecnica`
- `plano`
- `certificado`
- `parte_trabajo`
- `albaran`
- `factura`

---

### 5. `evidencias` ✅
```sql
Campos clave:
- id (uuid)
- proyecto_id (uuid)
- tipo (text)
- descripcion
- ruta_archivo
- created_at
```

**Análisis:**
- ✅ Perfecto para fotos de instalaciones
- ✅ Soporta múltiples tipos

**Uso para CRA:**
```sql
-- Tipos de evidencia sugeridos
INSERT INTO evidencias (proyecto_id, tipo, descripcion, ruta_archivo)
VALUES 
  ('...', 'foto_instalacion', 'DVR principal', '/storage/dvr_salon_001.jpg'),
  ('...', 'foto_camaras', 'Cámara entrada', '/storage/cam_entrada_001.jpg'),
  ('...', 'captura_video', 'Test visionado', '/storage/test_video.mp4'),
  ('...', 'documento_tecnico', 'Manual DVR', '/storage/manual_hikvision.pdf');
```

---

### 6. `registros` ✅ (Auditoría)
```sql
Campos clave:
- id (uuid)
- accion (text)
- entidad (text)
- entidad_id (uuid)
- created_at
```

**Análisis:**
- ✅ Sistema de auditoría genérico
- ✅ Trackea todas las acciones

**Uso:**
```sql
-- Registrar cada acción importante
INSERT INTO registros (accion, entidad, entidad_id)
VALUES 
  ('crear_incidencia', 'incidencias', '...'),
  ('resolver_incidencia', 'incidencias', '...'),
  ('crear_parte', 'partes_trabajo', '...'),
  ('visita_tecnica', 'proyectos', '...');
```

---

## 🚨 TABLAS QUE FALTAN PARA CRA

### 1. `incidencias_cra` (Nueva)
```sql
CREATE TABLE incidencias_cra (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cliente_id UUID REFERENCES clientes(id),
    ubicacion_id UUID REFERENCES ubicaciones(id),
    proyecto_id UUID REFERENCES proyectos(id),
    tipo_incidencia TEXT NOT NULL, -- 'salto_alarma', 'sin_video', 'fallo_tecnico', 'otros'
    origen TEXT DEFAULT 'manual', -- 'ajax', 'manual', 'automatico'
    prioridad TEXT DEFAULT 'normal', -- 'baja', 'normal', 'alta', 'critica'
    estado TEXT DEFAULT 'borrador', -- 'borrador', 'en_curso', 'resuelto', 'cerrado'
    descripcion TEXT,
    notas_resolucion TEXT,
    fecha_incidencia TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_resolucion TIMESTAMP WITH TIME ZONE,
    asignado_a TEXT, -- nombre del técnico o receptora
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_incidencias_cliente ON incidencias_cra(cliente_id);
CREATE INDEX idx_incidencias_estado ON incidencias_cra(estado);
CREATE INDEX idx_incidencias_prioridad ON incidencias_cra(prioridad);
CREATE INDEX idx_incidencias_fecha ON incidencias_cra(fecha_incidencia DESC);
```

### 2. `partes_trabajo_cra` (Nueva)
```sql
CREATE TABLE partes_trabajo_cra (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_parte TEXT UNIQUE, -- Autogenerado: PARTE/2026/0001
    cliente_id UUID REFERENCES clientes(id),
    ubicacion_id UUID REFERENCES ubicaciones(id),
    proyecto_id UUID REFERENCES proyectos(id),
    incidencia_id UUID REFERENCES incidencias_cra(id),
    tecnicos JSONB, -- Array de técnicos asignados
    tipo_trabajo TEXT, -- 'instalacion', 'mantenimiento', 'reparacion', 'revision'
    estado TEXT DEFAULT 'borrador', -- 'borrador', 'en_proceso', 'completado', 'facturado'
    fecha_trabajo DATE,
    hora_inicio TIME,
    hora_fin TIME,
    horas_trabajadas NUMERIC(5,2),
    materiales_usados JSONB,
    trabajo_realizado TEXT,
    observaciones TEXT,
    firma_cliente TEXT, -- Base64 de la firma
    albaran_id UUID REFERENCES documentos(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_partes_cliente ON partes_trabajo_cra(cliente_id);
CREATE INDEX idx_partes_estado ON partes_trabajo_cra(estado);
CREATE INDEX idx_partes_fecha ON partes_trabajo_cra(fecha_trabajo DESC);
```

### 3. `protocolos_cliente_cra` (Nueva)
```sql
CREATE TABLE protocolos_cliente_cra (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cliente_id UUID REFERENCES clientes(id),
    ubicacion_id UUID REFERENCES ubicaciones(id),
    nombre_protocolo TEXT NOT NULL,
    tipo_servicio TEXT, -- 'salon_juego', 'campo_solar', 'empresa'
    checklist JSONB, -- Lista de verificación específica
    acciones_incidencia JSONB, -- Qué hacer ante cada tipo de incidencia
    contactos_emergencia JSONB, -- Array de contactos
    horarios_operacion JSONB, -- Horarios de apertura/cierre
    criticidad TEXT DEFAULT 'normal', -- 'normal', 'prioritario', 'critico'
    fecha_inicio_garantia DATE,
    fecha_fin_garantia DATE,
    dentro_garantia BOOLEAN GENERATED ALWAYS AS (
        CASE 
            WHEN fecha_fin_garantia IS NULL THEN FALSE
            WHEN fecha_fin_garantia >= CURRENT_DATE THEN TRUE
            ELSE FALSE
        END
    ) STORED,
    dias_restantes_garantia INTEGER,
    notas TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_protocolos_cliente ON protocolos_cliente_cra(cliente_id);
CREATE INDEX idx_protocolos_ubicacion ON protocolos_cliente_cra(ubicacion_id);
CREATE INDEX idx_protocolos_garantia ON protocolos_cliente_cra(dentro_garantia);
```

### 4. `sistemas_visionado` (Nueva - Para los 58 salones)
```sql
CREATE TABLE sistemas_visionado (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ubicacion_id UUID REFERENCES ubicaciones(id),
    abonado TEXT,
    estado_visionado TEXT DEFAULT 'no_visible', -- 'visible', 'no_visible', 'intermitente'
    ip_dominio TEXT,
    puerto_http INTEGER,
    puerto_rtsp INTEGER,
    puerto_servidor INTEGER,
    p2p_id TEXT,
    usuario_dvr TEXT,
    password_dvr TEXT, -- Encriptado
    modelo_dvr TEXT,
    marca_dvr TEXT,
    num_camaras_total INTEGER,
    num_camaras_funcionando INTEGER,
    software_visionado TEXT, -- 'NVMS', 'EZView', 'Smart PSS', etc.
    proveedor_internet TEXT,
    velocidad_internet TEXT,
    ultima_conexion TIMESTAMP WITH TIME ZONE,
    problemas_detectados TEXT,
    acciones_requeridas TEXT,
    prioridad TEXT DEFAULT 'media',
    en_garantia BOOLEAN DEFAULT FALSE,
    fecha_fin_garantia DATE,
    notas TEXT,
    auditado BOOLEAN DEFAULT FALSE,
    fecha_auditoria DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_sistemas_estado ON sistemas_visionado(estado_visionado);
CREATE INDEX idx_sistemas_ubicacion ON sistemas_visionado(ubicacion_id);
CREATE INDEX idx_sistemas_auditado ON sistemas_visionado(auditado);
```

---

## 🔄 PLAN DE MIGRACIÓN Y SINCRONIZACIÓN

### Opción 1: Migrar a Odoo (Recomendado)
```
Supabase (datos actuales) → Odoo (sistema nuevo)
↓
Mantener Supabase solo para web/app
Odoo como sistema principal de CRA
```

### Opción 2: Sincronización Bidireccional
```
Supabase ←→ Sync Script ←→ Odoo
```

### Opción 3: Supabase como Master (si prefieres)
```
Supabase (master) → API → Odoo (solo lectura/escritura vía API)
```

---

## 📊 QUERIES ÚTILES PARA ANÁLISIS

### 1. Dashboard de Clientes
```sql
-- Resumen completo de clientes
SELECT 
    c.id,
    c.nombre,
    c.tipo_cliente,
    COUNT(DISTINCT u.id) as num_ubicaciones,
    COUNT(DISTINCT p.id) as num_proyectos,
    COUNT(DISTINCT CASE WHEN p.estado = 'en_ejecucion' THEN p.id END) as proyectos_activos,
    MAX(p.created_at) as ultimo_proyecto
FROM clientes c
LEFT JOIN ubicaciones u ON c.id = u.cliente_id
LEFT JOIN proyectos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.tipo_cliente
ORDER BY num_ubicaciones DESC, num_proyectos DESC;
```

### 2. Ubicaciones Sin Proyecto
```sql
-- Ubicaciones que necesitan atención
SELECT 
    u.id,
    u.nombre,
    c.nombre as cliente,
    u.tipo_instalacion,
    u.localidad,
    u.provincia
FROM ubicaciones u
LEFT JOIN clientes c ON u.cliente_id = c.id
LEFT JOIN proyectos p ON u.id = p.ubicacion_id
WHERE p.id IS NULL
ORDER BY c.nombre, u.nombre;
```

### 3. Proyectos Activos
```sql
-- Proyectos que requieren seguimiento
SELECT 
    p.id,
    c.nombre as cliente,
    u.nombre as ubicacion,
    p.tipo_proyecto,
    p.estado,
    p.created_at,
    COUNT(e.id) as num_evidencias,
    COUNT(d.id) as num_documentos
FROM proyectos p
LEFT JOIN clientes c ON p.cliente_id = c.id
LEFT JOIN ubicaciones u ON p.ubicacion_id = u.id
LEFT JOIN evidencias e ON p.id = e.proyecto_id
LEFT JOIN documentos d ON p.id = d.proyecto_id
WHERE p.estado IN ('en_ejecucion', 'aprobado')
GROUP BY p.id, c.nombre, u.nombre, p.tipo_proyecto, p.estado, p.created_at
ORDER BY p.created_at DESC;
```

### 4. Auditoría de Actividad
```sql
-- Últimas 50 acciones
SELECT 
    r.created_at,
    r.accion,
    r.entidad,
    r.entidad_id
FROM registros r
ORDER BY r.created_at DESC
LIMIT 50;
```

---

## 🎯 PROTOCOLOS PERSONALIZADOS BASADOS EN TU BD

### Protocolo por `tipo_cliente`

Primero, necesitamos saber qué tipos tienes:
```sql
SELECT DISTINCT tipo_cliente FROM clientes;
```

**Protocolo base para cada tipo:**

#### Si `tipo_cliente = 'salon_juego'` o similar:
```markdown
### Checklist Verificación
- [ ] Verificar cámaras de caja fuerte
- [ ] Verificar cámaras TPVs (mínimo 2)
- [ ] Comprobar grabación 24/7
- [ ] Verificar conexión en horario laboral (14:00-04:00)
- [ ] Revisar iluminación nocturna

### Criticidad
ALTA - Dinero en efectivo, horarios nocturnos

### Contactos
```sql
SELECT 
    c.nombre,
    c.telefono,
    c.email,
    u.nombre as ubicacion
FROM clientes c
LEFT JOIN ubicaciones u ON c.id = u.cliente_id
WHERE c.tipo_cliente = 'salon_juego';
```
```

#### Si `tipo_cliente = 'campo_solar'`:
```markdown
### Checklist Verificación
- [ ] Verificar perímetro completo
- [ ] Revisar eventos nocturnos (20:00-08:00)
- [ ] Comprobar barreras

 infrarrojas
- [ ] Verificar iluminación perimetral

### Criticidad
MEDIA - Alto valor material, bajo riesgo personal
```

---

## 🚀 SCRIPT DE IMPORTACIÓN SUPABASE → ODOO

```python
# import_supabase_to_odoo.py
import os
from supabase import create_client, Client
import xmlrpc.client

# Configuración Supabase
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_KEY")
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Configuración Odoo
ODOO_URL = "https://tu-odoo.com"
ODOO_DB = "tu_base_datos"
ODOO_USER = "admin"
ODOO_PASSWORD = "tu_password"

# Conectar a Odoo
common = xmlrpc.client.ServerProxy(f'{ODOO_URL}/xmlrpc/2/common')
uid = common.authenticate(ODOO_DB, ODOO_USER, ODOO_PASSWORD, {})
models = xmlrpc.client.ServerProxy(f'{ODOO_URL}/xmlrpc/2/object')

def importar_clientes():
    """Importar clientes de Supabase a Odoo"""
    # Obtener clientes de Supabase
    response = supabase.table('clientes').select('*').execute()
    clientes = response.data
    
    for cliente in clientes:
        # Buscar si ya existe en Odoo
        existing = models.execute_kw(
            ODOO_DB, uid, ODOO_PASSWORD,
            'res.partner', 'search',
            [[('email', '=', cliente['email'])]]
        )
        
        if not existing:
            # Crear en Odoo
            partner_id = models.execute_kw(
                ODOO_DB, uid, ODOO_PASSWORD,
                'res.partner', 'create',
                [{
                    'name': cliente['nombre'],
                    'email': cliente['email'],
                    'phone': cliente['telefono'],
                    'street': cliente['direccion'],
                    'city': cliente['localidad'],
                    'state_id': False,  # Buscar provincia
                    'country_id': False,  # Buscar país
                    'comment': f"Tipo: {cliente['tipo_cliente']}"
                }]
            )
            print(f"✅ Cliente creado: {cliente['nombre']} (ID: {partner_id})")
        else:
            print(f"⏭️  Cliente ya existe: {cliente['nombre']}")

def importar_ubicaciones():
    """Importar ubicaciones como direcciones adicionales"""
    response = supabase.table('ubicaciones').select('*, clientes(email)').execute()
    ubicaciones = response.data
    
    for ubicacion in ubicaciones:
        # Buscar cliente en Odoo por email
        partner_id = models.execute_kw(
            ODOO_DB, uid, ODOO_PASSWORD,
            'res.partner', 'search',
            [[('email', '=', ubicacion['clientes']['email'])]]
        )
        
        if partner_id:
            # Crear dirección adicional
            models.execute_kw(
                ODOO_DB, uid, ODOO_PASSWORD,
                'res.partner', 'create',
                [{
                    'parent_id': partner_id[0],
                    'type': 'delivery',
                    'name': ubicacion['nombre'],
                    'street': ubicacion['direccion'],
                    'city': ubicacion['localidad'],
                    'comment': f"Tipo instalación: {ubicacion['tipo_instalacion']}"
                }]
            )
            print(f"✅ Ubicación creada: {ubicacion['nombre']}")

if __name__ == "__main__":
    print("🚀 Iniciando importación Supabase → Odoo...")
    importar_clientes()
    importar_ubicaciones()
    print("✅ Importación completada!")
```

---

## 📋 PRÓXIMOS PASOS RECOMENDADOS

### Semana 1:
1. **Crear tablas nuevas en Supabase** (incidencias, partes, protocolos, sistemas_visionado)
2. **Importar Excel de 58 salones** a tabla `sistemas_visionado`
3. **Ejecutar queries de análisis** para entender distribución de clientes

### Semana 2:
4. **Decidir:** ¿Migrar a Odoo o mantener Supabase?
5. **Si Odoo:** Ejecutar script de importación
6. **Si Supabase:** Crear vistas y funciones auxiliares

### Semana 3:
7. **Crear protocolos** basados en tipos de cliente reales
8. **Documentar** procedimientos
9. **Capacitar** equipo en nueva estructura

---

**¿Quieres que te cree:**
1. ✅ Los scripts SQL para crear las tablas nuevas?
2. ✅ El script de importación completo Supabase → Odoo?
3. ✅ Queries específicas para tus tipos de cliente?
4. ✅ Dashboard visual en Supabase/Metabase?

Yo también puedo ejecutar queries directamente si me das acceso de API a Supabase. 🚀
