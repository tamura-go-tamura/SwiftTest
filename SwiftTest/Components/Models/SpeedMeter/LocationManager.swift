//
//  LocationManager.swift
//  SwiftTest
//
//  Created by 谷川優太 on 2024/06/05.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var speed: Double = 0.0
    @Published var distance: Double = 0.0 //歩いた距離(m)
//    @Published var latitude: Double = 0.0
//    @Published var longitude: Double = 0.0
    @Published var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    private var lastLocation: CLLocation?

    override init() {
        super.init()
        print("location init")
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
    //Check GPS authrization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Authorization status: Not Determined")
        case .restricted, .denied:
            print("Authorization status: Restricted or Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorization status: Authorized")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("Authorization status: Unknown")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("called")
        guard let location = locations.last else { return }
        //print(location.speed)
        speed = location.speed > 0 ? location.speed * 3.6 : 0.0 // m/s to km/h
        if let lastLocation = lastLocation {
            let distanceDelta = location.distance(from: lastLocation)
            distance += distanceDelta
        }
        lastLocation = location
        coordinate = location.coordinate
    }
}
