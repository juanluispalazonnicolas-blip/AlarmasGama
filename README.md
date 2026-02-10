# 🚨 CRA IBERSEGUR - Sistema de Gestión Completo

## 📊 Situación Actual

- **58 salones totales**
- **17 salones visibles** (29.3%) ✅
- **41 salones sin visionado** (70.7%) ❌
- **Meta 90 días:** 58/58 salones operativos (100%)

---

## 📦 Contenido del Proyecto

### 1. 🗺️ Hoja de Ruta 90 Días
- **`hoja_de_ruta_90_dias.md`** - Plan completo semana a semana
- **`PLAN_PRIMERA_SEMANA.md`** - Acción día a día con horarios
- **`PLANTILLAS_PROTOCOLOS.md`** - 8 protocolos de actuación

### 2. 💾 Módulo Odoo CRA Gestión
Ubicación: `cra_gestion/`
- Gestión de incidencias
- Partes de trabajo
- Protocolos de clientes
- Listo para instalar en Odoo 19 Enterprise

### 3. 🗃️ Base de Datos Supabase
- **`supabase_cra_schema.sql`** - Script SQL completo (4 tablas nuevas)
- **`GUIA_TABLAS_SUPABASE.md`** - Guía de uso con ejemplos
- **`ANALISIS_SUPABASE_CRA.md`** - Análisis del esquema existente

**Tablas nuevas:**
- `incidencias_cra` - Registro de todas las incidencias
- `partes_trabajo_cra` - Gestión de visitas técnicas
- `protocolos_cliente_cra` - Protocolos específicos por cliente
- `sistemas_visionado` - Control de los 58 salones CCTV

### 4. 📋 Herramientas de Auditoría
- **`Auditoria_Salones_CCTV.csv`** - Checklist de 58 salones
- **`Auditoria_Salones_CCTV.xlsx`** - Excel formateado
- **`GUIA_AUDITORIA_SALONES.md`** - Manual de uso
- **`FORMATO_GOOGLE_SHEETS.md`** - Guía para Google Sheets
- **`Auditoria_CCTV_Launcher.html`** - Página de acceso rápido

### 5. 🔌 Integración Ajax
- **`INTEGRACION_AJAX_API.md`** - Guía completa de integración
- Código Python para webhook SQS
- Flujo alternativo con n8n

---

## 🚀 Inicio Rápido

### Paso 1: Configurar Base de Datos Supabase

1. **Ir a tu proyecto Supabase:**
   - URL: https://supabase.com/dashboard/project/jmwcvcpnzwznxotiplkb

2. **Abrir SQL Editor:**
   - En el menú lateral: `SQL Editor` → `New Query`

3. **Ejecutar el script:**
   - Copiar todo el contenido de `supabase_cra_schema.sql`
   - Pegar en el editor
   - Click en `Run` (o Ctrl+Enter)

4. **Verificar:**
   ```sql
   -- Ver tablas creadas
   SELECT tablename FROM pg_tables WHERE schemaname = 'public';
   ```

### Paso 2: Importar Datos de Auditoría

```sql
-- Ejemplo: Importar salón #1 (no visible)
INSERT INTO sistemas_visionado (
    numero_salon, estado_visionado, prioridad
) VALUES (1, 'no_visible', 'alta');

-- Repetir para los 58 salones usando datos del Excel
```

### Paso 3: Instalar Módulo Odoo (Opcional)

1. Copiar carpeta `cra_gestion/` a `/addons` de Odoo
2. Actualizar lista de aplicaciones
3. Instalar "CRA Gestión"
4. Configurar grupos de usuarios

### Paso 4: Empezar Auditoría (Primera Semana)

- Seguir `PLAN_PRIMERA_SEMANA.md`
- Usar `Auditoria_Salones_CCTV.xlsx`
- Actualizar tabla `sistemas_visionado` en Supabase

---

## 📈 KPIs y Métricas

### Semana 1
- ✅ 58/58 salones auditados
- ✅ 27/58 salones visibles (+10 desde baseline)
- ✅ 10 incidencias resueltas

### Mes 1 (Semana 1-4)
- ✅ 42/58 salones visibles (72%)
- ✅ Odoo instalado y operativo
- ✅ Equipo capacitado

### Día 90 (Final)
- ✅ 58/58 salones visibles (100%)
- ✅ Procesos 100% digitalizados
- ✅ Integración Ajax completa
- ✅ Dashboard en tiempo real

---

## 🛠️ Stack Tecnológico

- **Base de Datos:** Supabase (PostgreSQL)
- **ERP/CRM:** Odoo 19 Enterprise
- **Automatización:** n8n (Docker)
- **Alertas:** Ajax Systems Enterprise API
- **Frontend:** HTML/CSS/JS
- **Hosting:** A definir

---

## 📚 Documentación

| Documento | Propósito |
|-----------|-----------|
| `hoja_de_ruta_90_dias.md` | Plan estratégico completo |
| `GUIA_TABLAS_SUPABASE.md` | Cómo usar cada tabla de BD |
| `PLANTILLAS_PROTOCOLOS.md` | Protocolos de actuación |
| `INTEGRACION_AJAX_API.md` | Integrar sistema de alarmas |

---

## 👥 Equipo

- **Líder del Proyecto:** Juan Luis (tú)
- **Receptora:** Lucía
- **Técnicos:** A asignar
- **Turno Noche:** A asignar

---

## 🎯 Objetivos Clave

1. **Corto plazo (30 días):**
   - De 17 → 42 salones visibles
   - Auditoría completa
   - Odoo instalado

2. **Medio plazo (60 días):**
   - De 42 → 52 salones visibles
   - Integración Ajax
   - Dashboard operativo

3. **Largo plazo (90 días):**
   - 58/58 salones visibles
   - Procesos documentados
   - Cultura de mejora continua

---

## 📞 Soporte

Para dudas sobre:
- **Supabase:** Consultar `GUIA_TABLAS_SUPABASE.md`
- **Odoo:** Ver documentación en `cra_gestion/README.md`
- **Ajax API:** Revisar `INTEGRACION_AJAX_API.md`

---

## 📄 Licencia

Uso interno - CRA Ibersegur

---

**Última actualización:** 2026-02-10  
**Versión:** 1.0  
**Estado:** En ejecución (Semana 1/13)
