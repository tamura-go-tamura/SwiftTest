//
//  DateTimer.swift
//  SwiftTest
//
//  Created by yuta on 2024/06/09.
//

import Foundation


/// Keeps time for a daily scrum meeting. Keep track of the total meeting time, the time for each speaker, and the name of the current speaker.


@MainActor
final class DateTimer: ObservableObject {
    @Published var nowDate: Date = Date()
    private weak var timer: Timer?
    
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
   
    
    /// Start the timer.
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            self?.update()
        }
        timer?.tolerance = 0.1
    }
    
    /// Stop the timer.
    func stopTimer() {
        timer?.invalidate()
        timerStopped = true
    }
    


    nonisolated private func update() {


        Task { @MainActor in
            guard !timerStopped else { return }
            nowDate = Date()
        }
    }
    
}
