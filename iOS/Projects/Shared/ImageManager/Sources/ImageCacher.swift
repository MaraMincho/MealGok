import Combine
import OSLog
import UIKit

// MARK: - FetchDescriptionProperty

public final class FetchDescriptionProperty {
  private var fetchStatus: CurrentValueSubject<FetchManagerFetchStatus, Never>
  private weak var fetchSubscription: AnyCancellable?

  init(fetchStatus: CurrentValueSubject<FetchManagerFetchStatus, Never>, fetchSubscription: AnyCancellable?) {
    self.fetchStatus = fetchStatus
    self.fetchSubscription = fetchSubscription
  }

  /// 현재 fetchStatus를 리턴합니다.
  func currentFetchStatus() -> FetchManagerFetchStatus {
    return fetchStatus.value
  }

  /// fetchStatusPublisher를 리턴합니다.
  func fetchStatusPublisher() -> AnyPublisher<FetchManagerFetchStatus, Never> {
    return fetchStatus.eraseToAnyPublisher()
  }

  func cancelFetch() {
    fetchSubscription?.cancel()
  }
}

// MARK: - FetchManager

final class FetchManager {
  private enum LoadImageProperty {
    static let queue = DispatchConcurrentQueue(label: "ImageQueue")
  }

  private var subscription = Set<AnyCancellable>()

  func dataTask(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> FetchDescriptionProperty {
    let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
    let fetchStatusPublisher: CurrentValueSubject<FetchManagerFetchStatus, Never> = .init(.fetching)

    let publisher = dataTaskPublisher
      .subscribe(on: LoadImageProperty.queue)
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

// MARK: - FetchManagerFetchStatus

public enum FetchManagerFetchStatus {
  /// 아직 Fetch를 시작하지 않았습니다.
  ///
  /// URL을 Fetch하라는 명령이 있었는지 확인해 보세요
  case notStarted

  /// 현재 Fetch중입니다.
  case fetching

  /// Fetch가 끝났습니다.
  case finished

  /// Fetch중 에러가 발생했습니다.
  case error(Error)
}

// MARK: - FileCacher

public final class FileCacher {
  private init() {}
  static let shared = FileCacher()

  // MARK: - Property

  var targetViewAndFetchProperty: NSMapTable<UIImageView, FetchDescriptionProperty> = .weakToStrongObjects()

  enum ImageFileManagerProperty {
    static let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let imageDirPath = documentPath.appending(path: ImageCacherConstants.dirName)
    static let fileManger = FileManager.default
    static let fetchManager = FetchManager()
  }

  private enum ImageNetworkProperty {
    static let imageSession: URLSession = .init(configuration: .default)
  }

  private enum ImageCacherConstants {
    static let dirName: String = "MealGokImages"
  }

  public enum FileCacherError: LocalizedError {
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
      completion(.failure(FileCacherError.invalidURL))
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
      shared.targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.error(error)), fetchSubscription: nil), forKey: target)
    }
  }

  public static func cancelFetch(target: UIImageView) {
    shared.targetViewAndFetchProperty.object(forKey: target)?.cancelFetch()
  }

  public static func fetchPublisher(target: UIImageView) -> AnyPublisher<FetchManagerFetchStatus, Never>? {
    return shared.targetViewAndFetchProperty.object(forKey: target)?.fetchStatusPublisher()
  }

  public static func fetchStatus(target: UIImageView) -> FetchManagerFetchStatus? {
    return shared.targetViewAndFetchProperty.object(forKey: target)?.currentFetchStatus()
  }
}

private extension FileCacher {
  /// Local을 통해 Fetch 합니다
  private static func fetchFromLocal(url: URL, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void) {
    do {
      try completion(.success(Data(contentsOf: url)))
      shared.targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.finished), fetchSubscription: nil), forKey: target)
    } catch {
      completion(.failure(error))
      shared.targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.error(error)), fetchSubscription: nil), forKey: target)
    }
  }

  /// 네트워크를 통해서 Fetch합니다.
  private static func fetchFromNetwork(url: URL, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void) {
    let fetchManager = ImageFileManagerProperty.fetchManager
    let description = fetchManager.dataTask(url: url, completion: completion)
    shared.targetViewAndFetchProperty.setObject(description, forKey: target)
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
