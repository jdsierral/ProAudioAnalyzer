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
    var bufSize: UInt32 { return audioController.bufSize }

    init(controller: AVAudioController) {
        audioController = controller
        initialize()
    }

    func runPerSample() {
        installSampleTap()
    }

    func runPerBuffer() {
        installBufferTap()
    }

    func stop() {
        removeTap()
    }

    func initialize() {
        assertionFailure("Function must be overridden")
    }

    func installSampleTap() {
        let input = audioController.input!
        let format = input.inputFormat(forBus: 0)

        if format.channelCount > 1 {
            input.installTap(onBus: 0, bufferSize: audioController.bufSize, format: format, block: { (buffer, timeStamp) in
				let data = buffer.floatChannelData!
                let bufSize = Int(buffer.frameLength)
                for i in 0..<bufSize {
                    self.process(leftInput: data[0][i], rightInput: data[1][i])
                }
//                if DBG {print("AC BufSize is: \(self.audioController.bufSize)")
//                        print("used buffer Size is \(bufSize)")
//                }
            })
        } else {
            input.installTap(onBus: 0, bufferSize: audioController.bufSize, format: format, block: { (buffer, timeStamp) in
                let data = buffer.floatChannelData!
                let bufSize = Int(buffer.frameLength)
                for i in 0..<bufSize {
                    self.process(leftInput: data[0][i], rightInput: data[0][i])
                }
            })
        }
        if DBG { print("Tap Installed") }
    }

    func installBufferTap() {
        let input = audioController.input!
        let format = input.inputFormat(forBus: 0)

        if format.channelCount > 1 {
            input.installTap(onBus: 0, bufferSize: audioController.bufSize, format: format, block: { (buffer, timeStamp) in
                self.process(block: buffer)
            })
        } else {
            input.installTap(onBus: 0, bufferSize: audioController.bufSize, format: format, block: { (buffer, timeStamp) in
                self.process(block: buffer)
            })
        }
    }


    func removeTap() {
        audioController.input.removeTap(onBus: 0)
        if DBG { print("Tap Removed") }
    }

    func process(leftInput: Float, rightInput: Float) {
        assertionFailure("Function must be overriden")
    }

    func process(block: AVAudioPCMBuffer) {
        assertionFailure("Function must be overriden")
    }
    
}
