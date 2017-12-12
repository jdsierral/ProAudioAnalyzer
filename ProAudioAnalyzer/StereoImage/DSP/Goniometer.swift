//
//  Goniometer.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/5/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation


class Goniometer {

    public static var settings = DefaultSettings.defaultGoniometerSettings

    var ID: String

    var lTrace = PurePeakTracker()
    var rTrace = PurePeakTracker()

    init(name id: String) {
        ID = id
    }

    func initialize(sampleRate fs: Double) {
		lTrace.reset()
        rTrace.reset()

        lTrace.setTime(Goniometer.settings.lTime, sampleRate: fs)
        rTrace.setTime(Goniometer.settings.rTime, sampleRate: fs)
    }

    func process(leftInput: Double, rightInput: Double) {
		lTrace.process(input: leftInput)
        rTrace.process(input: rightInput)
    }

    func getCurrentvalues() -> (l: Double, r: Double) {
        return (lTrace.value, rTrace.value)
    }
}
