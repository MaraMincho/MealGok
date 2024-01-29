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
  case home
  case splash
  case profile
  case login
  case onboarding
  case record
  case signUp

  public var targetName: String {
    return rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }
}

public extension TargetDependency {
  static let designSystem: TargetDependency = .project(target: "DesignSystem", path: .relativeToShared("DesignSystem"))
  static let commonNetworkingKeyManager: TargetDependency = .project(target: "CommonNetworkingKeyManager", path: .relativeToShared("CommonNetworkingKeyManager"))
  static let trinet: TargetDependency = .project(target: "Trinet", path: .relativeToCore("Network"))
  static let coordinator: TargetDependency = .project(target: "Coordinator", path: .relativeToCore("Coordinator"))
  static let combineCocoa: TargetDependency = .project(target: "CombineCocoa", path: .relativeToShared("CombineCocoa"))
  static let combineExtension: TargetDependency = .project(target: "CombineExtension", path: .relativeToShared("CombineExtension"))
  static let log: TargetDependency = .project(target: "Log", path: .relativeToShared("Log"))
  static let keychain: TargetDependency = .project(target: "Keychain", path: .relativeToCore("Keychain"))
  static let cacher: TargetDependency = .project(target: "Cacher", path: .relativeToCore("Cacher"))
  static let userInformationManager: TargetDependency = .project(target: "UserInformationManager", path: .relativeToShared("UserInformationManager"))
  static let auth: TargetDependency = .project(target: "Auth", path: .relativeToShared("Auth"))
  static let downSampling: TargetDependency = .project(target: "ImageDownsampling", path: .relativeToShared("ImageDownsampling"))

  static func feature(_ feature: Feature) -> TargetDependency {
    return .project(
      target: "\(feature.targetName)Feature",
      path: .relativeToRoot("Projects/Features/\(feature.targetName)")
    )
  }
}
