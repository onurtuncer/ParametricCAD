# ParametricCAD

> A GitHub template for parametric CAD applications built on
> [OpenCASCADE Technology (OCCT)](https://dev.opencascade.org/) in modern C++20.

[![CI](https://github.com/YOUR_ORG/ParametricCAD/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_ORG/ParametricCAD/actions/workflows/ci.yml)
[![Docs](https://github.com/YOUR_ORG/ParametricCAD/actions/workflows/docs.yml/badge.svg)](https://YOUR_ORG.github.io/ParametricCAD)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)

---

## What this template gives you

| Concern | Solution |
|---|---|
| Geometry kernel | OpenCASCADE 7.8 — vendored as a git submodule |
| Build system | CMake 3.25+ with `CMakePresets.json` |
| Compiler support | GCC, Clang, MSVC (x64) |
| Test harness | Catch2 v3 — vendored as a git submodule |
| Linear algebra | Eigen 3.4 — vendored, header-only |
| Documentation | Doxygen XML → Sphinx + Breathe + Furo HTML |
| CI | GitHub Actions — Linux and Windows matrix |
| Code style | `.clang-format` + `.clang-tidy` |

Everything is vendored. No system-installed OCCT, no vcpkg, no Conan.
A clean clone + one bootstrap command is all that is needed to build.

---

## Prerequisites

### Linux

| Tool | Minimum version |
|---|---|
| CMake | 3.25 |
| Ninja | any recent |
| GCC or Clang | GCC 12 / Clang 15 |
| Python | 3.10 (docs only) |

```bash
# Ubuntu 22.04 / 24.04
sudo apt install cmake ninja-build gcc g++ python3 python3-venv doxygen
```

### Windows

| Tool | Notes |
|---|---|
| Visual Studio 2022 | Desktop C++ workload required |
| CMake 3.25+ | Bundled with VS or from cmake.org |
| Ninja | Optional — needed for `windows-ninja-debug` preset |
| Python 3.10+ | Docs only — from python.org |
| Doxygen | Docs only — from doxygen.nl |

> **PowerShell execution policy** — the bootstrap and venv scripts require
> scripts to be runnable. Either set your policy permanently or run:
> ```powershell
> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
> ```

---

## Quick start

### 1 — Use this template

Click **Use this template → Create a new repository** on GitHub, then clone
your new repo:

```bash
git clone https://github.com/YOUR_ORG/YOUR_REPO
cd YOUR_REPO
```

### 2 — Initialise submodules

```bash
# Linux
./bootstrap.sh

# Windows (PowerShell)
.\bootstrap.ps1
```

This runs `git submodule update --init --recursive` and prints next steps.

### 3 — Configure and build

```bash
# Linux — debug build with tests
cmake --preset linux-debug
cmake --build build/linux-debug

# Windows — MSVC debug build with tests
cmake --preset windows-msvc-debug
cmake --build build/windows-msvc-debug
```

### 4 — Run tests

```bash
# Linux
ctest --preset linux-debug

# Windows
ctest --preset windows-msvc-debug
```

---

## Available presets

| Preset | Platform | Compiler | Config | Tests | ASan |
|---|---|---|---|---|---|
| `linux-debug` | Linux | GCC / Clang | Debug | on | off |
| `linux-release` | Linux | GCC / Clang | RelWithDebInfo | on | off |
| `linux-asan` | Linux | GCC / Clang | Debug | on | **on** |
| `windows-msvc-debug` | Windows | MSVC x64 | Debug | on | off |
| `windows-msvc-release` | Windows | MSVC x64 | Release | on | off |
| `windows-ninja-debug` | Windows | clang-cl | Debug | on | off |
| `docs` | Linux | — | Release | off | off |

---

## Project structure

```
ParametricCAD/
├── cmake/
│   ├── CompilerFlags.cmake   # Strict cross-platform warning flags
│   ├── VendorOCCT.cmake      # OCCT subdirectory + pcad::occt alias target
│   └── Docs.cmake            # Doxygen → Sphinx pipeline
├── vendor/
│   ├── occt/                 # git submodule — OpenCASCADE 7.8
│   ├── catch2/               # git submodule — Catch2 v3
│   └── eigen/                # git submodule — Eigen 3.4
├── src/
│   ├── geometry/             # Thin OCCT wrapper utilities
│   ├── parametric/           # Design variable types
│   ├── io/                   # STEP / IGES / STL export
│   └── main.cpp              # CLI entry point
├── tests/
│   ├── geometry/             # Catch2 unit tests — geometry module
│   └── io/                   # Catch2 unit tests — STEP roundtrip
├── docs/
│   ├── sphinx/               # Sphinx source (conf.py, index.rst, …)
│   ├── requirements.txt      # Pinned Python doc dependencies
│   ├── venv-setup.sh         # Create .venv on Linux
│   └── venv-setup.ps1        # Create .venv on Windows
├── .github/
│   ├── workflows/
│   │   ├── ci.yml            # Build + test matrix (Linux, Windows)
│   │   └── docs.yml          # Build docs → GitHub Pages
│   └── ISSUE_TEMPLATE/
├── bootstrap.sh              # git submodule init (Linux)
├── bootstrap.ps1             # git submodule init (Windows)
├── CMakeLists.txt
├── CMakePresets.json
├── .clang-format
├── .clang-tidy
└── .gitmodules
```

---

## Building documentation

```bash
# Linux
./docs/venv-setup.sh
source .venv/bin/activate
cmake --preset docs
cmake --build build/docs --target docs
# Output: build/docs/sphinx/html/index.html

# Windows (PowerShell)
.\docs\venv-setup.ps1
.\.venv\Scripts\Activate.ps1
cmake --preset docs
cmake --build build/docs --target docs
```

Documentation is automatically published to GitHub Pages on every push to
`main` via `.github/workflows/docs.yml`.

---

## Vendored dependencies

All dependencies are git submodules pinned to a specific tag.
**Do not upgrade a submodule without updating the pinned tag in `.gitmodules`
and testing on both platforms.**

| Library | Tag | Purpose |
|---|---|---|
| [OpenCASCADE](https://git.dev.opencascade.org/repos/occt.git) | `V7_8_0` | Geometry kernel, STEP/IGES I/O |
| [Catch2](https://github.com/catchorg/Catch2) | `v3.6.0` | Unit + integration test framework |
| [Eigen](https://gitlab.com/libeigen/eigen) | `3.4.0` | Header-only linear algebra |

Only the OCCT geometry kernel modules are compiled
(`FoundationClasses`, `ModelingData`, `ModelingAlgorithms`, `DataExchange`).
Visualisation, scripting (Tcl/Tk), and inspector modules are all disabled,
keeping build times fast and external dependencies minimal.

---

## Using this template for a new project

1. Create a repo from this template on GitHub.
2. Rename the top-level `project()` call in `CMakeLists.txt`.
3. Replace `src/geometry/`, `src/parametric/`, `src/io/` with your own modules.
4. Update this README — replace badges and org/repo references.
5. Run `./bootstrap.sh` and confirm `cmake --preset linux-debug` builds clean.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch naming, commit style, and
the PR checklist. All C++ code must pass `clang-format` and `clang-tidy`
before merge — both are checked in CI.

---

## License

GPL v3 — see [LICENSE](LICENSE).

## License

MIT — see [LICENSE](LICENSE).
