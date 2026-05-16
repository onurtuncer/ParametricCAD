# vendor/CMakeLists.txt
#
# Dependencies are now managed by vcpkg (see vcpkg.json in the repo root).
# This directory previously held git submodules for occt, catch2, and eigen,
# and pre-built CppAD binaries for Windows.
#
# The vendor/cppad directory (pre-built binaries) is no longer used.
# It can be removed with:
#   git rm -r vendor/cppad
#
# Former submodules (occt, catch2, eigen) can be removed with:
#   git rm -r vendor/occt vendor/catch2 vendor/eigen
