import Combine
import OSLog
import UIKit

// MARK: - MealGokCacher

public extension MealGokCacher {
  // MARK: - Method

  static func loadImage(url: URL?, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url else {
      completion(.failure(MealGokCacherError.invalidURL))
      return
    }
    Constants.sharedImageFileManagerProperty.loadImage(url: url, target: target, completion: completion)
  }

  static func cancelFetch(target: UIImageView) {
    Constants.sharedImageFileManagerProperty.cancelFetch(forKey: target)
  }

  static func fetchPublisher(target: UIImageView) -> AnyPublisher<FetchDescriptionStatus, Never>? {
    return Constants.sharedImageFileManagerProperty.fetchStatusPublisher(forKey: target)
  }

  static func fetchStatus(target: UIImageView) -> FetchDescriptionStatus? {
    return Constants.sharedImageFileManagerProperty.fetchStatus(forKey: target)
  }
}

// MARK: - MealGokCacherError

public enum MealGokCacherError: LocalizedError {
  case invalidURL
}
