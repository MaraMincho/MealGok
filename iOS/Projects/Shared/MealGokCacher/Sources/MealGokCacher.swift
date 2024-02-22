//
//  MealGokCacher.swift
//  ImageManager
//
//  Created by MaraMincho on 2/18/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import OSLog

// MARK: - MealGokCacher

public final class MealGokCacher {
  private init() {}

  enum Constants {
    static let dirName = "MealGokImages"
    static let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let imageDirPath = documentPath.appending(path: Constants.dirName)

    static let sharedImageFileManagerProperty: ImageFileManager = .init(imageDirURL: imageDirPath)
    static let sharedLocalFileManager: LocalFileManager = .init(imageDirURL: imageDirPath)
  }
}
