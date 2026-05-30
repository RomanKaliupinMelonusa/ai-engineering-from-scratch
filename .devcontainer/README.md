# Devcontainer Usage Guide

This project supports both CPU and GPU devcontainers. Follow these steps to open the desired environment in VS Code:

## 1. Prerequisites
- Install [Docker](https://www.docker.com/) (with NVIDIA Container Toolkit for GPU support)
- Install [Visual Studio Code](https://code.visualstudio.com/)
- Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## 2. Open the Project in VS Code
- Open the root folder of this repository in VS Code.

## 3. Open the Command Palette
- Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS)
- Type `Dev Containers: Open Folder in Container...` and select it.

## 4. Select the Devcontainer
- VS Code will prompt you to select a devcontainer configuration if multiple are found.
- Choose one of the following:
  - **.devcontainer/cpu** — for CPU-only development (default, works everywhere)
  - **.devcontainer/gpu** — for GPU-accelerated development (requires NVIDIA GPU and drivers)

## 5. Wait for Build and Attach
- VS Code will build the selected container and attach your workspace.
- The first build may take several minutes.

## 6. Verify
- Open a terminal in VS Code and run:
  - `python -c "import torch; print(torch.cuda.is_available())"`
- This should print `True` in the GPU container, `False` in the CPU container.

## Troubleshooting
- For GPU: Ensure you have a supported NVIDIA GPU, drivers, and Docker with NVIDIA Container Toolkit installed.
- If you do not see the selection prompt, use `Dev Containers: Reopen in Container` and select the desired config.

---
For more details, see the official [VS Code Dev Containers documentation](https://code.visualstudio.com/docs/devcontainers/containers).

## Troubleshooting: Disk space and Docker credential helper

When the Dev Containers extension fails during server install or when pulling images, two common causes are:

- **No space left on device** inside the Docker/WSL distribution (seen as `tar: write error: No space left on device`).
- **Missing Docker credential helper** (seen as `error getting credentials - err: exec: "docker-credential-desktop": executable file not found in %PATH%`).

Quick remedies:

- Free Docker/WSL disk space:

  - Windows PowerShell (run as admin):

    ```powershell
    # Remove unused images, containers, networks and volumes (destructive)
    docker system prune -a --volumes

    # Shutdown WSL so Docker Desktop can reclaim space
    wsl --shutdown
    ```

  - Or open Docker Desktop > Settings > Resources and increase disk/WSL disk size.

- Fix the Docker credential helper on Windows:

  - Ensure `docker-credential-desktop.exe` exists under `C:\Program Files\Docker\Docker\resources\bin` and that folder is in your `PATH`.
  - If it's missing or broken, reinstall Docker Desktop (installer restores the credential helper).
  - To add the folder to your system PATH without reinstalling (run PowerShell as **Admin**):

    ```powershell
    $dockerBin = "C:\Program Files\Docker\Docker\resources\bin"
    $current = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    if ($current -notlike "*$dockerBin*") {
        [Environment]::SetEnvironmentVariable("PATH", "$current;$dockerBin", "Machine")
        Write-Host "Added Docker bin to system PATH. Restart VS Code to apply."
    } else {
        Write-Host "Docker bin already in PATH."
    }

If you'd like an automated check, see the scripts in `.devcontainer/scripts` for diagnostics you can run locally before re-opening the container.
