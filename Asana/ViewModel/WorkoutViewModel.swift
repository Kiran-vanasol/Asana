//
//  WorkoutViewModel.swift
//  Asana
//
//  Created by Kiran T C on 12/09/25.
//

import Foundation
import Combine

@MainActor
class WorkoutViewModel: ObservableObject {
    @Published var poses: [APIPose] = []
    @Published var currentIndex: Int = 0
    @Published var timeRemaining: Int = 40
    @Published var isWorkoutFinished: Bool = false
    @Published var isIntroActive: Bool = true
    @Published var introCountdown: Int = 5

    private var introCancellable: AnyCancellable?
    private var workoutCancellable: AnyCancellable?

    init(poses: [APIPose] = []) {
        self.poses = poses
    }

    /// Starts the 5-second intro countdown
    func startIntro() {
        introCountdown = 5
        isIntroActive = true
        introCancellable?.cancel() // stop old intro timer

        introCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if self.introCountdown > 1 {
                    self.introCountdown -= 1
                } else {
                    self.isIntroActive = false
                    self.introCancellable?.cancel() // stop intro timer
                }
            }
    }

    /// Starts the workout session
    func startWorkout() {
        guard !poses.isEmpty else { return }
        currentIndex = 0
        timeRemaining = 40
        isWorkoutFinished = false
        workoutCancellable?.cancel() // stop old workout timer

        workoutCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if self.timeRemaining > 1 {
                    self.timeRemaining -= 1
                } else {
                    self.advancePose()
                }
            }
    }

    /// Move to the next pose
    func advancePose() {
        if currentIndex < poses.count - 1 {
            currentIndex += 1
            timeRemaining = 40
        } else {
            finishWorkout()
        }
    }

    /// Finish the workout
    func finishWorkout() {
        workoutCancellable?.cancel()
        isWorkoutFinished = true
    }
}
