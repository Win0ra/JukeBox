//
//  AVDelegate.swift
//  JukeBox-V2
//
//  Created by Maëva Bouvard on 25/06/2024.
//

import AVFoundation

class AVDelegate: NSObject, AVAudioPlayerDelegate {
    private let onFinish: () -> Void

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinish()
    }
}
