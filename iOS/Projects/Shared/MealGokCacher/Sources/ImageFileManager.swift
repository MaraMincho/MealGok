//
//  ImageFileManager.swift
//  ImageManager
//
//  Created by MaraMincho on 2/18/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import OSLog
import UIKit

// MARK: - ImageFileManager

final class ImageFileManager {
  // MARK: - Property

  init(documentPath: URL) {
    self.documentPath = documentPath
  }

  private let documentPath: URL
  private let fileManager = FileManager.default

  // MARK: - StoreProperty

  private var targetViewAndFetchTask: NSMapTable<AnyObject, FetchDescriptionTask> = .weakToStrongObjects()
  private let imageCache: NSCache<AnyObject, AnyObject> = .init()

  // MARK: - Method

  func cancelFetch(forKey: AnyObject) {
    targetViewAndFetchTask.object(forKey: forKey)?.taskHandle?.cancel()
  }

  func fetchStatus(forKey: AnyObject) -> FetchDescriptionStatus? {
    return targetViewAndFetchTask.object(forKey: forKey)?.fetchStatus.value
  }

  func fetchStatusPublisher(forKey: AnyObject) -> AnyPublisher<FetchDescriptionStatus, Never>? {
    return targetViewAndFetchTask.object(forKey: forKey)?.fetchStatusPublisher()
  }

  func loadImage(url: URL, target: AnyObject, completion: @escaping (Result<Data, Error>) -> Void) {
    let imagePathURL = documentPath.appending(path: url.lastPathComponent)

    let fetchDescriptionStatus = setFetchDescription(target: target)

    do {
      // TODO: Memory에 url과 Image가 있다면 그것을 리턴합니다.
      // if isExistImageInMemory { fetchFromMemory(url: url, target: target, completion: completion)}

      // 만약 이미지 파일이 Dir에 존재 한다면 Netwrok요청을 하지 않습니다.
      let isExistImage = try isExistImageInDirectory(url: imagePathURL)
      if isExistImage {
        let data = try fetchFromLocal(url: url)
        completion(.success(data))
        fetchDescriptionStatus.send(.finished)
        return
      }

      // 네트워크를 통해 Image를 Fetch합니다.
      let networkTask = Task<Data, Error> {
        let fetchedData = try await fetchFromNetwork(url: url)
        completion(.success(fetchedData))
        fetchDescriptionStatus.send(.finished)
        return fetchedData
      }
      targetViewAndFetchTask.object(forKey: target)?.taskHandle = networkTask
    } catch {
      targetViewAndFetchTask.setObject(.init(fetchStatus: .init(.error(error)), taskHandle: nil), forKey: target)
      completion(.failure(error))
    }
  }

  private enum Constants {
    static let dirName: String = "MealGokImages"
  }
}

private extension ImageFileManager {
  func isExistImageInDirectory(url: URL) throws -> Bool {
    // 만약 imageDirectory가 없다면 이미지 디렉토리를 생성합니다.
    if fileManager.fileExists(atPath: documentPath.path()) == false {
      try? fileManager.createDirectory(at: documentPath, withIntermediateDirectories: true)
    }
    return fileManager.fileExists(atPath: url.path())
  }
  
  /// fetchDescription을 target과 연결 짓습니다.
  func setFetchDescription(target: AnyObject) -> CurrentValueSubject<FetchDescriptionStatus, Never>{
    let fetchDescriptionStatus = CurrentValueSubject<FetchDescriptionStatus, Never>(.fetching)
    let fetchDescriptionTask = FetchDescriptionTask(fetchStatus: fetchDescriptionStatus, taskHandle: nil)
    targetViewAndFetchTask.setObject(fetchDescriptionTask, forKey: target)
    
    return fetchDescriptionStatus
  }
  
  /// Local을 통해 Fetch 합니다
  func fetchFromLocal(url: URL) throws -> Data {
    let data = try Data(contentsOf: url)
    return data
  }

  func fetchFromNetwork(url: URL) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
  }
}
