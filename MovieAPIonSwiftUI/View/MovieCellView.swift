//
//  MovieCellView.swift
//  MovieAPIonSwiftUI
//
//  Created by Almat Kairatov on 24.03.2023.
//

import SwiftUI
import Kingfisher

struct MovieCellView: View {
    
    let movie: Movie
    @Binding var likeArray: [Int]
    
    var body: some View {
        ZStack {
            if let backdropPath = movie.backdrop_path{
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(15)
                        .overlay(
                                LinearGradient(
                                        gradient: Gradient(colors: [.clear, .black]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                )
                                        .opacity(1)
                                        .cornerRadius(15)
                        )
            }
            else {
                Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(15)
                        .overlay(
                                LinearGradient(
                                        gradient: Gradient(colors: [.clear, .black]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                )
                                        .opacity(1)
                                        .cornerRadius(15)
                        )
            }
            VStack {
                HStack{
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(averageVoteColor(num: movie.vote_average ?? 0))
                        if (movie.vote_average ?? 0 > 0) {
                            Text(String(format: "%.1f", movie.vote_average!))
                                    .foregroundColor(.black)
                        }
                        else {
                            Text("?")
                                    .foregroundColor(.black)
                        }
                    }
                            .frame(width: 36, height: 36)
                            .padding(.leading, 30)
                            .padding(.top, 20)
                    Spacer()

                    let (isLiked, index) = likeArray.enumerated().first { $0.element == movie.id }.map { (true, $0.offset) } ?? (false, 0)

                    Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.system(size: 24))
                            .padding(.trailing, 26)
                            .padding(.top, 18)
                            .onTapGesture {
                                if isLiked {
                                    likeArray.remove(at: index)
                                } else {
                                    likeArray.append(movie.id!)
                                }
                            }
                }
                Spacer()

                VStack{
                    Text(movie.title ?? "Sorry, title is missing")
                            .fontWeight(.bold)
                            .padding(.bottom, 2)
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .frame(width: 200)
                    if let movieReleaseDate = movie.release_date {
                        let year = movieReleaseDate
                        Text(year)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                    } else { Text("Release date is missing")}
                

                }.padding(.bottom, 20)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .frame(width: 400, height: 204)
    }
}
