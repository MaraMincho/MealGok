//
//  MealGokChallengePersistedObject.swift
//  ThirdParty
//
//  Created by MaraMincho on 2/8/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - MealGokChallengePersistedObject

public final class MealGokChallengePersistedObject: Object {
  @Persisted(primaryKey: true) public var _id: ObjectId
  @Persisted public var challengeDateString: String
  @Persisted public var endTime: Date
  @Persisted public var startTime: Date
  @Persisted public var imageDataURL: String?
  @Persisted public var isSuccess: Bool

  /// init MealGokChallengePersistedObject
  /// - Parameters:
  ///   - challengeDateString: Date String of challenge. "yyyy-MM-dd"
  ///   - startTime: Start date of challenge.
  ///   - endTime: End date of challenge
  ///   - imageDataURLString: Image URL that user take food or something, if nil no picture
  ///   - isSuccess: wether success
  public convenience init(challengeDateString: String, startTime: Date, endTime: Date, imageDataURLString: String?, isSuccess: Bool) {
    self.init()
    self.challengeDateString = challengeDateString
    self.startTime = startTime
    self.endTime = endTime
    imageDataURL = imageDataURLString
    self.isSuccess = isSuccess
  }
}
