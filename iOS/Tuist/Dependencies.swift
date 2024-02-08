import ProjectDescription
import ProjectDescriptionHelpers

// in Dependencies.swift
// realm is require 10.45.3
let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    baseSettings: Settings.settings(configurations: [
      .debug(name: .debug),
      .release(name: .release)
    ])
  ),
  
  platforms: [.iOS]
)
