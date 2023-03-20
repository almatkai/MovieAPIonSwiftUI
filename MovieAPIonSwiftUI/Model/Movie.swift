//
//  Movie.swift
//  MovieAPIonSwiftUI
//
//  Created by Almat Kairatov on 20.03.2023.
//

import Foundation

struct Movie: Decodable, Identifiable, Equatable {
    let id: Int
    let title: String
    let release_date: String
    let vote_count: Int
    let overview: String
    let poster_path: String
    let backdrop_path: String
    let vote_average: Double
}
