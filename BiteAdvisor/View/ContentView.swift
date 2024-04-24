//
//  ContentView.swift
//  BiteAdvisor
//
//  Created by Timea Bartha on 21/4/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationviewModel = locationViewModel()
    @ObservedObject var networkManager = NetworkManager()
    
    @State var restaurants: [Business] = []
    @State var restaurantIndex = 0
    @State var disabledAddButton: Bool = false// disables the button if pressed too many times
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.teal, .blue,.black, .black]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    if restaurants.count > 0 {
                        CardView(restaurant: restaurants[restaurantIndex])
                            .onChange(of: restaurantIndex) {
                                print(restaurantIndex)
                            }
                    }
                    HStack {
                        Button(action: {
                            print("tapped!")
                            let newIndex = restaurantIndex - 1
                            if restaurantIndex > 0 {
                                restaurantIndex = newIndex
                            }
                        }, label: {
                            Text("Previous")
                                .bold()
                                .frame(width: 100, height: 40)
                                .foregroundColor(.white)
                                .overlay(Capsule().stroke(LinearGradient(gradient: Gradient(colors: [Color.teal, Color.blue]), startPoint: .leading, endPoint: .trailing), lineWidth: 5))
                                .padding()
                        })
                        Spacer()
                        Button(action: {
                            Task {
                                print("tapped!")
                                let newIndex = restaurantIndex + 1
                                if newIndex < restaurants.count {
                                    restaurantIndex = newIndex
                                } else {
                                    disabledAddButton = true
                                    do {
                                        await loadData(offset: self.restaurants.count)
                                    }
                                    disabledAddButton = false
                                    restaurantIndex = newIndex
                                }
                            }
                        }, label: {
                            Text("Next")
                                .bold()
                                .frame(width: 100, height: 40)
                                .foregroundColor(.white)
                                .overlay(Capsule().stroke(LinearGradient(gradient: Gradient(colors: [Color.teal, Color.blue]), startPoint: .leading, endPoint: .trailing), lineWidth: 5))
                                .padding()
                        })
                        .disabled(disabledAddButton)
                    }
                }
            }
        }
        .task {
            await loadData(offset: self.restaurants.count)
        }
    }
    
    func loadData(offset: Int) async {
        do {
            let yelpResponse = try await networkManager.fetchData(latitude: locationviewModel.userLatitude, longitude: locationviewModel.userLongitude, offset: offset)
            restaurants.append(contentsOf: yelpResponse.businesses)
        } catch YelpError.invalidURL {
            print("invalud URL")
        } catch YelpError.invalidData {
            print("invalid data")
        } catch YelpError.invalidResponse {
            print("invalid response")
        } catch {
            print("unexpected error")
        }
    }
}

#Preview {
    ContentView()
        
}
