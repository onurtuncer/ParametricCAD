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

# Discover and register all TEST_CASE blocks with CTest
include(Catch)
catch_discover_tests(pcad_tests)
