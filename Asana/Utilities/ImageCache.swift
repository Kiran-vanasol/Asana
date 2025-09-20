//
//  ImageCache.swift
//  Asana
//
//  Created by Kiran T C on 20/09/25.
//

// ImageCache.swift
import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        // optional tuning:
        // cache.countLimit = 200
        // cache.totalCostLimit = 1024 * 1024 * 200
    }

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func insert(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func removeAll() {
        cache.removeAllObjects()
    }
}
