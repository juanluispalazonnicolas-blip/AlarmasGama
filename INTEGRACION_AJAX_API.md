# 🔌 Integración de Ajax Systems con Odoo CRA Gestión

## ✅ Respuesta Rápida

**Sí, es totalmente posible conectarse con Ajax Desktop/PRO** mediante la **Ajax Enterprise API**.

---

## 📊 Opciones de Integración Disponibles

### **Opción 1: Ajax Enterprise API** ⭐ Recomendada
La solución más robusta y profesional para CRAs.

**Características:**
- ✅ API REST completa
- ✅ Feed de eventos en tiempo real
- ✅ Webhooks mediante Amazon SQS
- ✅ Acceso a toda la información de seguridad
- ✅ Control remoto de sistemas Ajax
- ✅ Documentación con Swagger UI

### **Opción 2: Ajax PRO Desktop + Exportación**
Solución intermedia si no tienes acceso a Enterprise API.

**Características:**
- ⚠️ Requiere acceso manual o scripts
- ⚠️ No es en tiempo real
- ✅ Más sencilla de implementar inicialmente

### **Opción 3: Ajax Cloud Signaling**
Comunicación directa CMS (Central Monitoring Station).

**Características:**
- ✅ Protocolos estándar (Sur-Gard, ADEMCO 685, SIA DC-09)
- ✅ Sin instalación local necesaria
- ⚠️ Requiere configuración en Ajax Cloud

---

## 🚀 Implementación Recomendada: Enterprise API

### 1. Requisitos Previos

**Credenciales necesarias:**
- Cuenta Ajax PRO con acceso a Enterprise API
- AWS AccessKey y SecretKey (para SQS)
- Permisos de administrador en tu sistema Ajax

**Tecnologías:**
- Python 3.8+ o Node.js
- Conexión HTTPS
- Amazon SQS SDK

### 2. Arquitectura de Integración

```
┌─────────────────────┐
│  Ajax Systems Hub   │
│   (Instalaciones)   │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│   Ajax Cloud API    │
│  (Enterprise API)   │
└──────────┬──────────┘
           │
           ↓ Amazon SQS (FIFO Queue)
┌─────────────────────┐
│  Tu Servicio Web    │
│  (Python/Node.js)   │
└──────────┬──────────┘
           │
           ↓ Webhook/API Call
┌─────────────────────┐
│   Odoo CRA Gestión  │
│  (Módulo creado)    │
└─────────────────────┘
```

### 3. Tipos de Eventos que Recibirás

| Tipo | Descripción | Código Ejemplo |
|------|-------------|----------------|
| **ALARM** | Alarmas disparadas | M_01_20 (Puerta abierta) |
| **ALARM_RECOVERED** | Alarma recuperada | - |
| **MALFUNCTION** | Mal funcionamiento | - |
| **FUNCTION_RECOVERED** | Funcionamiento restaurado | - |
| **SECURITY** | Armado/Desarmado | - |
| **COMMON** | Eventos comunes | - |
| **USER** | Eventos de usuario | - |
| **LIFECYCLE** | Eventos de ciclo de vida | - |

### 4. Estructura de un Evento Ajax

```json
{
  "userId": "12345",
  "hubId": "67890",
  "deviceId": "sensor_001",
  "eventCode": "M_01_20",
  "eventType": "ALARM",
  "timestamp": "2026-02-10T01:30:00Z",
  "description": "Door protect reed open",
  "location": "Salón Golden Palace - Puerta Principal"
}
```

---

## 💻 Código de Ejemplo: Integración Básica

### Script Python para Recibir Eventos Ajax

```python
# ajax_integration.py
import boto3
import json
import requests
from datetime import datetime

# Configuración
AWS_ACCESS_KEY = 'tu_access_key'
AWS_SECRET_KEY = 'tu_secret_key'
SQS_QUEUE_URL = 'https://sqs.region.amazonaws.com/account/ajax-events'
ODOO_URL = 'https://tu-servidor-odoo.com'
ODOO_API_KEY = 'tu_api_key'

# Cliente SQS
sqs = boto3.client(
    'sqs',
    aws_access_key_id=AWS_ACCESS_KEY,
    aws_secret_access_key=AWS_SECRET_KEY,
    region_name='eu-west-1'  # Ajustar según tu región
)

def procesar_evento_ajax(evento):
    """Procesa un evento de Ajax y lo envía a Odoo"""
    
    # Mapear tipo de evento Ajax a tipo de incidencia Odoo
    tipo_incidencia_map = {
        'ALARM': 'salto_alarma',
        'MALFUNCTION': 'aviso_tecnico',
        'SECURITY': 'otros'
    }
    
    # Determinar prioridad según tipo de evento
    prioridad_map = {
        'ALARM': 'critica',
        'MALFUNCTION': 'alta',
        'SECURITY': 'normal',
        'COMMON': 'baja'
    }
    
    # Preparar datos para Odoo
    incidencia_data = {
        'name': f"INC-AJAX-{evento['hubId']}-{datetime.now().strftime('%Y%m%d%H%M%S')}",
        'tipo_incidencia': tipo_incidencia_map.get(evento['eventType'], 'otros'),
        'origen': 'ajax',
        'descripcion': f"{evento.get('description', 'Evento Ajax')} - Hub: {evento['hubId']} - Device: {evento.get('deviceId', 'N/A')}",
        'prioridad': prioridad_map.get(evento['eventType'], 'normal'),
        'fecha_incidencia': evento.get('timestamp', datetime.now().isoformat()),
        'estado': 'borrador'
    }
    
    # Enviar a Odoo mediante API
    try:
        response = requests.post(
            f'{ODOO_URL}/api/cra/incidencia',
            json=incidencia_data,
            headers={'Authorization': f'Bearer {ODOO_API_KEY}'}
        )
        
        if response.status_code == 200:
            print(f"✅ Incidencia creada en Odoo: {incidencia_data['name']}")
            return True
        else:
            print(f"❌ Error creando incidencia: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error de conexión con Odoo: {e}")
        return False

def escuchar_eventos_ajax():
    """Escucha continuamente eventos de la cola SQS de Ajax"""
    
    print("🎧 Escuchando eventos de Ajax...")
    
    while True:
        try:
            # Recibir mensajes de la cola
            response = sqs.receive_message(
                QueueUrl=SQS_QUEUE_URL,
                MaxNumberOfMessages=10,
                WaitTimeSeconds=20  # Long polling
            )
            
            if 'Messages' in response:
                for message in response['Messages']:
                    # Parsear evento
                    evento = json.loads(message['Body'])
                    
                    print(f"📨 Evento recibido: {evento.get('eventType')} - {evento.get('description')}")
                    
                    # Procesar evento
                    if procesar_evento_ajax(evento):
                        # Eliminar mensaje de la cola si se procesó correctamente
                        sqs.delete_message(
                            QueueUrl=SQS_QUEUE_URL,
                            ReceiptHandle=message['ReceiptHandle']
                        )
                    
        except KeyboardInterrupt:
            print("\n👋 Deteniendo escucha de eventos...")
            break
        except Exception as e:
            print(f"❌ Error procesando eventos: {e}")
            continue

if __name__ == "__main__":
    escuchar_eventos_ajax()
```

### Instalación de Dependencias

```bash
pip install boto3 requests
```

### Ejecutar el Script

```bash
python ajax_integration.py
```

---

## 🔄 Integración con Odoo CRA Gestión

### Paso 1: Añadir API REST al Módulo Odoo

Crear endpoint para recibir incidencias:

```python
# models/api_incidencia.py
from odoo import http
from odoo.http import request
import json

class CRAIncidenciaAPI(http.Controller):
    
    @http.route('/api/cra/incidencia', type='json', auth='api_key', methods=['POST'])
    def crear_incidencia_ajax(self, **kwargs):
        """API endpoint para crear incidencias desde Ajax"""
        
        try:
            # Obtener datos del request
            data = request.jsonrequest
            
            # Crear incidencia
            incidencia = request.env['cra.incidencia'].sudo().create({
                'tipo_incidencia': data.get('tipo_incidencia'),
                'origen': 'ajax',
                'descripcion': data.get('descripcion'),
                'prioridad': data.get('prioridad', 'normal'),
                'fecha_incidencia': data.get('fecha_incidencia'),
                'estado': 'borrador'
            })
            
            return {
                'status': 'success',
                'incidencia_id': incidencia.id,
                'incidencia_name': incidencia.name
            }
            
        except Exception as e:
            return {
                'status': 'error',
                'message': str(e)
            }
```

### Paso 2: Configurar Autenticación API

Añadir API Key en Odoo:
1. Configuración → Usuarios → Tu usuario
2. Preferencias → Seguridad → API Keys
3. Generar nueva clave

---

## 📱 Alternativa Simple: Webhook con n8n

Si prefieres una solución sin código, usa **n8n** (que mencionaste que ya tienes en Docker):

### Flujo de n8n

```
[Ajax Enterprise API] 
    → [n8n Webhook Trigger]
    → [Procesar datos JSON]
    → [HTTP Request a Odoo API]
```

### Configuración en n8n:

1. **Trigger: Webhook**
   - URL: `https://tu-n8n.com/webhook/ajax-events`
   - Método: POST

2. **Nodo: Function**
   ```javascript
   // Mapear evento Ajax a formato Odoo
   const evento = $input.item.json;
   
   return {
     tipo_incidencia: evento.eventType === 'ALARM' ? 'salto_alarma' : 'otros',
     origen: 'ajax',
     descripcion: `${evento.description} - Hub: ${evento.hubId}`,
     prioridad: evento.eventType === 'ALARM' ? 'critica' : 'normal'
   };
   ```

3. **Nodo: HTTP Request**
   - Método: POST
   - URL: `https://tu-odoo.com/api/cra/incidencia`
   - Headers: `Authorization: Bearer {api_key}`

---

## 🔧 Configuración en Ajax PRO Desktop

### Habilitar Enterprise API:

1. **Contacta con Ajax Systems:**
   - Solicita acceso a la Enterprise API
   - Es para empresas de seguridad con múltiples instalaciones

2. **Configurar en Ajax Cloud:**
   - Panel de empresa → Integraciones
   - Activar "Enterprise API"
   - Generar credenciales AWS SQS

3. **Configurar eventos a enviar:**
   - Editar `AjaxEventsDescription.xml`
   - Seleccionar eventos relevantes para tu CRA

---

## 💰 Costos

| Opción | Costo |
|--------|-------|
| **Enterprise API** | Requiere cuenta Ajax PRO (consultar con Ajax) |
| **Amazon SQS** | ~$0.40 por millón de solicitudes |
| **Infraestructura** | Servidor para script (puede ser un Raspberry Pi) |

---

## 🎯 Plan de Implementación Sugerido

### Fase 1: Preparación (Semana 1)
- [ ] Solicitar acceso a Ajax Enterprise API
- [ ] Configurar credenciales AWS
- [ ] Probar conexión con SQS

### Fase 2: Desarrollo (Semana 2-3)
- [ ] Crear script de integración Python/Node.js
- [ ] Añadir API REST a módulo Odoo
- [ ] Probar con eventos de prueba

### Fase 3: Despliegue (Semana 4)
- [ ] Desplegar script en servidor
- [ ] Configurar monitorización
- [ ] Crear dashboard de eventos

### Fase 4: Optimización (Mes 2)
- [ ] Filtrar eventos no relevantes
- [ ] Añadir reconocimiento de patrones
- [ ] Automatizar respuestas

---

## 📚 Recursos Útiles

- **Ajax Enterprise API Docs:** https://ajax.systems/cloud/enterprise
- **AWS SQS Python SDK:** https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sqs.html
- **Odoo External API:** https://www.odoo.com/documentation/19.0/developer/reference/external_api.html

---

## ⚠️ Consideraciones Importantes

> [!WARNING]
> - La **Enterprise API requiere cuenta empresarial** con Ajax Systems
> - Hay que gestionar correctamente las **credenciales AWS** (no hardcodear)
> - Implementar **retry logic** para eventos que fallen
> - Considerar **rate limiting** para evitar saturar Odoo

> [!TIP]
> - Empieza con una **integración simple** (solo alarmas críticas)
> - Usa **n8n** para prototipo rápido antes de código custom
> - Implementa **logs detallados** para debugging
> - Configura **alertas** si el servicio de integración cae

---

## ✅ Beneficios de la Integración

1. **Automatización completa** - Cero trabajo manual
2. **Tiempo real** - Incidencias creadas instantáneamente
3. **Sin duplicados** - Control por ID de evento
4. **Trazabilidad** - Todo el historial en un solo lugar
5. **Analíticas** - Estadísticas automáticas en Odoo

---

**¿Quieres que cree el código completo de integración o prefieres empezar con una solución más simple como n8n?** 🚀
