//
//  AudioAnalyzer.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation



class AudioAnalyzer {
    var audioController: AVAudioController!
    var sampleRate: Double { return audioController.sampleRate }
    var bufferSize: AVAudioFrameCount { return audioController.bufferSize }

    init(controller: AVAudioController) {
        audioController = controller
        initialize()
    }

    func run() {
        installTap()
    }

    func stop() {
        removeTap()
    }

    func initialize() {
        assertionFailure("Function must be overridden")
    }

    func installTap() {
        let input = audioController.input
        let format = input.inputFormat(forBus: 0)

        if format.channelCount > 1 {
            input.installTap(onBus: 0, bufferSize: AVAudioFrameCount(audioController.bufferSize), format: format, block: { (buffer, timeStamp) in
				let data = buffer.floatChannelData!
                let bufSize = Int(buffer.frameLength)
                for i in 0..<bufSize {
                    self.process(leftInput: Double(data[0][i]), rightInput: Double(data[1][i]))
                }
            })
        } else {
            input.installTap(onBus: 0, bufferSize: audioController.bufferSize, format: format, block: { (buffer, timeStamp) in
                let data = buffer.floatChannelData!
                let bufSize = Int(buffer.frameLength)
                for i in 0..<bufSize {
                    self.process(leftInput: Double(data[0][i]), rightInput: Double(data[0][i]))
                }
            })
        }
        if DBG { print("Tap Installed") }
    }


    func removeTap() {
        audioController.input.removeTap(onBus: 0)
        if DBG { print("Tap Removed") }
    }

    func process(leftInput: Double, rightInput: Double) {
        assertionFailure("Function must be overriden")
    }
    
}
