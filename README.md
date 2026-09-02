# dev-environment

Configuración versionada de mis herramientas de IA para desarrollo: **Claude Code** (`~/.claude`) y **Codex** (`~/.codex`).

Este repo es la fuente de verdad. Las rutas reales que leen las herramientas son symlinks que apuntan acá, así que editar un archivo del repo cambia la config al instante — y `git log` da historial de todo.

## Estructura

```
shared/instructions.md   → instrucciones globales, compartidas por ambas herramientas
claude/                  → settings.json, agents/, skills/, hooks/
codex/                   → config.toml, agents/, automations/
scripts/                 → install / uninstall / status
```

`shared/instructions.md` es un solo archivo enlazado desde **dos** lugares (`~/.claude/CLAUDE.md` y `~/.codex/AGENTS.md`). Antes eran copias idénticas mantenidas a mano; ahora se editan una sola vez.

## Instalación en una máquina nueva

Requiere Windows con **Modo Desarrollador activado** (Configuración → Privacidad y seguridad → Para desarrolladores), que permite crear symlinks sin permisos de administrador.

```powershell
git clone <url-del-repo> F:\Proyectos\dev-environment
cd F:\Proyectos\dev-environment
.\scripts\install.ps1
```

`install.ps1` respalda la config existente en `~/.dotfiles-backup/<timestamp>/` antes de reemplazarla por symlinks. Es idempotente: correrlo dos veces no rompe nada.

Después de instalar, reiniciá Claude Code y Codex.

## Comandos

| Comando | Qué hace |
|---|---|
| `.\scripts\status.ps1` | Muestra qué rutas están enlazadas y cuáles no |
| `.\scripts\install.ps1` | Crea los symlinks (con backup previo) |
| `.\scripts\uninstall.ps1` | Revierte: deja copias reales, desenlaza todo |

## Qué NO está acá

Credenciales y estado local, deliberadamente fuera del control de versiones:

- `~/.claude/.credentials.json` y `~/.codex/auth.json` — tokens de sesión
- `plugins/`, `projects/`, `sessions/`, `cache/`, `telemetry/`, logs — estado local por máquina

Los archivos de configuración que sí están versionados (`settings.json`, `config.toml`) se revisaron: no contienen claves ni tokens, solo preferencias y listas de plugins habilitados.
