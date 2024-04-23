//
//  LocationViewModel.swift
//  BiteAdvisor
//
//  Created by Timea Bartha on 21/4/24.
//

import Foundation
import CoreLocation

class locationViewModel: NSObject, ObservableObject {
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest//gives us the most accurate possible location for the user location
        self.locationManager.requestWhenInUseAuthorization()//call in order to request location
        self.locationManager.startUpdatingLocation() //updates so we can start using location/
    }
}
extension locationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error:: \(error.localizedDescription)")
       }
}
