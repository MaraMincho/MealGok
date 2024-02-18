//
//  PersistableRepository.swift
//  ThirdParty
//
//  Created by MaraMincho on 2/8/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import RealmSwift

open class PersistableRepository {
  public let realm = RealmShared.shared.realm
  public init() {}
}
