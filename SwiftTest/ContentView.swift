//
//  ContentView.swift
//  SwiftTest
//
//  Created by yuta on 2024/05/28.
//
//
import SwiftUI
import CoreLocation
import MapKit
import SwiftyGif

struct ContentView: View {
    
    @State var selectionDate = Date()
    @StateObject var nowDateTimer = DateTimer()
    @StateObject var mapViewModel: MapViewModel = MapViewModel() //目的地点の経度緯度情報
    @StateObject private var speedViewModel: SpeedViewModel = SpeedViewModel()
    @State var distance = CLLocationDistance(floatLiteral: 0.0)
    
    var remainingTimeInHour: Double {
        //残り時間をhour単位で取得
        //nowDateは現在時刻を取得するようにする
        get {
            let dateSubtraction: Double = Double(selectionDate.timeIntervalSince(nowDateTimer.nowDate)) / 3600.0
            return dateSubtraction;
        }
    }
    
    func calculateDistance(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
            print("update distance")
            let sourcePlacemark = MKPlacemark(coordinate: source)
            let destinationPlacemark = MKPlacemark(coordinate: destination)

            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlacemark)
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            directionRequest.transportType = .automobile

            let directions = MKDirections(request: directionRequest)
            directions.calculate { [self] response, error in
                
                if let error = error as NSError? {
                    print("Error calculating directions: \(String(describing: error))")
                    return
                }

                guard let response = response, let route = response.routes.first else {
                    print("No valid route found")
                    return
                }

                DispatchQueue.main.async {
                    self.distance = route.distance
                }
            }
        }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.calculateDistance(from: speedViewModel.coordinate, to: mapViewModel.coordinate)
        }
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    SpeedmeterView(
                        currentSpeed: $speedViewModel.speed,
                        recommendSpeed: (distance.magnitude/1000.0)/remainingTimeInHour
                    ).previewDisplayName("SpeedmeterView")
                }
                
                List{
                    NavigationLink(
                        destination: ConfigurationView(selectionDate: $selectionDate, viewModel: mapViewModel)
                    ) {
                        Text("Settings")
                    }
                }
                .padding(
                    EdgeInsets(
                        top: 0,        // 上の余白
                        leading: 100,    // 左の余白
                        bottom: 0,     // 下の余白
                        trailing: 100    // 右の余白
                    )
                ).scrollContentBackground(.hidden)
                
            }
        }
        .onAppear{
            nowDateTimer.startTimer()
            startTimer()
        }
        .onChange(of: mapViewModel.coordinate.latitude) {
            self.calculateDistance(from: speedViewModel.coordinate, to: mapViewModel.coordinate)
        }
    }
}

#Preview {
    ContentView()
}
