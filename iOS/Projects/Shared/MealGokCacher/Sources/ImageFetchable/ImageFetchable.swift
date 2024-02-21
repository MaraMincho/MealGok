//
//  ImageFetchable.swift
//  MealGokCacher
//
//  Created by MaraMincho on 2/21/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//
import Combine
import OSLog
import UIKit

// MARK: - ImageFetchable

public protocol ImageFetchable {
  func setImage(url: URL?, downSampleProperty property: DownSampleProperty?)
  func cancelFetch()
  func fetchPublisher() -> AnyPublisher<FetchDescriptionStatus, Never>?
  func fetchStatus() -> FetchDescriptionStatus?
  func applyDownSampling(data: Data, downSampleProperty property: DownSampleProperty?)
  func setImage(downSampledImage: UIImage?)
}

public extension ImageFetchable where Self: AnyObject {
  func setImage(url: URL?, downSampleProperty property: DownSampleProperty? = nil) {
    MealGokCacher.loadImage(url: url, target: self) { [weak self] result in
      switch result {
      case let .success(data):
        self?.applyDownSampling(data: data, downSampleProperty: property)
      case let .failure(error):
        Logger().error("\(error.localizedDescription)")
      }
    }
  }

  func cancelFetch() {
    MealGokCacher.cancelFetch(target: self)
  }

  func fetchPublisher() -> AnyPublisher<FetchDescriptionStatus, Never>? {
    return MealGokCacher.fetchPublisher(target: self)
  }

  func fetchStatus() -> FetchDescriptionStatus? {
    return MealGokCacher.fetchStatus(target: self)
  }

  func applyDownSampling(data: Data, downSampleProperty property: DownSampleProperty?) {
    let targetImage: UIImage? = property == nil ? UIImage(data: data) : data.downSample(downSampleProperty: property!)
    DispatchQueue.main.async {
      self.setImage(downSampledImage: targetImage)
    }
  }
}
