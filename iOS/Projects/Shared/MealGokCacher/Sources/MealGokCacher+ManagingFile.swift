//
//  MealGokCacher+ManagingFile.swift
//  ImageManager
//
//  Created by MaraMincho on 2/18/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

/// 외부에 FileManager를 이용할 때 사용하는 Method입니다.
public extension MealGokCacher {
  /// 도큐먼트 폴더에 파일 이름을 추가한 URL을 리턴합니다.
  static func url(fileName: String) -> URL {
    return Constants.sharedImageFileManagerProperty.url(fileName: fileName)
  }

  /// 도큐먼트 폴더에 파일 이름을 추가한 URL이 현재 존재하는지 확인합니다.
  static func isExistURL(fileName: String) -> Bool {
    return Constants.sharedImageFileManagerProperty.isExistURL(fileName: fileName)
  }

  /// 도큐먼트 폴더에 파일 이름을 추가한 URL을 통해 Data를 저장합니다.
  ///
  /// Data가 nil일 경우 어떠한 작업도 시행하지 않습니다.
  static func save(fileName: String, data: Data?) {
    guard let data else { return }
    return Constants.sharedImageFileManagerProperty.save(fileName: fileName, data: data)
  }
}
