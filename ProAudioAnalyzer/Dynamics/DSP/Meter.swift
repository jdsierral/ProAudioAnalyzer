//
//  Meter.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/29/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation


struct SignalDynamics {
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

    public static var settings = DefaultSettings.defaultMeterSettings
    static var useAESstddB = DefaultSettings.useAESstddB

    var ID: String
    var peak = PeakTracker()
    var rms  = RMSTracker()
    var vu   = VUTracker()
    var clipHolder = ValueHolder()
    var ispHolder = ISPHolder()
    var dbManager = DecibelManager()


    init(name id: String) {
        ID = id
    }

    func initialize(sampleRate fs: Double) {
        peak.reset()
        rms.reset()
        vu.reset()
        clipHolder.reset()
        ispHolder.reset()

        peak.setAttack(Meter.settings.peakAttackTime, sampleRate: fs)
        peak.setRelease(Meter.settings.peakReleaseTime, sampleRate: fs)
		peak.holder.setTime(Meter.settings.peakHolderTime, sampleRate: fs)

        rms.setTime(Meter.settings.rmsTime, sampleRate: fs)
        rms.holder.setTime(Meter.settings.rmsHolderTime, sampleRate: fs)

        vu.setTime(Meter.settings.vuTime, sampleRate: fs)
        vu.holder.setTime(Meter.settings.vuHolderTime, sampleRate: fs)

        clipHolder.setTime(Meter.settings.clipHolderTime, sampleRate: fs)
        ispHolder.setTime(Meter.settings.ispHolderTime, sampleRate: fs)
    }

    func process(input: Double) {
		peak.process(input: input)
        rms.process(input: input)
        vu.process(input: input)
        clipHolder.tick(input)
    }

    /////////////////////////////////////////////////////////////////////////


    func getCurrentRawValues() -> SignalDynamics {
		let values = SignalDynamics(name: ID,
                                    peakValue: peak.value,
                                    rmsValue: (Meter.useAESstddB ? rms.value * sqrt(2.0) : rms.value),
                                    vuValue: vu.value,
                                    peakMax: peak.holder.value,
                                    rmsMax: rms.holder.value,
                                    ispMax: vu.holder.value,
                                    clip: clipHolder.isClip)
        return values
    }

    func getCurrentdBValues() -> SignalDynamics {
		var values = getCurrentRawValues()
        values.peakValue = dB.mag2dB(mag: values.peakValue)
        values.rmsValue = dB.mag2dB(mag: values.rmsValue)
        values.vuValue = dB.mag2dB(mag: values.vuValue)
        values.peakMax = dB.mag2dB(mag: values.peakMax)
        values.rmsMax = dB.mag2dB(mag: values.rmsMax)
        values.ispMax = dB.mag2dB(mag: values.ispMax)
		return values
    }

    func getCurrentNormalizedValues() -> SignalDynamics {
		var values = getCurrentdBValues()
        values.peakValue = dB.norm(dB: values.peakValue)
        values.rmsValue = dB.norm(dB: values.rmsValue)
        values.vuValue = dB.norm(dB: values.vuValue)
        values.peakMax = dB.norm(dB: values.peakMax)
        values.rmsMax = dB.norm(dB: values.rmsMax)
        values.ispMax = dB.norm(dB: values.ispMax)
        return values
    }
}
