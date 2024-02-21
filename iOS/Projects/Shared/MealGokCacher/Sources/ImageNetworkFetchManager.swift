//
//  ImageNetworkFetchManager.swift
//  ImageManager
//
//  Created by MaraMincho on 2/18/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import Foundation

// MARK: - FetchManager

final class ImageNetworkFetchManager {
  private enum LoadImageProperty {
    static let queue = DispatchSerialQueue(label: "ImageQueue")
  }

  private var subscription = Set<AnyCancellable>()

  func dataTask(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> FetchDescriptionProperty {
    let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
    let fetchStatusPublisher: CurrentValueSubject<FetchDescriptionStatus, Never> = .init(.fetching)

    let publisher = dataTaskPublisher
      .receive(on: LoadImageProperty.queue)
      .sink { complete in
        switch complete {
        case .finished:
          fetchStatusPublisher.send(.finished)
        case let .failure(error):
          fetchStatusPublisher.send(.error(error))
          completion(.failure(error))
        }
      } receiveValue: { (data: Data, _: URLResponse) in
        completion(.success(data))
      }
    let property = FetchDescriptionProperty(fetchStatus: fetchStatusPublisher, fetchSubscription: publisher)

    publisher.store(in: &subscription)
    return property
  }
}
