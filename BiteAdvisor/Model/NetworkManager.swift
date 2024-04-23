//
//  NetworkManager.swift
//  BiteAdvisor
//
//  Created by Timea Bartha on 21/4/24.
//


import Foundation

class NetworkManager: ObservableObject {

    func fetchData(latitude: Double, longitude: Double, offset: Int) async throws -> YelpResponse { // mark it as throws so I can throw errors, it's important  as many things can go wrong
        let endpoint = "https://api.yelp.com/v3/businesses/search"
        let apiKey = "itoMaM6DJBtqD54BHSZQY9WdWR5xI_CnpZdxa3SG5i7N0M37VK1HklDDF4ifYh8SI-P2kI_mRj5KRSF4_FhTUAkEw322L8L8RY6bF1UB8jFx3TOR0-wW6Tk0KftNXXYx"
        let limit = "10"
        
        guard let url = URL(string: endpoint) else {
            throw YelpError.invalidURL // made a URL object for the above session
        }
        
        print("making request with offset: \(offset)")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "term", value: "restaurants"),
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "limit", value: limit),
            URLQueryItem(name: "offset", value: String(offset)),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request) // getting data from the request
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // checking to see if we have a 200 which means everything is good to go
            throw YelpError.invalidResponse // else return error
        }
        do {
            let decoder = JSONDecoder()
            
            return try decoder.decode(YelpResponse.self, from: data)// trying to decode the data into a YelpRestaurant and if all is good we return a YelpRestaurant
        } catch {
            throw YelpError.invalidData
        }
    }
}

enum YelpError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
