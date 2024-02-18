//
//  DownSampleProperty.swift
//  ImageManager
//
//  Created by MaraMincho on 2/12/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

// MARK: - DownSampleProperty

public extension Data {
  /// DownSampleProperty가 nil일경우 nil을 반환합니다.
  func downSample(downSampleProperty property: DownSampleProperty?) -> UIImage? {
    guard let property else { return nil }

    let data = self as CFData
    guard let imageSource = CGImageSourceCreateWithData(data, nil) else {
      return nil
    }

    let maxPixel = Swift.max(property.size.width, property.size.height)
    let downSampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxPixel,
    ] as CFDictionary

    guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions) else {
      return nil
    }
    return UIImage(cgImage: cgImage)
  }
}

// MARK: - DownSampleProperty

public struct DownSampleProperty {
  let size: CGSize
  let scale: Int
  init(size: CGSize, scale: Int = 1) {
    self.size = size
    self.scale = scale
  }
}
