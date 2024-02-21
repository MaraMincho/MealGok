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

    static let sharedImageFileManagerProperty: ImageFileManagerProperty = .init(documentPath: imageDirPath)
    static let sharedLocalFileManager: LocalFileManager = .init(documentPath: imageDirPath)
  }
}

// MARK: - LocalFileManager

final class LocalFileManager {
  private let documentPath: URL
  private let fileManager = FileManager.default
  init(documentPath: URL) {
    self.documentPath = documentPath
  }

  func url(fileName: String) -> URL {
    return documentPath.appending(path: fileName)
  }

  /// 도큐먼트 폴더에 파일 이름을 추가한 URL이 현재 존재하는지 확인합니다.
  func isExistURL(fileName: String) -> Bool {
    let imagePathURL = documentPath.appending(path: fileName)
    return fileManager.fileExists(atPath: imagePathURL.path())
  }

  func save(fileName: String, data: Data) {
    let imagePathURL = documentPath.appending(path: fileName)

    do {
      if fileManager.fileExists(atPath: documentPath.path()) == false {
        try fileManager.createDirectory(at: documentPath, withIntermediateDirectories: true)
      }
      Logger().debug("\(imagePathURL.path())")
      try data.write(to: imagePathURL)
    } catch {
      Logger().error("\(error.localizedDescription)")
      Logger().error("error(Cant make ImageFileManagerProperty, \(#function)")
    }
  }
}
