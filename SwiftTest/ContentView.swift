//
//  ContentView.swift
//  SwiftTest
//
//  Created by yuta on 2024/05/28.
//
//
import SwiftUI
import CoreLocation

struct ContentView: View {
    
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
        
        
        
        NavigationStack {
            ZStack {
                // Background Image
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    //                            Text(String(viewModel.location))
                    //                            Text(String(viewModel.latitude))
                    //                            Text(String(viewModel.longitude))
//                    Text(String(remainingTimeInHour))
                    Text(String(speedViewModel.distance))
                    SpeedmeterView(
                        currentSpeed: $speedViewModel.speed,
                        recommendSpeed: (3.0-speedViewModel.distance/1000.0)/remainingTimeInHour
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
            }
            
        
        
    }
}

#Preview {
    ContentView()
}
