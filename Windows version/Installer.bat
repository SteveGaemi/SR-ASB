@echo off
setlocal enabledelayedexpansion
title Installing Symbolic Regression App (Python + Julia + Node + Frontend)
echo ========================================================
echo   Symbolic Regression App - Full Setup
echo ========================================================

set INSTALL_DIR=%cd%

REM -----------------------------
REM Step 1: Install Embedded Python
REM -----------------------------
if not exist Python\python.exe (
    echo [1/6] Downloading embedded Python...
    powershell -Command "Invoke-WebRequest https://www.python.org/ftp/python/3.11.8/python-3.11.8-embed-amd64.zip -OutFile python_embed.zip"

    echo [2/6] Extracting Python...
    powershell -Command "Expand-Archive python_embed.zip -DestinationPath Python"
    del python_embed.zip

    REM Enable standard library loading
    echo import site>>Python\python311._pth
)

REM -----------------------------
REM Step 2: Install pip manually
REM -----------------------------
if not exist Python\Scripts\pip.exe (
    echo [3/6] Installing pip...
    powershell -Command "Invoke-WebRequest https://bootstrap.pypa.io/get-pip.py -OutFile get-pip.py"
    Python\python.exe get-pip.py
    del get-pip.py
)

REM -----------------------------
REM Step 3: Install Python dependencies
REM -----------------------------
echo [4/6] Installing Python packages...
Python\python.exe -m pip install --upgrade pip
Python\python.exe -m pip install -r requirements.txt

REM -----------------------------
REM Step 4: Download and extract Julia
REM -----------------------------
if not exist julia\bin\julia.exe (
    echo [5/6] Downloading Julia 1.9.4...
    powershell -Command "Invoke-WebRequest https://julialang-s3.julialang.org/bin/winnt/x64/1.9/julia-1.9.4-win64.zip -OutFile julia.zip"

    echo Extracting Julia...
    powershell -Command "Expand-Archive -Path julia.zip -DestinationPath ."

    REM Wait until extraction completes
    :wait_julia
    if not exist "julia-1.9.4\bin\julia.exe" (
        timeout /t 1 >nul
        goto wait_julia
    )

    ren "julia-1.9.4" julia
    del julia.zip
)

if not exist julia\bin\julia.exe (
    echo ❌ Julia installation failed or was not extracted properly.
    pause
    exit /b
)

REM -----------------------------
REM Step 5: Install Julia packages
REM -----------------------------
echo [6/6] Installing Julia packages...
echo import Pkg > install_julia_packages.jl
echo Pkg.add("PythonCall") >> install_julia_packages.jl
echo Pkg.add("SymbolicRegression") >> install_julia_packages.jl
julia\bin\julia.exe install_julia_packages.jl
del install_julia_packages.jl

REM -----------------------------
REM Step 6: Install Node.js and Build Frontend
REM -----------------------------
if not exist "nodejs\node.exe" (
    echo [7/8] Downloading embedded Node.js...
    powershell -Command "Invoke-WebRequest https://nodejs.org/dist/v18.18.2/node-v18.18.2-win-x64.zip -OutFile node.zip"

    echo Extracting Node.js...
    powershell -Command "Expand-Archive node.zip -DestinationPath node_temp"
    del node.zip

    if exist "node_temp\node-v18.18.2-win-x64\node.exe" (
        echo Moving Node.js to local folder...
        mkdir nodejs
        xcopy /E /I /Y "node_temp\node-v18.18.2-win-x64\*" "nodejs\"
        rmdir /S /Q node_temp
    ) else (
        echo ❌ Extraction failed or unexpected folder structure.
        pause
        exit /b
    )
)

set "NODE_PATH=%cd%\nodejs"
set PATH=%NODE_PATH%;%PATH%
set "NPM_CMD=%NODE_PATH%\npm.cmd"

if not exist "%NPM_CMD%" (
    echo ❌ npm.cmd not found — Node.js setup failed.
    pause
    exit /b
)

if exist "frontend\package.json" (
    echo [8/8] Building frontend...

    cd frontend

    echo Running npm install...
    call "%NPM_CMD%" install
    if errorlevel 1 (
        echo ❌ npm install failed.
        pause
        exit /b
    )

    echo Running npm run build...
    call "%NPM_CMD%" run build
    if errorlevel 1 (
        echo ❌ npm run build failed.
        pause
        exit /b
    )

    cd ..
) else (
    echo ❌ frontend\package.json not found.
    pause
    exit /b
)

echo.
echo ✅ All installations complete!
echo ▶️ You can now run start_app.bat
pause
endlocal
