// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SwiftRichString",
    platforms: [
        .iOS(SupportedPlatform.IOSVersion.v13)
    ],
    products: [
        .library(name: "SwiftRichString", targets: ["SwiftRichString"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftRichString")
    ]
)
