FROM mcr.microsoft.com/devcontainers/python:1-3.12-bookworm

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# System dependencies for audio/image processing
# Remove yarn repo with expired GPG key from base image
RUN rm -f /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libsndfile1 \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies with uv (CPU-only PyTorch to save ~1.5GB)
COPY requirements.txt /tmp/requirements.txt
RUN uv pip install --system --break-system-packages --no-cache \
    --extra-index-url https://download.pytorch.org/whl/cpu \
    -r /tmp/requirements.txt
