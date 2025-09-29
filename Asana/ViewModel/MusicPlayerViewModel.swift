//
//  MusicPlayerViewModel.swift
//  Asana
//
//  Created by Kiran T C on 23/09/25.
//

import Foundation

@MainActor
class MusicPlayerViewModel: ObservableObject {
    let sessionId: String
    
    @Published var poses: [MusicPose] = []
    @Published var currentIndex: Int = 0
    @Published var isPlaying: Bool = false
    @Published var isFinished: Bool = false
    @Published private(set) var workoutType: String = "InnerEchoes"
    
   
    
    init(poses: [MusicPose], workoutType: String = "InnerEchoes", sessionId: String) {
        self.poses = poses
        self.workoutType = workoutType
        self.sessionId = sessionId
//        
//        if !poses.isEmpty {
//                play()
//            }
    }

    
    
    // MARK: - Audio Playback
    func play() {
        guard currentIndex < poses.count else { return }
        let trackName = poses[currentIndex].name
        AudioManager.shared.playSound(folder: "Audio/\(workoutType)", fileName: trackName)
        isPlaying = true
    }
    
    func pause() {
        AudioManager.shared.stop()
        isPlaying = false
    }
    
    func togglePlayPause() {
        isPlaying ? pause() : play()
    }
    
    func nextTrack() {
        if currentIndex < poses.count - 1 {
            currentIndex += 1
            play()
        } else {
            finishSession()
        }
    }
    
    func previousTrack() {
        if currentIndex > 0 {
            currentIndex -= 1
            play()
        }
    }
    
    // MARK: - Session Complete
    private func finishSession() {
        pause()
        isFinished = true
        
        StreakService.shared.recordCompletion(for: workoutType) { result in
            switch result {
            case .success(let info):
                print("Meditation streak updated: \(info.streakCount)")
            case .failure(let error):
                print("Failed to update meditation streak:", error.localizedDescription)
            }
        }
    }
}
