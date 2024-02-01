//
//  MealGokSuccessContentView.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

final class MealGokSuccessContentView: UIView {
  
  private let property: MealGokSuccessContentViewProperty
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    
    return label
  }()
  
  init(frame: CGRect, mealGokContentProperty: MealGokSuccessContentViewProperty) {
    self.property = mealGokContentProperty
    super.init(frame: frame)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("Cant use this method")
  }
}

struct MealGokSuccessContentViewProperty {
  /// yyyy. mm. dd 형식의 날짜 String
  let date: String
  
  let pictureURL: URL?
  
  let description: String
}
