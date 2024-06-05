//
//  ContentView.swift
//  SwiftTest
//
//  Created by yuta on 2024/05/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Background Image
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                SpeedmeterView().previewDisplayName("SpeedmeterView")
            }
        }
    }
}

#Preview {
    ContentView()
}
