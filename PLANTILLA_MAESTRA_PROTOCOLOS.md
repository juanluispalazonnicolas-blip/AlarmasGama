# 📋 PLANTILLA MAESTRA DE PROTOCOLOS CRA

## 🎯 Propósito

Esta es la **plantilla base universal** que se personalizará para cada cliente. Define claramente las responsabilidades de cada rol en la cadena de seguridad.

---

## 👥 ROLES Y RESPONSABILIDADES

### 1. 🎥 VIGILANTES (Monitoreo Remoto)
**Ubicación:** CRA (Centro Receptora de Alarmas)  
**Horario:** 24/7 turnos rotativos  
**Función:** Monitoreo continuo de sistemas de visionado

### 2. 📞 RECEPTORA (Operador de Incidencias)
**Ubicación:** CRA  
**Horario:** 24/7 turnos rotativos  
**Función:** Gestión de comunicaciones y coordinación

### 3. 🚗 ACUDAS (Personal de Campo)
**Ubicación:** Móvil / En ruta  
**Horario:** Según disponibilidad (24/7 con servicio de guardia)  
**Función:** Verificación física y resolución in-situ

---

## 🔔 PROTOCOLO POR TIPO DE EVENTO

### EVENTO 1: SALTO DE ALARMA

#### 📊 Tiempo Objetivo Total: **5 minutos** (desde alarma hasta acción)

#### 🎥 VIGILANTE (0-2 min)

```
□ [0 seg] Recibir notificación de alarma en sistema
□ [10 seg] Localizar cámara(s) afectada(s)
□ [30 seg] Revisar grabación 2 min antes del salto
□ [1 min] Analizar imágenes en tiempo real
□ [2 min] DECIDIR:
   
   ✅ FALSA ALARMA (animal, viento, sombra)
      → Marcar como falsa alarma
      → Anotar causa en sistema
      → FIN (no escalar)
   
   ⚠️ NO HAY VIDEO / CÁMARAS NO FUNCIONAN
      → Escalar INMEDIATAMENTE a Receptora
      → Marcar como "Sin verificación visual"
      → Ir a: RECEPTORA - Sin Video
   
   🚨 ALARMA REAL VERIFICADA (intrusión, robo, emergencia)
      → Escalar INMEDIATAMENTE a Receptora
      → Capturar pantallazos
      → Anotar: Nº personas, características, vehículo, punto entrada
      → Mantener vigilancia continua
      → Ir a: RECEPTORA - Alarma Verificada
```

#### 📞 RECEPTORA - Alarma Verificada (2-3 min)

```
□ [2 min] Recibir alerta de Vigilante con detalles
□ [2 min 15 seg] Llamar a CONTACTO 1 del cliente
   
   Script:
   "Buenos días/tardes, [NOMBRE]. Soy [TU NOMBRE] de CRA Ibersegur.
    A las [HORA EXACTA] se activó alarma en [UBICACIÓN].
    Hemos verificado las imágenes: [DESCRIPCIÓN DE LO VISTO].
    ¿Está al corriente de esto?"
   
   SI CONTESTA Y CONFIRMA:
   □ Preguntar si desea avisar policía
   □ Anotar respuesta en sistema
   □ Crear incidencia en Odoo
   □ Enviar WhatsApp con capturas video
   □ FIN
   
   NO CONTESTA (3 intentos, 30 seg entre llamadas):
   □ Llamar a CONTACTO 2 (backup)
   □ Si no contesta: Llamar a CONTACTO 3
   
   NINGUNO CONTESTA:
   □ [3 min] Evaluar criticidad:
      • Si es ROBO EN CURSO: Llamar 112/Policía Local
      • Si es INTRUSIÓN SIN ROBO: SMS urgente + email + WhatsApp
   □ Activar ACUDA si está configurado
   □ Ir a: ACUDAS - Verificación Presencial
```

#### 📞 RECEPTORA - Sin Video (2-3 min)

```
□ [2 min] Recibir alerta de Vigilante
□ [2 min 15 seg] Llamar a CONTACTO 1 del cliente
   
   Script:
   "Buenos días/tardes, [NOMBRE]. Soy [TU NOMBRE] de CRA Ibersegur.
    A las [HORA EXACTA] se activó alarma en [UBICACIÓN].
    NO PODEMOS VERIFICAR por fallo en el sistema de video.
    ¿Puede confirmar si está todo correcto?"
   
   CLIENTE CONFIRMA QUE ESTÁ TODO BIEN:
   □ Crear incidencia técnica (prioridad ALTA)
   □ Agendar visita técnica urgente
   □ FIN
   
   CLIENTE NO PUEDE CONFIRMAR / NO CONTESTA:
   □ Activar ACUDA para verificación presencial
   □ Crear incidencia (alarma + técnica)
   □ Ir a: ACUDAS - Verificación Presencial
```

#### 🚗 ACUDAS - Verificación Presencial (10-30 min)

```
□ [5 min] Recibir notificación de Receptora
□ [5 min] Revisar datos del cliente en app:
   • Dirección exacta
   • Contacto telefonos
   • Código acceso/Alarma
   • Plano de ubicación si existe
   • Puntos de acceso
□ [10-20 min] Desplazamiento al lugar
□ [Llegada] Llamar a Receptora: "Llegado a ubicación"

EN UBICACIÓN:
□ Inspección visual perímetro (NO ENTRAR si hay peligro)
□ Verificar:
   • Puertas/ventanas forzadas
   • Vehículos sospechosos
   • Movimiento interior
   • Daños visibles

SI DETECTA PELIGRO / ROBO ACTIVO:
□ NO ENTRAR - Mantenerse a distancia segura
□ Llamar 112/Policía INMEDIATAMENTE
□ Informar a Receptora
□ Documentar con fotos/video desde exterior
□ Esperar a policía

SI NO HAY PELIGRO EVIDENTE:
□ Contactar cliente para confirmar acceso
□ Entrar con precaución si cliente autoriza
□ Verificar interiores
□ Documentar estado (fotos/video)
□ Informar a Receptora y Cliente

□ [Finalización] Completar parte de trabajo en Odoo:
   • Tiempo llegada/salida
   • Hallazgos
   • Acciones tomadas
   • Fotos adjuntas
   • Firma cliente si procede
```

---

### EVENTO 2: PÉRDIDA DE VIDEO / CONEXIÓN

#### 📊 Tiempo Objetivo: **15 minutos** (para diagnóstico inicial)

#### 🎥 VIGILANTE (0-5 min)

```
□ [0 min] Detectar pérdida de video/conexión en sistema
□ [1 min] Verificar:
   • ¿Es solo 1 cámara o todas?
   • ¿Es solo este cliente o varios?
   • ¿Hay conectividad de red?

SI ES PROBLEMA GENERAL (múltiples clientes):
□ Escalar a soporte técnico interno
□ No llamar a todos los clientes (problema nuestro)
□ FIN

SI ES PROBLEMA ESPECÍFICO (solo este cliente):
□ [2 min] Esperar 3-5 min para reconexión automática
□ [5 min] Si persiste → Escalar a Receptora
□ Anotar: Hora exacta pérdida, última imagen vista
```

#### 📞 RECEPTORA (5-10 min)

```
□ [5 min] Recibir notificación de Vigilante
□ [6 min] Llamar a CONTACTO TÉCNICO (no responsable)
   
   Script:
   "Buenos días, [NOMBRE]. Soy [TU NOMBRE] de CRA Ibersegur.
    Desde las [HORA] no tenemos conexión con su sistema de video.
    ¿Ha habido algún cambio? ¿Corte de luz? ¿Obras?"
   
   CLIENTE INDICA CAUSA (corte luz, router apagado, etc):
   □ Dar instrucciones básicas si procede
   □ Crear incidencia prioridad MEDIA
   □ Agendar seguimiento en 2h
   □ FIN
   
   CLIENTE NO SABE / NO HAY CAMBIOS:
   □ Crear incidencia prioridad ALTA
   □ Agendar visita técnica urgente (24h)
   □ Avisar a técnicos disponibles
   □ FIN
```

#### 🚗 ACUDAS (Solo si es URGENTE)

```
Solo se activa ACUDA para pérdida de video si:
• Cliente prioritario/crítico
• Más de 24h sin video
• Cliente específicamente lo solicita
• Sospecha de sabotaje/robo

Procedimiento igual que visita técnica estándar.
```

---

### EVENTO 3: VISITA TÉCNICA PROGRAMADA

#### 🎥 VIGILANTE

```
NO APLICA - Vigilante no interviene en visitas programadas
```

#### 📞 RECEPTORA (Día anterior)

```
□ [-24h] Confirmar cita con cliente vía WhatsApp/SMS
   "Estimado [NOMBRE], confirmamos visita técnica 
    mañana [FECHA] a las [HORA]. ¿Confirma disponibilidad?"

□ [-24h] Asignar técnico disponible
□ [-24h] Enviar al técnico:
   • Datos del cliente
   • Historial incidencias
   • Materiales necesarios
   • Ubicación GPS

□ [Día de visita - Mañana] Recordatorio por WhatsApp al cliente
□ [Durante visita] Disponible para consultas del técnico
□ [Post-visita] Verificar que parte de trabajo esté completado
```

#### 🚗 ACUDAS - Técnico (Día de visita)

```
PRE-VISITA (Día anterior):
□ Revisar datos del cliente en Odoo
□ Revisar historial incidencias
□ Verificar materiales necesarios
□ Cargar herramientas en furgoneta
□ Confirmar ubicación en GPS

DURANTE VISITA:
□ [Llegada] Foto del cuentakilómetros
□ [Llegada] Presentarse profesionalmente al cliente
□ [Trabajo] Realizar diagnóstico completo
□ [Trabajo] Documentar con fotos ANTES/DESPUÉS
□ [Trabajo] Explicar al cliente qué se hace y por qué
□ [Finalización] Probar funcionamiento completo
□ [Finalización] Firma digital del cliente
□ [Salida] Foto del cuentakilómetros

POST-VISITA (Mismo día):
□ Subir fotos a Odoo
□ Completar parte de trabajo:
   • Problema encontrado
   • Solución aplicada
   • Materiales usados (con albarán)
   • Tiempo total
   • Observaciones
□ Si problema NO resuelto:
   • Documentar exactamente qué falta
   • Agendar 2ª visita
   • Informar a Receptora
□ Marcar incidencia como resuelta en sistema
□ Cliente recibe automáticamente email con resumen
```

---

## 📊 TABLA RESUMEN DE RESPONSABILIDADES

| Evento | Vigilante | Receptora | Acudas |
|--------|-----------|-----------|--------|
| **Salto Alarma** | Verificar video (2 min) | Llamar cliente + coordinar (3 min) | Verificación física (30 min) |
| **Sin Video** | Detectar + esperar (5 min) | Llamar + diagnóstico (10 min) | Solo si urgente |
| **Visita Técnica** | - | Coordinar + seguimiento | Ejecutar visita completa |
| **Problema Técnico** | Detectar (inmediato) | Crear incidencia (5 min) | Resolver (1-24h) |

---

## ⏱️ TIEMPOS OBJETIVO POR ROL

### 🎥 VIGILANTE
- Verificación visual: **< 2 minutos**
- Escalado a Receptora: **Inmediato** (si procede)

### 📞 RECEPTORA
- Primera llamada cliente: **< 3 minutos** (desde alarma)
- Documentación incidencia: **< 5 minutos**
- Activación Acudas: **< 5 minutos**

### 🚗 ACUDAS
- Llegada a ubicación urbana: **< 20 minutos**
- Llegada ubicación rural: **< 40 minutos**
- Informe post-visita: **Mismo día** (obligatorio)

---

## 📞 CONTACTOS POR ROL

### Para VIGILANTE:
```json
{
  "supervisor_turno": "XXX XXX XXX",
  "soporte_tecnico_interno": "XXX XXX XXX",
  "receptora_backup": "XXX XXX XXX"
}
```

### Para RECEPTORA:
```json
{
  "cliente_contacto_1": "Por definir por cliente",
  "cliente_contacto_2": "Por definir por cliente",
  "coordinador_acudas": "XXX XXX XXX",
  "policia_local": "092 / Local específico",
  "emergencias": "112"
}
```

### Para ACUDAS:
```json
{
  "receptora_turno": "XXX XXX XXX (24/7)",
  "coordinador_tecnico": "XXX XXX XXX",
  "proveedor_materiales": "XXX XXX XXX",
  "cliente_contacto": "Por definir por cliente"
}
```

---

## 🎓 FORMACIÓN OBLIGATORIA

### VIGILANTE debe saber:
- ✅ Identificar falsa alarma vs alarma real
- ✅ Capturar pantallazos y video
- ✅ Describir sucesos con claridad
- ✅ Cuándo escalar y cuándo no

### RECEPTORA debe saber:
- ✅ Scripts de llamadas
- ✅ Manejo de crisis y clientes molestos
- ✅ Crear incidencias en Odoo
- ✅ Coordinar con policía y acudas
- ✅ Toma de decisiones bajo presión

### ACUDAS debe saber:
- ✅ Protocolos de seguridad personal
- ✅ Cuándo NO entrar a una ubicación
- ✅ Documentación fotográfica profesional
- ✅ Uso de Odoo en campo (app móvil)
- ✅ Diagnóstico técnico básico

---

## 📋 PERSONALIZACIÓN POR CLIENTE

Al crear un protocolo específico, modificar:

```
DATOS DEL CLIENTE:
□ Nombre comercial y ubicación exacta
□ Tipo de instalación (salón, campo solar, empresa, etc.)
□ Criticidad (normal, prioritario, crítico)

CONTACTOS ESPECÍFICOS:
□ Responsable 1: Nombre, tel principal, tel backup, horario
□ Responsable 2: Nombre, tel, relación (encargado, gerente, etc.)
□ Contacto técnico: Tel, horario, para qué llamar
□ Policía local: Tel específico si lo tiene

HORARIOS OPERACIÓN:
□ Lunes-Viernes: Apertura - Cierre
□ Sábado: Horario o cerrado
□ Domingo/Festivos: Horario o cerrado
□ Vigilancia fuera horario: SÍ/NO

PARTICULARIDADES:
□ Tienen animales (no escalar por ellos)
□ Hacen obras (ignorar detectores polvo temporalmente)
□ Personal de limpieza: Horario exacto
□ Zonas sensibles: Cámaras específicas a vigilar
□ Código acceso / Clave alarma (si aplica)
□ Plano de ubicación adjunto
□ ¿Servicio de acudas activo?: SÍ/NO
□ Tiempo respuesta acudas esperado: XX minutos

NIVEL DE SERVICIO:
□ ¿Llamar por cualquier alarma?: SÍ/NO
□ ¿Llamar solo si es verificada?: SÍ/NO
□ ¿Enviar resumen semanal?: SÍ/NO
□ Preferencia contacto: Llamada / WhatsApp / Email
```

---

## 📊 INDICADORES DE CALIDAD

### Por Protocolo
- % Falsas alarmas detectadas por Vigilante: **> 90%**
- Tiempo medio respuesta Receptora: **< 3 min**
- Tiempo medio llegada Acudas (urbano): **< 20 min**
- % Incidencias documentadas completas: **100%**
- Satisfacción cliente (mensual): **>8/10**

### Global CRA
- % Protocolos personalizados activos: **100%** (1 por cliente)
- % Personal capacitado: **100%**
- Revisión protocolos: **Cada 90 días**

---

**NOTA IMPORTANTE:**  
Esta plantilla es un **punto de partida**. Cada cliente debe tener su protocolo personalizado basado en esta estructura.

**Última actualización:** 2026-02-10  
**Versión:** 1.0  
**Aprobado por:** Dirección CRA
