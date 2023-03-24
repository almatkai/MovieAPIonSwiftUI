//
// Created by Almat Kairatov on 20.03.2023.
//

import Foundation

class MovieViewModel: ObservableObject {

    private var options = ["popular", "upcoming", "now_playing", "top_rated"]
    @Published var movies = [Movie]()
    @Published var total_results = Int()
    @Published var index = 0
    @Published var page = 1
    
    func fetchMovies(){
        // MARK: - Fetch Movies
        let movieManager = MovieManager()
        movieManager.fetchMovies(typeOfSort: options[index], page: page) { movies in
            DispatchQueue.main.async {
                self.movies = movies.results
                self.total_results = movies.total_results
            }
        }
    }
}
