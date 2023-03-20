//
//  HomeView.swift
//  MovieAPIonSwiftUI
//
//  Created by Almat Kairatov on 20.03.2023.
//

import SwiftUI
import Kingfisher
import Foundation

struct HomeView: View {
    
    @State var movies: [Movie]
    @State var selectedIndex: Int
    @State var page: Int
    @State var total_results: Int
    
    let categories = ["Popular", "Upcoming", "Trending", "Top Rated"]
    let categoriesLowercased: [String]
    
    let movieManager = MovieManager()
    
    @State var flag = true
    
    @State private var scrollUp = false
    
    @State var isFetching = false
    
    var body: some View{

        NavigationView{
            ZStack{
                if isFetching {
                    ProgressView()
                } else {
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false){
                            Text("").frame(height: 48)
                                .id(1)
                            ForEach(movies) { movie in
                                NavigationLink(destination: MovieInfoView(movie: movie), label: {
                                    ZStack {
                                        KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movie.backdrop_path)"))
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
                                        VStack {
                                            HStack{
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 18)
                                                        .fill(averageVoteColor(num: movie.vote_average))
                                                    if (movie.vote_average > 0) {
                                                        Text(String(format: "%.1f", movie.vote_average))
                                                            .foregroundColor(.black)
                                                    }
                                                    else {
                                                        Text("?")
                                                            .foregroundColor(.black)
                                                    }
                                                }
                                                .frame(width: 36, height: 36)
                                                .padding()
                                                Spacer()
                                                
                                                Image(systemName: flag ? "heart" : "heart.fill")
                                                    .foregroundColor(.red)
                                                    .font(.system(size: 24))
                                                    .padding(.horizontal)
                                                    .onTapGesture {
                                                        flag.toggle()
                                                    }
                                            }
                                            Spacer()
                                            
                                            VStack{
                                                Text(movie.title)
                                                    .fontWeight(.bold)
                                                    .padding(.bottom, 2)
                                                    .foregroundColor(.white)
                                                
                                                let year = movie.release_date.prefix(4)
                                                Text(year)
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.white)
                                                
                                            }.padding(.bottom, 20)
                                        }
                                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 16)
                                })
                                .onChange(of: scrollUp){ scrollUp in
                                    withAnimation{
                                        proxy.scrollTo(1)
                                    }
                                }
                            }
                        }
                    }
                }
                VStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        // MARK: - Buttons (Popular, Upcoming, ...)
                        HStack{
                            ForEach(categories.indices, id: \.self) { index in
                                Button{
                                    selectedIndex = index
                                } label: {
                                    Text(categories[index])
                                        .background(Color.clear)
                                }.tag(index)
                                    .buttonStyle(CapsuleButtonStyle(color: selectedIndex == index ? Color.blue : Color.gray))
                                    .disabled(selectedIndex == index ? true : false)
                            }
                        }.padding(.horizontal)
                            .background(Color.clear)
                    }
                    .background(Color.clear)
                    Spacer()
                    // MARK: - Page Changer
                    HStack{
                        if page > 1 {
                            Button{
                                if page > 1 {
                                    page -= 1
                                }
                            } label: {
                                Image(systemName: "arrow.backward.circle")
                                    .frame(width: 20)
                                    .foregroundColor(.white)
                            } .padding(6)
                        }
                        Text("\(page)")
                             .font(.system(size: 20))
                             .foregroundColor(.white)
                             .padding(6)
                        if page < total_results {
                            Button{
                                if page < total_results {
                                    page += 1
                                }
                            } label: {
                                Image(systemName: "arrow.forward.circle")
                                    .frame(width: 20)
                                    .foregroundColor(.white)
                            } .padding(6)
                        } else { Text("").font(.system(size: 20)) }
                    }
                    .onChange(of: page){ newPage in
                        scrollUp.toggle()
                        movieManager.fetchMovies(typeOfSort: categoriesLowercased[selectedIndex], isFetching: $isFetching, page: page){ movies in
                                self.movies = movies.results
                                self.total_results = movies.total_results
                        }
                    }
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(25)
                    .animation(.easeIn)
                }
                .padding(.top, 10)
            }
                .padding(.top)
                .onChange(of: selectedIndex) { newValue in
                    page = 1
                    scrollUp.toggle()
                    movieManager.fetchMovies(typeOfSort: categoriesLowercased[newValue], isFetching: $isFetching, page: page){ movies in
                        self.movies = movies.results
                        self.total_results = movies.total_results
                    }
                }
        }.onAppear{
            movieManager.fetchMovies(typeOfSort: categoriesLowercased[0], isFetching: $isFetching, page: page){ movies in
                        self.movies = movies.results
                        self.total_results = movies.total_results
                    }
                }
    }
}
// MARK: - CapsuleButtonStyle
struct CapsuleButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(7)
            .foregroundColor(.white)
            .background(
                Capsule()
                    .fill(configuration.isPressed ? Color.gray : color)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
// MARK: - Average Vote Color
func averageVoteColor(num: Double) -> Color {
    switch num {
        case ..<5.0:
            return .red
        case ..<6.6:
            return .gray
        case ..<7.5:
            return .yellow
        default:
            return Color(hex: "00ff00")
        }
}



