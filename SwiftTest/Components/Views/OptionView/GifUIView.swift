//
//  GifUIView.swift
//  SwiftTest
//
//  Created by 谷川優太 on 2024/06/16.
//

import Foundation
import SwiftyGif
import SwiftUI

struct GifUIView: UIViewRepresentable {
    let gifName: String
    var speed: Double
    let imageView = UIImageView()
    var sleepDuration: UInt32


    func makeUIView(context: Context) -> UIImageView {
        print(gifName)
        imageView.contentMode = .scaleAspectFit
        var images = [UIImage]()
        do {
            for i in 1...20 {
               let imageName = "runner (1_\(i)).png"
               if let image = UIImage(named: imageName) {
                   images.append(image)
               }
           }
            imageView.animationImages = images
            imageView.animationDuration = 1 / speed // アニメーションの時間（秒）
            imageView.animationRepeatCount = 0
            imageView.startAnimating()
//            print(speed)
//            let gif = try UIImage(gifName: gifName)
//            imageView.setImage(gif, loopCount: -1)
//            DispatchQueue.global(qos: .background).async {
//                self.startAndStopGifAnimation()
//            }
        } catch {
            print("Error loading GIF: \(error)")
        }
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context){
        // No update needed
        let shouldUpdate = Int.random(in: 1...100) == 1
        if shouldUpdate && abs(uiView.animationDuration - (1/speed)) > 0.1 {
            print("Speed update: \(speed)")
            uiView.animationDuration = 1 / speed
            uiView.startAnimating()
        }
    }
        
    
    func startAndStopGifAnimation() {
        while true {
            DispatchQueue.main.async {
                self.imageView.startAnimatingGif()
            }
            usleep(self.sleepDuration / UInt32(self.speed == 0 ? 1 : self.speed))
            
            DispatchQueue.main.async {
                self.imageView.stopAnimatingGif()
            }
            usleep(self.sleepDuration / UInt32(self.speed == 0 ? 1 : self.speed))
        }
    }
}
