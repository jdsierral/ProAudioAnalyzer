//
//  DefaultSettings.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation

struct MeterDynamicsSettings {
    var peakAttackTime: Double
    var peakReleaseTime: Double
    var peakHolderTime: Double
    var rmsTime: Double
    var rmsHolderTime: Double
    var vuTime: Double
    var vuHolderTime: Double
    var clipHolderTime: Double
    var ispHolderTime: Double
}

struct MeterdBSettings {
    let HiLimit: Double
    let LowLimit: Double
}

struct PhaseMeterSettings {
    var peakPhaseAttackTime: Double
    var peakPhaseReleaseTime: Double
    var rmsPhaseTime: Double
    var peakTime: Double
    var rmsTime: Double
}

class DefaultSettings {
    private init() {}
    static var defaultMeterSettings = MeterDynamicsSettings(
        peakAttackTime: 0.01,
        peakReleaseTime: 1.0,
        peakHolderTime: 3.0,
        rmsTime: 0.1,
        rmsHolderTime: 1.0,
        vuTime: 0.3,
        vuHolderTime: 1.0,
        clipHolderTime: 5.0,
        ispHolderTime: 1.0)

    static var defaultMaxMeterSettings = MeterDynamicsSettings(
        peakAttackTime: 0.1,
        peakReleaseTime: 5,
        peakHolderTime: 10,
        rmsTime: 1,
        rmsHolderTime: 10,
        vuTime: 3,
        vuHolderTime: 20,
        clipHolderTime: 10,
        ispHolderTime: 10)
    static var useAESstddB = true

    static var defaultMinMaxdBLimits: (min: Double, max: Double) = (-100.0, 10.0)

    static var defaultPhaseMeterSettings = PhaseMeterSettings(
        peakPhaseAttackTime: 0.01,
        peakPhaseReleaseTime: 0.3,
        rmsPhaseTime: 0.12,
        peakTime: 0.01,
        rmsTime: 0.12)

    static var defaultMaxPhaseMeterSettings = PhaseMeterSettings(
        peakPhaseAttackTime: 0.1,
        peakPhaseReleaseTime: 1,
        rmsPhaseTime: 1,
        peakTime: 0.1,
        rmsTime: 1.0)

    static var defaultGoniometerSettings: (lTime: Double, rTime: Double) = (0.01, 0.01)
    static var defaultMaxGoniometerSettings: (lTime: Double, rTime: Double) = (0.1, 0.1)

}
