# Auditoría de Protocolos Supabase usando PowerShell
# Conecta via REST API y genera reporte

$SUPABASE_URL = "https://jmwcvcpnzwznxotiplkb.supabase.co"
$SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imptd2N2Y3Buend6bnhvdGlwbGtiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDY4MzM2MSwiZXhwIjoyMDg2MjU5MzYxfQ.qvr2juHfYEk98ilR9Dm09MOehlvh1rN6SinHGCTaEVE"

$headers = @{
    "apikey"        = $SUPABASE_KEY
    "Authorization" = "Bearer $SUPABASE_KEY"
    "Content-Type"  = "application/json"
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "🔍 AUDITORÍA AUTOMÁTICA DE PROTOCOLOS SUPABASE" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar conexión
Write-Host "1️⃣ Verificando conexión a Supabase..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$SUPABASE_URL/rest/v1/" -Headers $headers -Method Get -ErrorAction Stop
    Write-Host "   ✅ Conexión establecida correctamente" -ForegroundColor Green
}
catch {
    Write-Host "   ❌ Error de conexión: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""

# 2. Verificar tabla de protocolos
Write-Host "2️⃣ Consultando tabla 'protocolos_cliente_cra'..." -ForegroundColor Yellow

try {
    $protocolos = Invoke-RestMethod `
        -Uri "$SUPABASE_URL/rest/v1/protocolos_cliente_cra" `
        -Headers $headers `
        -Method Get `
        -ErrorAction Stop
    
    Write-Host "   ✅ Tabla existe" -ForegroundColor Green
    Write-Host "   📊 Total protocolos creados: $($protocolos.Count)" -ForegroundColor Cyan
    
    if ($protocolos.Count -eq 0) {
        Write-Host ""
        Write-Host "   ⚠️  LA TABLA ESTÁ VACÍA - No hay protocolos creados" -ForegroundColor Yellow
        Write-Host "   👉 Necesitas crear los protocolos base" -ForegroundColor Yellow
    }
    else {
        Write-Host ""
        Write-Host "   📋 Protocolos existentes:" -ForegroundColor Cyan
        foreach ($p in $protocolos) {
            $nombre = $p.nombre_protocolo
            $tipo = $p.tipo_servicio
            $criticidad = $p.criticidad
            $activo = if ($p.activo) { "🟢 Activo" } else { "🔴 Inactivo" }
            Write-Host "      • $nombre | Tipo: $tipo | $criticidad | $activo"
        }
    }
    
}
catch {
    Write-Host "   ❌ Error consultando tabla: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   👉 La tabla probablemente NO EXISTE" -ForegroundColor Yellow
    Write-Host "   👉 Ejecuta el script: sql\09_tabla_protocolos.sql" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# 3. Análisis de completitud
Write-Host "3️⃣ Análisis de completitud de protocolos..." -ForegroundColor Yellow

$protocolos_recomendados = @(
    "Protocolo General Salones de Juego",
    "Protocolo General Campos Solares",
    "Protocolo General Empresas",
    "Protocolo Comunicación Cliente",
    "Protocolo Escalado Incidencias",
    "Protocolo Turno Noche",
    "Protocolo Visitas Técnicas"
)

$protocolos_existentes_nombres = $protocolos | ForEach-Object { $_.nombre_protocolo }

Write-Host "   📊 Protocolos recomendados: $($protocolos_recomendados.Count)" -ForegroundColor Cyan
Write-Host "   📊 Protocolos existentes: $($protocolos_existentes_nombres.Count)" -ForegroundColor Cyan
Write-Host ""

$faltantes = @()
foreach ($recomendado in $protocolos_recomendados) {
    $encontrado = $protocolos_existentes_nombres | Where-Object { $_ -like "*$recomendado*" }
    if ($encontrado) {
        Write-Host "   ✅ $recomendado" -ForegroundColor Green
    }
    else {
        Write-Host "   ❌ $recomendado - FALTANTE" -ForegroundColor Red
        $faltantes += $recomendado
    }
}

Write-Host ""
$encontrados = $protocolos_recomendados.Count - $faltantes.Count
Write-Host "   📊 Resumen: $encontrados/$($protocolos_recomendados.Count) protocolos base encontrados" -ForegroundColor Cyan

Write-Host ""

# 4. Análisis de calidad
if ($protocolos.Count -gt 0) {
    Write-Host "4️⃣ Análisis de calidad de protocolos existentes..." -ForegroundColor Yellow
    
    $i = 1
    foreach ($p in $protocolos) {
        $nombre = $p.nombre_protocolo
        Write-Host ""
        Write-Host "   📄 Protocolo #$i : $nombre" -ForegroundColor Cyan
        
        $tiene_cliente = $null -ne $p.cliente_id
        $tiene_tipo = $null -ne $p.tipo_servicio
        $tiene_checklist = ($null -ne $p.checklist) -and ($p.checklist -ne "[]")
        $tiene_acciones = ($null -ne $p.acciones_incidencia) -and ($p.acciones_incidencia -ne "{}")
        $tiene_contactos = ($null -ne $p.contactos_emergencia) -and ($p.contactos_emergencia -ne "[]")
        $tiene_horarios = ($null -ne $p.horarios_operacion) -and ($p.horarios_operacion -ne "{}")
        
        $score = @($tiene_tipo, $tiene_checklist, $tiene_acciones, $tiene_contactos, $tiene_horarios) | Where-Object { $_ } | Measure-Object | Select-Object -ExpandProperty Count
        $total = 5
        
        Write-Host "      Cliente asignado: $(if ($tiene_cliente) { '✅' } else { '❌' })"
        Write-Host "      Tipo servicio: $(if ($tiene_tipo) { '✅' } else { '❌' })"
        Write-Host "      Checklist: $(if ($tiene_checklist) { '✅' } else { '❌' })"
        Write-Host "      Acciones incidencia: $(if ($tiene_acciones) { '✅' } else { '❌' })"
        Write-Host "      Contactos emergencia: $(if ($tiene_contactos) { '✅' } else { '❌' })"
        Write-Host "      Horarios operación: $(if ($tiene_horarios) { '✅' } else { '❌' })"
        
        $porcentaje = [math]::Round(($score / $total) * 100)
        Write-Host "      📊 Completitud: $score/$total ($porcentaje%)" -ForegroundColor $(if ($porcentaje -ge 80) { "Green" } elseif ($porcentaje -ge 50) { "Yellow" } else { "Red" })
        
        $i++
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "✅ AUDITORÍA COMPLETADA" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan

# Guardar reporte
$reporte = @{
    fecha_auditoria         = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    total_protocolos        = $protocolos.Count
    protocolos_recomendados = $protocolos_recomendados.Count
    protocolos_faltantes    = $faltantes
    protocolos_detalle      = $protocolos
} | ConvertTo-Json -Depth 10

$reporte | Out-File -FilePath "reporte_auditoria_protocolos.json" -Encoding UTF8

Write-Host ""
Write-Host "📄 Reporte guardado en: reporte_auditoria_protocolos.json" -ForegroundColor Green
