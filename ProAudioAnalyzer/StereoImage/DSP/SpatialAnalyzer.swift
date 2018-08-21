//
//  SpatialAnalyzer.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/5/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation

class StereoImageAnalyzer: AudioAnalyzer {
    var phaseMeter: PhaseMeter = PhaseMeter(name: "Phase")
    var goniometer: Goniometer = Goniometer(name: "Lissajous")

    override func initialize() {
		phaseMeter.initialize(sampleRate: sampleRate)
        goniometer.initialize(sampleRate: sampleRate)
    }

    override func process(leftInput: Double, rightInput: Double) {
        let l = Double(leftInput)
        let r = Double(rightInput)
        phaseMeter.process(leftInput: l, rightInput: r)
        goniometer.process(leftInput: l, rightInput: r)
    }
}
