#!/bin/bash
set -e

echo "========================================================"
echo "  Symbolic Regression App - Full Setup (macOS)"
echo "========================================================"

INSTALL_DIR=$(pwd)

# -----------------------------
# Step 1: Install Embedded Python
# -----------------------------
if [ ! -f Python/bin/python3 ]; then
  echo "[1/6] Downloading and installing Python..."
  PYTHON_VERSION="3.11.8"
  PYTHON_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/python-${PYTHON_VERSION}-macos11.pkg"

  curl -L "$PYTHON_URL" -o python.pkg
  sudo installer -pkg python.pkg -target /
  rm python.pkg

  echo "[1b] Creating local Python directory..."

  PYTHON_BIN=$(python3 -c 'import os, sys; print(os.path.realpath(sys.executable))')
  mkdir -p Python/bin

  cp "$PYTHON_BIN" Python/bin/python3

  if command -v pip3 >/dev/null 2>&1; then
      cp "$(which pip3)" Python/bin/pip3 || echo "⚠️ pip3 not copied (non-fatal)"
  fi

  ./Python/bin/python3 --version
fi

# -----------------------------
# Step 2: Ensure pip is installed
# -----------------------------
if [ ! -f Python/bin/pip3 ]; then
  echo "[2/6] Installing pip..."
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  Python/bin/python3 get-pip.py
  rm get-pip.py
fi

# -----------------------------
# Step 3: Install Python dependencies
# -----------------------------
echo "[3/6] Installing Python packages..."
Python/bin/python3 -m pip install --upgrade pip setuptools wheel
Python/bin/python3 -m pip install -r requirements.txt

# echo "🧹 Reinstalling NumPy and SciPy to avoid MKL..."
# $PYTHON -m pip uninstall -y numpy scipy
# $PYTHON -m pip install numpy==1.24.4 scipy==1.10.1


# -----------------------------
# Step 4: Install Julia locally
# -----------------------------
if [ ! -f julia/bin/julia ]; then
  echo "[4/6] Downloading Julia 1.9.4..."
  JULIA_VERSION="1.9.4"
  if [[ $(uname -m) == "arm64" ]]; then
    JULIA_URL="https://julialang-s3.julialang.org/bin/mac/aarch64/1.9/julia-${JULIA_VERSION}-macaarch64.tar.gz"
  else
    JULIA_URL="https://julialang-s3.julialang.org/bin/mac/x64/1.9/julia-${JULIA_VERSION}-mac64.tar.gz"
  fi

  curl -L "$JULIA_URL" -o julia.tar.gz
  tar -xzf julia.tar.gz
  rm julia.tar.gz
  JULIA_DIR=$(find . -maxdepth 1 -type d -name "julia-*" | head -n 1)
  mv "$JULIA_DIR" julia
fi

# -----------------------------
# Step 5: Install Julia packages
# -----------------------------
echo "[5/6] Installing Julia packages..."
cat <<EOF > install_julia_packages.jl
import Pkg
Pkg.Registry.update()
Pkg.add("PythonCall")
Pkg.add("SymbolicRegression")
Pkg.precompile()
EOF
./julia/bin/julia install_julia_packages.jl
rm install_julia_packages.jl

# -----------------------------
# Step 6: Install Node.js and Build Frontend
# -----------------------------
if [ ! -f nodejs/bin/node ]; then
  echo "[6/6] Downloading Node.js..."
  NODE_VERSION="v18.18.2"
  ARCH=$(uname -m)
  if [ "$ARCH" == "arm64" ]; then
    NODE_DISTRO="darwin-arm64"
  else
    NODE_DISTRO="darwin-x64"
  fi
  NODE_TAR="node-${NODE_VERSION}-${NODE_DISTRO}.tar.gz"
  NODE_URL="https://nodejs.org/dist/${NODE_VERSION}/${NODE_TAR}"

  curl -L "$NODE_URL" -o node.tar.gz
  tar -xzf node.tar.gz
  rm node.tar.gz
  mv "node-${NODE_VERSION}-${NODE_DISTRO}" nodejs
fi

export PATH="$INSTALL_DIR/nodejs/bin:$PATH"
NPM_CMD="$INSTALL_DIR/nodejs/bin/npm"

if [ ! -f "$NPM_CMD" ]; then
  echo "❌ npm not found. Node.js setup failed."
  exit 1
fi

if [ -f frontend/package.json ]; then
  echo "Building frontend..."
  cd frontend
  "$NPM_CMD" install
  "$NPM_CMD" run build
  cd "$INSTALL_DIR"
else
  echo "❌ frontend/package.json not found."
  exit 1
fi

echo
echo "✅ All installations complete!"
echo "▶️ You can now run ./start_app.sh"
