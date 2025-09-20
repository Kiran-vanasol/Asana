//
//  WorkoutViewModel.swift
//  Asana
//
//  Created by Kiran T C on 12/09/25.
//

//import Foundation
//import Combine
//
//@MainActor
//class WorkoutViewModel: ObservableObject {
//    @Published var poses: [APIPose] = []
//    @Published var currentIndex: Int = 0
//    @Published var timeRemaining: Int = 40
//    @Published var poseDuration: Int = 40
//    @Published var isWorkoutFinished: Bool = false
//    @Published var isIntroActive: Bool = true
//    @Published var introCountdown: Int = 5
//    @Published var isPaused: Bool = false
//
//    // Popup states
//    @Published var showUpNext: Bool = false
//    @Published var upNextPose: APIPose? = nil
//
//    // New popup state for per-pose 5s intro
//    @Published var isPoseIntroActive: Bool = false
//    @Published var poseIntroCountdown: Int = 5
//
//    private var introCancellable: AnyCancellable?
//    private var workoutCancellable: AnyCancellable?
//    @Published private(set) var workoutType: String = "BackPain"
//
//    init(poses: [APIPose] = [], workoutType: String = "BackPain") {
//        self.poses = poses
//        self.workoutType = workoutType
//    }
//
//    // MARK: - Intro
//    func startIntro() {
//        introCountdown = 5
//        isIntroActive = true
//        introCancellable?.cancel()
//
//        // Play correct "Let's Start" audio
//        playIntroSound(for: workoutType)
//
//        introCancellable = Timer.publish(every: 1, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                guard let self else { return }
//
//                if self.introCountdown > 1 {
//                    self.introCountdown -= 1
//                } else {
//                    self.isIntroActive = false
//                    self.introCancellable?.cancel()
//                    self.startWorkout()
//                }
//            }
//    }
//
//    // MARK: - Workout
//    func startWorkout() {
//        guard !poses.isEmpty else { return }
//        currentIndex = 0
//        poseDuration = 40
//        timeRemaining = poseDuration
//        isWorkoutFinished = false
//        isPaused = false
//
//        // Play first pose audio directly
//        playCurrentPoseAudio()
//        startTimer()
//    }
//
//    private func startTimer() {
//        workoutCancellable?.cancel()
//        
//        poseDuration = 40
//        timeRemaining = poseDuration
//        workoutCancellable = Timer.publish(every: 1, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                guard let self else { return }
//                guard !self.isPaused else { return }
//
//                if self.timeRemaining > 1 {
//                    self.timeRemaining -= 1
//
//                    if self.timeRemaining == 3 {
//                        // Play beep at 3s mark
//                        AudioManager.shared.playSound(folder: "Audio/Common", fileName: "beep_asana")
//
//                        let nextPose = self.currentIndex + 1 < self.poses.count ? self.poses[self.currentIndex + 1] : nil
//                        self.showUpNextPopup(nextPose: nextPose)
//                    }
//                } else {
//                    self.advancePose()
//                }
//            }
//    }
//
//    func pauseWorkout() { isPaused = true }
//    func resumeWorkout() { isPaused = false }
//    func togglePauseResume() { isPaused.toggle() }
//
//    // MARK: - Poses
//    func advancePose() {
//        if currentIndex < poses.count - 1 {
//            currentIndex += 1
////            poseDuration = 40
////            timeRemaining = poseDuration
//            startPoseIntro(for: currentIndex) //  show 5s popup before starting
//        } else {
//            finishWorkout()
//        }
//    }
//
//    func goBackPose() {
//        if currentIndex > 0 {
//            currentIndex -= 1
////            poseDuration = 40
////            timeRemaining = poseDuration
//            startPoseIntro(for: currentIndex) // also show 5s popup
//        }
//    }
//
//    func finishWorkout() {
//        workoutCancellable?.cancel()
//        isWorkoutFinished = true
//    }
//
//    // MARK: - Helpers
//    private func playCurrentPoseAudio() {
//        let poseName = poses[currentIndex].name
//        AudioManager.shared.playSound(folder: "Audio/\(workoutType)", fileName: poseName)
//    }
//
//    private func playIntroSound(for workoutType: String) {
//        var fileName = "PostureReset" // default
//        switch workoutType {
//        case "PostureReset": fileName = "Lets Start1"
//        case "BackPain": fileName = "Lets Start2"
//        case "NeckPain": fileName = "Lets Start3"
//        default: break
//        }
//        AudioManager.shared.playSound(folder: "Audio/\(workoutType)", fileName: fileName)
//    }
//
//    private func showUpNextPopup(nextPose: APIPose?) {
//        upNextPose = nextPose
//        showUpNext = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.showUpNext = false
//        }
//    }
//
//    // MARK: - Pose Intro (5s popup)
//    func startPoseIntro(for index: Int) {
//        guard index >= 0, index < poses.count else { return }
//        isPoseIntroActive = true
//        poseIntroCountdown = 5
//        introCancellable?.cancel()
//
//        // Play audio for this pose
//        AudioManager.shared.playSound(folder: "Audio/\(workoutType)", fileName: poses[index].name)
//
//        introCancellable = Timer.publish(every: 1, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                guard let self else { return }
//                if self.poseIntroCountdown > 1 {
//                    self.poseIntroCountdown -= 1
//                } else {
//                    self.isPoseIntroActive = false
//                    self.introCancellable?.cancel()
//                    self.startTimer() // start timer after popup
//                }
//            }
//    }
//}
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

    // Popup states
    @Published var showUpNext: Bool = false
    @Published var upNextPose: APIPose? = nil

    // Per-pose 5s intro
    @Published var isPoseIntroActive: Bool = false
    @Published var poseIntroCountdown: Int = 5

    private var introCancellable: AnyCancellable?
    private var workoutCancellable: AnyCancellable?
    @Published private(set) var workoutType: String = "BackPain"

    init(poses: [APIPose] = [], workoutType: String = "BackPain") {
        self.poses = poses
        self.workoutType = workoutType
    }

    // MARK: - App Intro
    func startIntro() {
        introCountdown = 5
        isIntroActive = true
        introCancellable?.cancel()
        playIntroSound(for: workoutType)

        introCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if self.introCountdown > 1 {
                    self.introCountdown -= 1
                } else {
                    self.isIntroActive = false
                    self.introCancellable?.cancel()
                    // Start workout — but show per-pose intro first
                    self.startWorkout()
                }
            }
    }

    // MARK: - Workout
    func startWorkout() {
        guard !poses.isEmpty else { return }
        currentIndex = 0
        isWorkoutFinished = false
        isPaused = false

        // Start the first pose with a 5s pose intro (so the ring starts only after the popup)
        startPoseIntro(for: currentIndex)
    }

    private func startTimer() {
        // ensure any previous timer stopped
        workoutCancellable?.cancel()

        // reset duration now (only when about to start the actual pose countdown)
        poseDuration = 40
        timeRemaining = poseDuration

        workoutCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                // If paused or currently showing pose intro, do nothing
                guard !self.isPaused else { return }
                guard !self.isPoseIntroActive else { return }

                if self.timeRemaining > 1 {
                    self.timeRemaining -= 1

                    if self.timeRemaining == 3 {
                        AudioManager.shared.playSound(folder: "Audio/Common", fileName: "beep_asana")
                        let nextPose = self.currentIndex + 1 < self.poses.count ? self.poses[self.currentIndex + 1] : nil
                        self.showUpNextPopup(nextPose: nextPose)
                    }
                } else {
                    // finished this pose
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
            // start the 5s pose intro (timer was canceled in startPoseIntro)
            startPoseIntro(for: currentIndex)
        } else {
            finishWorkout()
        }
    }

    func goBackPose() {
        if currentIndex > 0 {
            currentIndex -= 1
            startPoseIntro(for: currentIndex)
        }
    }

    func finishWorkout() {
        workoutCancellable?.cancel()
        introCancellable?.cancel()
        isWorkoutFinished = true
    }

    // MARK: - Helpers
    private func playCurrentPoseAudio() {
        let poseName = poses[currentIndex].name
        AudioManager.shared.playSound(folder: "Audio/\(workoutType)", fileName: poseName)
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

    // MARK: - Pose Intro (5s popup)
    func startPoseIntro(for index: Int) {
        guard index >= 0, index < poses.count else { return }

        // STOP the main timer immediately so it doesn't keep decrementing
        workoutCancellable?.cancel()

        // hide UpNext while intro is visible
        showUpNext = false
        upNextPose = nil

        isPoseIntroActive = true
        poseIntroCountdown = 5
        introCancellable?.cancel()

        // Play audio for this pose (intro voice)
        AudioManager.shared.playSound(folder: "Audio/\(workoutType)", fileName: poses[index].name)

        introCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.poseIntroCountdown > 1 {
                    self.poseIntroCountdown -= 1
                } else {
                    // pose intro done: start actual pose timer
                    self.isPoseIntroActive = false
                    self.introCancellable?.cancel()
                    self.startTimer()
                }
            }
    }
}
