import ProjectDescription
import ProjectDescriptionHelpers

// in Dependencies.swift
let dependencies = Dependencies(
  carthage: [
    .github(path: "realm/realm-swift", requirement: .upToNext("10.46.0"))
  ],
  swiftPackageManager: SwiftPackageManagerDependencies(
    baseSettings: Settings.settings(configurations: [
      .debug(name: .debug),
      .release(name: .release)
    ])
  ),
  
  platforms: [.iOS]
)
