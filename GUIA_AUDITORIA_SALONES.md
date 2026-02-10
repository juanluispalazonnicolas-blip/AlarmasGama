# 📋 Guía de Uso: Auditoría de Salones CCTV

## 🎯 Objetivo
Este documento te ayudará a realizar una auditoría completa de los 58 salones para identificar por qué solo 16 tienen visionado activo.

---

## 📊 Archivos Incluidos

1. **Auditoria_Salones_CCTV.csv** - Checklist principal (Excel/Google Sheets)
2. Esta guía de uso

---

## 🚀 Cómo Usar el Checklist

### Paso 1: Abrir el Archivo

**Opción A - Excel:**
```
1. Abre Excel
2. Archivo → Abrir → Selecciona "Auditoria_Salones_CCTV.csv"
3. Guarda como "Auditoria_Salones_CCTV.xlsx" para mantener formato
```

**Opción B - Google Sheets:**
```
1. Ve a sheets.google.com
2. Archivo → Importar → Subir → Selecciona "Auditoria_Salones_CCTV.csv"
3. Configuración de importación: Separador = coma
```

### Paso 2: Configurar Formato (Recomendado)

**En Excel o Google Sheets:**
1. Selecciona toda la hoja
2. Formato → Ajuste de texto → Ajustar
3. Congela la primera fila: Vista → Inmovilizar → 1 fila
4. Aplica filtros: Datos → Crear filtro

---

## 📝 Descripción de Campos

### 🔵 Información Básica

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| **Nº Salón** | Número consecutivo del salón | 1, 2, 3... |
| **Abonado** | Código/ID del abonado | ABO-001 |
| **Cliente** | Nombre del salón de juego | Salón Golden Palace |
| **Ubicación** | Dirección completa | Calle Mayor 45, Madrid |
| **Estado Visionado** | Situación actual | Visible / No visible / Intermitente |

### 🔵 Configuración de Red

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| **IP/Dominio** | Dirección IP o DDNS del DVR/NVR | 192.168.1.100 o salon01.ddns.net |
| **Puerto HTTP** | Puerto web del DVR | 80, 8000, 8080 |
| **Puerto RTSP** | Puerto de streaming | 554, 8554 |
| **P2P ID** | ID de conexión P2P (si aplica) | ABCD-EFGH-1234-5678 |
| **IP Pública** | IP pública del router | 85.123.45.67 |
| **Proveedor Internet** | Compañía de internet | Movistar, Vodafone, Orange |
| **Velocidad Internet** | Mbps de subida/bajada | 300/30 |

### 🔵 Equipo y Acceso

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| **Usuario DVR/NVR** | Usuario de acceso | admin |
| **Contraseña** | Contraseña (¡mantener seguro!) | ●●●●●●●● |
| **Modelo DVR/NVR** | Marca y modelo del grabador | Hikvision DS-7608NI-K2 |
| **Nº Cámaras Totales** | Cámaras instaladas | 8 |
| **Nº Cámaras Funcionando** | Cámaras operativas | 6 |
| **Marca Cámaras** | Fabricante de cámaras | Hikvision, Dahua, UNV |

### 🔵 Contactos

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| **Teléfono Responsable** | Tel. del encargado del salón | 600 123 456 |
| **Email Responsable** | Email del encargado | encargado@salon.com |
| **Teléfono Informático** | Tel. del soporte técnico local | 600 789 012 |
| **Email Informático** | Email del técnico | tecnico@salon.com |

### 🔵 Diagnóstico Técnico

| Campo | Descripción | Valores |
|-------|-------------|---------|
| **Router/Switch** | Modelo del router | TP-Link, Cisco, MikroTik |
| **Última Conexión** | Fecha de última conexión exitosa | 05/02/2026 |
| **Software Visionado** | Programa usado en CRA | NVMS, EZView, Smart PSS |
| **Fecha Auditoría** | Cuándo se verificó | 10/02/2026 |
| **Técnico Auditor** | Quién hizo la auditoría | Juan Pérez |

### 🔵 Estado del Sistema (Valores: OK / Fallo / N/A)

| Campo | Descripción |
|-------|-------------|
| **Estado Conexión Internet** | Conectividad a internet |
| **Estado Alimentación DVR** | DVR encendido y funcionando |
| **Estado Grabación** | Sistema grabando correctamente |
| **Espacio Disco Duro** | Disco con espacio suficiente |
| **Estado Red Local** | Red interna del salón operativa |

### 🔵 Análisis y Seguimiento

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| **Problemas Detectados** | Lista de problemas encontrados | "Puerto 8000 bloqueado, cámara 3 sin imagen" |
| **Acciones Requeridas** | Pasos para resolver | "Abrir puerto en router, reemplazar cámara 3" |
| **Prioridad** | Urgencia de resolución | Baja / Media / Alta / Crítica |
| **Dentro Garantía** | Si aplica garantía | Sí / No |
| **Fecha Fin Garantía** | Vencimiento de garantía | 31/12/2026 |
| **Observaciones** | Notas adicionales | "Cliente reporta fallos intermitentes" |
| **Completado** | Auditoría terminada | Sí / No |

---

## 🔍 Proceso de Auditoría Recomendado

### Para Cada Salón:

#### 1️⃣ Verificación Remota (5-10 min)

```
□ Ping a la IP/Dominio
□ Intentar acceso web (navegador → http://IP:Puerto)
□ Verificar acceso P2P si está configurado
□ Comprobar puertos abiertos (usar herramienta online)
□ Verificar última actividad en software de visionado
```

#### 2️⃣ Contacto con Cliente (5 min)

```
□ Llamar al responsable
□ Confirmar que el sistema está encendido
□ Verificar conexión a internet del salón
□ Preguntar por cortes de luz recientes
□ Solicitar modelo de router/DVR si no lo tienes
```

#### 3️⃣ Diagnóstico Avanzado (10-15 min)

```
□ Revisar logs del software de visionado
□ Verificar configuración de red del DVR
□ Comprobar reglas de firewall/NAT
□ Revisar licencias de software
□ Verificar puertos correctos (HTTP, RTSP)
```

#### 4️⃣ Documentar Hallazgos (5 min)

```
□ Rellenar todos los campos del checklist
□ Asignar prioridad según criticidad
□ Definir acciones concretas
□ Estimar tiempo de resolución
□ Marcar como completado
```

---

## 🚨 Problemas Comunes y Soluciones

### ❌ Problema: No responde a ping
**Posibles causas:**
- Internet caído en el salón
- DVR apagado
- IP/Dominio cambiado
- Firewall bloqueando ICMP

**Acciones:**
```
1. Llamar al responsable para verificar conexión
2. Verificar IP pública actual
3. Revisar configuración DDNS
4. Solicitar reinicio de router y DVR
```

### ❌ Problema: Puerto cerrado/filtrado
**Posibles causas:**
- Puerto no abierto en router
- ISP bloqueando puertos
- Configuración NAT incorrecta

**Acciones:**
```
1. Acceder al router remotamente (si es posible)
2. Configurar port forwarding
3. Verificar que el DVR usa ese puerto
4. Considerar cambio de puerto si ISP bloquea
```

### ❌ Problema: P2P no funciona
**Posibles causas:**
- P2P ID incorrecto
- Servicio P2P del fabricante caído
- DVR desactualizado

**Acciones:**
```
1. Verificar P2P ID en el DVR
2. Actualizar firmware del DVR
3. Re-registrar dispositivo en plataforma P2P
4. Usar alternativa (DDNS + puertos)
```

### ❌ Problema: Cámaras sin imagen
**Posibles causas:**
- Cable de red dañado
- PoE no funciona
- Cámara averiada
- Configuración IP duplicada

**Acciones:**
```
1. Verificar estado de cámaras en DVR
2. Revisar alimentación PoE
3. Hacer ping a IP de cámara
4. Solicitar visita técnica si es HW
```

---

## 📊 Análisis de Datos

### Después de Completar el Checklist:

**1. Crea Tablas Dinámicas (Pivot Tables)**

```
Agrupar por:
- Estado Visionado
- Problemas Detectados
- Prioridad
- Dentro Garantía
```

**2. Identifica Patrones**

```
¿Hay problemas recurrentes?
- Mismo proveedor de internet
- Mismo modelo de DVR
- Misma zona geográfica
```

**3. Prioriza Acciones**

```
Orden de atención:
1. Crítica + Fuera de garantía
2. Crítica + En garantía
3. Alta
4. Media
5. Baja
```

---

## 🎯 Objetivos y KPIs

### Métrica de Éxito

| KPI | Actual | Objetivo |
|-----|--------|----------|
| Salones visibles | 16/58 (28%) | 58/58 (100%) |
| Tiempo medio auditoría | - | < 30 min/salón |
| Resolución en 1ª llamada | - | > 50% |
| Salones críticos resueltos | - | 100% en 48h |

### Plan de Acción por Día

**Día 1-2:** Auditar todos los salones (29 salones/día)
**Día 3-5:** Resolver problemas críticos y altos
**Día 6-10:** Resolver problemas medios y bajos
**Día 11-14:** Verificación final y cierre

---

## 💾 Backup y Seguridad

> **⚠️ IMPORTANTE:**
> Este archivo contiene información sensible (contraseñas, IPs, contactos)

**Medidas de seguridad:**
```
□ Guardar en carpeta protegida
□ Hacer backup diario
□ Encriptar si es posible (Excel: Archivo → Información → Proteger)
□ No compartir por email sin protección
□ Mantener en servidor seguro de la empresa
```

---

## 🔄 Sincronización con Odoo (Futuro)

Cuando instales el módulo CRA Gestión en Odoo, podrás:

1. **Importar estos datos** directamente a la tabla de Protocolos
2. **Crear incidencias automáticas** para cada problema detectado
3. **Generar partes de trabajo** para técnicos
4. **Hacer seguimiento** del progreso en tiempo real

**Formato de importación Odoo:**
- Exporta el CSV desde Excel/Sheets
- En Odoo: CRA Gestión → Protocolos → Importar
- Mapea los campos correspondientes
- Valida e importa

---

## 📞 Soporte

Para dudas sobre el uso del checklist:
- Consulta esta guía
- Revisa la hoja de ruta CRA
- Contacta con tu supervisor técnico

---

## ✅ Checklist de Checklist

Antes de empezar:
```
□ Archivo CSV abierto en Excel/Sheets
□ Primera fila congelada
□ Filtros activados
□ Formato aplicado
□ Backup del archivo original guardado
□ Guía de uso leída
□ Listos para auditar
```

---

**¡Buena suerte con la auditoría!** 🚀

*Documento creado: 10/02/2026*  
*Versión: 1.0*
