//
//  RouteViewModel.swift
//  SwiftTest
//
//  Created by yuta on 2024/06/09.
//
//import Foundation
//import CoreLocation
//import MapKit
//
//class RouteViewModel: ObservableObject {
//    
//    var targetCoordinate : CLLocationCoordinate2D
//    var originCoordinate:  CLLocationCoordinate2D
//    @Published var distance: Double = 0.0
//    @Published var errorMessage: String?
//    
//    init(originCoordinate : CLLocationCoordinate2D, targetCoordinate: CLLocationCoordinate2D) {
//        self.originCoordinate = originCoordinate
//        self.targetCoordinate = targetCoordinate
//        Task {
//            await fetchRouteDistance()
//        }
//    }
//    
//    func fetchRouteDistance() async {
//        
//        do {
//            let calculatedDistance = try await calculateRouteDistance(from: originCoordinate, to: targetCoordinate)
//            distance = calculatedDistance
//            errorMessage = nil
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//    }
//}
//
//func calculateRouteDistance(from sourceCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) async throws -> Double {
//    return try await withCheckedThrowingContinuation { continuation in
//        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
//        
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//        
//        let directionRequest = MKDirections.Request()
//        directionRequest.source = sourceMapItem
//        directionRequest.destination = destinationMapItem
//        directionRequest.transportType = .automobile
//        
//        let directions = MKDirections(request: directionRequest)
//        
//        directions.calculate { (response, error) in
//            if let error = error {
//                continuation.resume(throwing: error)
//                return
//            }
//            
//            guard let response = response, let route = response.routes.first else {
//                continuation.resume(throwing: NSError(domain: "RouteErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Route not found"]))
//                return
//            }
//            
//            let distance = route.distance
//            continuation.resume(returning: distance)
//        }
//    }
//}
