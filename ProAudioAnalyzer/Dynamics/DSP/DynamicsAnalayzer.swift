//
//  DynamicsAnalayzer.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/29/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation



class DynamicsAnalyzer : AudioAnalyzer {

    var lMeter = Meter(name: "Left")
    var rMeter = Meter(name: "Right")
    var mMeter = Meter(name: "Mid")
    var sMeter = Meter(name: "Side")

    override func initialize() {
        lMeter.initialize(sampleRate: sampleRate)
        rMeter.initialize(sampleRate: sampleRate)
        mMeter.initialize(sampleRate: sampleRate)
        sMeter.initialize(sampleRate: sampleRate)
    }
    
    override func process(leftInput: Double, rightInput: Double) {

        let l = leftInput
        let r = rightInput
        let m = (l + r) / 2
        let s = (l - r) / 2

        lMeter.process(input: l)
        rMeter.process(input: r)
        mMeter.process(input: m)
        sMeter.process(input: s)
    }

}
