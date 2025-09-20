//
//  CachedAsyncImage.swift
//  Asana
//
//  Created by Kiran T C on 20/09/25.
//
// CachedAsyncImage.swift
import SwiftUI

/// A small SwiftUI wrapper that uses ImageLoader and ImageCache.
/// Usage: CachedAsyncImage(url: URL(...)) { image in ... } placeholder: { ... }
struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    @StateObject private var loader = ImageLoader()
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    init(url: URL?,
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let ui = loader.image {
                content(Image(uiImage: ui))
            } else {
                placeholder()
            }
        }
        .onAppear {
            guard let url = url else { return }
            loader.load(from: url)
        }
        .onDisappear {
            loader.cancel()
        }
    }
}

