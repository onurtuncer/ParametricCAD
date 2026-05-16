# cmake/VendorOCCT.cmake
# Finds OpenCASCADE via vcpkg and exposes the pcad::occt alias target.
# Only the modules needed for the geometry kernel and data exchange are linked.

find_package(OpenCASCADE CONFIG REQUIRED)

add_library(pcad_occt_kernel INTERFACE)
add_library(pcad::occt ALIAS pcad_occt_kernel)

target_link_libraries(pcad_occt_kernel INTERFACE
    # Foundation
    TKernel
    TKMath
    # Modeling
    TKBRep
    TKG2d
    TKG3d
    TKGeomBase
    TKGeomAlgo
    TKTopAlgo
    TKPrim
    TKShHealing
    TKBool
    TKBO
    TKFillet
    TKOffset
    # Data exchange
    TKXSBase
    TKDE
    TKDECascade
    TKDESTEP
    TKDEIGES
    TKDESTL
)
