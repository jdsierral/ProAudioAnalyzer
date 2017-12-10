//
//  Trackers.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/29/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation


class PeakTracker : Tracker{

    var coefs2 = OnePoleCoefs()

    func setAttack(_ time: Double, sampleRate fs: Double) {
        coefs.setTau(sec: time, fs: fs)
    }

    func setRelease(_ time: Double, sampleRate fs: Double) {
        coefs2.setTau(sec: time, fs: fs)
    }

    override func process(input: Double) {
        let curValue = fabs(input)
        if curValue > state {
            state += coefs.b0 * ( curValue - state )
        } else {
            state += coefs2.b0 * ( curValue - state )
        }
    }
}

class RMSTracker : Tracker {

    func setTime(_ time: Double, sampleRate fs: Double) {
        coefs.setTau(sec: time, fs: fs)
    }

    override var value: Double { return sqrt(state) }

    override func process(input: Double) {
        let curValue = input * input
        super.process(input: curValue)
    }
}

class VUTracker : Tracker {

    func setTime(_ time: Double, sampleRate fs: Double) {
        coefs.setTau(sec: time, fs: fs)
    }

    override func process(input: Double) {
        let curValue = fabs(input)
        super.process(input: curValue)
    }
}

class IntegratorTracker : Tracker {
    private var lastTauInSamples = 1;

    func setTime(_ time: Double, sampleRate fs: Double) {
        lastTauInSamples = Int(time * fs)
        coefs.setTau(sec: time, fs: fs)
    }

    func updateTau() {
        coefs.setTau(samples: lastTauInSamples)
        lastTauInSamples += 1
    }

    override func process(input: Double) {
        updateTau()
        let curValue = fabs(input)
        super.process(input: curValue)
    }
}

class PhasePeakTracker : PeakTracker {
    override func process(input: Double) {
        if fabs(input) > fabs(state) {
            state += coefs.b0 * ( input - state )
        } else {
            state += coefs2.b0 * ( input - state )
        }

    }
}

class PhaseRMSTracker : Tracker {
    func setTime(_ time: Double, sampleRate fs: Double) {
        coefs.setTau(sec: time, fs: fs)
    }

    override var value: Double { return sqrt(state) }
    override func process(input: Double) {
        let curValue = input * input * input / fabs(input)
        super.process(input: curValue)
    }
}

class PhaseIntegratorTracker : IntegratorTracker {
    override func process(input: Double) {
        super.updateTau()
        state += coefs.b0 * ( input - state )
    }
}

class PurePeakTracker : Tracker {
    func setTime(_ time: Double, sampleRate fs: Double) {
        coefs.setTau(sec: time, fs: fs)
    }
}
