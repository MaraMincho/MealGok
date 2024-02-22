//
//  LocalFileManager.swift
//  MealGokCacher
//
//  Created by MaraMincho on 2/22/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import OSLog

// MARK: - LocalFileManager

final class LocalFileManager {
  private let imageDirURL: URL
  private let fileManager = FileManager.default
  init(imageDirURL: URL) {
    self.imageDirURL = imageDirURL
  }

  func url(fileName: String) -> URL {
    return imageDirURL.appending(path: fileName)
  }

  /// 도큐먼트 폴더에 파일 이름을 추가한 URL이 현재 존재하는지 확인합니다.
  func isExistURL(fileName: String) -> Bool {
    let imagePathURL = imageDirURL.appending(path: fileName)
    return fileManager.fileExists(atPath: imagePathURL.path())
  }

  func save(fileName: String, data: Data) {
    let imagePathURL = imageDirURL.appending(path: fileName)

    do {
      if fileManager.fileExists(atPath: imageDirURL.path()) == false {
        try fileManager.createDirectory(at: imageDirURL, withIntermediateDirectories: true)
      }
      let path = imageDirURL.path
      Logger().debug("\(path)")
      try data.write(to: imageDirURL)
    } catch {
      Logger().error("\(error.localizedDescription)")
      Logger().error("error(Cant make ImageFileManagerProperty, \(#function)")
    }
  }
}
