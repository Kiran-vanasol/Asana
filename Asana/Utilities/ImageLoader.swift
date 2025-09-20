//
//  ImageLoader.swift
//  Asana
//
//  Created by Kiran T C on 20/09/25.
//

import UIKit
import Combine
import CryptoKit

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?
    private static let fileIOQueue = DispatchQueue(label: "com.asana.imageloader.disk", qos: .utility)

    /// Load a URL (memory -> disk -> network)
    func load(from url: URL) {
        // 1) memory cache
        if let mem = ImageCache.shared.image(forKey: url.absoluteString) {
            self.image = mem
            return
        }

        // 2) disk cache
        let diskURL = Self.diskCacheURL(for: url)
        if FileManager.default.fileExists(atPath: diskURL.path) {
            ImageLoader.fileIOQueue.async {
                if let data = try? Data(contentsOf: diskURL),
                   let ui = UIImage(data: data) {
                    ImageCache.shared.insert(ui, forKey: url.absoluteString)
                    DispatchQueue.main.async {
                        self.image = ui
                    }
                    return
                }
                // if disk read fails, fall back to network
                DispatchQueue.main.async {
                    self.fetchFromNetwork(url: url)
                }
            }
            return
        }

        // 3) network
        fetchFromNetwork(url: url)
    }

    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }

    // MARK: - Private

    private func fetchFromNetwork(url: URL) {
        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] img in
                guard let self = self, let ui = img else { return }
                ImageCache.shared.insert(ui, forKey: url.absoluteString)
                self.image = ui

                // write to disk async
                ImageLoader.fileIOQueue.async {
                    let diskURL = Self.diskCacheURL(for: url)
                    if let data = ui.jpegData(compressionQuality: 0.9) {
                        try? FileManager.default.createDirectory(at: diskURL.deletingLastPathComponent(),
                                                                withIntermediateDirectories: true)
                        try? data.write(to: diskURL, options: [.atomic])
                    }
                }
            })
    }

    private static func diskCacheURL(for url: URL) -> URL {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let folder = caches.appendingPathComponent("AsanaImageCache", isDirectory: true)
        let fileName = sha256(url.absoluteString) + ".jpg"
        return folder.appendingPathComponent(fileName)
    }

    private static func sha256(_ string: String) -> String {
        guard let data = string.data(using: .utf8) else { return UUID().uuidString }
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
