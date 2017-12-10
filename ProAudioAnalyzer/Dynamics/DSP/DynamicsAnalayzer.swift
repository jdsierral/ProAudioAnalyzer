//
//  DynamicsAnalayzer.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/29/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation



class DynamicsAnalyzer {

    var audioController: AVAudioController!
    var lMeter: Meter
    var rMeter: Meter
    var mMeter: Meter
    var sMeter: Meter

    init(_ controller: AVAudioController) {
        audioController = controller
        lMeter = Meter(sampleRate: audioController.sampleRate, withName: "Left Meter")
        rMeter = Meter(sampleRate: audioController.sampleRate, withName: "Right Meter")
        mMeter = Meter(sampleRate: audioController.sampleRate, withName: "Mid Meter")
        sMeter = Meter(sampleRate: audioController.sampleRate, withName: "Side Meter")
    }

    func run() {
        stop()
        installTap()
    }

    func stop() {
        removeTap()
    }

    func installTap() {

        let input = audioController.input!
        let format = input.inputFormat(forBus: 0)

        if format.channelCount > 1 {
            input.installTap(onBus: 0, bufferSize: audioController.bufSize, format: format, block: { (buffer, timeStamp) in
                if let data = buffer.floatChannelData {
                    let bufSize = Int(buffer.frameLength)
                    for i in 0..<bufSize {
                        self.process(leftInput: data[0][i], rightInput: data[1][i])
                    }
                }
            })
        } else {
            input.installTap(onBus: 0, bufferSize: audioController.bufSize, format: format, block: { (buffer, timeStamp) in
                if let data = buffer.floatChannelData {
                    let bufSize = Int(buffer.frameLength)
                    for i in 0..<bufSize {
                        self.process(leftInput: data[0][i], rightInput: data[0][i])
                    }
                }
            })
        }
    }

    func removeTap() {
        if let input = audioController?.input{
            input.removeTap(onBus: 0)
        }
    }

    func process(leftInput: Float, rightInput: Float) {

        let l = Double(leftInput)
        let r = Double(rightInput)
        let m = (l + r) / 2
        let s = (l - r) / 2

        lMeter.process(input: l)
        rMeter.process(input: r)
        mMeter.process(input: m)
        sMeter.process(input: s)
    }

}
