//
//  UICollectionViewCell+ImageFetchable.swift
//  MealGokCacher
//
//  Created by MaraMincho on 2/21/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

extension UICollectionViewCell: ImageFetchable {
  public func setImage(downSampledImage: UIImage?) {
    largeContentImage = downSampledImage
  }
}
