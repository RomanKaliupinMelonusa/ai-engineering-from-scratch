#!/usr/bin/env bash
set -e

echo "=== Post-create setup ==="

# Verify Python packages
python -c "import numpy; print(f'NumPy {numpy.__version__} OK')"
python -c "import torch; print(f'PyTorch {torch.__version__} OK')"

# Install pnpm globally (if node feature didn't)
if ! command -v pnpm &> /dev/null; then
    npm install -g pnpm
fi

# Verify toolchains
echo ""
echo "Toolchain versions:"
echo "  Python:  $(python --version)"
echo "  Node.js: $(node --version)"
echo "  pnpm:    $(pnpm --version)"
echo "  Rust:    $(rustc --version)"
echo "  Cargo:   $(cargo --version)"
echo "  uv:      $(uv --version)"
echo ""
echo "=== Dev container ready ==="
