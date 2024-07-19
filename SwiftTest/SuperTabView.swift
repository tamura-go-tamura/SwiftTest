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

struct SuperTabView: View {
    
    @State var selectionDate = Date()
    @StateObject var nowDateTimer = DateTimer()
    @StateObject var mapViewModel: MapViewModel = MapViewModel() //目的地点の経度緯度情報
    @StateObject private var speedViewModel: SpeedViewModel = SpeedViewModel()
    @State var distance = CLLocationDistance(floatLiteral: 0.0)
    @State var totalDistance = CLLocationDistance(floatLiteral: 0.0)

    let openAIKey: String = "";
    @State var messageFromLlm: String = "おはようございます。今日も一日元気に出勤しましょう。";
    @State var jsonFromLlm: Dictionary<String, Any> = ["content":"test"];
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
                self.totalDistance = route.distance + speedViewModel.distance
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
    
    private func getLlmAns(text: String){
        if (openAIKey=="" ){
            return;
        }
        let semaphore = DispatchSemaphore (value: 0);

        let parameters = "{\"model\": \"gpt-4o\",\"messages\": [{\"role\": \"system\",\"content\": \"あなたは、朝の通勤途中のサラリーマンに対して元気づけたり、新しい情報を与えたりするアシスタントです。\"},{\"role\": \"user\",\"content\": \"\(text)\"}]}";
        let postData = parameters.data(using: .utf8)
        
        print("=============LLM入力============");
        print(parameters);

        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            self.messageFromLlm = String(data: data, encoding: .utf8)!;
            print("=============LLM出力============")
            print(String(data: data, encoding: .utf8)!)
            do{
                self.jsonFromLlm = try JSONSerialization.jsonObject(
                    with: self.messageFromLlm.data(using: String.Encoding.utf8)!
                ) as! Dictionary<String, Any>;
                let choices: Array = self.jsonFromLlm["choices"] as! Array<Any>;
                let oneChoice : Dictionary = choices[0] as! Dictionary<String, Any>;
                let oneMessage: Dictionary = oneChoice["message"] as! Dictionary<String, Any>;
                self.messageFromLlm = oneMessage["content"] as! String;
            } catch {
                self.messageFromLlm = "エラーが発生しました！";
            }
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    
    var body: some View {
        
        TabView{
            
            ProgressView(elapsedDistance: speedViewModel.distance / 1000, remainingDistance: distance/1000, totalDistance: totalDistance/1000, speed: (distance.magnitude/1000.0)/remainingTimeInHour)
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
            self.getLlmAns(text: "以下の緯度と経度の場所に関しての本日ならではの耳寄り情報を教えつつ、出勤途中のサラリーマンを激励してください！出力は100文字程度でお願いします。また、緯度と経度について再度述べる必要はありません。経度:\(mapViewModel.coordinate.longitude), 緯度:\(mapViewModel.coordinate.latitude)");
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
