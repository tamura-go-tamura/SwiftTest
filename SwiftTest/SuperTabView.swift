//
//  ContentView.swift
//  SwiftTest
//
//  Created by yuta on 2024/05/28.
//
//
import SwiftUI
import CoreLocation

struct SuperTabView: View {
    
    @State var selectionDate = Date()
    @StateObject var nowDateTimer = DateTimer()
    @StateObject var mapViewModel: MapViewModel = MapViewModel() //目的地点の経度緯度情報
    @StateObject private var speedViewModel: SpeedViewModel = SpeedViewModel() //現在地点の経度緯度情報
        
    @State var recommendSpeed = 10.0; //まだ
    var distance: Double = 0.0; // まだ
    
    var remainingTimeInHour: Double {
        //残り時間をhour単位で取得
        //nowDateは現在時刻を取得するようにする
        get {
            let dateSubtraction: Double = Double(selectionDate.timeIntervalSince(nowDateTimer.nowDate)) / 3600.0
            return dateSubtraction;
        }
    }
    
    
    var body: some View {
        
        TabView{
            
            Text("ここに現在の進度が表示")     // Viewファイル②
                .tabItem {
                    Image(systemName: "figure.walk.circle.fill")
                    Text("Map")
                }
            
            
            SpeedmeterView(
                currentSpeed: $speedViewModel.speed,
                recommendSpeed: (3.0-speedViewModel.distance/1000.0)/remainingTimeInHour
            ).previewDisplayName("SpeedmeterView")   // Viewファイル①
                .tabItem {
                    Image(systemName: "stopwatch.fill")
                    Text("Meter")
                }
            
            ConfigurationView(selectionDate: $selectionDate, viewModel: mapViewModel)    // Viewファイル②
                .tabItem {
                    Image(systemName: "pencil.circle.fill")
                    Text("Setting")
                }
            
        }

        
    }
}

#Preview {
    SuperTabView()
}
