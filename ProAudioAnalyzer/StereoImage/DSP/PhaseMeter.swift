//
//  PhaseMeter.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/5/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation

struct PhaseDynamics {
    var name: String
    var peakValue: Double
    var rmsValue: Double
    var intValue: Double
    var corrValue: Double
}

class PhaseMeter {

    public static var settings = DefaultSettings.defaultPhaseMeterSettings

    var ID: String
	var peakPhase = PhasePeakTracker()
    var rmsPhase = PhaseRMSTracker()
    var intPhase = PhaseIntegratorTracker()

    var peakL = PurePeakTracker()
    var peakR = PurePeakTracker()
    var rmsL = RMSTracker()
    var rmsR = RMSTracker()

    init(name: String) {
        ID = name
    }

    func initialize(sampleRate fs: Double) {
		peakPhase.reset()
        rmsPhase.reset()
        peakL.reset()
        peakR.reset()
        rmsL.reset()
        rmsR.reset()

        peakPhase.setAttack(PhaseMeter.settings.peakPhaseAttackTime , sampleRate: fs)
        peakPhase.setRelease(PhaseMeter.settings.peakPhaseReleaseTime, sampleRate: fs)
        rmsPhase.setTime(PhaseMeter.settings.rmsPhaseTime, sampleRate: fs)

        peakL.setTime(PhaseMeter.settings.peakTime, sampleRate: fs)
        peakR.setTime(PhaseMeter.settings.peakTime, sampleRate: fs)
        rmsL.setTime(PhaseMeter.settings.rmsTime, sampleRate: fs)
    	rmsR.setTime(PhaseMeter.settings.rmsTime, sampleRate: fs)
    }

    func process(leftInput: Double, rightInput: Double) {
        var phase = atan(leftInput/rightInput) * 180.0 / (Double.pi)
        if phase.isNaN { phase = 0.0 }
        peakL.process(input: leftInput)
        peakR.process(input: rightInput)
        rmsL.process(input: leftInput)
        rmsR.process(input: rightInput)
        peakPhase.process(input: phase)
        rmsPhase.process(input: phase)
        intPhase.process(input: phase)
    }

    func getCurrentPhaseValues() -> PhaseDynamics {
        let values = PhaseDynamics(name: ID,
                                   peakValue: (peakPhase.value + 90.0)/180.0,
                                   rmsValue:  (rmsPhase.value + 90.0)/180.0,
                                   intValue:  (intPhase.value + 90.0)/180.0,
                                   corrValue: getCorrelationValues())
        return values
    }

    func getCorrelationValues() -> Double {
        var corr = (peakL.value * peakR.value) / (rmsL.value * rmsR.value)
        if corr.isNaN { corr = 0.0 }
        return corr
    }
}
