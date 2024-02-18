import ProjectDescription
import ProjectDescriptionHelpers

/// in Dependencies.swift
/// realm is require 10.45.3
let dependencies = Dependencies(
  carthage: [
    .github(path: "realm/realm-swift", requirement: .exact("10.46.0")),
  ],
  swiftPackageManager: SwiftPackageManagerDependencies(
    baseSettings: Settings.settings(configurations: [
      .debug(name: .debug),
      .release(name: .release),
    ])
  ),

  platforms: [.iOS]
)
