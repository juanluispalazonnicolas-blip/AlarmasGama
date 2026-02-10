$pdfPath = "c:\Users\Juanlu\Desktop\ALARMAS GAMA\PROTOCOLOS GAMA SEGURIDAD.pdf"
$bytes = [System.IO.File]::ReadAllBytes($pdfPath)
$rawText = [System.Text.Encoding]::GetEncoding("iso-8859-1").GetString($bytes)

# Extract text between parentheses (PDF text objects)
$allMatches = [regex]::Matches($rawText, '\(([^\)]{2,500})\)')

$result = @()
foreach ($m in $allMatches) {
    $val = $m.Groups[1].Value.Trim()
    if ($val.Length -gt 1 -and $val -match '[a-zA-Z0-9]') {
        $result += $val
    }
}

$output = $result -join "`n"
if ($output.Length -gt 0) {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    Write-Output $output
}
else {
    Write-Output "No se pudo extraer texto. El PDF puede ser imagen escaneada."
}
