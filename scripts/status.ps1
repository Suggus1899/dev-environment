# Muestra el estado de cada ruta: enlazada al repo, archivo real, o ausente.

. "$PSScriptRoot\_map.ps1"

$rows = foreach ($entry in $LinkMap) {
    $real = $entry.Real
    $short = $real.Replace($HomeDir, "~")

    if (-not (Test-Path $real)) {
        $estado = "AUSENTE"; $apunta = "-"
    } elseif (Test-IsSymlink $real) {
        $target = (Get-Item $real -Force).Target
        if ($target -eq $entry.Repo) {
            $estado = "enlazado"; $apunta = $target.Replace($RepoRoot, "<repo>")
        } else {
            $estado = "SYMLINK A OTRO LADO"; $apunta = $target
        }
    } else {
        $estado = "archivo real (sin enlazar)"; $apunta = "-"
    }

    [PSCustomObject]@{ Ruta = $short; Estado = $estado; Apunta = $apunta }
}

$rows | Format-Table -AutoSize

$pend = ($rows | Where-Object { $_.Estado -ne "enlazado" }).Count
if ($pend -eq 0) {
    Write-Host "Todo enlazado correctamente." -ForegroundColor Green
} else {
    Write-Host "$pend ruta(s) sin enlazar - corre scripts\install.ps1" -ForegroundColor Yellow
}
