//
//  TimerUseCasePropertyEntity.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Foundation

public struct TimerUseCasePropertyEntity {
  /// 타이머뷰에 표시 될 "분" 텍스트 입니다.
  let minute: String

  /// 타이머뷰에 표시 될 "초" 텍스트 입니다.
  let seconds: String

  /// 부채꼴의 각도입니다. radian으로 표시됩니다.
  ///
  /// UseCase에서 Entity로 활용할 때, 만약 Protin
  let fanRadian: Double?
}
