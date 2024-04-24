//
//  CardView.swift
//  BiteAdvisor
//
//  Created by Timea Bartha on 21/4/24.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var locationviewModel = locationViewModel()
    
    var restaurant: Business
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(LinearGradient(gradient: Gradient(colors: [.black, .black, .blue]), startPoint: .top, endPoint: .bottom))
                GeometryReader { geometry in
                    VStack {
                        AsyncImage(url: URL(string: restaurant.imageURL)) { image in image.resizable() } placeholder: { Color.red }
                            .padding(10)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                        Spacer()
                        VStack {
                            Text(restaurant.name)
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                            Text(" Rating: \(restaurant.rating, specifier: "%.1f")")
                                .font(.headline)
                                .foregroundColor(.white)
                        }.padding()
                    }
                }
            }.padding(30)
                
        }
        .padding(10)
    }
}

