# Revierte: reemplaza cada symlink por una copia real del contenido del repo.
# Deja la maquina como si el repo no existiera. El repo queda intacto.

$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_map.ps1"

$restored = @(); $skipped = @(); $failed = @()

foreach ($entry in $LinkMap) {
    $real = $entry.Real
    $repo = $entry.Repo
    $name = Split-Path $real -Leaf
    $tool = Split-Path (Split-Path $real -Parent) -Leaf

    if (-not (Test-IsSymlink $real)) {
        $skipped += "$tool/$name - no es symlink, no se toca"
        continue
    }

    try {
        Remove-Item $real -Force -Recurse
        Copy-Item $repo $real -Recurse -Force
        $restored += "$tool/$name"
    } catch {
        $failed += "$tool/$name - $($_.Exception.Message)"
    }
}

Write-Host ""
Write-Host "=== Restaurados como archivos reales ($($restored.Count)) ===" -ForegroundColor Green
$restored | ForEach-Object { Write-Host "  + $_" }
if ($skipped.Count) {
    Write-Host "=== Saltados ($($skipped.Count)) ===" -ForegroundColor DarkGray
    $skipped | ForEach-Object { Write-Host "  = $_" }
}
if ($failed.Count) {
    Write-Host "=== Fallaron ($($failed.Count)) ===" -ForegroundColor Red
    $failed | ForEach-Object { Write-Host "  ! $_" }
}
Write-Host ""
Write-Host "El repo en $RepoRoot quedo intacto." -ForegroundColor Cyan
