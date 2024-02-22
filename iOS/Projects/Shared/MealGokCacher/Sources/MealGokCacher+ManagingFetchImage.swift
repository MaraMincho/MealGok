import Combine
import OSLog
import UIKit

// MARK: - MealGokCacher

public extension MealGokCacher {
  // MARK: - Method

  static func loadImage(url: URL?, target: AnyObject, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url else {
      completion(.failure(MealGokCacherError.invalidURL))
      return
    }
    Constants.sharedImageFileManagerProperty.loadImage(url: url, target: target, completion: completion)
  }

  static func loadImagePublisher(url: URL?, target: AnyObject) -> AnyPublisher<Result<Data, Error>, Never> {
    guard let url else {
      return Just(.failure(MealGokCacherError.invalidURL)).eraseToAnyPublisher()
    }
    return Future { promise in
      Constants.sharedImageFileManagerProperty.loadImage(url: url, target: target) { result in
        switch result {
        case let .success(data):
          promise(.success(.success(data)))
        case let .failure(error):
          promise(.success(.failure(error)))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  static func loadImagePublisher(url: URL?, target: AnyObject) async -> Result<Data,Error> {
    guard let url else {
      return .failure(MealGokCacherError.invalidURL)
    }
    return await withCheckedContinuation { continuation in
      Constants.sharedImageFileManagerProperty.loadImage(url: url, target: target) { result in
        continuation.resume(returning: result)
      }
    }
  }

  static func cancelFetch(target: AnyObject) {
    Constants.sharedImageFileManagerProperty.cancelFetch(forKey: target)
  }

  static func fetchPublisher(target: AnyObject) -> AnyPublisher<FetchDescriptionStatus, Never>? {
    return Constants.sharedImageFileManagerProperty.fetchStatusPublisher(forKey: target)
  }

  static func fetchStatus(target: AnyObject) -> FetchDescriptionStatus? {
    return Constants.sharedImageFileManagerProperty.fetchStatus(forKey: target)
  }
}

// MARK: - MealGokCacherError

public enum MealGokCacherError: LocalizedError {
  case invalidURL
}
