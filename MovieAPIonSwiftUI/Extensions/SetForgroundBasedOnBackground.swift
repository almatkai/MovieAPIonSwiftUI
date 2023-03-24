//
//  SetForgroundBasedOnBackground.swift
//  MovieAPIonSwiftUI
//
//  Created by Almat Kairatov on 24.03.2023.
//

import SwiftUI

func setForegroundBasedOnBackground(backgroundColor: Color) -> Color {
    let uiColor = UIColor(backgroundColor)
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
    return brightness > 0.5 ? .black : .white
}
