# Módulo CRA Gestión para Odoo 19

Módulo personalizado para la gestión integral de una Central Receptora de Alarmas (CRA).

## Características

- ✅ **Gestión de Incidencias**: Control completo de incidencias con origen AJAX, manual o automático
- ✅ **Partes de Trabajo**: Gestión de partes de técnicos con control de duplicidad
- ✅ **Protocolos por Cliente**: Definición de procedimientos personalizados
- ✅ **Gestión de Garantías**: Tracking automático de garantías
- ✅ **Múltiples Vistas**: Kanban, Lista, Formulario con búsquedas avanzadas
- ✅ **Permisos por Rol**: Receptora, Técnico, Administrador
- ✅ **Mensajería Integrada**: Seguimiento y notificaciones

## Requisitos

- Odoo 19.1+e (Enterprise Edition)
- Módulos base: `contacts`, `mail`

## Instalación

### 1. Copiar el Módulo

Copia la carpeta completa `cra_gestion` a tu directorio de addons de Odoo:

```bash
# En servidor on-premise
cp -r cra_gestion /path/to/odoo/addons/

# O añade la ruta en tu configuración de Odoo
addons_path = /path/to/odoo/addons,/path/to/cra_gestion
```

### 2. Actualizar Lista de Aplicaciones

1. Activa el **Modo Desarrollador**:
   - Ve a Configuración → Activar modo desarrollador
   
2. Actualiza la lista de aplicaciones:
   - Apps → Actualizar lista de aplicaciones
   - Confirma la actualización

### 3. Instalar el Módulo

1. En el menú de Apps, busca "CRA Gestión"
2. Haz clic en **Instalar**
3. Espera a que se complete la instalación

### 4. Configurar Permisos

Asigna los roles a tus usuarios:

1. Ve a Configuración → Usuarios y Compañías → Usuarios
2. Edita cada usuario y en la pestaña "Permisos de Acceso"
3. En la sección "CRA Gestión" asigna el rol apropiado:
   - **Receptora**: Para personal de recepción
   - **Técnico**: Para técnicos de campo
   - **Administrador CRA**: Para supervisores/administradores

## Estructura del Módulo

```
cra_gestion/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   ├── incidencia.py
│   ├── parte_trabajo.py
│   └── protocolo.py
├── views/
│   ├── incidencia_views.xml
│   ├── parte_trabajo_views.xml
│   ├── protocolo_views.xml
│   └── menus.xml
├── security/
│   ├── cra_security.xml
│   └── ir.model.access.csv
├── data/
│   └── sequences.xml
└── static/
    └── description/
        └── icon.png
```

## Uso Básico

### Crear una Incidencia

1. Ve a **CRA Gestión → Incidencias → Todas las Incidencias**
2. Clic en **Crear**
3. Rellena los datos:
   - Cliente
   - Tipo de incidencia
   - Descripción
   - Prioridad
4. Clic en **Iniciar** para comenzar a trabajar en ella

### Crear un Parte de Trabajo

1. Ve a **CRA Gestión → Partes de Trabajo → Todos los Partes**
2. Clic en **Crear**
3. Selecciona cliente, técnicos, tipo de trabajo
4. Describe el trabajo realizado
5. Completa el parte cuando termine

### Configurar un Protocolo

1. Ve a **CRA Gestión → Protocolos → Todos los Protocolos**
2. Clic en **Crear**
3. Define:
   - Cliente asociado
   - Tipo de servicio
   - Checklist de verificación
   - Horarios
   - Nivel de criticidad
   - Fechas de garantía

## Permisos por Rol

| Funcionalidad | Receptora | Técnico | Admin |
|--------------|-----------|---------|-------|
| Ver incidencias | ✅ | ✅ | ✅ |
| Crear incidencias | ✅ | ✅ | ✅ |
| Eliminar incidencias | ❌ | ❌ | ✅ |
| Ver partes | ✅ | ✅ | ✅ |
| Crear/editar partes | ❌ | ✅ | ✅ |
| Ver protocolos | ✅ | ✅ | ✅ |
| Crear/editar protocolos | ❌ | ❌ | ✅ |

## Soporte

Para soporte técnico o consultas sobre el módulo, contacta con el equipo de CRA Ibersegur.

## Licencia

LGPL-3

## Versión

1.0.0 - Versión inicial

---

**Desarrollado para CRA Ibersegur**
