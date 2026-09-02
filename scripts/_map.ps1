# Mapa único de enlaces. Dot-sourced por install/uninstall/status.
# Real = ruta que la herramienta lee; Repo = ruta versionada en este repo.

$RepoRoot = Split-Path -Parent $PSScriptRoot
$HomeDir = $env:USERPROFILE

$LinkMap = @(
    # Instrucciones globales compartidas: un solo archivo, dos consumidores
    @{ Real = "$HomeDir\.claude\CLAUDE.md";     Repo = "$RepoRoot\shared\instructions.md"; Type = "File" }
    @{ Real = "$HomeDir\.codex\AGENTS.md";      Repo = "$RepoRoot\shared\instructions.md"; Type = "File" }

    @{ Real = "$HomeDir\.claude\settings.json"; Repo = "$RepoRoot\claude\settings.json";   Type = "File" }
    @{ Real = "$HomeDir\.claude\agents";        Repo = "$RepoRoot\claude\agents";          Type = "Directory" }
    @{ Real = "$HomeDir\.claude\skills";        Repo = "$RepoRoot\claude\skills";          Type = "Directory" }
    @{ Real = "$HomeDir\.claude\hooks";         Repo = "$RepoRoot\claude\hooks";           Type = "Directory" }

    @{ Real = "$HomeDir\.codex\config.toml";    Repo = "$RepoRoot\codex\config.toml";      Type = "File" }
    @{ Real = "$HomeDir\.codex\agents";         Repo = "$RepoRoot\codex\agents";           Type = "Directory" }
    @{ Real = "$HomeDir\.codex\automations";    Repo = "$RepoRoot\codex\automations";      Type = "Directory" }
)

function Test-IsSymlink {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $false }
    return (Get-Item $Path -Force).LinkType -eq "SymbolicLink"
}
