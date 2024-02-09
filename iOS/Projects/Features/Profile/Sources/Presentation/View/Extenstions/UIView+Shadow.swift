//
//  UIView+Shadow.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/9/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

extension UIView {
  func addShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = .init(width: -2, height: 2)
    layer.shadowRadius = 3.0
    layer.shadowOpacity = 0.1
  }
}
