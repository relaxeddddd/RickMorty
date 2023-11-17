import Foundation

/// CacheManager
final class CacheManager {
  
  // MARK: - Private properties
  
  private var cacheDictionary: [
    Endpoint: NSCache<NSString, NSData>
  ] = [:]
  
  // MARK: - Init
  init() {
    setUpCache()
  }
  
  // MARK: - Public func
  
  public func cachedResponse(for endpoint: Endpoint, url: URL?) -> Data? {
    guard let targetCache = cacheDictionary[endpoint], let url = url else {
      return nil
    }
    let key = url.absoluteString as NSString
    return targetCache.object(forKey: key) as? Data
  }
  
  public func setCache(for endpoint: Endpoint, url: URL?, data: Data) {
    guard let targetCache = cacheDictionary[endpoint], let url = url else {
      return
    }
    let key = url.absoluteString as NSString
    targetCache.setObject(data as NSData, forKey: key)
  }
  
  // MARK: - Private func
  
  private func setUpCache() {
    Endpoint.allCases.forEach({ endpoint in
      cacheDictionary[endpoint] = NSCache<NSString, NSData>()
    })
  }
}
