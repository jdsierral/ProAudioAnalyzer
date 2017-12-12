//
//  PhaseSpectrum.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/11/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import Accelerate

class PhaseSpectrum: Spectrum {

    var spectrumPha: UnsafeMutablePointer<Double>
    var spectrumPhaDeg: UnsafeMutablePointer<Double>
    var spectrumPhaDegNorm: UnsafeMutablePointer<Double>

    private var normalMult: Double = 0.0
    private var normalAdd:  Double = 0.0
    private var degMutl: Double = 0.0
    private var degAdd: Double = 0.0

    override init(name: String, fftSize: UInt32, sampleRate: Double) {
        ID = name
        fft = FFT(fftSize: fftSize)

        let fftSz = Int(fftSize)

        spectrumPha =  UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        spectrumPhaDeg =  UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        spectrumPhaDegNorm =  UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
    }
}
