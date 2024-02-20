//
//  UserDefaults+Date.swift
//  CommonExtensions
//
//  Created by MaraMincho on 2/20/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

public extension UserDefaults {
  func set(date: Date?, forKey key: String) {
    set(date, forKey: key)
  }

  func date(forKey key: String) -> Date? {
    return value(forKey: key) as? Date
  }
}
