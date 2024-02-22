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
