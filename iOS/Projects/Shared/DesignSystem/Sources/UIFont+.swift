//
//  UIFont+.swift
//  DesignSystem
//
//  Created by MaraMincho on 1/30/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

public extension UIFont {
  static func preferredFont(forTextStyle textStyle: TextStyle, weight: UIFont.Weight?) -> UIFont {
    let descriptor = UIFontDescriptor
      .preferredFontDescriptor(withTextStyle: textStyle)
      .addingAttributes(
        [
          .traits: [UIFontDescriptor.TraitKey.weight: weight],
        ]
      )
    return UIFont(descriptor: descriptor, size: 0)
  }
}
