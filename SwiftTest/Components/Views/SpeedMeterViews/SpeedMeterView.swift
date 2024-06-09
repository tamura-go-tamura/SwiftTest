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
    @Binding var recommendSpeed: Double;
    
    var body: some View {
        
        ZStack {
            Gauge(value: currentSpeed, in: 0...25) {
                Image(systemName: "gauge.medium")
                    .font(.system(size: 50.0))
            } currentValueLabel: {
                Text("\(Int(currentSpeed))")
                
            }
            .gaugeStyle(SpeedometerGaugeStyle(recommendSpeed: recommendSpeed / 25.0))
            Triangle()
               .fill(Color.red)
               .rotationEffect(.degrees(180))
               .frame(width: 25, height: 35)
               .offset(x:5, y: -185) // Adjust based on your gauge size
               .rotationEffect(.degrees(-137.0 + (270.0 * recommendSpeed / 25)))
            
        }
    }
}
