# vendor/catch2 — Catch2 Testing Framework

| Field       | Value                                              |
|-------------|----------------------------------------------------|
| Source      | https://github.com/catchorg/Catch2                 |
| Pinned tag  | `v3.6.0`                                           |
| License     | BSL-1.0 (Boost Software License)                   |
| CMake target| `Catch2::Catch2WithMain`                           |

## Usage

Test executables link against `Catch2::Catch2WithMain` — this provides the
`main()` entry point so each test binary needs only `TEST_CASE` blocks.

## Upgrading

1. Update the tag in this file and in `bootstrap.sh` / `bootstrap.ps1`.
2. Run `git -C vendor/catch2 fetch --tags && git -C vendor/catch2 checkout <new-tag>`.
