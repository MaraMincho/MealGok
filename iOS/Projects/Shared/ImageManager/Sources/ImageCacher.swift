import UIKit
import OSLog

public final class FileCacher {
  private enum ImageFileManagerProperty{
    static let documentPath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first!
    static let imageDirPath = documentPath.appending(path: ImageCacherConstants.dirName)
    static let fileManger = FileManager.default
  }
  
  private enum ImageNetworkProperty {
    static let imageSession: URLSession = .init(configuration: .default)
  }
  
  private enum ImageCacherConstants {
    static let dirName: String = "MealGokImages"
  }
  
  public enum FileCacherError: LocalizedError {
    case noData
  }
  
  public static func url(fileName: String) -> URL {
    return ImageFileManagerProperty.imageDirPath.appending(path: fileName)
  }
  
  public static func isExistURL(fileName: String) -> Bool {
    let url = ImageFileManagerProperty.imageDirPath.appending(path: fileName)
    return ImageFileManagerProperty.fileManger.fileExists(atPath: url.path())
  }
  
  public static func save(fileName: String, data: Data?) {
    guard let data else { return }
    let imagePathURL = ImageFileManagerProperty.imageDirPath.appending(path: fileName)
    let fileManager = ImageFileManagerProperty.fileManger
    
    do {
      if fileManager.fileExists(atPath: ImageFileManagerProperty.imageDirPath.path()) == false {
        try fileManager.createDirectory(at: ImageFileManagerProperty.imageDirPath, withIntermediateDirectories: true)
      }
      try data.write(to: imagePathURL)
    } catch {
      Logger().error("\(error.localizedDescription)")
      Logger().error("error(Cant make ImageFileManagerProperty, \(#function)")
    }
    
  }
  
  /// LoadImageData
  /// - Parameters:
  ///   - url: URL
  ///   - completion: Network data
  /// - Returns: DataTask if image in cache return nil
  @discardableResult
  public static func load(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask?{
    
    /// 파일지 저장될 URL입니다.
    let imagePathURL = ImageFileManagerProperty.imageDirPath.appending(path: url.lastPathComponent)
    do {
      
      /// 만약 이미지 파일이 Dir에 존재 한다면 Netwrok요청을 하지 않습니다.
      let isExistImage = try isExistImageInDirectory(url: imagePathURL)
      if isExistImage {
        completion(.success(try Data(contentsOf: url)))
        return nil
      }
      
      return loadImage(url: imagePathURL) { result in
        switch result {
        case let .success(data):
          completion(.success(data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
    }catch {
      completion(.failure(error))
      return nil
    }
  }
  
  private static func isExistImageInDirectory(url: URL) throws -> Bool{
    let fileManager = ImageFileManagerProperty.fileManger
    
    /// 만약 imageDirectory가 없다면 이미지 디렉토리를 생성합니다.
    if fileManager.fileExists(atPath: ImageFileManagerProperty.imageDirPath.path()) == false {
      try fileManager.createDirectory(at: ImageFileManagerProperty.imageDirPath, withIntermediateDirectories: true)
    }
    return fileManager.fileExists(atPath: url.path())
  }
  
  private static func loadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
    let session = ImageNetworkProperty.imageSession
    let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
      guard error == nil else {
        completion(.failure(error!))
        return
      }
      
      guard let data else {
        completion(.failure(FileCacherError.noData))
        return
      }
      
      completion(.success(data))
    }
    task.resume()
    return task
  }
}
