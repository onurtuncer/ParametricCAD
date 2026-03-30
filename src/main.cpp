/// @file main.cpp
/// @brief CLI entry point for the ParametricCAD template application.
///
/// This is intentionally minimal — it demonstrates the full pipeline:
///   1. Create geometry via OcctUtils
///   2. Export to STEP and STL
///
/// Replace this with your own application logic when using the template.

#include "geometry/OcctUtils.hpp"
#include "io/StepExporter.hpp"
#include "io/StlExporter.hpp"

#include <iostream>
#include <filesystem>
#include <cstdlib>

namespace fs = std::filesystem;

int main(int argc, char* argv[])
{
    std::cout << "ParametricCAD — template application\n";
    std::cout << "-------------------------------------\n";

    // ── Output directory ─────────────────────────────────────────────────────
    const fs::path outDir = (argc > 1) ? fs::path{ argv[1] } : fs::path{ "output" };

    std::error_code ec;
    fs::create_directories(outDir, ec);
    if (ec) {
        std::cerr << "ERROR: could not create output directory '"
            << outDir.string() << "': " << ec.message() << '\n';
        return EXIT_FAILURE;
    }

    // ── Build example geometry ────────────────────────────────────────────────
    std::cout << "\nBuilding geometry...\n";

    const auto sphere = pcad::geometry::makeSphere(5.0);
    if (!sphere) {
        std::cerr << "ERROR: failed to build sphere\n";
        return EXIT_FAILURE;
    }
    std::cout << "  Sphere  r=5.0  type=" << pcad::geometry::shapeTypeString(*sphere) << '\n';

    const auto box = pcad::geometry::makeBox(10.0, 6.0, 4.0);
    if (!box) {
        std::cerr << "ERROR: failed to build box\n";
        return EXIT_FAILURE;
    }
    std::cout << "  Box  10x6x4  type=" << pcad::geometry::shapeTypeString(*box) << '\n';

    // ── Bounding boxes ────────────────────────────────────────────────────────
    if (const auto bb = pcad::geometry::boundingBox(*sphere)) {
        const auto [dx, dy, dz] = bb->extents();
        std::cout << "  Sphere bbox extents: " << dx << " x " << dy << " x " << dz << '\n';
    }

    // ── STEP export ───────────────────────────────────────────────────────────
    std::cout << "\nExporting STEP...\n";
    try {
        pcad::io::StepExporter stepExp;
        stepExp.addShape(*sphere, "ExampleSphere");
        stepExp.addShape(*box, "ExampleBox");
        const auto stepPath = outDir / "example.step";
        stepExp.write(stepPath);
        std::cout << "  Written: " << stepPath.string() << '\n';
    }
    catch (const std::exception& e) {
        std::cerr << "ERROR (STEP): " << e.what() << '\n';
        return EXIT_FAILURE;
    }

    // ── STL export ────────────────────────────────────────────────────────────
    std::cout << "\nExporting STL...\n";
    try {
        pcad::io::StlExporter stlExp;
        stlExp.setLinearDeflection(0.01);
        const auto stlPath = outDir / "example_sphere.stl";
        stlExp.write(*sphere, stlPath);
        std::cout << "  Written: " << stlPath.string() << '\n';
    }
    catch (const std::exception& e) {
        std::cerr << "ERROR (STL): " << e.what() << '\n';
        return EXIT_FAILURE;
    }

    std::cout << "\nDone.\n";
    return EXIT_SUCCESS;
}