//
//  ProgressView.swift
//  SwiftTest
//
//  Created by 谷川優太 on 2024/07/07.
//

import Foundation
import SwiftUI

struct ProgressView: View {
    var elapsedDistance: Double
    var remainingDistance: Double
    var totalDistance: Double
    var speed: Double
    var progressPercentage: Double {
        (elapsedDistance / totalDistance) * 100
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer() // 上部のスペースを確保

                VStack(alignment: .center) {
                    HStack {
                        Text("経過距離: \(elapsedDistance, specifier: "%.2f") km")
                        Spacer()
                        Text("残り距離: \(totalDistance - elapsedDistance, specifier: "%.2f") km")
                    }
                    .padding(.horizontal)
                    
                    Text("\(remainingDistance == 0 ? 100 : Int(progressPercentage))%")
                        .foregroundColor(.black)
                        .padding(.bottom, 5)

                    HStack {
                        Image(systemName: "flag") // 左側のアイコン
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(height: 20)
                                .opacity(0.3)
                                .foregroundColor(.gray)
                                .cornerRadius(10)

                            if progressPercentage < 100 {
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color(red: 0.254, green: 0.412, blue: 0.882), // 鮮やかな青色
                                                        Color(red: 0.854, green: 0.439, blue: 0.839)  // 鮮やかな紫色
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                                .frame(width: geometry.size.width - 90, height: 20) // 常に100%の幅
                                                .mask(
                                                    HStack(spacing: 0) {
                                                        Rectangle()
                                                            .frame(width: CGFloat(max(0, min(progressPercentage, 100)) / 100) * (geometry.size.width - 90), height: 20)
                                                        Spacer()
                                                    }
                                                )
                                                .cornerRadius(10)
                                            } else {
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color(red: 0.254, green: 0.412, blue: 0.882), // 鮮やかな青色
                                                        Color(red: 0.854, green: 0.439, blue: 0.839)  // 鮮やかな紫色
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                                .frame(width: geometry.size.width - 90, height: 20) // 常に100%の幅
                                                .cornerRadius(10)
                                            }
                        }
                        .frame(width: geometry.size.width - 90) // 進捗バーの幅を調整
                        Image(systemName: "flag.checkered") // 右側のアイコン
                    }
                    .padding(.horizontal)
                }
                .frame(width: geometry.size.width * 0.9) // 親ビューの幅の90%に調整
                Text("\(speed)").opacity(0)
                GifUIView(gifName: "runner", speed: speed / 10, sleepDuration: 1000)
                                        .scaleEffect(0.15)
                                        .frame(width: 10, height: 10)
                                        .offset(x:(geometry.size.width - 90) * (progressPercentage/100 - 0.5))
                Spacer() // 下部のスペースを確保
            }
            .frame(width: geometry.size.width, height: geometry.size.height) // GeometryReader の幅と高さにフレームを設定
        }
    }
}
