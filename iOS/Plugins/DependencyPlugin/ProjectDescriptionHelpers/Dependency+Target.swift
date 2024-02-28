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
  case profile
  case profileHamburger
  public var targetName: String {
    return rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }
}

// MARK: - Shared

public extension TargetDependency {
  static let designSystem: TargetDependency = .project(target: "DesignSystem", path: .relativeToShared("DesignSystem"))
  static let routerFactory: TargetDependency = .project(target: "RouterFactory", path: .relativeToCore("RouterFactory"))
  static let combineCocoa: TargetDependency = .project(target: "CombineCocoa", path: .relativeToCore("CombineCocoa"))
  static let MealGokCacher: TargetDependency = .project(target: "MealGokCacher", path: .relativeToShared("MealGokCacher"))
  static let sharedNotificationName: TargetDependency = .project(target: "SharedNotificationName", path: .relativeToCore("SharedNotificationName"))
  static let commonExtensions: TargetDependency = .project(target: "CommonExtensions", path: .relativeToShared("CommonExtensions"))
  static func feature(_ feature: Feature) -> TargetDependency {
    return .project(
      target: "\(feature.targetName)Feature",
      path: .relativeToRoot("Projects/Features/\(feature.targetName)")
    )
  }
}

// MARK: - ThirdParty

public extension TargetDependency {
  static let thirdParty: TargetDependency = .project(target: "ThirdParty", path: .relativeToShared("ThirdParty"), condition: .none)

  static let RealmSwift = TargetDependency.external(name: "RealmSwift", condition: .none)
  static let Realm = TargetDependency.external(name: "Realm", condition: .none)
}
