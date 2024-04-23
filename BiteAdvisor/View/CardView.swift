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
    
    @State private var offset = CGSize.zero
    var restaurant: Business
    
    var body: some View {
        VStack {
            ZStack {
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .fill(.gray)
                    GeometryReader { geometry in
                        VStack {
                            AsyncImage(url: URL(string: restaurant.imageURL)) { image in image.resizable() } placeholder: { Color.red }
                                .padding(10)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .scaledToFit()
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                                
                                
                
                            Text(restaurant.name)
                                .font(.title)
                                .bold()
                            Text(" Rating: \(restaurant.rating, specifier: "%.1f")")
                                .font(.headline)
                            
                        }
                    }
                }.padding(30)
                    .rotationEffect(.degrees(Double(offset.width / 5)))
                    .offset(x: offset.width * 5, y: 0) // move left and right but never up and down
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                                
                            }
                            .onEnded { _ in
                                if abs(offset.width) > 100 { // abs = absolute number of that value
                                    if offset.width > 0 {
                                    }
                                    
                                } else {
                                    offset = .zero
                                }
                            }
                    )
                .animation(.spring(), value: offset)
           
        }
        .padding(10)
        /* .task {
                    do {
                        restaurant = try await self.networkManager.fetchData(latitude: locationviewModel.userLatitude, longitude: locationviewModel.userLongitude)
                    } catch YelpError.invalidURL {
                        print("invalud URL")
                    } catch YelpError.invalidData {
                        print("invalid data")
                    } catch YelpError.invalidResponse {
                        print("invalid response")
                    } catch {
                        print("unexpected error")
                    }
                } */
        }
}

//#Preview {
//    CardView()
//}
