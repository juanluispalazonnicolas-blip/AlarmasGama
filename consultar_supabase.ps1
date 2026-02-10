$url = "https://jmwcvcpnzwznxotiplkb.supabase.co/rest/v1/protocolos_cliente_cra"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imptd2N2Y3Buend6bnhvdGlwbGtiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDY4MzM2MSwiZXhwIjoyMDg2MjU5MzYxfQ.qvr2juHfYEk98ilR9Dm09MOehlvh1rN6SinHGCTaEVE"

$headers = @{
    "apikey"        = $key
    "Authorization" = "Bearer $key"
}

Write-Host "Consultando Supabase..." -ForegroundColor Cyan

try {
    $result = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    $result | ConvertTo-Json -Depth 10 | Out-File "protocolos_supabase.json" -Encoding UTF8
    
    Write-Host "✅ Consulta exitosa" -ForegroundColor Green
    Write-Host "Total protocolos: $($result.Count)" -ForegroundColor Yellow
    Write-Host "Resultados guardados en: protocolos_supabase.json" -ForegroundColor Cyan
    
}
catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}
