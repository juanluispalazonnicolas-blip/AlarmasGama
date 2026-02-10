# 🎨 Guía de Formato para Google Sheets

## Cómo Aplicar Colores y Hacer el Checklist Más Dinámico

---

## 📊 Paso 1: Importar el CSV

1. **Abre Google Sheets**: [sheets.google.com](https://sheets.google.com)
2. **Archivo → Importar → Subir**
3. Selecciona `Auditoria_Salones_CCTV.csv`
4. **Configuración de importación:**
   - Separador: Detectar automáticamente
   - Convertir texto a números: Sí

---

## 🎨 Paso 2: Aplicar Formato con Colores

### 🔵 Encabezados (Fila 1)

**Selecciona la fila 1 completa:**
```
Formato → Relleno: #4A90E2 (azul)
Formato → Texto: Blanco, Negrita, Centrado
```

### 🟢 Grupo 1: Información Básica (Columnas A-E)
**Columnas:** Nº, Abonado, Cliente, Ubicación, Estado Visionado

```
Seleccionar rango A2:E59
Formato → Relleno alterno: 
  - Color 1: #E8F5E9 (verde claro)
  - Color 2: #FFFFFF (blanco)
```

### 🔷 Grupo 2: Configuración de Red (Columnas F-J)
**Columnas:** IP/Dominio, Puerto HTTP, Puerto RTSP, Puerto Servidor, P2P ID

```
Seleccionar rango F2:J59
Formato → Relleno alterno:
  - Color 1: #E3F2FD (azul claro)
  - Color 2: #FFFFFF (blanco)
```

### 🟡 Grupo 3: Acceso y Equipo (Columnas K-P)
**Columnas:** Usuario, Contraseña, Modelo DVR, Nº Cámaras Total, Nº Cámaras OK, Software CRA

```
Seleccionar rango K2:P59
Formato → Relleno alterno:
  - Color 1: #FFF9C4 (amarillo claro)
  - Color 2: #FFFFFF (blanco)
```

### 🟠 Grupo 4: Contactos (Columnas Q-S)
**Columnas:** Tel. Responsable, Tel. Informático, Proveedor Internet

```
Seleccionar rango Q2:S59
Formato → Relleno alterno:
  - Color 1: #FFE0B2 (naranja claro)
  - Color 2: #FFFFFF (blanco)
```

### 🟣 Grupo 5: Seguimiento (Columnas T-AA)
**Columnas:** Velocidad, Última Conexión, Problemas, Acciones, Prioridad, Garantía, Fin Garantía, Completado

```
Seleccionar rango T2:AA59
Formato → Relleno alterno:
  - Color 1: #F3E5F5 (morado claro)
  - Color 2: #FFFFFF (blanco)
```

---

## 🎯 Paso 3: Formato Condicional Inteligente

### ✅ Columna E: Estado Visionado

**Selecciona E2:E59:**

1. **Formato → Formato condicional → Agregar regla**

**Regla 1: "Visible"**
```
Si el texto contiene: "Visible"
Color de fondo: #4CAF50 (verde)
Color de texto: Blanco
Negrita
```

**Regla 2: "No visible"**
```
Si el texto contiene: "No visible"
Color de fondo: #F44336 (rojo)
Color de texto: Blanco
Negrita
```

**Regla 3: "Intermitente"**
```
Si el texto contiene: "Intermitente"
Color de fondo: #FF9800 (naranja)
Color de texto: Blanco
Negrita
```

### 🚨 Columna X: Prioridad

**Selecciona X2:X59:**

**Regla 1: "Crítica"**
```
Si el texto es exactamente: "Crítica"
Color de fondo: #D32F2F (rojo oscuro)
Color de texto: Blanco
Negrita
```

**Regla 2: "Alta"**
```
Si el texto es exactamente: "Alta"
Color de fondo: #FF9800 (naranja)
Color de texto: Blanco
```

**Regla 3: "Media"**
```
Si el texto es exactamente: "Media"
Color de fondo: #FDD835 (amarillo)
Color de texto: Negro
```

**Regla 4: "Baja"**
```
Si el texto es exactamente: "Baja"
Color de fondo: #66BB6A (verde)
Color de texto: Blanco
```

### ✔️ Columna AA: Completado

**Selecciona AA2:AA59:**

**Regla 1: "Sí"**
```
Si el texto es exactamente: "Sí"
Color de fondo: #4CAF50 (verde)
Color de texto: Blanco
Icono: ✓
```

**Regla 2: "No"**
```
Si el texto es exactamente: "No"
Color de fondo: #E0E0E0 (gris)
Color de texto: #666666
```

---

## 📌 Paso 4: Configuraciones Adicionales

### Congelar Fila de Encabezado
```
Ver → Inmovilizar → 1 fila
```

### Activar Filtros
```
Datos → Crear filtro
```

### Ajustar Ancho de Columnas
```
Seleccionar todas las columnas → Clic derecho → Cambiar tamaño → Ajustar a los datos
```

### Envoltura de Texto
```
Columnas V y W (Problemas y Acciones):
Formato → Ajuste de texto → Ajustar
```

---

## 🚀 Paso 5: Crear Vistas Personalizadas

### Vista 1: Solo No Visibles (Principal)
```
1. Datos → Filtros de vista → Crear filtro de vista nuevo
2. Nombre: "🔴 Salones Sin Visionado"
3. Filtro en columna E: "No visible"
4. Ordenar por columna X (Prioridad): Z → A
```

### Vista 2: Críticos y Altos
```
1. Crear filtro de vista nuevo
2. Nombre: "⚠️ Prioridad Alta/Crítica"
3. Filtro en columna X: "Crítica" o "Alta"
4. Filtro en columna E: "No visible"
```

### Vista 3: Todos Visibles
```
1. Crear filtro de vista nuevo
2. Nombre: "✅ Operativos"
3. Filtro en columna E: "Visible"
```

### Vista 4: Pendientes de Completar
```
1. Crear filtro de vista nuevo
2. Nombre: "📋 Sin Auditar"
3. Filtro en columna AA: "No"
```

---

## 🎨 Paso 6: Iconos y Emojis (Opcional)

Para hacer el checklist más visual, puedes añadir emojis en las celdas:

**Estado Visionado:**
- ✅ Visible
- ❌ No visible
- ⚠️ Intermitente

**Prioridad:**
- 🔴 Crítica
- 🟠 Alta
- 🟡 Media
- 🟢 Baja

**Completado:**
- ✔️ Sí
- ⏳ No

---

## 📊 Paso 7: Dashboard Rápido (Opcional Avanzado)

Crea una pestaña separada llamada "Dashboard":

### Métricas Principales
```
=COUNTIF(E:E,"Visible")           → Salones Visibles
=COUNTIF(E:E,"No visible")        → Salones No Visibles
=COUNTIF(X:X,"Crítica")           → Casos Críticos
=COUNTIF(AA:AA,"Sí")              → Auditorías Completadas
```

### Gráfico de Estado
```
1. Insertar → Gráfico
2. Tipo: Gráfico circular
3. Rango de datos: E2:E59
4. Personalizar colores según formato condicional
```

---

## 🎯 Resultado Final

Con estos pasos tendrás:

✅ **Encabezados azules con texto blanco**
✅ **5 grupos de columnas con colores diferenciados**
✅ **Formato condicional automático**
✅ **4 vistas personalizadas**
✅ **Filtros activos**
✅ **Fácil de leer y navegar**

---

## ⚡ Atajos Rápidos en Google Sheets

| Acción | Atajo |
|--------|-------|
| Congelar fila | Ver → Inmovilizar |
| Crear filtro | Ctrl + Shift + L |
| Formato condicional | Formato → Formato condicional |
| Centrar texto | Ctrl + Shift + E |
| Negrita | Ctrl + B |
| Copiar formato | Ctrl + Alt + C, luego Ctrl + Alt + V |

---

## 📋 Checklist de Formato

```
□ CSV importado
□ Encabezados con fondo azul
□ 5 grupos de columnas coloreados
□ Formato condicional en Estado Visionado
□ Formato condicional en Prioridad
□ Formato condicional en Completado
□ Fila de encabezado congelada
□ Filtros activados
□ Vistas personalizadas creadas
□ Anchos de columna ajustados
```

---

**¡Ahora tu checklist será mucho más visual y fácil de usar!** 🎉
