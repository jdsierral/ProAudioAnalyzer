//
//  ComplexSpectrum.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/11/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import Accelerate

class ComplexSpectrum {
    var ID: String
    var fft: FFT
    var fftSize: Int { return Int(fft.fftSize) }

    var real: UnsafeMutablePointer<Double>
    var imag: UnsafeMutablePointer<Double>
    var spectrum: DSPDoubleSplitComplex

    init(name: String, fftSize: UInt32, sampleRate: Double) {
        ID = name
        fft = FFT(fftSize: fftSize)

        let array = UnsafeMutablePointer<Double>.allocate(capacity: Int(fftSize) * 2)

        real = array
        imag = array.advanced(by: Int(fftSize))

        spectrum = DSPDoubleSplitComplex(realp: real, imagp: imag)
    }

    func computeSpectrum(dataPtr: UnsafeMutablePointer<Double>) {
		fft.process(dataPtr: dataPtr, specPtr: &spectrum)
    }

}
