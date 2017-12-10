//
//  Holders.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/30/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation

class ValueHolder {
    private var state = 0.0 { didSet { counter = counterLenght } }
    private var counter = 0
    var counterLenght = 0
    var isOnHold: Bool { return counter == 0 }
    var value: Double { return state }
    var isClip: Bool { return state > 0.9885530947} // ref -0.1 dB

    func reset() { state = 0.0 }

    func setTime(_ time: Double, sampleRate: Double) {
        counterLenght = Int(time * sampleRate)
        counter = counterLenght
    }

    func tick(_ newValue: Double) {
        if isOnHold { counter -= 1 } else { state = 0 }
        state = max(state, fabs(newValue) )
    }
}

class ISPHolder: ValueHolder {

    override func tick(_ newValue: Double) {
        // TODO: Interpolator for InterSamplePeakDetection
    }
}



