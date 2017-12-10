//
//  BaseTracker.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/29/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation


struct OnePoleCoefs {
    var b0 = 1.0
    var a1 = 0.0

    mutating func setTau(sec tau: Double, fs: Double) {
        a1 = exp(-1.0 / ( tau * fs ) )
        b0 = 1.0 - a1
    }

    mutating func setTau(samples tau: Int) {
        a1 = exp(-1.0 / Double(tau) )
        b0 = 1.0 - a1
        assert(a1 != 0)
    }

    mutating func reset() {
        b0 = 1.0
        a1 = 0.0
    }
}

class Tracker  {
    // Holder //
    var holder = ValueHolder()

    // Filter //

    var coefs = OnePoleCoefs()
    var state = 0.0 { didSet { holder.tick(state) } }

    var value: Double { return state }

    func reset() {
        state = 0.0
    }

    func resetCoefs() {
        coefs.reset()
    }

    func resetTimer() {
        holder.reset()
    }

    func process(input: Double) {
        state += coefs.b0 * ( input - state )
    }
}
