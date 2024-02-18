//
//  FileCacher+PublicMethod.swift
//  ImageManager
//
//  Created by MaraMincho on 2/18/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import OSLog

/// 외부에 FileManager를 이용할 때 사용하는 Method입니다.
public extension MealGokCacher {
  /// 도큐먼트 폴더에 파일 이름을 추가한 URL을 리턴합니다.
  static func url(fileName: String) -> URL {
    return ImageFileManagerProperty.imageDirPath.appending(path: fileName)
  }

  /// 도큐먼트 폴더에 파일 이름을 추가한 URL이 현재 존재하는지 확인합니다.
  static func isExistURL(fileName: String) -> Bool {
    let imagePathURL = ImageFileManagerProperty.imageDirPath.appending(path: fileName)
    Logger().debug("\(imagePathURL.path())")
    return ImageFileManagerProperty.fileManger.fileExists(atPath: imagePathURL.path())
  }

  /// 도큐먼트 폴더에 파일 이름을 추가한 URL을 통해 Data를 저장합니다.
  ///
  /// Data가 nil일 경우 리턴합니다.
  static func save(fileName: String, data: Data?) {
    guard let data else { return }
    let imagePathURL = ImageFileManagerProperty.imageDirPath.appending(path: fileName)
    let fileManager = ImageFileManagerProperty.fileManger

    do {
      if fileManager.fileExists(atPath: ImageFileManagerProperty.imageDirPath.path()) == false {
        try fileManager.createDirectory(at: ImageFileManagerProperty.imageDirPath, withIntermediateDirectories: true)
      }
      Logger().debug("\(imagePathURL.path())")
      try data.write(to: imagePathURL)
    } catch {
      Logger().error("\(error.localizedDescription)")
      Logger().error("error(Cant make ImageFileManagerProperty, \(#function)")
    }
  }
}
