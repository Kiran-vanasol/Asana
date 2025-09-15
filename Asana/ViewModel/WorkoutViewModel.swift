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
    @Published var poseDuration: Int = 40
    @Published var isWorkoutFinished: Bool = false
    @Published var isIntroActive: Bool = true
    @Published var introCountdown: Int = 5
    @Published var isPaused: Bool = false

    //  Popup state
    @Published var showUpNext: Bool = false
    @Published var upNextPose: APIPose? = nil

    private var introCancellable: AnyCancellable?
    private var workoutCancellable: AnyCancellable?
    @Published private(set) var workoutType: String = "BackPain"

    init(poses: [APIPose] = [], workoutType: String = "BackPain") {
        self.poses = poses
        self.workoutType = workoutType
    }

    // MARK: - Intro
    func startIntro() {
        introCountdown = 5
        isIntroActive = true
        introCancellable?.cancel()

        // Play the correct "Lets Start" audio depending on workout type
        playIntroSound(for: workoutType)

        introCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }

                if self.introCountdown > 1 {
                    self.introCountdown -= 1
                } else {
                    self.isIntroActive = false
                    self.introCancellable?.cancel()
                    self.startWorkout()
                }
            }
    }

    // MARK: - Workout
    func startWorkout() {
        guard !poses.isEmpty else { return }
        currentIndex = 0
        poseDuration = 45
        timeRemaining = poseDuration
        isWorkoutFinished = false
        isPaused = false

        playCurrentPoseAudio()
        startTimer()
    }

    private func startTimer() {
        workoutCancellable?.cancel()

        workoutCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                guard !self.isPaused else { return }

                if self.timeRemaining > 1 {
                    self.timeRemaining -= 1

                    if self.timeRemaining == 3 {
                        //  beep_asana  in Audio/Common
                        AudioManager.shared.playSound(folder: "Audio/Common", fileName: "beep_asana")

                        let nextPose = self.currentIndex + 1 < self.poses.count ? self.poses[self.currentIndex + 1] : nil
                        self.showUpNextPopup(nextPose: nextPose)
                    }
                } else {
                    self.advancePose()
                }
            }
    }

    func pauseWorkout() { isPaused = true }
    func resumeWorkout() { isPaused = false }
    func togglePauseResume() { isPaused.toggle() }

    // MARK: - Poses
    func advancePose() {
        if currentIndex < poses.count - 1 {
            currentIndex += 1
            poseDuration = 40
            timeRemaining = poseDuration
            playCurrentPoseAudio()
        } else {
            finishWorkout()
        }
    }

    func finishWorkout() {
        workoutCancellable?.cancel()
        isWorkoutFinished = true
    }

    // MARK: - Helpers
    private func playCurrentPoseAudio() {
        let poseName = poses[currentIndex].name
        AudioManager.shared.playSound(folder: "Audio/\(workoutType)", fileName: poseName)
    }
    func goBackPose() {
        if currentIndex > 0 {
            currentIndex -= 1
            poseDuration = 40
            timeRemaining = poseDuration
            playCurrentPoseAudio()
        }
    }

    private func playIntroSound(for workoutType: String) {
        var fileName = "PostureReset" // default
        switch workoutType {
        case "PostureReset": fileName = "Lets Start1"
        case "BackPain": fileName = "Lets Start2"
        case "NeckPain": fileName = "Lets Start3"
        default: break
        }
        AudioManager.shared.playSound(folder: "Audio/\(workoutType)", fileName: fileName)
    }

    private func showUpNextPopup(nextPose: APIPose?) {
        upNextPose = nextPose
        showUpNext = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showUpNext = false
        }
    }
}


