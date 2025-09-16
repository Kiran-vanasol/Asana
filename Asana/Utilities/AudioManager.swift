//
//  AudioManager.swift
//  Asana
//
//  Created by Kiran T C on 15/09/25.
//

import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?

    private init() {}

    /// Play audio from bundle folder references
    func playSound(folder: String, fileName: String, ext: String = "mp3") {
        // folder should be like "Audio/BackPain" or "Audio/Common"
        let path = "\(folder)/\(fileName)"
        
        print("Looking for: \(path).\(ext)")

        guard let url = Bundle.main.url(forResource: path, withExtension: ext) else {
            print("Audio file not found in bundle: \(path).\(ext)")
            return
        }

        do {
            // Keep strong reference to player
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            print("Now playing: \(path).\(ext)")
        } catch {
            print(" Error playing sound \(path): \(error.localizedDescription)")
        }
    }

    /// Stop any currently playing audio
    func stop() {
        if player?.isPlaying == true {
            player?.stop()
            print("Audio stopped")
        }
    }
}
