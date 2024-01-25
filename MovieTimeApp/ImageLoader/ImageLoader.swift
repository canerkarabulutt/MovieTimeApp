//
//  ImageLoader.swift
//  MovieApp
//
//  Created by Caner Karabulut on 24.12.2023.
//

import Foundation

class ImageLoader {
    static let shared = ImageLoader()
    
    private init() {}

    public func downloadImage(_ url: URL, completion: @escaping (Result<Data,Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
