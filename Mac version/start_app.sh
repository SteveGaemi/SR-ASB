#!/bin/bash
 
set -e
cd "$(dirname "$0")"
 
# Use embedded Julia and Python locally
export PYTHONCALL_JULIA_EXE="$PWD/julia/bin/julia"
export JULIA_PYTHONCALL_EXE="$PWD/julia/bin/julia"
PYTHON="$PWD/Python/bin/python3"
 
 
# PORT=5000
 
# ✅ Stop any process already using port 5000
# PIDS=$(lsof -ti :$PORT)
#if [ -n "$PIDS" ]; then
#  echo "⚠️ Port $PORT is already in use. Terminating process(es): $PIDS"
#  kill -9 $PIDS
#  sleep 1
#fi
 
# Check frontend build
if [ ! -f frontend/build/index.html ]; then
  echo "❌ Frontend not built. Run ./install.sh first."
  exit 1
fi
 
# Start Flask backend in background
echo "🚀 Starting Flask backend..."
Python/bin/python3 backend/main.py
 
# Wait for backend to start
sleep 5
 
# Open frontend in default browser
open http://localhost:5000