//
//  UIImage+DownSample.swift
//  ImageManager
//
//  Created by MaraMincho on 2/15/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

public extension UIImageView {
  func downsampleImage(scale: CGFloat = 1) {
    guard let imageData = image?.jpegData(compressionQuality: 1) else {
      return
    }
    let pointSize = bounds.size
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions)!

    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels,
    ] as CFDictionary

    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
      return
    }

    image = UIImage(cgImage: downsampledImage)
  }
}
