//
//  UIImageView+.swift
//  ImageManager
//
//  Created by MaraMincho on 2/12/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

public extension UIImageView {
  private enum LoadImageProperty {
    static let queue = DispatchSerialQueue(label: "ImageQueue")
  }
  
  @discardableResult
  func setImage(url: URL?, downSampleProperty property: DownSampleProperty? = nil) -> URLSessionDataTask? {
    guard let url = url else {
      return nil
    }
    return FileCacher.load(url: url) { [weak self] result in
      switch result {
        
      /// 성공했을 때 다운샘플링 프로퍼티에 따라서 이미지를 resizing 합니다.
      case let .success( data):
        self?.applyDownSampling(data: data, downSampleProperty: property)
        
      /// 에러가 발생했을 때 Error을 핸들링 하면 좋아 보임
      case let .failure(error):
        break
      }
      
    }
  }
  
  func applyDownSampling(data: Data, downSampleProperty property: DownSampleProperty?) {
    let targetImage: UIImage? = property == nil ? UIImage(data: data) : data.downSample(downSampleProperty: property)
    
    DispatchQueue.main.async {
      self.image = targetImage
    }
  }
}
