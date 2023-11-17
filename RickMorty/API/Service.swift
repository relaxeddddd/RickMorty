import Foundation

/// Service
final class Service {
  
  /// singleton
  static let shared = Service()

  private let cacheManager = CacheManager()

  private init() {}

  /// Types error
  enum ServiceError: Error {
      case failedToCreateRequest
      case failedToGetData
  }
  
  // MARK: - Public func
  
  public func execute<T: Codable>(
    _ request: Request,
    expecting type: T.Type,
    completion: @escaping (Result<T, Error>) -> Void
  ) {
    if let cachedData = cacheManager.cachedResponse(
      for: request.endpoint,
      url: request.url
    ) {
      do {
        let result = try JSONDecoder().decode(type.self, from: cachedData)
        completion(.success(result))
      }
      catch {
        completion(.failure(error))
      }
      return
    }
    
    guard let urlRequest = self.request(from: request) else {
      completion(.failure(ServiceError.failedToCreateRequest))
      return
    }
    
    let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
      guard let data = data, error == nil else {
        completion(.failure(error ?? ServiceError.failedToGetData))
        return
      }
      
      do {
        let result = try JSONDecoder().decode(type.self, from: data)
        self?.cacheManager.setCache(
          for: request.endpoint,
          url: request.url,
          data: data
        )
        completion(.success(result))
      }
      catch {
        completion(.failure(error))
      }
    }
    task.resume()
  }
  
  // MARK: - Private
  
  private func request(from request: Request) -> URLRequest? {
    guard let url = request.url else {
      return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = request.httpMethod
    return request
  }
}
