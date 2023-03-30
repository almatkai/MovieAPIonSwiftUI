//
//  MovieInfoview.swift
//  MovieAPIonSwiftUI
//
//  Created by Almat Kairatov on 20.03.2023.
//

import SwiftUI
import Kingfisher

struct MovieInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var backgroundColor: Color = Color("systemWhite")
    @State private var forgroundColor: Color  = Color("systemBlack")

    let movie: Movie
    
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    ZStack{
                        if let backdropPath = movie.backdrop_path{
                            KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)"))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                        }
                        else {
                            Image("placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                        }
                    }
                    HStack{
                        Text(movie.title ?? "Title is missing")
                                .font(.system(size: 22))
                                .fontWeight(.heavy)
                                .padding(.vertical, 10)
                                .foregroundColor(forgroundColor)
                        Spacer()
                    }
                    if movie.overview != "" {
                        HStack{
                            Text("Review:")
                                    .fontWeight(.bold)
                                    .foregroundColor(forgroundColor)
                            Spacer()
                        }.padding(.bottom, 2)
                        Text(movie.overview!)
                                .foregroundColor(forgroundColor)
                    } else {
                        HStack{
                            Text("This movie was not reviewed yet")
                                    .padding(.bottom, 2)
                                    .foregroundColor(forgroundColor)
                            Spacer()
                        }
                    }
                }.padding(.horizontal, 20)
                Spacer()
            }
                    .background(backgroundColor)
                    .onAppear {
                        if let backDropPath = movie.backdrop_path{
                            setAverageColor(url:"https://image.tmdb.org/t/p/w500\(backDropPath)")
                        }
                        
                    }
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button{self.presentationMode.wrappedValue.dismiss()} label: {Image(systemName: "chevron.left").foregroundColor(forgroundColor)}.offset(x: 8))
            .gesture(DragGesture().onEnded { _ in
                self.presentationMode.wrappedValue.dismiss()
            })
    }

    private func setAverageColor(url: String) {
        guard let imageUrl = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            guard let data = data, error == nil, let uiImage = UIImage(data: data) else { return }
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.global(qos: .default).async {
                withAnimation(.easeIn(duration: 1)){
                    backgroundColor = Color(uiImage.averageColor ?? .clear)
                }
                group.leave()
            }
            group.wait()
            withAnimation(.easeIn(duration: 1)){
                forgroundColor = setForegroundBasedOnBackground(backgroundColor: backgroundColor)
            }
        }.resume()
    }

}
