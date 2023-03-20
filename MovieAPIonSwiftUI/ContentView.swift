//
//  ContentView.swift
//  MovieAPIonSwiftUI
//
//  Created by Almat Kairatov on 20.03.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var movies = [Movie]()
    @State var total_results = Int()
    @State var index: Int = 0
    @State var page: Int = 1

    @State var isFetching = false
    private var options = ["popular", "upcoming", "now_playing", "top_rated"]
    
    var body: some View {
        HomeView(movies: movies, selectedIndex: index, page: page, total_results: total_results, categoriesLowercased: options)
            .onAppear{
                fetchMovies(index: index)
            }
    }
    
    func fetchMovies(index: Int){
        // MARK: - Fetch Movies
        let movieManager = MovieManager()
        movieManager.fetchMovies(typeOfSort: options[index], isFetching: $isFetching, page: page) { movies in
            self.movies = movies.results
            self.total_results = movies.total_results
        }
    }

}

