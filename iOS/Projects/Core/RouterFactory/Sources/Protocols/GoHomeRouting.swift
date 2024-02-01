//
//  GoHomeRouting.swift
//  RouterFactory
//
//  Created by MaraMincho on 2/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

// MARK: - GoHomeRouting

public protocol GoHomeRouting {
  func goHome()
}

// MARK: - GoHomeRouterDelegate

public final class GoHomeRouterDelegate {
  public static let shared = GoHomeRouterDelegate()
  public var delegate: GoHomeRouting?

  public func goHome() {
    delegate?.goHome()
  }
}
