//
//  ContentView.swift
//  MovieAPIonSwiftUI
//
//  Created by Almat Kairatov on 20.03.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var movieViewModel: MovieViewModel
    
    var body: some View {
        HomeView()
            .onAppear{
                movieViewModel.fetchMovies()
            }
    }
}

