// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SNASteward",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SNASteward",
            targets: ["SNASteward"]),
    ],
    dependencies: [
        .package(url: "https://github.com/supabase-community/supabase-swift", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "SNASteward",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ]),
    ]
) 