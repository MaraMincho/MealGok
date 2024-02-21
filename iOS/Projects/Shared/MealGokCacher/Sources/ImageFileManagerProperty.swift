//
//  ImageFileManagerProperty.swift
//  ImageManager
//
//  Created by MaraMincho on 2/18/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import OSLog
import UIKit

// MARK: - ImageFileManagerProperty

actor ImageFileManagerProperty {
  // MARK: - Property

  init(documentPath: URL) {
    self.documentPath = documentPath
  }

  private let documentPath: URL
  private let fileManager = FileManager.default
  private let imageNetworkFetchManager = ImageNetworkFetchManager()

  // MARK: - StoreProperty

  private var targetViewAndFetchProperty: NSMapTable<AnyObject, FetchDescriptionProperty> = .weakToStrongObjects()

  // MARK: - Method

  func setTargetViewAndFetchProperty(imageView: AnyObject, fetchDescriptionProperty: FetchDescriptionProperty) {
    targetViewAndFetchProperty.setObject(fetchDescriptionProperty, forKey: imageView)
  }

  func fetchProperty(forKey: AnyObject) -> FetchDescriptionProperty? {
    return targetViewAndFetchProperty.object(forKey: forKey)
  }

  func cancelFetch(forKey: AnyObject) {
    fetchProperty(forKey: forKey)?.cancelFetch()
  }

  func fetchStatus(forKey: AnyObject) -> FetchDescriptionStatus? {
    return fetchProperty(forKey: forKey)?.currentFetchStatus()
  }

  func fetchStatusPublisher(forKey: AnyObject) -> AnyPublisher<FetchDescriptionStatus, Never>? {
    return fetchProperty(forKey: forKey)?.fetchStatusPublisher()
  }

  func loadImage(url: URL, target: AnyObject, completion: @escaping (Result<Data, Error>) -> Void) async {
    let imagePathURL = documentPath.appending(path: url.lastPathComponent)
    do {
      // TODO: Memory에 url과 Image가 있다면 그것을 리턴합니다.
      // if isExistImageInMemory { fetchFromMemory(url: url, target: target, completion: completion)}

      // 만약 이미지 파일이 Dir에 존재 한다면 Netwrok요청을 하지 않습니다.
      let isExistImage = try isExistImageInDirectory(url: imagePathURL)
      if isExistImage {
        fetchFromLocal(url: url, target: target, completion: completion)
      }

      // 네트워크를 통해 Image를 Fetch합니다.
      await fetchFromNetwork(url: url, target: target, completion: completion)
    } catch {
      completion(.failure(error))
      setTargetViewAndFetchProperty(imageView: target, fetchDescriptionProperty: .init(fetchStatus: .init(.error(error)), fetchSubscription: nil))
    }
  }

  private enum Constants {
    static let dirName: String = "MealGokImages"
  }
}

private extension ImageFileManagerProperty {
  func isExistImageInDirectory(url: URL) throws -> Bool {
    // 만약 imageDirectory가 없다면 이미지 디렉토리를 생성합니다.
    if fileManager.fileExists(atPath: documentPath.path()) == false {
      try? fileManager.createDirectory(at: documentPath, withIntermediateDirectories: true)
    }
    return fileManager.fileExists(atPath: url.path())
  }

  /// Local을 통해 Fetch 합니다
  func fetchFromLocal(url: URL, target: AnyObject, completion: @escaping (Result<Data, Error>) -> Void) {
    do {
      try completion(.success(Data(contentsOf: url)))
      targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.finished), fetchSubscription: nil), forKey: target)
    } catch {
      completion(.failure(error))
      targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.error(error)), fetchSubscription: nil), forKey: target)
    }
  }

  /// 네트워크를 통해서 Fetch합니다.
  private func fetchFromNetwork(url: URL, target: AnyObject, completion: @escaping (Result<Data, Error>) -> Void) async {
    let description = await imageNetworkFetchManager.dataTask(url: url, completion: completion)
    targetViewAndFetchProperty.setObject(description, forKey: target)
  }
}
