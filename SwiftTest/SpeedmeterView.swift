//
//  SpeedmeterView.swift
//  SwiftTest
//
//  Created by 谷川優太 on 2024/05/29.
//

import Foundation
import SwiftUI
struct SpeedmeterView: View {
 
    @State private var currentSpeed = 100.0
 
    var body: some View {
        Gauge(value: currentSpeed, in: 0...200) {
            Image(systemName: "gauge.medium")
                .font(.system(size: 50.0))
        } currentValueLabel: {
            Text("\(currentSpeed.formatted(.number))")
 
        }
        .gaugeStyle(SpeedometerGaugeStyle())
 
    }
}
