//
//  MovieManager.swift
//  MovieAPIonSwiftUI
//
//  Created by Almat Kairatov on 20.03.2023.
//

import Foundation
import SwiftUI

struct MovieManager {
    func fetchMovies(typeOfSort: String, page: Int, completion: @escaping(TotalMovieResultModel) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(typeOfSort)?api_key=e4c34b81df02c39e57793e9118805012&language=en-US&page=\(page)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response , error) in
            if let error = error{
                print ("DEBUG: Error fetching movies: \(error.localizedDescription) ")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("DEBUG: HTTP error code: \(httpResponse.statusCode)")
                    return
                }
            }
            guard let jsonData: Data? = data else {
                print("DEBUG: No data received from server.")
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(TotalMovieResultModel.self, from: jsonData!)
                for _ in decodedData.results {
                    completion(decodedData)
                }
            } catch let DecodingError.dataCorrupted(context) {
                print("DEBUG CONTEXT: \(context)")
            } catch let DecodingError.keyNotFound(key, context) {
                print("DEBUG CONTEXT: Key '\(key)' not found:", context.debugDescription)
                print("1 codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("DEBUG CONTEXT: Value '\(value)' not found:", context.debugDescription)
                print("DEBUG CONTEXT: 2 codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("DEBUG CONTEXT: Type '\(type)' mismatch:", context.debugDescription)
                print("DEBUG CONTEXT: 3 codingPath:", context.codingPath)
            } catch {
                print("ERROR: \(error.localizedDescription)")
                if let data = jsonData {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print JSON data.")
                } else {
                    print("No JSON data received.")
                }
            }
        }
        
        dataTask.resume()
    }
}
