import SwiftUI
import Combine

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image
    
    init(url: URL, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }
    
    var body: some View {
        image
            .onAppear { loader.load() }
    }
    
    private var image: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    private var cancellables = Set<AnyCancellable>()
    
    init(url: URL) {
        self.url = url
    }
    
    func load() {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
            .store(in: &cancellables)
    }
}
