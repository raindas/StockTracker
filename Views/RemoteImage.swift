//
//  RemoteImage.swift
//  StockTracker
//
//  Created by President Raindas on 04/07/2021.
//

import SwiftUI

struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }
    
    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading
        
        init(url: String) {
            var checkedURL = url
            if checkedURL == "" {
                checkedURL = "https://drive.google.com/uc?id=1b5GRPAof51japA3K3MDNiHZRBa2tjGDP"
            }
//            func isReachable(completion: @escaping (Bool) -> ()) {
//                var request = URLRequest(url: URL(string: url)!)
//                request.httpMethod = "HEAD"
//                URLSession.shared.dataTask(with: request) { _, response, _ in
//                    completion((response as? HTTPURLResponse)?.statusCode == 200)
//                }.resume()
//            }
//
//            isReachable {
//                success in
//                if success {
//                    print("url1 is reachable")
//                } else {
//                    print("url1 is Unreachable")
//                }
//            }
            
            guard let parsedURL = URL(string: checkedURL) else {
                fatalError("Invalid URL: \(checkedURL)")
            }
            
            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
        
    }
    
    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image
    
    var body: some View {
        selectImage()
            .resizable()
    }
    
    init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
    }
    
    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}
