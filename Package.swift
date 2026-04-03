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
    targets: [
        .target(
            name: "Prism",
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
