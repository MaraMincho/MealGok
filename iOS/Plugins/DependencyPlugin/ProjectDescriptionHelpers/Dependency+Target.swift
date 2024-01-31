//
//  Dependency+Target.swift
//  IOS
//
//  Created by 홍승현 on 11/19/23.
//

import ProjectDescription

// MARK: - Feature

public enum Feature: String {
  case writeBoard
  case mealTimer
  public var targetName: String {
    return rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }
}

public extension TargetDependency {
  static let designSystem: TargetDependency = .project(target: "DesignSystem", path: .relativeToShared("DesignSystem"))
  static let routerFactory: TargetDependency = .project(target: "RouterFactory", path: .relativeToCore("RouterFactory"))
  static let combineCocoa: TargetDependency = .project(target: "CombineCocoa", path: .relativeToCore("CombineCocoa"))
  static func feature(_ feature: Feature) -> TargetDependency {
    return .project(
      target: "\(feature.targetName)Feature",
      path: .relativeToRoot("Projects/Features/\(feature.targetName)")
    )
  }
}

