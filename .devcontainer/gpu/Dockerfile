FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu22.04

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Base tools + Python 3.12 via deadsnakes PPA (ubuntu 22.04 ships 3.10)
RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common gpg-agent \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y --no-install-recommends \
        python3.12 python3.12-venv python3.12-dev \
        ffmpeg libsndfile1 libgl1 \
        curl wget sudo ca-certificates \
        tmux htop nvtop \
    && rm -rf /var/lib/apt/lists/*

# devcontainer features (node/nvm) use `source` which requires bash, not dash
RUN ln -sf /bin/bash /bin/sh

# Set python3.12 as default python / python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
    && update-alternatives --install /usr/bin/python  python  /usr/bin/python3.12 1

# Install pip for python3.12 (bootstrap is more reliable than python3-pip on 22.04)
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Create the vscode user required by remoteUser in devcontainer.json
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install Python dependencies with GPU PyTorch
COPY requirements.txt /tmp/requirements.txt
# Install torch without bundled NVIDIA pip packages; cuDNN/NCCL/etc. are already
# provided system-wide by the cuda:cudnn-devel base image, and downloading them
# again as pip packages (~3 GB) exhausts Docker Desktop's build storage.
RUN uv pip install --system --break-system-packages --no-cache \
    --extra-index-url https://download.pytorch.org/whl/cu128 \
    --no-deps torch torchvision torchaudio
# Install remaining requirements; torch is already satisfied so the NVIDIA
# runtime pip packages are never pulled as transitive dependencies.
RUN uv pip install --system --break-system-packages --no-cache \
    -r /tmp/requirements.txt
