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
    
    @EnvironmentObject var movieViewModel: MovieViewModel
    
    let categories = ["Popular", "Upcoming", "Trending", "Top Rated"]
    
    @State var flag = true
    
    @State private var scrollUp = false
    @State var likeArray = [Int]()
    
    var body: some View{

        NavigationView{
            ZStack{
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false){
                        Text("").frame(height: 48)
                            
                        ForEach(movieViewModel.movies) { movie in
                            NavigationLink(destination: MovieInfoView(movie: movie), label: {
                                MovieCellView(movie: movie, likeArray: $likeArray)
                            })
                            .onChange(of: scrollUp){ scrollUp in
                                withAnimation{
                                    proxy.scrollTo(1)
                                }
                            }
                            .frame(height: 204)
                        }
                    }
                }
                VStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        // MARK: - Buttons (Popular, Upcoming, ...)
                        HStack{
                            ForEach(categories.indices, id: \.self) { index in
                                Button{
                                    movieViewModel.index = index
                                } label: {
                                    Text(categories[index])
                                        .background(Color.clear)
                                }.tag(index)
                                    .buttonStyle(CapsuleButtonStyle(color: movieViewModel.index == index ? Color.blue : Color.gray))
                                    .disabled(movieViewModel.index == index ? true : false)
                            }
                        }.padding(.horizontal)
                            .background(Color.clear)
                    }
                    .background(Color.clear)
                    Spacer()
                    // MARK: - Page Changer
                    HStack{
                        if movieViewModel.page > 1 {
                            Button{
                                if movieViewModel.page > 1 {
                                    movieViewModel.page -= 1
                                }
                            } label: {
                                Image(systemName: "arrow.left")
                                    .frame(width: 20)
                                    .foregroundColor(.white)
                            } .padding(6)
                        }
                        Text("\(movieViewModel.page)")
                             .font(.system(size: 20))
                             .foregroundColor(.white)
                             .padding(6)
                        if movieViewModel.page < movieViewModel.total_results {
                            Button{
                                if movieViewModel.page < movieViewModel.total_results {
                                    movieViewModel.page += 1
                                }
                            } label: {
                                Image(systemName: "arrow.right")
                                    .frame(width: 20)
                                    .foregroundColor(.white)
                            } .padding(6)
                        } else { Text("").font(.system(size: 20)) }
                    }
                    .onChange(of: movieViewModel.page){ newPage in
                        scrollUp.toggle()
                        movieViewModel.fetchMovies()
                    }
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(25)
                    .animation(.easeIn)
                }
                .padding(.top, 10)
            }
                .padding(.top)
                .onChange(of: movieViewModel.index) { newValue in
                    movieViewModel.page = 1
                    scrollUp.toggle()
                    movieViewModel.fetchMovies()
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



