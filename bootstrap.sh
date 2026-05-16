#!/usr/bin/env bash
# bootstrap.sh
# Verifies prerequisites for ParametricCAD and prints the next steps.
# Dependencies are managed by vcpkg — no git submodules to initialise.
#
# Prerequisites:
#   - vcpkg installed and VCPKG_ROOT set in your environment
#     https://learn.microsoft.com/en-us/vcpkg/get_started/get-started
#   - CMake 3.25+
#   - GCC or Clang + Ninja
#
# Usage:
#   chmod +x bootstrap.sh
#   ./bootstrap.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${REPO_ROOT}"

echo "╔══════════════════════════════════════════════╗"
echo "║         ParametricCAD — Bootstrap            ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# ── Tool checks ───────────────────────────────────────────────────────────────
if ! command -v git &>/dev/null; then
    echo "ERROR: git not found on PATH." >&2
    exit 1
fi
echo "==> Found $(git --version)"

if ! command -v cmake &>/dev/null; then
    echo "ERROR: cmake not found on PATH. Install CMake 3.25+." >&2
    exit 1
fi
echo "==> Found $(cmake --version | head -1)"

# ── vcpkg check ───────────────────────────────────────────────────────────────
echo ""
if [[ -z "${VCPKG_ROOT:-}" ]]; then
    echo "WARNING: VCPKG_ROOT is not set."
    echo "  Install vcpkg and set VCPKG_ROOT before configuring:"
    echo "    git clone https://github.com/microsoft/vcpkg ~/vcpkg"
    echo "    ~/vcpkg/bootstrap-vcpkg.sh -disableMetrics"
    echo "    export VCPKG_ROOT=\$HOME/vcpkg   # add to ~/.bashrc or ~/.profile"
elif [[ -x "${VCPKG_ROOT}/vcpkg" ]]; then
    echo "==> Found vcpkg at ${VCPKG_ROOT}"
    echo "    $("${VCPKG_ROOT}/vcpkg" version 2>/dev/null | head -1 || true)"
else
    echo "WARNING: VCPKG_ROOT=${VCPKG_ROOT} but vcpkg binary not found."
    echo "  Run: ${VCPKG_ROOT}/bootstrap-vcpkg.sh -disableMetrics"
fi

echo ""
echo "vcpkg will automatically install all dependencies listed in vcpkg.json"
echo "the first time you run cmake --preset. Subsequent runs use the binary cache."
echo ""

echo "Bootstrap complete. Next steps:"
echo ""
echo "  Build (debug):"
echo "    cmake --preset linux-debug"
echo "    cmake --build build/linux-debug"
echo ""
echo "  Run tests:"
echo "    ctest --preset linux-debug"
echo ""
echo "  Build docs (optional):"
echo "    ./docs/venv-setup.sh"
echo "    source .venv/bin/activate"
echo "    cmake --preset docs"
echo "    cmake --build build/docs --target docs"
