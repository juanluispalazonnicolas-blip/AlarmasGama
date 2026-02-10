# 🎯 INSTALACIÓN SÚPER SIMPLE - PASO A PASO

## ✅ Instrucciones para tu NUEVO proyecto Supabase

---

## 📋 **ORDEN DE EJECUCIÓN**

**Ejecuta estos archivos EN ORDEN, uno por uno:**

### 1. `01_extensiones.sql`
- **Qué hace:** Habilita UUID
- **Tiempo:** 5 segundos
- **Resultado esperado:** Ver una fila con "uuid-ossp"

### 2. `02_tabla_clientes.sql`
- **Qué hace:** Crea tabla de clientes
- **Tiempo:** 5 segundos
- **Resultado esperado:** "Tabla clientes creada, total: 0"

### 3. `03_tabla_ubicaciones.sql`
- **Qué hace:** Crea tabla de ubicaciones
- **Tiempo:** 5 segundos
- **Resultado esperado:** "Tabla ubicaciones creada, total: 0"

### 4. `04_tablas_proyectos.sql`
- **Qué hace:** Crea proyectos, documentos, evidencias
- **Tiempo:** 10 segundos
- **Resultado esperado:** Lista con 3 nombres de tablas

### 5. `05_funciones.sql`
- **Qué hace:** Crea función para actualizar fechas
- **Tiempo:** 5 segundos
- **Resultado esperado:** "Función creada correctamente"

### 6. `06_tabla_sistemas_visionado.sql` ⭐ **IMPORTANTE**
- **Qué hace:** Crea la tabla de los 58 salones
- **Tiempo:** 10 segundos
- **Resultado esperado:** "Tabla sistemas_visionado creada, total: 0"

### 7. `07_tabla_incidencias.sql`
- **Qué hace:** Crea tabla de incidencias
- **Tiempo:** 10 segundos
- **Resultado esperado:** "Tabla incidencias_cra creada, total: 0"

### 8. `08_tabla_partes_trabajo.sql`
- **Qué hace:** Crea tabla de partes de trabajo
- **Tiempo:** 10 segundos
- **Resultado esperado:** "Tabla partes_trabajo_cra creada, total: 0"

### 9. `09_tabla_protocolos.sql`
- **Qué hace:** Crea tabla de protocolos
- **Tiempo:** 10 segundos
- **Resultado esperado:** "Tabla protocolos_cliente_cra creada, total: 0"

### 10. `10_verificacion.sql` ✅ **FINAL**
- **Qué hace:** Verifica que todo se creó bien
- **Tiempo:** 5 segundos
- **Resultado esperado:** "✅ INSTALACIÓN COMPLETADA"

---

## 🔥 **CÓMO EJECUTAR CADA ARCHIVO**

### Método 1: Copiar y Pegar (Recomendado)

1. **Ir a tu Supabase:**
   - URL: https://supabase.com/dashboard/project/[TU-PROYECTO-ID]/sql/new

2. **Para cada archivo (en orden):**
   - Abre el archivo `.sql` en tu PC
   - Copia TODO el contenido (Ctrl+A, Ctrl+C)
   - Pega en Supabase SQL Editor (Ctrl+V)
   - Click en "Run" (botón verde)
   - **Espera a que termine** antes de continuar con el siguiente
   - Verifica el resultado esperado

3. **Repetir** para los 10 archivos

---

## ⏱️ **TIEMPO TOTAL**

- **Total:** ~5 minutos
- **Por archivo:** 30-60 segundos

---

## ❌ **SI ALGO FALLA**

### Error: "already exists"
**Solución:** La tabla ya existe, continúa con el siguiente archivo.

### Error: "permission denied"
**Solución:** Asegúrate de estar usando el proyecto correcto.

### Error: "does not exist" (en paso 3+)
**Solución:** Vuelve al paso anterior, asegúrate de que se ejecutó correctamente.

---

## ✅ **VERIFICACIÓN FINAL**

Cuando termines los 10 archivos, ejecuta esto:

```sql
SELECT tablename 
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;
```

**Deberías ver 9 tablas:**
1. clientes
2. documentos
3. evidencias
4. incidencias_cra
5. partes_trabajo_cra
6. proyectos
7. protocolos_cliente_cra
8. sistemas_visionado
9. ubicaciones

---

## 🎉 **SIGUIENTE PASO**

Cuando veas "✅ INSTALACIÓN COMPLETADA", estás listo para:

1. **Importar los 58 salones** a `sistemas_visionado`
2. **Crear tu primera incidencia de prueba**
3. **Empezar a trabajar**

---

## 📞 **¿PROBLEMAS?**

Si llegas hasta el paso 5 sin errores pero falla en el 6, 7, 8 o 9:
- **Ignóralo** y continúa con los demás
- Al final me dices cuál falló y lo arreglamos

**Lo CRÍTICO es que funcione el paso 6** (`sistemas_visionado`) para gestionar los 58 salones.

---

**¡EMPIEZA CON EL PASO 1!** 🚀
