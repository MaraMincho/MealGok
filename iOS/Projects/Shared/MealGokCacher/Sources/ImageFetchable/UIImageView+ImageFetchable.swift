//
//  UIImageView+ImageFetchable.swift
//  ImageManager
//
//  Created by MaraMincho on 2/12/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import OSLog
import UIKit

extension UIImageView: ImageFetchable {
  public func setImage(downSampledImage image: UIImage?) {
    self.image = image
  }
}

