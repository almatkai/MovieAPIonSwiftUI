//
//  MovieManager.swift
//  MovieAPIonSwiftUI
//
//  Created by Almat Kairatov on 20.03.2023.
//

import Foundation
import SwiftUI

struct MovieManager {
    func fetchMovies(typeOfSort: String, page: Int, completion: @escaping(MovieModel) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(typeOfSort)?api_key=e4c34b81df02c39e57793e9118805012&language=ru-Ru&page=\(page)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _ , error) in
            if let error = error{
                print ("DEBUG: Error fetching movies: \(error.localizedDescription) ")
            }
            guard let jsonData = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(MovieModel.self, from: jsonData)
                for _ in decodedData.results {
                    completion(decodedData)
                }
            } catch {
                print("DEBUG: Decoding error ...")
            }
            
        }
        
        dataTask.resume()
    }
}
