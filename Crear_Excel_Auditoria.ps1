$OutputPath = "c:\Users\Juan Luis\.gemini\antigravity\scratch\Alarmas Gama\Auditoria_Salones_CCTV.xlsx"

Write-Host "Creando archivo Excel..." -ForegroundColor Cyan

try {
    $Excel = New-Object -ComObject Excel.Application
    $Excel.Visible = $false
    $Excel.DisplayAlerts = $false
    
    $Workbook = $Excel.Workbooks.Add()
    $Worksheet = $Workbook.Worksheets.Item(1)
    $Worksheet.Name = "Auditoria Salones"
    
    # Encabezados
    $Headers = "Nº", "Abonado", "Cliente", "Ubicacion", "Estado Visionado", "IP/Dominio", "Puerto HTTP", "Puerto RTSP", "Puerto Servidor", "P2P ID", "Usuario", "Contraseña", "Modelo DVR", "Num Camaras Total", "Num Camaras OK", "Software CRA", "Tel Responsable", "Tel Informatico", "Proveedor Internet", "Velocidad Mbps", "Ultima Conexion", "Problemas Detectados", "Acciones Requeridas", "Prioridad", "Garantia", "Fin Garantia", "Completado"
    
    for ($i = 0; $i -lt $Headers.Length; $i++) {
        $Worksheet.Cells.Item(1, $i + 1) = $Headers[$i]
    }
    
    # Formato de encabezados
    $HeaderRange = $Worksheet.Range("A1", $Worksheet.Cells.Item(1, $Headers.Length))
    $HeaderRange.Interior.Color = 14852594
    $HeaderRange.Font.Color = 16777215
    $HeaderRange.Font.Bold = $true
    $HeaderRange.HorizontalAlignment = -4108
    $Worksheet.Rows.Item(1).RowHeight = 30
    
    # Añadir datos
    for ($salon = 1; $salon -le 58; $salon++) {
        $row = $salon + 1
        $Worksheet.Cells.Item($row, 1) = $salon
        $Worksheet.Cells.Item($row, 11) = "admin"
        
        if ($salon -eq 17 -or $salon -eq 43) {
            $Worksheet.Cells.Item($row, 5) = "Visible"
            $Worksheet.Cells.Item($row, 24) = "Baja"
            $Worksheet.Cells.Item($row, 25) = "Si"
            $Worksheet.Cells.Item($row, 27) = "Si"
        }
        else {
            $Worksheet.Cells.Item($row, 5) = "No visible"
            $Worksheet.Cells.Item($row, 24) = "Media"
            $Worksheet.Cells.Item($row, 25) = "No"
            $Worksheet.Cells.Item($row, 27) = "No"
        }
    }
    
    # Aplicar colores
    for ($row = 2; $row -le 59; $row += 2) {
        $Worksheet.Range($Worksheet.Cells.Item($row, 1), $Worksheet.Cells.Item($row, 5)).Interior.Color = 15071983
        $Worksheet.Range($Worksheet.Cells.Item($row, 6), $Worksheet.Cells.Item($row, 10)).Interior.Color = 16774638
        $Worksheet.Range($Worksheet.Cells.Item($row, 11), $Worksheet.Cells.Item($row, 16)).Interior.Color = 13041663
        $Worksheet.Range($Worksheet.Cells.Item($row, 17), $Worksheet.Cells.Item($row, 19)).Interior.Color = 11927295
        $Worksheet.Range($Worksheet.Cells.Item($row, 20), $Worksheet.Cells.Item($row, 27)).Interior.Color = 16053485
    }
    
    # Ajustar anchos
    $Worksheet.Columns.Item(1).ColumnWidth = 5
    $Worksheet.Columns.Item(2).ColumnWidth = 12
    $Worksheet.Columns.Item(3).ColumnWidth = 20
    $Worksheet.Columns.Item(4).ColumnWidth = 25
    $Worksheet.Columns.Item(5).ColumnWidth = 15
    $Worksheet.Columns.Item(22).ColumnWidth = 30
    $Worksheet.Columns.Item(23).ColumnWidth = 30
    
    # Congelar y filtros
    $Worksheet.Application.ActiveWindow.SplitRow = 1
    $Worksheet.Application.ActiveWindow.FreezePanes = $true
    $DataRange = $Worksheet.Range("A1", $Worksheet.Cells.Item(59, 27))
    $DataRange.AutoFilter() | Out-Null
    
    # Guardar
    if (Test-Path $OutputPath) { Remove-Item $OutputPath -Force }
    $Workbook.SaveAs($OutputPath)
    $Workbook.Close($false)
    $Excel.Quit()
    
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Worksheet) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Workbook) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) | Out-Null
    [System.GC]::Collect()
    
    Write-Host "Excel creado exitosamente: $OutputPath" -ForegroundColor Green
    Start-Process $OutputPath
    
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
