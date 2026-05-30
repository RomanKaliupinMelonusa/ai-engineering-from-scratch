#!/usr/bin/env bash
set -e

echo "=== Devcontainer diagnostics ==="

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker CLI not found in PATH. Install Docker Desktop and retry."
  exit 1
fi

echo "\n-- Docker version --"
docker version || true

echo "\n-- Docker system df --"
docker system df || true

echo "\n-- Docker info (summary) --"
docker info --format '{{json .}}' 2>/dev/null || true

if command -v wsl >/dev/null 2>&1; then
  echo "\n-- WSL distributions --"
  wsl -l -v || true
  echo "\n-- docker-desktop disk usage (may require Docker Desktop running) --"
  if wsl -l -v | grep -qi docker-desktop; then
    wsl -d docker-desktop -- df -h / || echo "Could not query docker-desktop disk usage"
  else
    echo "docker-desktop distro not present; skipping WSL disk check"
  fi
fi

echo "\n-- Credential helper check --"
if command -v docker-credential-desktop >/dev/null 2>&1; then
  echo "docker-credential-desktop is on PATH"
else
  echo "docker-credential-desktop NOT found on PATH. On Windows check: C:\\Program Files\\Docker\\Docker\\resources\\bin"
fi

echo "\nSuggested next steps if you saw 'No space left on device' or credential helper errors:"
echo " 1) Run: docker system prune -a --volumes  # destroys unused images/containers/volumes"
echo " 2) Restart Docker Desktop / run: wsl --shutdown"
echo " 3) Reinstall Docker Desktop if docker-credential-desktop is missing"

echo "\nDone."
exit 0
