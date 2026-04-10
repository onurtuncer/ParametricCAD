# vendor/occt — OpenCASCADE Technology

| Field       | Value                                                       |
|-------------|-------------------------------------------------------------|
| Source      | https://github.com/Open-Cascade-SAS/OCCT                    |
| Pinned tag  | `V7_8_0`                                                    |
| License     | LGPL v2.1                                                   |
| CMake target| `pcad::occt` (alias defined in `cmake/VendorOCCT.cmake`)    |

## Modules enabled

Only the geometry kernel and data exchange modules are built:

- `FoundationClasses` — basic types, math, collections
- `ModelingData` — BRep, geometry primitives
- `ModelingAlgorithms` — Boolean ops, fillets, sweeps
- `DataExchange` — STEP, IGES read/write

All visualisation, scripting (Tcl/Tk), and inspector modules are disabled to
keep the Windows build fast and dependency-free.

## Upgrading

1. Update the tag in this file and in `bootstrap.sh` / `bootstrap.ps1`.
2. Run `git -C vendor/occt fetch --tags && git -C vendor/occt checkout <new-tag>`.
3. Rebuild from a clean binary directory.
