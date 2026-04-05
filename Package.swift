// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Prism",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Prism",
            targets: ["Prism"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/EmergeTools/Pow", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Prism",
            dependencies: [
                .product(name: "Pow", package: "Pow"),
            ],
            path: "Prism/Sources/Prism",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "PrismTests",
            dependencies: ["Prism"],
            path: "Prism/Tests/PrismTests"
        ),
    ]
)
