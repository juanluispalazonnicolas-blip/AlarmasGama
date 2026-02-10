# 🎯 INSTRUCCIONES PARA TU PROYECTO SUPABASE

## Tu Proyecto

**URL:** https://supabase.com/dashboard/project/jmwcvcpnzwznxotiplkb  
**Project ID:** `jmwcvcpnzwznxotiplkb`

---

## 🚀 PASO A PASO: Crear las Tablas

### 1. Acceder al SQL Editor

1. Ve a: https://supabase.com/dashboard/project/jmwcvcpnzwznxotiplkb/sql
2. Click en **"New Query"** (arriba a la derecha)
3. Dale un nombre: `CRA Schema Setup`

### 2. Copiar y Pegar el Script

1. Abre el archivo `supabase_cra_schema.sql`
2. Selecciona TODO el contenido (Ctrl+A)
3. Copia (Ctrl+C)
4. Pega en el SQL Editor de Supabase (Ctrl+V)

### 3. Ejecutar

1. Click en **"Run"** (botón verde) o presiona **Ctrl+Enter**
2. Espera a que termine (puede tardar 10-15 segundos)
3. Si todo sale bien, verás: `Success. No rows returned`

### 4. Verificar que se crearon las tablas

Ejecuta esta query en una nueva pestaña:

```sql
SELECT 
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN (
    'incidencias_cra',
    'partes_trabajo_cra',
    'protocolos_cliente_cra',
    'sistemas_visionado'
  )
ORDER BY tablename;
```

**Deberías ver:**
- ✅ `incidencias_cra`
- ✅ `partes_trabajo_cra`
- ✅ `protocolos_cliente_cra`
- ✅ `sistemas_visionado`

---

## 📊 Importar Datos del Excel de Auditoría

### Opción 1: Manual (Recomendado para empezar)

Crea un SQL para cada salón basándote en tu Excel:

```sql
-- Salón 1 - No visible
INSERT INTO sistemas_visionado (
    numero_salon,
    abonado,
    estado_visionado,
    ip_dominio,
    puerto_http,
    usuario_dvr,
    modelo_dvr,
    software_visionado,
    prioridad,
    problemas_detectados,
    acciones_requeridas
) VALUES (
    1,
    'ABO-001', -- Tomar del Excel
    'no_visible',
    '192.168.1.100', -- Tomar del Excel
    8000,
    'admin',
    'Hikvision DS-7608', -- Tomar del Excel
    'NVMS',
    'alta',
    'Puerto bloqueado por ISP', -- Tomar del Excel
    'Cambiar puerto a 8888 o configurar VPN'
);

-- Repetir para cada uno de los 58 salones...
```

### Opción 2: Importación masiva CSV

1. En Supabase, ve a: **Table Editor** → `sistemas_visionado`
2. Click en **"Insert"** → **"Import data from CSV"**
3. Selecciona tu archivo `Auditoria_Salones_CCTV.csv`
4. Mapea las columnas correctamente
5. Click en **"Import"**

---

## 🔍 Queries Útiles para Empezar

### Ver resumen de estado de salones

```sql
SELECT 
    estado_visionado,
    COUNT(*) as total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sistemas_visionado), 2) || '%' as porcentaje
FROM sistemas_visionado
GROUP BY estado_visionado
ORDER BY total DESC;
```

### Ver salones sin visionado (top prioridad)

```sql
SELECT 
    numero_salon,
    abonado,
    ip_dominio,
    problemas_detectados,
    prioridad
FROM sistemas_visionado
WHERE estado_visionado = 'no_visible'
ORDER BY 
    CASE prioridad
        WHEN 'critica' THEN 1
        WHEN 'alta' THEN 2
        WHEN 'media' THEN 3
        WHEN 'baja' THEN 4
    END,
    numero_salon;
```

### Actualizar estado de un salón después de arreglarlo

```sql
UPDATE sistemas_visionado
SET 
    estado_visionado = 'visible',
    ultima_conexion = NOW(),
    problemas_detectados = NULL,
    acciones_requeridas = NULL,
    auditado = TRUE,
    fecha_auditoria = CURRENT_DATE
WHERE numero_salon = 1; -- Cambiar por el número correcto
```

---

## 📝 Crear Primera Incidencia de Prueba

```sql
INSERT INTO incidencias_cra (
    tipo_incidencia,
    origen,
    prioridad,
    titulo,
    descripcion,
    estado
) VALUES (
    'sin_video',
    'manual',
    'alta',
    'Salón #5 sin visionado desde esta mañana',
    'Cliente reporta que no puede ver cámaras. Sistema no responde en IP configurada.',
    'en_curso'
);

-- Ver la incidencia creada (con número autogenerado)
SELECT * FROM incidencias_cra ORDER BY created_at DESC LIMIT 1;
```

---

## 🔐 Configurar API Keys (Para integración)

Si quieres acceder desde código (Python, n8n, etc.):

1. Ve a: https://supabase.com/dashboard/project/jmwcvcpnzwznxotiplkb/settings/api
2. Copia:
   - **Project URL:** `https://jmwcvcpnzwznxotiplkb.supabase.co`
   - **anon/public key:** (para frontend)
   - **service_role key:** (para backend - ¡mantén esto secreto!)

### Ejemplo de conexión con Python

```python
from supabase import create_client, Client

url = "https://jmwcvcpnzwznxotiplkb.supabase.co"
key = "tu_service_role_key_aqui"
supabase: Client = create_client(url, key)

# Consultar salones sin visionado
response = supabase.table('sistemas_visionado')\
    .select('*')\
    .eq('estado_visionado', 'no_visible')\
    .execute()

print(f"Salones sin visionado: {len(response.data)}")
```

---

## 🛡️ Row Level Security (RLS) - IMPORTANTE

**Por defecto, las tablas NO tienen RLS activado**, lo que significa:
- ✅ Puedes trabajar inmediatamente
- ⚠️ Cualquiera con la API key puede acceder

**Para producción, deberías activar RLS:**

```sql
-- Activar RLS en todas las tablas
ALTER TABLE incidencias_cra ENABLE ROW LEVEL SECURITY;
ALTER TABLE partes_trabajo_cra ENABLE ROW LEVEL SECURITY;
ALTER TABLE protocolos_cliente_cra ENABLE ROW LEVEL SECURITY;
ALTER TABLE sistemas_visionado ENABLE ROW LEVEL SECURITY;

-- Crear política: solo usuarios autenticados pueden ver todo
CREATE POLICY "Allow authenticated users" ON incidencias_cra
    FOR ALL USING (auth.role() = 'authenticated');

-- Repetir para cada tabla...
```

**Por ahora, déjalo sin RLS** mientras configuras todo.

---

## 📊 Crear Vistas Personalizadas

Ya vienen 3 vistas creadas automáticamente:

1. **`v_dashboard_sistemas`** - Resumen de todos los salones
2. **`v_incidencias_pendientes`** - Incidencias sin resolver
3. **`v_partes_pendientes_facturacion`** - Partes sin facturar

**Usarlas:**

```sql
-- Ver dashboard completo
SELECT * FROM v_dashboard_sistemas
ORDER BY numero_salon;

-- Ver incidencias urgentes
SELECT * FROM v_incidencias_pendientes
WHERE prioridad IN ('critica', 'alta');
```

---

## ❌ Si Algo Sale Mal

### Error: "permission denied for schema public"
**Solución:** Tu usuario no tiene permisos. Ve a `Settings` → `Database` → asegúrate de que estás usando el owner.

### Error: "function uuid_generate_v4() does not exist"
**Solución:** Ejecuta primero:
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

### Error: "relation already exists"
**Solución:** La tabla ya existe. Para recrearla:
```sql
DROP TABLE IF EXISTS nombre_tabla CASCADE;
-- Luego vuelve a ejecutar el CREATE TABLE
```

---

## 🎯 Próximos Pasos

1. ✅ Ejecutar `supabase_cra_schema.sql`
2. ✅ Verificar que las 4 tablas se crearon
3. ✅ Importar datos de los 58 salones
4. ✅ Crear primera incidencia de prueba
5. ✅ Consultar vistas predefinidas

**Cuando termines, tendrás:**
- Base de datos lista para producción
- Sistema de tracking de incidencias
- Control completo de los 58 salones
- Base para integración con Odoo/n8n

---

**¿Dudas?** Todo está documentado en `GUIA_TABLAS_SUPABASE.md` con ejemplos detallados.
