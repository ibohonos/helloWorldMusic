//
//  URLImage.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import Foundation
import SwiftUI
import Combine

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    var url: URL?
    var cache: ImageCache?
    private var cancellable: AnyCancellable?
    private(set) var isLoading = false
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    deinit {
        image = nil
        cancellable?.cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        guard let url = url else { return }
//        print(#function)

        if let image = cache?[url] {
            self.image = image
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map {
                self.isLoading = true
                return UIImage(data: $0.data)
            }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    func cancel() {
//        print(#function)
        cancellable?.cancel()
    }
    
    private func onStart() {
//        print(#function)
        isLoading = true
    }
    
    private func onFinish() {
//        print(#function)
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
//        print(#function)
        guard let url = url else { return }

        image.map { cache?[url] = $0 }
    }
}

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader = ImageLoader()

    private let placeholder: Placeholder
    private let url: URL
    private var cache: ImageCache?
    private let configuration: (Image) -> Image
    
    init(url: URL,
         placeholder: Placeholder = Image(systemName: "photo") as! Placeholder,
         cache: ImageCache? = nil,
         configuration: @escaping (Image) -> Image = { $0 }
    ) {
        self.placeholder = placeholder
        self.configuration = configuration
        self.url = url
        self.cache = cache
    }

    var body: some View {
        image
            .onAppear {
                self.loader.url = url
                self.loader.cache = cache
                self.loader.load()
            }
            .onDisappear {
                self.loader.cancel()
            }
    }
    
    private var image: some View {
        Group {
            if let img = loader.image {
                configuration(Image(uiImage: img))
            } else {
                placeholder
            }
        }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
