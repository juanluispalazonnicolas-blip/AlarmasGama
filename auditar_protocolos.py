"""
Auditoría automática de protocolos en Supabase
Conecta a la base de datos y genera reporte completo
"""

import requests
import json
from datetime import datetime

# Configuración
SUPABASE_URL = "https://jmwcvcpnzwznxotiplkb.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imptd2N2Y3Buend6bnhvdGlwbGtiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDY4MzM2MSwiZXhwIjoyMDg2MjU5MzYxfQ.qvr2juHfYEk98ilR9Dm09MOehlvh1rN6SinHGCTaEVE"

headers = {
    "apikey": SUPABASE_KEY,
    "Authorization": f"Bearer {SUPABASE_KEY}",
    "Content-Type": "application/json"
}

print("=" * 60)
print("🔍 AUDITORÍA AUTOMÁTICA DE PROTOCOLOS SUPABASE")
print("=" * 60)
print()

# 1. Verificar conexión
print("1️⃣ Verificando conexión a Supabase...")
try:
    response = requests.get(
        f"{SUPABASE_URL}/rest/v1/",
        headers=headers
    )
    if response.status_code == 200:
        print("   ✅ Conexión establecida correctamente")
    else:
        print(f"   ❌ Error de conexión: {response.status_code}")
        print(f"   Respuesta: {response.text}")
        exit(1)
except Exception as e:
    print(f"   ❌ Error: {e}")
    exit(1)

print()

# 2. Listar todas las tablas
print("2️⃣ Listando tablas en la base de datos...")
try:
    # Intentar obtener lista de tablas usando la API REST
    # Primero intentamos con una tabla conocida
    test_tables = [
        "clientes", 
        "ubicaciones", 
        "proyectos", 
        "sistemas_visionado",
        "incidencias_cra",
        "partes_trabajo_cra",
        "protocolos_cliente_cra"
    ]
    
    existing_tables = []
    for table in test_tables:
        response = requests.get(
            f"{SUPABASE_URL}/rest/v1/{table}?limit=0",
            headers=headers
        )
        if response.status_code == 200:
            existing_tables.append(table)
            print(f"   ✅ {table}")
        else:
            print(f"   ❌ {table} - No existe")
    
    print(f"\n   Total tablas encontradas: {len(existing_tables)}")
    
except Exception as e:
    print(f"   ❌ Error listando tablas: {e}")

print()

# 3. Revisar tabla de protocolos
print("3️⃣ Analizando tabla 'protocolos_cliente_cra'...")

if "protocolos_cliente_cra" not in existing_tables:
    print("   ❌ La tabla 'protocolos_cliente_cra' NO EXISTE")
    print("   👉 Necesitas ejecutar el script SQL: 09_tabla_protocolos.sql")
    exit(1)

try:
    response = requests.get(
        f"{SUPABASE_URL}/rest/v1/protocolos_cliente_cra",
        headers=headers
    )
    
    if response.status_code == 200:
        protocolos = response.json()
        print(f"   ✅ Tabla existe")
        print(f"   📊 Total protocolos creados: {len(protocolos)}")
        
        if len(protocolos) == 0:
            print("\n   ⚠️  LA TABLA ESTÁ VACÍA - No hay protocolos creados")
        else:
            print("\n   📋 Protocolos existentes:")
            for p in protocolos:
                nombre = p.get('nombre_protocolo', 'Sin nombre')
                tipo = p.get('tipo_servicio', 'Sin tipo')
                criticidad = p.get('criticidad', 'Sin criticidad')
                activo = "🟢 Activo" if p.get('activo', False) else "🔴 Inactivo"
                print(f"      • {nombre} | Tipo: {tipo} | {criticidad} | {activo}")
    else:
        print(f"   ❌ Error consultando tabla: {response.status_code}")
        print(f"   Respuesta: {response.text}")

except Exception as e:
    print(f"   ❌ Error: {e}")

print()

# 4. Análisis de completitud
print("4️⃣ Análisis de completitud de protocolos...")

protocolos_recomendados = [
    "Protocolo General Salones de Juego",
    "Protocolo General Campos Solares",
    "Protocolo General Empresas",
    "Protocolo Comunicación Cliente",
    "Protocolo Escalado Incidencias",
    "Protocolo Turno Noche",
    "Protocolo Visitas Técnicas"
]

protocolos_existentes_nombres = [p.get('nombre_protocolo', '') for p in protocolos] if len(protocolos) > 0 else []

print(f"   📊 Protocolos recomendados: {len(protocolos_recomendados)}")
print(f"   📊 Protocolos existentes: {len(protocolos_existentes_nombres)}")
print()

faltantes = []
for recomendado in protocolos_recomendados:
    encontrado = any(recomendado.lower() in existente.lower() for existente in protocolos_existentes_nombres)
    if encontrado:
        print(f"   ✅ {recomendado}")
    else:
        print(f"   ❌ {recomendado} - FALTANTE")
        faltantes.append(recomendado)

print()
print(f"   📊 Resumen: {len(protocolos_recomendados) - len(faltantes)}/{len(protocolos_recomendados)} protocolos base encontrados")

print()

# 5. Revisar calidad de los protocolos existentes
if len(protocolos) > 0:
    print("5️⃣ Análisis de calidad de protocolos existentes...")
    
    for i, p in enumerate(protocolos, 1):
        nombre = p.get('nombre_protocolo', 'Sin nombre')
        print(f"\n   📄 Protocolo #{i}: {nombre}")
        
        # Verificar campos importantes
        tiene_cliente = p.get('cliente_id') is not None
        tiene_tipo = p.get('tipo_servicio') is not None
        tiene_checklist = p.get('checklist') not in [None, [], '[]']
        tiene_acciones = p.get('acciones_incidencia') not in [None, {}, '{}']
        tiene_contactos = p.get('contactos_emergencia') not in [None, [], '[]']
        tiene_horarios = p.get('horarios_operacion') not in [None, {}, '{}']
        
        score = sum([tiene_tipo, tiene_checklist, tiene_acciones, tiene_contactos, tiene_horarios])
        total = 5
        
        print(f"      Cliente asignado: {'✅' if tiene_cliente else '❌'}")
        print(f"      Tipo servicio: {'✅' if tiene_tipo else '❌'}")
        print(f"      Checklist: {'✅' if tiene_checklist else '❌'}")
        print(f"      Acciones incidencia: {'✅' if tiene_acciones else '❌'}")
        print(f"      Contactos emergencia: {'✅' if tiene_contactos else '❌'}")
        print(f"      Horarios operación: {'✅' if tiene_horarios else '❌'}")
        print(f"      📊 Completitud: {score}/{total} ({score*100//total}%)")

print()
print("=" * 60)
print("✅ AUDITORÍA COMPLETADA")
print("=" * 60)

# Guardar reporte
reporte = {
    "fecha_auditoria": datetime.now().isoformat(),
    "total_protocolos": len(protocolos) if len(protocolos) > 0 else 0,
    "protocolos_recomendados": len(protocolos_recomendados),
    "protocolos_faltantes": faltantes,
    "tablas_existentes": existing_tables,
    "protocolos_detalle": protocolos if len(protocolos) > 0 else []
}

with open('reporte_auditoria_protocolos.json', 'w', encoding='utf-8') as f:
    json.dump(reporte, f, indent=2, ensure_ascii=False)

print("\n📄 Reporte guardado en: reporte_auditoria_protocolos.json")
