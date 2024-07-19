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
import AVFoundation

import Foundation;

struct Event: Codable, Identifiable{
    let id = UUID()
    let name: String
    let url: String
}

struct Message: Codable {
    let comment: String
    let events: Array<Event>
}


struct SuperTabView: View {
    
    @State var selectionDate = Date()
    @StateObject var nowDateTimer = DateTimer()
    @StateObject var mapViewModel: MapViewModel = MapViewModel() //目的地点の経度緯度情報
    @StateObject private var speedViewModel: SpeedViewModel = SpeedViewModel()
    @State var distance = CLLocationDistance(floatLiteral: 0.0)
    
    @State var messageFromLlm: String = "おはようございます。今日も一日元気に出勤しましょう。";
    @State var jsonFromLlm: Message = Message(comment: "", events: [
        Event(name: "", url: "")
    ])
    var speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer();
    
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
    
    private func speeche(text: String) {
        let utterance = AVSpeechUtterance(string: text) // 読み上げる文字
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP") // 言語
        utterance.rate = 0.5 // 読み上げ速度
        utterance.pitchMultiplier = 1.0 // 読み上げる声のピッチ
        utterance.preUtteranceDelay = 0.2 // 読み上げるまでのため
        speechSynthesizer.speak(utterance)
    }
    
    private func getLlmAns(latitude: String, longitude: String){
        let endpoint = "https://1w09ojfeok.execute-api.ap-northeast-1.amazonaws.com/test?latitude=\(latitude)&longitude=\(longitude)";
        guard let url = URLComponents(string: endpoint) else { return }
        // HTTPメソッドを実行
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            guard let _data = data else { return }

            // JSONデコード
            do{
                let message = try JSONDecoder().decode(Message.self, from: _data)
                print("==========message===========\n\(message)")
                self.messageFromLlm = message.comment;
                self.jsonFromLlm = message;
            } catch{
                return
            }
            }
        task.resume()

    }
    
    
    var body: some View {
        
        TabView{
            
            ProgressView(jsonFromLlm: self.jsonFromLlm, elapsedDistance: speedViewModel.distance / 1000, remainingDistance: distance/1000)
                .tabItem {
                    Image(systemName: "figure.walk.circle.fill")
                    Text("Map")
                }
            
            SpeedmeterView(
                currentSpeed: $speedViewModel.speed,
                recommendSpeed: (distance.magnitude/1000.0)/remainingTimeInHour
            ).previewDisplayName("SpeedmeterView").previewDisplayName("SpeedmeterView")   // Viewファイル①
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
        .onAppear{
            setupTabBarAppearance()
            nowDateTimer.startTimer()
            startTimer()
        }
        .onChange(of: mapViewModel.coordinate.latitude) {
            self.calculateDistance(from: speedViewModel.coordinate, to: mapViewModel.coordinate)
            self.getLlmAns(latitude: String(mapViewModel.coordinate.latitude), longitude:String(mapViewModel.coordinate.longitude));
        }
        .onChange(of: self.messageFromLlm){
            self.speeche(text:self.messageFromLlm);
        }

        
    }
    
    func setupTabBarAppearance() {

        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    SuperTabView();
}
