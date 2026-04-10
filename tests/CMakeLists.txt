# tests/CMakeLists.txt

add_executable(pcad_tests
    geometry/test_primitives.cpp
    io/test_step_export.cpp
    io/test_stl_export.cpp
)

target_link_libraries(pcad_tests
    PRIVATE
        pcad::lib
        pcad::compiler_flags
        Catch2::Catch2WithMain
)

# Discover and register all TEST_CASE blocks with CTest.
# DL_PATHS ensures the OCCT DLLs are findable at test-discovery time on Windows
# (exit code 0xc0000135 = DLL not found without this).
include(Catch)
catch_discover_tests(pcad_tests
    DL_PATHS "$<TARGET_FILE_DIR:TKernel>"
)
