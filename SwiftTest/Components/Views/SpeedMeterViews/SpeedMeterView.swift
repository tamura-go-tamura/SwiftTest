//
//  SpeedmeterView.swift
//  SwiftTest
//
//  Created by 谷川優太 on 2024/05/29.
//

import Foundation
import SwiftUI
struct SpeedmeterView: View {
 
    @Binding var currentSpeed: Double;
    var recommendSpeed: Double;
    
    var body: some View {
        
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            Gauge(value: currentSpeed, in: 0...30) {
                Image(systemName: "gauge.medium")
                    .font(.system(size: 50.0))
            } currentValueLabel: {
                let roundSpeed = round(currentSpeed * 10) / 10;
                Text(String(format: "%.1f", roundSpeed))
                
            }
            .gaugeStyle(SpeedometerGaugeStyle(recommendSpeed: recommendSpeed / 30.0))
            Triangle()
                .fill(recommendSpeed <= 30 && recommendSpeed >= 0 ? Color.red :  Color.white.opacity(0))
               .rotationEffect(.degrees(180))
               .frame(width: 25, height: 35)
               .offset(x:5, y: -185) // Adjust based on your gauge size
               .rotationEffect(.degrees(-137.0 + (270.0 * recommendSpeed / 30)))
            
        }
    }
}
