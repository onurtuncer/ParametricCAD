cmake_minimum_required(VERSION 3.25)

project(ParametricCAD
    VERSION 0.1.0
    DESCRIPTION "Parametric CAD template built on OpenCASCADE"
    LANGUAGES CXX
)

# ── C++ standard ────────────────────────────────────────────────────────────
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ── Output directories ───────────────────────────────────────────────────────
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# ── Module path ──────────────────────────────────────────────────────────────
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# ── Build options ────────────────────────────────────────────────────────────
option(PCAD_BUILD_TESTS   "Build the Catch2 test suite"  ON)
option(PCAD_BUILD_DOCS    "Build Sphinx + Doxygen docs"  OFF)
option(PCAD_ENABLE_ASAN   "Enable AddressSanitizer"      OFF)

# ── Compiler flags ───────────────────────────────────────────────────────────
include(CompilerFlags)

# ── Dependencies (via vcpkg) ─────────────────────────────────────────────────
include(VendorOCCT)
include(VendorCppAD)

find_package(Eigen3 CONFIG REQUIRED)

if(PCAD_BUILD_TESTS)
    find_package(Catch2 3 CONFIG REQUIRED)
endif()

# ── Main library + application ───────────────────────────────────────────────
add_subdirectory(src)

# ── Tests ────────────────────────────────────────────────────────────────────
if(PCAD_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# ── Docs ─────────────────────────────────────────────────────────────────────
if(PCAD_BUILD_DOCS)
    include(Docs)
endif()