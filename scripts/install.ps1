# Reemplaza las configs reales por symlinks a este repo.
# Idempotente: si algo ya está enlazado, lo saltea.
# Hace backup de todo lo que toca antes de tocarlo.

$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_map.ps1"

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupRoot = "$HomeDir\.dotfiles-backup\$stamp"

$linked = @(); $skipped = @(); $failed = @()

foreach ($entry in $LinkMap) {
    $real = $entry.Real
    $repo = $entry.Repo
    $name = Split-Path $real -Leaf
    $tool = Split-Path (Split-Path $real -Parent) -Leaf

    if (-not (Test-Path $repo)) {
        $failed += "$tool/$name - no existe en el repo: $repo"
        continue
    }

    if (Test-IsSymlink $real) {
        $skipped += "$tool/$name - ya es symlink"
        continue
    }

    try {
        if (Test-Path $real) {
            $dest = Join-Path $backupRoot $tool
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
            Copy-Item $real (Join-Path $dest $name) -Recurse -Force
            Remove-Item $real -Recurse -Force
        }
        New-Item -ItemType SymbolicLink -Path $real -Target $repo -Force | Out-Null
        $linked += "$tool/$name"
    } catch {
        $failed += "$tool/$name - $($_.Exception.Message)"
    }
}

Write-Host ""
Write-Host "=== Enlazados ($($linked.Count)) ===" -ForegroundColor Green
$linked | ForEach-Object { Write-Host "  + $_" }
if ($skipped.Count) {
    Write-Host "=== Saltados ($($skipped.Count)) ===" -ForegroundColor DarkGray
    $skipped | ForEach-Object { Write-Host "  = $_" }
}
if ($failed.Count) {
    Write-Host "=== Fallaron ($($failed.Count)) ===" -ForegroundColor Red
    $failed | ForEach-Object { Write-Host "  ! $_" }
}
if (Test-Path $backupRoot) {
    Write-Host ""
    Write-Host "Backup en: $backupRoot" -ForegroundColor Yellow
}
Write-Host ""
Write-Host "Reinicia Claude Code y Codex para que tomen la config enlazada." -ForegroundColor Cyan
