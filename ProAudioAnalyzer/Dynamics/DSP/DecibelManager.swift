//
//  DecibelManager.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/30/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation

class DecibelManager {

    enum DbRef {
        case UK_PPM
        case EBU_PPM
        case IEEE_PPM
        case IEEE_VU
        case DIN_PPM
        case K_20
        case K_14
        case K_12
    }

    var limits: (min: Double, max: Double) = (0, 0) {
        didSet { assert(limits.max >= limits.min) }
    }

    var dangerLevel = -6.0
    var cautionLevel = -10.0
    var safeLevel = 0.0


    var numTicks: Int = 10
    var ticks: [Double] {
        let base = (0..<numTicks).map { Double($0)/Double(numTicks) * (limits.max - limits.min) + limits.min }
        // TODO: Fix This! ta horrible
        return base
    }

    func mag2dB (mag: Double) -> Double {
        return 20.0 * log10(mag)
    }

    func scaleddB (db: Double) -> Double {
		return 0.0
    }

    func normalizedDb(db: Double) -> Double {
        return  min(max((db - limits.min) / (limits.max - limits.min), 0), 1)
    }

    func loadDefaults() {
        limits = (-60.0, 0.0)
    }
}
