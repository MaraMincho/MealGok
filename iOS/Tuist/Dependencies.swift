import ProjectDescription
import ProjectDescriptionHelpers

// in Dependencies.swift
let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
      .package(url: "https://github.com/realm/realm-swift", .exact("10.45.3")),
      .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.1")),
    ],
    baseSettings: Settings.settings(configurations: [
      .debug(name: .debug),
      .release(name: .release)
    ])
  ),
  
  platforms: [.iOS]
)
