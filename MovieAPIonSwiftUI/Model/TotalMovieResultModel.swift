//
//  MovieModel.swift
//  MovieAPIonSwiftUI
//
//  Created by Almat Kairatov on 20.03.2023.
//

import Foundation

struct TotalMovieResultModel: Decodable{
    let page: Int
    let total_results: Int
    let results: [Movie]
    let total_pages: Int
}
