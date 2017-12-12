//
//  DecibelManager.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/30/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation

typealias dB = DecibelManager

class DecibelManager {

    enum dBRef: Int {
        case UK_PPM = 0
        case EBU_PPM
        case IEEE_PPM
        case IEEE_VU
        case DIN_PPM
        case K_20
        case K_14
        case K_12

    }

    static var dBType: dBRef = .IEEE_PPM

    static var limits: (min: Double, max: Double) = (-60.0, 0.0) {
        didSet { assert(limits.max >= limits.min) }
    }

    static var dangerLeveldB = -6.0
    static var cautionLeveldB = -10.0
    static var safeLeveldB = -20.0

    class func mag2dB (mag: Double) -> Double {
        if mag == 0.0 { return -Double.infinity }
        return 20.0 * log10(mag)
    }

    class func norm (dB: Double) -> Double {
        return  min(max((dB - limits.min) / (limits.max - limits.min), 0), 1)
    }
}
