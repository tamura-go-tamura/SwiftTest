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
    let speed: Double

    func makeUIView(context: Context) -> UIImageView {
        print(gifName)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        do {
            let gif = try UIImage(gifName: gifName)
            imageView.setGifImage(gif, loopCount: -1)
            let manager = SwiftyGifManager.defaultManager
        } catch {
            print("Error loading GIF: \(error)")
        }
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        // No update needed
    }
}
