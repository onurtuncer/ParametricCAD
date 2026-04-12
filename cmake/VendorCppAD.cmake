# cmake/VendorCppAD.cmake
# CppAD — automatic differentiation library (version 20250000.3 / cppad-20250623).
#
# Windows : pre-built static binaries vendored under vendor/cppad/x64-{Debug,Release}
# Linux   : downloaded from GitHub at configure time via FetchContent
#
# Exposes alias target: pcad::cppad
#
# CppAD quirks handled here:
#   - CppAD writes configure.hpp back into its source tree (not the binary dir).
#     With FetchContent the populate dir is inside the build tree, so this is fine.
#   - CppAD unconditionally sets CMAKE_INSTALL_PREFIX (CACHE FORCE) from cppad_prefix.
#     We save and restore our own prefix around the subdirectory call.
#   - CppAD only accepts CMAKE_BUILD_TYPE == "Debug" or "Release"; it hard-errors on
#     RelWithDebInfo/MinSizeRel. We shadow CMAKE_BUILD_TYPE with "Release" for the
#     duration of the subdirectory call, then restore it.
#   - FetchContent_Populate(name) is deprecated in CMake ≥ 3.30 (policy CMP0169).
#     We set the policy to OLD so we can keep the EXCLUDE_FROM_ALL add_subdirectory.
#   - On Linux cppad_lib is built SHARED; build-tree RPATH keeps it findable for
#     test executables without manual LD_LIBRARY_PATH.

if(WIN32)

    # ── Windows: pre-built binaries ───────────────────────────────────────────
    set(_cppad_root "${CMAKE_CURRENT_SOURCE_DIR}/vendor/cppad")

    add_library(cppad_lib STATIC IMPORTED GLOBAL)
    set_target_properties(cppad_lib PROPERTIES
        IMPORTED_LOCATION_DEBUG          "${_cppad_root}/x64-Debug/lib/cppad_lib.lib"
        IMPORTED_LOCATION_RELEASE        "${_cppad_root}/x64-Release/lib/cppad_lib.lib"
        IMPORTED_LOCATION_RELWITHDEBINFO "${_cppad_root}/x64-Release/lib/cppad_lib.lib"
        IMPORTED_LOCATION_MINSIZEREL     "${_cppad_root}/x64-Release/lib/cppad_lib.lib"
    )
    target_include_directories(cppad_lib INTERFACE
        "$<$<CONFIG:Debug>:${_cppad_root}/x64-Debug/include>"
        "$<$<NOT:$<CONFIG:Debug>>:${_cppad_root}/x64-Release/include>"
    )

else()

    # ── Linux: FetchContent ────────────────────────────────────────────────────
    include(FetchContent)

    FetchContent_Declare(cppad
        GIT_REPOSITORY https://github.com/coin-or/CppAD.git
        GIT_TAG        20250000.3
        GIT_SHALLOW    TRUE
    )

    # CppAD sets CMAKE_INSTALL_PREFIX (CACHE FORCE) from cppad_prefix — save and restore.
    set(_cppad_saved_prefix "${CMAKE_INSTALL_PREFIX}")
    set(cppad_prefix "${CMAKE_BINARY_DIR}/cppad_install" CACHE PATH "" FORCE)

    # CppAD hard-errors on any build type other than Debug/Release.
    # Shadow CMAKE_BUILD_TYPE with Release for the subdirectory call, then restore.
    set(_cppad_saved_build_type "${CMAKE_BUILD_TYPE}")
    if(CMAKE_BUILD_TYPE MATCHES "^(RelWithDebInfo|MinSizeRel)$")
        set(CMAKE_BUILD_TYPE "Release")
    endif()

    # FetchContent_Populate(name) is deprecated in CMake ≥ 3.30 (CMP0169).
    # Set OLD so we keep EXCLUDE_FROM_ALL on the add_subdirectory call.
    if(POLICY CMP0169)
        cmake_policy(SET CMP0169 OLD)
    endif()

    FetchContent_GetProperties(cppad)
    if(NOT cppad_POPULATED)
        FetchContent_Populate(cppad)
        # EXCLUDE_FROM_ALL: cppad's own tests/examples won't join the default build.
        add_subdirectory("${cppad_SOURCE_DIR}" "${cppad_BINARY_DIR}" EXCLUDE_FROM_ALL)
    endif()

    set(CMAKE_BUILD_TYPE "${_cppad_saved_build_type}")
    set(CMAKE_INSTALL_PREFIX "${_cppad_saved_prefix}" CACHE PATH "Install path prefix" FORCE)

endif()

# ── Alias ─────────────────────────────────────────────────────────────────────
add_library(pcad::cppad ALIAS cppad_lib)
