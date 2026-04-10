# ParametricCAD

> A GitHub template for CAD applications built on
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
| Documentation | Doxygen XML → Sphinx + Breathe + Furo HTML |
| CI | GitHub Actions — Linux and Windows matrix |
| Code style | `.clang-format` + `.clang-tidy` |

Everything is vendored. No system-installed OCCT, no vcpkg, no Conan.
A clean clone + one bootstrap command is all that is needed to build.

---

## Repository layout

```
ParametricCAD/
├── cmake/
│   ├── CompilerFlags.cmake   # Strict cross-platform warning flags
│   ├── VendorOCCT.cmake      # OCCT subdirectory + pcad::occt alias target
│   └── Docs.cmake            # Doxygen → Sphinx pipeline
├── vendor/
│   ├── occt/                 # git submodule — OpenCASCADE V7_8_0
│   ├── catch2/               # git submodule — Catch2 v3.6.0
│   └── eigen/                # git submodule — Eigen 3.4.0
├── src/
│   ├── geometry/             # OCCT wrapper (primitives, bounding box)
│   ├── io/                   # STEP / IGES / STL export
│   └── main.cpp              # CLI entry point
├── tests/
│   ├── geometry/             # Catch2 tests — primitive creation & bbox
│   └── io/                   # Catch2 tests — STEP and STL export
├── docs/
│   ├── requirements.txt      # Pinned Python doc dependencies
│   ├── venv-setup.sh         # Create .venv on Linux
│   └── venv-setup.ps1        # Create .venv on Windows
├── bootstrap.sh              # Submodule init (Linux / macOS)
├── bootstrap.ps1             # Submodule init (Windows PowerShell)
├── CMakeLists.txt
├── CMakePresets.json
└── .gitmodules
```

---

## Prerequisites

### Linux

| Tool | Minimum |
|---|---|
| CMake | 3.25 |
| Ninja | any |
| GCC or Clang | GCC 12 / Clang 15 |
| Python 3 | 3.10 (docs only) |
| Doxygen | any (docs only) |

```bash
# Ubuntu 22.04 / 24.04
sudo apt install cmake ninja-build gcc g++ python3 python3-venv doxygen
```

### Windows

| Tool | Notes |
|---|---|
| Visual Studio 2022 | Desktop C++ workload required |
| CMake 3.25+ | Bundled with VS, or from cmake.org |
| Python 3.10+ | Docs only — from python.org |
| Doxygen | Docs only — from doxygen.nl |

> **PowerShell execution policy** — run once before the bootstrap script:
> ```powershell
> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
> ```

---

## Quick start

### 1 — Clone

```bash
git clone https://github.com/YOUR_ORG/YOUR_REPO
cd YOUR_REPO
```

### 2 — Bootstrap (pulls all submodules)

```bash
# Linux
./bootstrap.sh

# Windows (PowerShell)
.\bootstrap.ps1
```

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
ctest --preset linux-debug --output-on-failure

# Windows
ctest --preset windows-msvc-debug --output-on-failure
```

---

## Available presets

| Preset | Platform | Compiler | Config | ASan |
|---|---|---|---|---|
| `linux-debug` | Linux | GCC / Clang | Debug | off |
| `linux-release` | Linux | GCC / Clang | RelWithDebInfo | off |
| `linux-asan` | Linux | GCC / Clang | Debug | on |
| `windows-msvc-debug` | Windows | MSVC x64 | Debug | off |
| `windows-msvc-release` | Windows | MSVC x64 | Release | off |
| `windows-ninja-debug` | Windows | clang-cl | Debug | off |
| `docs` | Linux | — | Release | off |

---

## Vendored dependencies

All dependencies are git submodules pinned to a specific tag. The pinned
commits are baked into the gitlinks — `bootstrap.sh` / `bootstrap.ps1` always
checks out exactly those commits with no extra steps.

| Library | Tag | License | Purpose |
|---|---|---|---|
| [OpenCASCADE](https://github.com/Open-Cascade-SAS/OCCT) | `V7_8_0` | LGPL 2.1 | Geometry kernel, STEP/IGES/STL I/O |
| [Catch2](https://github.com/catchorg/Catch2) | `v3.6.0` | BSL-1.0 | Unit and integration testing |
| [Eigen](https://gitlab.com/libeigen/eigen) | `3.4.0` | MPL-2.0 | Header-only linear algebra |

Only the OCCT geometry kernel modules are compiled:
`FoundationClasses`, `ModelingData`, `ModelingAlgorithms`, `DataExchange`.
Visualisation, scripting (Tcl/Tk), and inspector modules are all disabled.

To upgrade a submodule:

```bash
git -C vendor/<name> fetch --tags
git -C vendor/<name> checkout <new-tag>
git add vendor/<name>
git commit -m "chore(vendor): bump <name> to <new-tag>"
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

---

## Using this template for a new project

1. Click **Use this template → Create a new repository** on GitHub.
2. Rename the `project()` call in `CMakeLists.txt`.
3. Replace `YOUR_ORG/ParametricCAD` badge URLs with your org and repo name.
4. Add your own modules under `src/` and tests under `tests/`.
5. Run `.\bootstrap.ps1` (or `./bootstrap.sh`) and confirm the build is clean.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch naming, commit style, and
the PR checklist.

---

## License

GPL v3 — see [LICENSE](LICENSE).

## Author

**Prof. Dr. Onur Tuncer**
Aerospace Engineer, Researcher & C++ Systems Developer
Email: onur.tuncer@itu.edu.tr

<p align="left">
  <img src="assets/itu_logo.png" width="180" alt="Istanbul Technical University"/>
</p>
