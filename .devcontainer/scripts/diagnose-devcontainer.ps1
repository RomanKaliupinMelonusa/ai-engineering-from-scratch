<#
.SYNOPSIS
  Diagnostic helper for Windows to check Docker, WSL, and docker-credential-desktop.
#>

Write-Host "=== Devcontainer diagnostics (PowerShell) ===" -ForegroundColor Cyan

try {
    docker version | Out-String | Write-Host
} catch {
    Write-Host "Docker CLI not found or Docker not running." -ForegroundColor Yellow
}

Write-Host "`n-- Docker system df --"
try { docker system df | Out-String | Write-Host } catch { }

Write-Host "`n-- WSL distributions --"
try { wsl -l -v | Out-String | Write-Host } catch { }

Write-Host "`n-- Check docker-desktop disk usage (may require Docker Desktop) --"
try {
    $distros = wsl -l -v 2>$null
    if ($distros -match 'docker-desktop') {
        wsl -d docker-desktop -- df -h / 2>$null | Out-String | Write-Host
    } else {
        Write-Host "docker-desktop distro not present; skipping disk check"
    }
} catch { }

Write-Host "`n-- Credential helper check --"
$possible = @(
    "$Env:ProgramFiles\Docker\Docker\resources\bin\docker-credential-desktop.exe",
    "$Env:ProgramFiles(x86)\Docker\Docker\resources\bin\docker-credential-desktop.exe"
)
$found = $false
foreach ($p in $possible) {
    if (Test-Path $p) { Write-Host "Found: $p"; $found = $true }
}
if (-not $found) {
    Write-Host "docker-credential-desktop.exe not found in common locations." -ForegroundColor Yellow
    Write-Host "If missing, reinstall Docker Desktop or add the resources\bin folder to your PATH." -ForegroundColor Yellow
} else {
    Write-Host "If Docker still reports credential helper missing, ensure the folder is in your PATH." -ForegroundColor Green
}

Write-Host "`nSuggested fixes:" -ForegroundColor Cyan
Write-Host " 1) Run (PowerShell as admin): `"docker system prune -a --volumes`"" -ForegroundColor White
Write-Host " 2) Restart Docker Desktop or run: `"wsl --shutdown`"" -ForegroundColor White
Write-Host " 3) Reinstall Docker Desktop if credential helper is missing" -ForegroundColor White

Write-Host "`nDone." -ForegroundColor Cyan
