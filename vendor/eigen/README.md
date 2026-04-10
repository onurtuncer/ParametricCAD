# vendor/eigen — Eigen Linear Algebra Library

| Field       | Value                                              |
|-------------|----------------------------------------------------|
| Source      | https://gitlab.com/libeigen/eigen                  |
| Pinned tag  | `3.4.0`                                            |
| License     | MPL-2.0 (Mozilla Public License)                   |
| CMake target| `Eigen3::Eigen` (INTERFACE, header-only)           |

## Usage

Header-only — link a target against `Eigen3::Eigen` and include as normal:

```cpp
#include <Eigen/Dense>
```

## Upgrading

1. Update the tag in this file and in `bootstrap.sh` / `bootstrap.ps1`.
2. Run `git -C vendor/eigen fetch --tags && git -C vendor/eigen checkout <new-tag>`.
