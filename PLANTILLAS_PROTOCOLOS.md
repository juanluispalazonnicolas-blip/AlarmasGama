# 📋 PLANTILLAS DE PROTOCOLOS CRA

## 1. PROTOCOLO SALONES DE JUEGO

### Checklist Verificación Diaria

```
□ Verificar visionado en tiempo real
□ Revisar grabación últimas 24h
□ Comprobar todas las cámaras (especialmente caja/TPVs)
□ Verificar conexión a internet
□ Comprobar estado del DVR/NVR
```

### Protocolo Ante Alarma

1. **Verificar video** (2 min máximo)
2. **No hay video:** Llamar responsable
3. **Hay video y es falsa alarma:** Marcar en sistema
4. **Hay video y es real:** 
   - Llamar responsable INMEDIATAMENTE
   - Llamar policía si procede
   - Crear incidencia en Odoo
   - Documentar con capturas de pantalla

### Contactos Tipo

| Rol | Contacto 1 | Contacto 2 |
|-----|------------|------------|
| Responsable | [Tel] | [Tel backup] |
| Informático | [Tel] | - |
| Emergencias | 112 | Policía Local |

### Criticidad

**ALTA** - Dinero en efectivo, abierto hasta tarde

---

## 2. PROTOCOLO CAMPOS SOLARES

### Checklist Verificación Diaria

```
□ Verificar cámaras perimetrales
□ Revisar eventos de movimiento nocturnos
□ Comprobar barreras infrarrojos (si aplica)
□ Verificar iluminación nocturna
```

### Protocolo Ante Intrusión

1. **Verificar video de perímetro**
2. **Detectar si hay personas:**
   - ¿Están robando material?
   - ¿Están cerca de equipos críticos?
3. **Llamar a responsable**
4. **Si es robo activo:** Policía + Seguridad
5. **Documentar:**
   - Hora exacta
   - Punto de entrada
   - Número de intrusos
   - Vehículo (matrícula si posible)
   - Capturas de video

### Contactos Tipo

| Rol | Contacto 1 | Contacto 2 |
|-----|------------|------------|
| Responsable | [Tel] | [Tel backup] |
| Seguridad 24h | [Tel] | - |
| Policía | 112/091 | Local |

### Criticidad

**MEDIA** - Bajo riesgo personal, alto riesgo material

---

## 3. PROTOCOLO EMPRESAS GENERALES

### Checklist Verificación Diaria

```
□ Verificar cámaras de acceso principal
□ Revisar áreas sensibles (caja, almacén)
□ Comprobar horario de apertura/cierre
□ Verificar armado/desarmado según protocolo
```

### Protocolo Horario Laboral

**Durante jornada laboral:**
- Verificar video solo si hay alarma
- No molestar al cliente por eventos menores

**Fuera de horario:**
- Cualquier movimiento es sospechoso
- Verificar inmediatamente
- Llamar a responsable

### Contactos Tipo

| Rol | Contacto 1 | Contacto 2 |
|-----|------------|------------|
| Gerente | [Tel] | [Email] |
| Encargado | [Tel] | - |
| Servicios | [Tel] | - |

### Criticidad

**NORMAL** - Varían según sector

---

## 4. PROTOCOLO VISITAS TÉCNICAS

### Pre-Visita (Día anterior)

```
□ Confirmar cita con cliente
□ Revisar historial de incidencias
□ Preparar materiales necesarios
□ Cargar herramientas en furgoneta
□ Verificar ubicación (GPS)
```

### Durante Visita

```
□ Llegada: Foto del contador horario
□ Revisar sistema completo
□ Documentar problemas encontrados
□ Explicar al cliente qué se hizo
□ Firma del cliente en parte digital
□ Salida: Foto del contador horario
```

### Post-Visita (Mismo día)

```
□ Subir fotos a Odoo
□ Completar parte de trabajo
□ Si hay materiales: Adjuntar albarán
□ Marcar incidencia como resuelta
□ Enviar resumen al cliente por email
```

### Si el Problema NO se Resuelve

1. **Documentar exactamente qué se intentó**
2. **Especificar qué se necesita:**
   - Material adicional
   - Ayuda de otro técnico
   - Fabricante
3. **Agendar segunda visita si procede**
4. **Comunicar a receptora**

---

## 5. PROTOCOLO ANALÍTICAS DIARIAS

### ¿Qué Revisar?

**NO revisar analytics de TODO.** Solo:

1. **Clientes prioritarios** (listado semanal)
2. **Clientes con historial de problemas**
3. **Instalaciones nuevas** (primeros 30 días)

### Clasificación de Eventos

| Tipo | Acción | Ejemplo |
|------|--------|---------|
| 🟢 NORMAL | Ignorar | Cámara movimiento por viento |
| 🟡 REVISAR | Anotar en Excel | Pérdida video <2min |
| 🔴 CRÍTICO | Crear incidencia | DVR sin conexión >1h |

### Tiempo Máximo

- **15 minutos por cliente prioritario**
- **5 minutos resto de clientes**
- **1 hora máximo total al día**

### Template Anotación

```
Cliente: [Nombre]
Fecha: [DD/MM/YYYY]
Evento: [Descripción breve]
Frecuencia: Primera vez / Recurrente
Acción: [Qué se hizo]
```

---

## 6. PROTOCOLO TURNO NOCHE

### ✅ PUEDES

```
□ Marcar incidencias en sistema
□ Notificar a responsables (según protocolo)
□ Reflejar eventos en log
□ Coordinar con policía si es emergencia
□ Tomar capturas de video
```

### ❌ NO PUEDES (sin aprobación)

```
□ Resolver incidencias técnicas
□ Modificar configuración de sistemas
□ Hacer compromisos con clientes
□ Agendar visitas técnicas
□ Cambiar protocolos de actuación
```

### Casos Especiales

**Si hay duda:** Llamar a supervisor de turno

**Si es emergencia real (robo, fuego):**
1. Policía/Bomberos
2. Cliente
3. Supervisor

**Si es problema técnico:**
1. Marcar en sistema
2. Dejar nota para turno día
3. No intentar resolver solo

### Checklist Cambio de Turno

```
□ Revisar log de turno anterior
□ Verificar incidencias pendientes
□ Confirmar contactos de emergencia disponibles
□ Probar software de visionado (todos funcionan)
□ Al terminar: Pasar log a turno siguiente
```

---

## 7. PROTOCOLO COMUNICACIÓN CON CLIENTES

### Cuándo Llamar

**SÍ llamar:**
- Alarma verificada (video)
- Problema técnico que afecta servicio
- Cliente pidió ser notificado siempre

**NO llamar (usar email/WhatsApp):**
- Eventos menores sin video
- Consultas no urgentes
- Actualizaciones de estado

### Script Llamada

```
"Buenos días/tardes, soy [Nombre] de CRA Ibersegur.

Le llamamos porque a las [HORA] se activó una alarma en [UBICACIÓN].

Hemos verificado las imágenes y [DESCRIPCIÓN DE LO VISTO].

¿Está usted al corriente de esto? / ¿Quiere que avisemos a la policía?"

[Escuchar respuesta]

"Perfecto, queda registrado en el sistema. ¿Alguna otra cosa?"

"Gracias, que tenga buen día."
```

### Tono de Comunicación

- 📞 **Llamada:** Profesional, directo, conciso
- 📧 **Email:** Formal, detallado
- 💬 **WhatsApp:** Cordial, rápido

---

## 8. PROTOCOLO ESCALADO DE INCIDENCIAS

### Nivel 1: Receptora

**Puede resolver:**
- Verificación de alarmas
- Llamadas a clientes
- Creación de incidencias
- Coordinación básica

**Tiempo resolución:** <5 min

### Nivel 2: Técnico

**Puede resolver:**
- Configuración remota
- Soporte técnico avanzado
- Visitas en campo
- Instalaciones

**Tiempo resolución:** <24h

### Nivel 3: Supervisor/Gerente

**Interviene en:**
- Problemas recurrentes
- Clientes muy insatisfechos
- Decisiones de inversión
- Cambios de protocolo

**Tiempo resolución:** <72h

### Cuándo Escalar

```
Receptora → Técnico:
• Problema técnico que no puede resolver por teléfono
• Cliente pide hablar con técnico
• Incidencia >30 min sin resolver

Técnico → Supervisor:
• Problema requiere inversión >€500
• Cliente amenaza con baja
• Problema recurrente (>3 veces mismo mes)
```

---

## 📊 MÉTRICAS POR PROTOCOLO

### Salones de Juego
- Tiempo medio verificación alarma: <2min
- % falsas alarmas: <90%
- Satisfacción cliente: >9/10

### Campos Solares
- Detección intrusión: 100%
- Tiempo notificación: <5min
- Incidencias reales: Trackear

### Visitas Técnicas
- Problemas resueltos 1ªvisita: >80%
- Tiempo medio visita: <2h
- Partes completados mismo día: 100%

---

## 🔄 REVISIÓN DE PROTOCOLOS

**Cada 30 días:**
- Revisar si protocolos se siguen
- Recoger feedback del equipo
- Ajustar según necesidad

**Cada 90 días:**
- Revisión completa
- Actualizar con mejores prácticas
- Capacitar en cambios

---

**Estos protocolos son VIVOS:**
Se mejoran continuamente basándose en la experiencia real del equipo.

**Sugerencias bienvenidas:** Formulario en Notion/Odoo
