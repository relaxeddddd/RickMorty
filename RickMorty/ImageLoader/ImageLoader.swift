import Foundation

/// ImageLoader
final class ImageLoader {
  /// singleton
  static let shared = ImageLoader()
  
  // MARK: - Private properties
  private var imageDataCache = NSCache<NSString, NSData>()
  
  // MARK: - Init
  private init() {}
  
  // MARK: - Public func
  public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    let key = url.absoluteString as NSString
    if let data = imageDataCache.object(forKey: key) {
      completion(.success(data as Data))
      return
    }
    
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
      guard let data = data, error == nil else {
        completion(.failure(error ?? URLError(.badServerResponse)))
        return
      }
      let value = data as NSData
      self?.imageDataCache.setObject(value, forKey: key)
      completion(.success(data))
    }
    task.resume()
  }
}
