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

final class ImageFileManagerProperty {
  // MARK: - SingleTone Shared Property

  static let shared = ImageFileManagerProperty()

  // MARK: - Property

  private let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  private lazy var imageDirPath = documentPath.appending(path: Constants.dirName)
  private let fileManager = FileManager.default
  private let imageNetworkFetchManager = ImageNetworkFetchManager()

  // MARK: - StoreProperty

  private var targetViewAndFetchProperty: NSMapTable<UIImageView, FetchDescriptionProperty> = .weakToStrongObjects()

  // MARK: - Method

  func setTargetViewAndFetchProperty(imageView: UIImageView, fetchDescriptionProperty: FetchDescriptionProperty) {
    targetViewAndFetchProperty.setObject(fetchDescriptionProperty, forKey: imageView)
  }

  func fetchProperty(forKey: UIImageView) -> FetchDescriptionProperty? {
    return targetViewAndFetchProperty.object(forKey: forKey)
  }

  func cancelFetch(forKey: UIImageView) {
    fetchProperty(forKey: forKey)?.cancelFetch()
  }

  func fetchStatus(forKey: UIImageView) -> FetchDescriptionStatus? {
    return fetchProperty(forKey: forKey)?.currentFetchStatus()
  }

  func fetchStatusPublisher(forKey: UIImageView) -> AnyPublisher<FetchDescriptionStatus, Never>? {
    return fetchProperty(forKey: forKey)?.fetchStatusPublisher()
  }

  func loadImage(url: URL, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void) {
    let imagePathURL = imageDirPath.appending(path: url.lastPathComponent)
    do {
      // 만약 이미지 파일이 Dir에 존재 한다면 Netwrok요청을 하지 않습니다.
      let isExistImage = try isExistImageInDirectory(url: imagePathURL)
      if isExistImage {
        fetchFromLocal(url: url, target: target, completion: completion)
      }

      // 네트워크를 통해 Image를 Fetch합니다.
      fetchFromNetwork(url: url, target: target, completion: completion)
    } catch {
      completion(.failure(error))
      setTargetViewAndFetchProperty(imageView: target, fetchDescriptionProperty: .init(fetchStatus: .init(.error(error)), fetchSubscription: nil))
    }
  }

  private enum Constants {
    static let dirName: String = "MealGokImages"
  }

  private init() {}
}

extension ImageFileManagerProperty {
  func url(fileName: String) -> URL {
    return imageDirPath.appending(path: fileName)
  }

  /// 도큐먼트 폴더에 파일 이름을 추가한 URL이 현재 존재하는지 확인합니다.
  func isExistURL(fileName: String) -> Bool {
    let imagePathURL = imageDirPath.appending(path: fileName)
    return fileManager.fileExists(atPath: imagePathURL.path())
  }

  func save(fileName: String, data: Data) {
    let imagePathURL = imageDirPath.appending(path: fileName)

    do {
      if fileManager.fileExists(atPath: imageDirPath.path()) == false {
        try fileManager.createDirectory(at: imageDirPath, withIntermediateDirectories: true)
      }
      Logger().debug("\(imagePathURL.path())")
      try data.write(to: imagePathURL)
    } catch {
      Logger().error("\(error.localizedDescription)")
      Logger().error("error(Cant make ImageFileManagerProperty, \(#function)")
    }
  }
}

private extension ImageFileManagerProperty {
  func isExistImageInDirectory(url: URL) throws -> Bool {
    // 만약 imageDirectory가 없다면 이미지 디렉토리를 생성합니다.
    if fileManager.fileExists(atPath: imageDirPath.path()) == false {
      try? fileManager.createDirectory(at: imageDirPath, withIntermediateDirectories: true)
    }
    return fileManager.fileExists(atPath: url.path())
  }

  /// Local을 통해 Fetch 합니다
  func fetchFromLocal(url: URL, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void) {
    do {
      try completion(.success(Data(contentsOf: url)))
      targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.finished), fetchSubscription: nil), forKey: target)
    } catch {
      completion(.failure(error))
      targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.error(error)), fetchSubscription: nil), forKey: target)
    }
  }

  /// 네트워크를 통해서 Fetch합니다.
  private func fetchFromNetwork(url: URL, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void) {
    let description = imageNetworkFetchManager.dataTask(url: url, completion: completion)
    targetViewAndFetchProperty.setObject(description, forKey: target)
  }
}
