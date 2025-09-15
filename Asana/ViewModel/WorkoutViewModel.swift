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
    @Published var isPaused: Bool = false   // 👈 NEW: track pause state

    private var introCancellable: AnyCancellable?
    private var workoutCancellable: AnyCancellable?

    init(poses: [APIPose] = []) {
        self.poses = poses
    }

    // MARK: - Intro
    func startIntro() {
        introCountdown = 5
        isIntroActive = true
        introCancellable?.cancel()

        introCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if self.introCountdown > 1 {
                    self.introCountdown -= 1
                } else {
                    self.isIntroActive = false
                    self.introCancellable?.cancel()
                }
            }
    }

    // MARK: - Workout
    func startWorkout() {
        guard !poses.isEmpty else { return }
        currentIndex = 0
        timeRemaining = 40
        isWorkoutFinished = false
        isPaused = false

        startTimer()
    }

    private func startTimer() {
        workoutCancellable?.cancel()

        workoutCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                guard !self.isPaused else { return }  // 👈 Stop if paused

                if self.timeRemaining > 1 {
                    self.timeRemaining -= 1
                } else {
                    self.advancePose()
                }
            }
    }

    func pauseWorkout() {
        isPaused = true
    }

    func resumeWorkout() {
        isPaused = false
    }

    func togglePauseResume() {
        isPaused.toggle()
    }

    // MARK: - Poses
    func advancePose() {
        if currentIndex < poses.count - 1 {
            currentIndex += 1
            timeRemaining = 40
        } else {
            finishWorkout()
        }
    }

    func finishWorkout() {
        workoutCancellable?.cancel()
        isWorkoutFinished = true
    }
}
