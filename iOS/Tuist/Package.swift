// swift-tools-version: 5.9

@preconcurrency import PackageDescription

#if TUIST
    @preconcurrency import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
    )
#endif

let package = Package(
  name: "MealGokPackages",
  dependencies: [
    .package(url: "https://github.com/realm/realm-swift.git", from: "10.46.0"),
  ]
)
