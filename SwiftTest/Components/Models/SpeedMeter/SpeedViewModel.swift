//
//  SpeedViewModel.swift
//  SwiftTest
//
//  Created by 谷川優太 on 2024/06/05.
//

import Foundation
import Combine

class SpeedViewModel: ObservableObject {
    @Published var speed: Double = 0.0
    @Published var distance: Double = 0.0
    @Published var latitude: Double = 0.0
    @Published var longiude: Double = 0.0
    private var cancellables = Set<AnyCancellable>()
    private var locationManager = LocationManager()

    init() {
        locationManager.$speed
            .assign(to: \.speed, on: self)
            .store(in: &cancellables)
        locationManager.$distance
            .assign(to: \.distance, on: self)
            .store(in: &cancellables)
        locationManager.$latitude
            .assign(to: \.latitude, on: self)
            .store(in: &cancellables)
        locationManager.$longitude
            .assign(to: \.longiude, on: self)
            .store(in: &cancellables)
    }
}
