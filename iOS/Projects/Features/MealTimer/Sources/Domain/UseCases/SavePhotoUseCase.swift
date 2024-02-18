//
//  SavePhotoUseCase.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/13/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation
import ImageManager

// MARK: - SavePhotoUseCaseRepresentable

protocol SavePhotoUseCaseRepresentable {
  func saveDataWithNowDescription(_ data: Data?) -> Date
}

// MARK: - SavePhotoUseCase

final class SavePhotoUseCase: SavePhotoUseCaseRepresentable {
  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm"

    return dateFormatter
  }()

  /// 데이터를 현재 시간으로 저장합니다.
  /// - Parameter data: 저장할 데이터 입니다. data가 nil 일경우 아무 일도 일어나지 않습니다.
  /// - Returns: 파일의 이름을 리턴합니다.(yyyy-MM-dd_HH:mm)
  func saveDataWithNowDescription(_ data: Data?) -> Date {
    let now = Date.now
    let fileName = dateFormatter.string(from: now)
    MealGokCacher.save(fileName: fileName, data: data)
    return now
  }
}
