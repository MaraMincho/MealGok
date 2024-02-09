//
//  RealmShared.swift
//  ThirdParty
//
//  Created by MaraMincho on 2/8/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import RealmSwift

public final class RealmShared {
  public static let shared = RealmShared()
  public let realm: Realm
  private init () {
    let configure = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    realm = try! Realm(configuration: configure)
  }
}
