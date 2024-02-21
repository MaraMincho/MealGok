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
    Task {
      await Constants.sharedImageFileManagerProperty.loadImage(url: url, target: target, completion: completion)
    }
  }

  static func cancelFetch(target: AnyObject) {
    Task {
      await Constants.sharedImageFileManagerProperty.cancelFetch(forKey: target)
    }
  }

  static func fetchPublisher(target: AnyObject) async -> AnyPublisher<FetchDescriptionStatus, Never>? {
    return await Constants.sharedImageFileManagerProperty.fetchStatusPublisher(forKey: target)
  }

  static func fetchStatus(target: AnyObject) async -> FetchDescriptionStatus? {
    return await Constants.sharedImageFileManagerProperty.fetchStatus(forKey: target)
  }
}

// MARK: - MealGokCacherError

public enum MealGokCacherError: LocalizedError {
  case invalidURL
}
