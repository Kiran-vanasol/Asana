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

    /// Play audio from blue folder references
    func playSound(folder: String, fileName: String, ext: String = "mp3") {
        // remove the extra "Audio/"
        let path = "\(folder)/\(fileName)"
        
        guard let url = Bundle.main.url(forResource: path, withExtension: ext) else {
            print("Audio file not found: \(path).\(ext)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            print("Playing sound: \(path).\(ext)")
        } catch {
            print(" Error playing sound \(path): \(error.localizedDescription)")
        }
    }

    func stop() {
        player?.stop()
    }
}
