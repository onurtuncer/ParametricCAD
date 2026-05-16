# bootstrap.ps1
# Verifies prerequisites for ParametricCAD and prints the next steps.
# Dependencies are managed by vcpkg — no git submodules to initialise.
#
# Prerequisites:
#   - vcpkg installed and VCPKG_ROOT set in your environment
#     https://learn.microsoft.com/en-us/vcpkg/get_started/get-started
#   - CMake 3.25+
#   - Visual Studio 2022 with C++ workload
#
# Usage (from repo root in PowerShell):
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#   .\bootstrap.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path "$PSScriptRoot"
Set-Location $RepoRoot

Write-Host "================================================"
Write-Host "=         ParametricCAD - Bootstrap            ="
Write-Host "================================================"
Write-Host ""

# ── Tool checks ───────────────────────────────────────────────────────────────
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git not found on PATH. Install Git for Windows: https://git-scm.com"
    exit 1
}
Write-Host "==> Found $(git --version)"

if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Error "cmake not found on PATH. Install CMake 3.25+: https://cmake.org/download"
    exit 1
}
Write-Host "==> Found $(cmake --version | Select-Object -First 1)"

# ── vcpkg check ───────────────────────────────────────────────────────────────
Write-Host ""
if (-not $env:VCPKG_ROOT) {
    Write-Host "WARNING: VCPKG_ROOT is not set." -ForegroundColor Yellow
    Write-Host "  Install vcpkg and set VCPKG_ROOT before configuring:" -ForegroundColor Yellow
    Write-Host "    git clone https://github.com/microsoft/vcpkg C:\vcpkg" -ForegroundColor Yellow
    Write-Host "    C:\vcpkg\bootstrap-vcpkg.bat -disableMetrics" -ForegroundColor Yellow
    Write-Host "    [Environment]::SetEnvironmentVariable('VCPKG_ROOT', 'C:\vcpkg', 'User')" -ForegroundColor Yellow
} else {
    $vcpkgExe = Join-Path $env:VCPKG_ROOT "vcpkg.exe"
    if (Test-Path $vcpkgExe) {
        Write-Host "==> Found vcpkg at $env:VCPKG_ROOT"
        Write-Host "    $( & $vcpkgExe version 2>$null | Select-Object -First 1 )"
    } else {
        Write-Host "WARNING: VCPKG_ROOT is set to $env:VCPKG_ROOT but vcpkg.exe not found." -ForegroundColor Yellow
        Write-Host "  Run: $env:VCPKG_ROOT\bootstrap-vcpkg.bat -disableMetrics" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "vcpkg will automatically install all dependencies listed in vcpkg.json"
Write-Host "the first time you run cmake --preset. Subsequent runs use the binary cache."
Write-Host ""

Write-Host "Bootstrap complete. Next steps:"
Write-Host ""
Write-Host "  Build (MSVC Debug):"
Write-Host "    cmake --preset windows-msvc-debug"
Write-Host "    cmake --build build/windows-msvc-debug"
Write-Host ""
Write-Host "  Run tests:"
Write-Host "    ctest --preset windows-msvc-debug"
Write-Host ""
Write-Host "  Build docs (optional):"
Write-Host "    .\docs\venv-setup.ps1"
Write-Host "    .\.venv\Scripts\Activate.ps1"
Write-Host "    cmake --preset docs"
Write-Host "    cmake --build build/docs --target docs"
