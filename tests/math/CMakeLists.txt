# tests/math/CMakeLists.txt

add_executable(pcad_tests_math
    test_cppad.cpp
)

target_link_libraries(pcad_tests_math
    PRIVATE
        pcad::cppad
        pcad::compiler_flags
        Catch2::Catch2WithMain
)

include(Catch)
catch_discover_tests(pcad_tests_math
    # On Linux cppad_lib is SHARED; provide its directory so the test runner
    # can find the .so even before install.
    DL_PATHS "$<TARGET_FILE_DIR:cppad_lib>"
)
