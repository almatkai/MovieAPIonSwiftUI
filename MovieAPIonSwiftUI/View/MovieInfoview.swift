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
    @State private var forgroundColor: Color = Color("systemBlack")

    let movie: Movie
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    ZStack{
                        KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movie.backdrop_path)"))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                    }
                    HStack{
                        Text(movie.title)
                                .font(.system(size: 22))
                                .fontWeight(.heavy)
                                .padding(.vertical, 10)
                                .foregroundColor(forgroundColor)
                        Spacer()
                    }
                    if movie.overview != "" {
                        HStack{
                            Text("Описание:")
                                    .fontWeight(.bold)
                                    .foregroundColor(forgroundColor)
                            Spacer()
                        }.padding(.bottom, 2)
                        Text(movie.overview)
                                .foregroundColor(forgroundColor)
                    } else {
                        HStack{
                            Text("Описание отсутствует")
                                    .padding(.bottom, 2)
                            Spacer()
                        }
                    }
                }.padding(.horizontal, 20)
                Spacer()
            }
                    .background(backgroundColor)
                    .onAppear {
                        setAverageColor(url: "https://image.tmdb.org/t/p/w500\(movie.backdrop_path)")
                    }
                    .onChange(of: backgroundColor){ newValue in
                        forgroundColor = setForegroundBasedOnBackground(backgroundColor: newValue)
                    }
        }
    }

    private func setAverageColor(url: String) {
        guard let imageUrl = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                    guard let data = data, error == nil, let uiImage = UIImage(data: data) else { return }
                    let group = DispatchGroup()
                    group.enter()
                    DispatchQueue.global(qos: .default).async {
                        backgroundColor = Color(uiImage.averageColor ?? .clear)
                        group.leave()
                    }
                    group.wait()
                    forgroundColor = setForegroundBasedOnBackground(backgroundColor: backgroundColor)
                }.resume()
    }

}

func setForegroundBasedOnBackground(backgroundColor: Color) -> Color {
    let uiColor = UIColor(backgroundColor)
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
    return brightness > 0.5 ? .black : .white
}