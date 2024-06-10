//
//  SpeedmeterStyle.swift
//  SwiftTest
//
//  Created by 谷川優太 on 2024/05/29.
//

import Foundation
import SwiftUI
struct SpeedometerGaugeStyle: GaugeStyle {
    var recommendSpeed: Double
    public init(recommendSpeed: Double) {
        self.recommendSpeed = recommendSpeed
    }
    private var purpleGradient = LinearGradient(gradient: Gradient(colors: [ Color(red: 220/255, green: 220/255, blue: 220/255), Color(red: 255/255, green: 255/255, blue: 255/255) ]), startPoint: .trailing, endPoint: .leading)
 
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
 
            Circle()
                .fill(LinearGradient(
                    gradient: (recommendSpeed > configuration.value) ? Gradient(colors: [Color(red: 247/255, green: 150/255, blue: 65/255), Color(red: 255/255, green: 50/255, blue: 70/255)])
                :Gradient(colors: [Color(red: 70/255, green: 170/255, blue: 247/255), Color(red: 70/255, green: 50/255, blue: 255/255)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
))
            
                //.foregroundColor(Color(recommendSpeed > configuration.value ? .systemRed:.systemGray6))
 
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(purpleGradient, lineWidth: 20)
                .rotationEffect(.degrees(135))
 
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1, 22.5], dashPhase: 0.0))
                .rotationEffect(.degrees(135))
            
            Triangle()
                .fill(Color.white)
               .frame(width: 20, height: 150)
               .offset(x:5, y: -70) // Adjust based on your gauge size
               .rotationEffect(.degrees(-137.0 + (270.0 * configuration.value)))
            
 
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .offset(y: 60)
                Text("KM/H")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                    .offset(y: 60)
            }
 
        }
        .frame(width: 300, height: 300)
 
    }
 
}
