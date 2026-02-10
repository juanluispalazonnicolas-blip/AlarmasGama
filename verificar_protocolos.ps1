$url = "https://jmwcvcpnzwznxotiplkb.supabase.co/rest/v1/protocolos_cliente_cra"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imptd2N2Y3Buend6bnhvdGlwbGtiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDY4MzM2MSwiZXhwIjoyMDg2MjU5MzYxfQ.qvr2juHfYEk98ilR9Dm09MOehlvh1rN6SinHGCTaEVE"

$headers = @{
    "apikey"        = $key
    "Authorization" = "Bearer $key"
}

Write-Host "🔍 Verificando protocolos creados..." -ForegroundColor Cyan
Write-Host ""

try {
    $protocolos = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    
    Write-Host "✅ RESULTADO:" -ForegroundColor Green
    Write-Host "   Total protocolos: $($protocolos.Count)" -ForegroundColor Yellow
    Write-Host ""
    
    if ($protocolos.Count -eq 0) {
        Write-Host "❌ No se encontraron protocolos" -ForegroundColor Red
        Write-Host "   El script no se ejecutó correctamente o hubo un error" -ForegroundColor Red
    }
    else {
        Write-Host "📋 Protocolos creados:" -ForegroundColor Cyan
        Write-Host ""
        
        $i = 1
        foreach ($p in $protocolos) {
            $nombre = $p.nombre_protocolo
            $tipo = $p.tipo_servicio
            $criticidad = $p.criticidad
            $activo = if ($p.activo) { "🟢" } else { "🔴" }
            
            # Verificar completitud
            $tiene_checklist = ($null -ne $p.checklist) -and ($p.checklist -ne "[]")
            $tiene_acciones = ($null -ne $p.acciones_incidencia) -and ($p.acciones_incidencia -ne "{}")
            $tiene_contactos = ($null -ne $p.contactos_emergencia) -and ($p.contactos_emergencia -ne "[]")
            $tiene_horarios = ($null -ne $p.horarios_operacion) -and ($p.horarios_operacion -ne "{}")
            
            $completitud = @($tiene_checklist, $tiene_acciones, $tiene_contactos, $tiene_horarios) | Where-Object { $_ } | Measure-Object | Select-Object -ExpandProperty Count
            $porcentaje = [math]::Round(($completitud / 4) * 100)
            
            Write-Host "   $i. $nombre" -ForegroundColor White
            Write-Host "      Tipo: $tipo | Criticidad: $criticidad | $activo" -ForegroundColor Gray
            Write-Host "      Completitud: $completitud/4 ($porcentaje%)" -ForegroundColor $(if ($porcentaje -ge 75) { "Green" } else { "Yellow" })
            Write-Host ""
            
            $i++
        }
        
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        
        if ($protocolos.Count -eq 7) {
            Write-Host "🎉 ¡PERFECTO! Todos los protocolos base creados" -ForegroundColor Green
        }
        elseif ($protocolos.Count -gt 0) {
            Write-Host "⚠️  Se crearon $($protocolos.Count) protocolos (esperados: 7)" -ForegroundColor Yellow
        }
    }
    
}
catch {
    Write-Host "❌ Error consultando Supabase: $($_.Exception.Message)" -ForegroundColor Red
}
