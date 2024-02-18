import Combine
import OSLog
import UIKit

// MARK: - MealGokCacher

public final class MealGokCacher {
  private init() {}
  
  private enum Constants{
    static let sharedImageFileManagerProperty: ImageFileManagerProperty = ImageFileManagerProperty.shared
  }

  public enum MealGokCacher: LocalizedError {
    case noData
    case invalidURL
  }

  // MARK: - Method

  /// LoadImageData
  /// - Parameters:
  ///   - url: URL
  ///   - completion: Network data
  /// - Returns: DataTask if image in cache return nil
  public static func loadImage(url: URL?, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url else {
      completion(.failure(MealGokCacher.invalidURL))
      return
    }
    let imagePathURL = ImageFileManagerProperty.imageDirPath.appending(path: url.lastPathComponent)
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
      Constants
        .sharedImageFileManagerProperty
        .targetViewAndFetchProperty
        .setObject(.init(fetchStatus: .init(.error(error)), fetchSubscription: nil), forKey: target)
    }
  }

  public static func cancelFetch(target: UIImageView) {
    Constants
      .sharedImageFileManagerProperty
      .targetViewAndFetchProperty
      .object(forKey: target)?.cancelFetch()
  }

  public static func fetchPublisher(target: UIImageView) -> AnyPublisher<FetchDescriptionStatus, Never>? {
    return Constants
      .sharedImageFileManagerProperty
      .targetViewAndFetchProperty
      .object(forKey: target)?.fetchStatusPublisher()
  }

  public static func fetchStatus(target: UIImageView) -> FetchDescriptionStatus? {
    return Constants
      .sharedImageFileManagerProperty
      .targetViewAndFetchProperty.object(forKey: target)?.currentFetchStatus()
  }
}

private extension MealGokCacher {
  /// Local을 통해 Fetch 합니다
  private static func fetchFromLocal(url: URL, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void) {
    do {
      try completion(.success(Data(contentsOf: url)))
      Constants
        .sharedImageFileManagerProperty
        .targetViewAndFetchProperty
        .setObject(.init(fetchStatus: .init(.finished), fetchSubscription: nil), forKey: target)
    } catch {
      completion(.failure(error))
      Constants
        .sharedImageFileManagerProperty
        .targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.error(error)), fetchSubscription: nil), forKey: target)
    }
  }

  /// 네트워크를 통해서 Fetch합니다.
  private static func fetchFromNetwork(url: URL, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void) {
    let fetchManager = ImageFileManagerProperty.imageNetworkFetchManager
    let description = fetchManager.dataTask(url: url, completion: completion)
    Constants
      .sharedImageFileManagerProperty
      .targetViewAndFetchProperty
      .setObject(description, forKey: target)
  }

  /// 파일캐셔를 통해서 현재 이미지가 Dir에 저장되어있는지 확인합니다.
  private static func isExistImageInDirectory(url: URL) throws -> Bool {
    let fileManager = ImageFileManagerProperty.fileManger

    // 만약 imageDirectory가 없다면 이미지 디렉토리를 생성합니다.
    if fileManager.fileExists(atPath: ImageFileManagerProperty.imageDirPath.path()) == false {
      try? fileManager.createDirectory(at: ImageFileManagerProperty.imageDirPath, withIntermediateDirectories: true)
    }
    return fileManager.fileExists(atPath: url.path())
  }
}
