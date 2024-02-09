//
//  Package+.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 2/8/24.
//

import ProjectDescription

public extension Package {
  static let realm = Package.remote(
    url: "https://github.com/realm/realm-swift.git",
    requirement: .exact("10.45.3")
  )
}
