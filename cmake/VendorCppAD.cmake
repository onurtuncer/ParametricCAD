# cmake/VendorCppAD.cmake
# CppAD's vcpkg port installs headers and a static lib but no cmake config file.
# Locate them via find_path / find_library (vcpkg toolchain puts the installed
# prefix on CMAKE_PREFIX_PATH so the standard search paths apply).

find_path(CPPAD_INCLUDE_DIR NAMES cppad/cppad.hpp REQUIRED)

find_library(CPPAD_LIB_RELEASE NAMES cppad_lib REQUIRED)

# Debug lib lives one level up from the release lib under debug/lib/
get_filename_component(_cppad_lib_dir "${CPPAD_LIB_RELEASE}" DIRECTORY)
find_library(CPPAD_LIB_DEBUG NAMES cppad_lib
    PATHS "${_cppad_lib_dir}/../debug/lib"
    NO_DEFAULT_PATH
)
if(NOT CPPAD_LIB_DEBUG)
    set(CPPAD_LIB_DEBUG "${CPPAD_LIB_RELEASE}")
endif()

add_library(cppad_lib STATIC IMPORTED GLOBAL)
set_target_properties(cppad_lib PROPERTIES
    IMPORTED_LOCATION                "${CPPAD_LIB_RELEASE}"
    IMPORTED_LOCATION_RELEASE        "${CPPAD_LIB_RELEASE}"
    IMPORTED_LOCATION_RELWITHDEBINFO "${CPPAD_LIB_RELEASE}"
    IMPORTED_LOCATION_MINSIZEREL     "${CPPAD_LIB_RELEASE}"
    IMPORTED_LOCATION_DEBUG          "${CPPAD_LIB_DEBUG}"
    INTERFACE_INCLUDE_DIRECTORIES    "${CPPAD_INCLUDE_DIR}"
)

add_library(pcad::cppad ALIAS cppad_lib)
