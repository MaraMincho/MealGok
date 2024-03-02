//
//  UIImage+.swift
//  MealGokCacher
//
//  Created by MaraMincho on 3/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

public extension UIImage {
  func downSampleImage(downSampleProperty property: DownSampleProperty) -> Data? {
    guard let imageData = pngData() else {
      return nil
    }
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions)!

    let maxDimensionInPixels = max(property.size.width, property.size.height) * property.scale
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels,
    ] as CFDictionary

    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
      return nil
    }

    return UIImage(cgImage: downsampledImage).pngData()
  }
}
