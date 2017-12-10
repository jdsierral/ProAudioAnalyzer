//
//  Meter.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/29/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation

struct Dynamics {
    var name: String
    var peakValue: Double
    var rmsValue: Double
    var vuValue: Double
    var peakMax: Double
    var rmsMax: Double
    var ispMax: Double
    var clip: Bool
}

class Meter {
    var fs: Double
    var peak = PeakTracker()
    var rms  = RMSTracker()
    var vu   = VUTracker()
    var clipHolder = ValueHolder()
    var ispHolder = ISPHolder()
    var useAESstdRMS = true
    var dbManager = DecibelManager()
    var ID: String

    func initialize() {
        peak.setAttack(0.001, sampleRate: fs)
        peak.setRelease(1.0, sampleRate: fs)
        peak.holder.setTime(-1, sampleRate: fs)

        rms.setTime(0.1, sampleRate: fs)
        rms.holder.setTime(1.0, sampleRate: fs)

        vu.setTime(0.3, sampleRate: fs)
        vu.holder.setTime(1.0, sampleRate: fs)

        clipHolder.setTime(5.0, sampleRate: fs)
        ispHolder.setTime(1.0, sampleRate: fs)

        dbManager.loadDefaults()
    }

    init(sampleRate: Double, withName name: String = String()) {
        fs = sampleRate
        ID = name

        initialize()
    }

    func process(input: Double) {
		peak.process(input: input)
        rms.process(input: input)
        vu.process(input: input)
        clipHolder.tick(input)
    }

    func getCurrentValues() -> Dynamics {
		let values = Dynamics(name: ID,
                              peakValue: dbManager.normalizedDb(db: dbManager.mag2dB(mag: peak.value)),
                              rmsValue: dbManager.normalizedDb(db: dbManager.mag2dB(mag: rms.value)),
                              vuValue: dbManager.normalizedDb(db: dbManager.mag2dB(mag: vu.value)),
                              peakMax: dbManager.mag2dB(mag: peak.holder.value),
                              rmsMax: dbManager.mag2dB(mag: rms.holder.value),
                              ispMax: dbManager.mag2dB(mag: vu.value),
                              clip: clipHolder.isClip)
		return values
    }
}
