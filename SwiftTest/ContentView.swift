//
//  ContentView.swift
//  SwiftTest
//
//  Created by yuta on 2024/05/28.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selected = true; // 目的地などを設定したかどうか
    @State private var distance = 0;
    @State var currentSpeed = 120.0;
    @State var recommendSpeed = 10.0;
    
    var body: some View {
        ZStack {
            // Background Image
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            if (selected){
                VStack {
                    SpeedmeterView(
                        currentSpeed:  $currentSpeed,
                        recommendSpeed: $recommendSpeed).previewDisplayName("SpeedmeterView")
                }
            } else{
                
            }
        }
        
    }
}

#Preview {
    ContentView()
}
