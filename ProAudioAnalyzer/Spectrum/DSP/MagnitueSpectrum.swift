//
//  MagnitudeSpectrum.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/11/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import Accelerate


class MagnitudeSpectrum {

    var ID: String
    var fft: FFT
    var fftSize: Int { return Int(fft.fftSize) }

//    public static var settings = DefaultSettings.defaultSpectrumSettings

    var spectrumMag: UnsafeMutablePointer<Double>
    var spectrumMagdB: UnsafeMutablePointer<Double>
    var spectrumMagdBNorm: UnsafeMutablePointer<Double>

    var maxdBValue: Double { return dB.limits.max }
    var mindBValue: Double { return dB.limits.min }
    private var normalMult: Double = 0;
    private var normalAdd:  Double = 0;
    private var ref: Double = 1.0


    init(name: String, fftSize: UInt32, sampleRate: Double) {
        ID = name
		fft = FFT(fftSize: fftSize)

        let fftSz = Int(fftSize)

        spectrumMag = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        spectrumMagdB = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        spectrumMagdBNorm = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)

        fft.setWindowTypeForCurrentSetup(type: .hamming)

		calculateNormalizationAffineTransform()
    }

    deinit {
        spectrumMag.deallocate(capacity: fftSize)
        spectrumMagdB.deallocate(capacity: fftSize)
        spectrumMagdBNorm.deallocate(capacity: fftSize)
    }

    func computeSpectrum(dataPtr: UnsafeMutablePointer<Double>) {
		fft.process(dataPtr: dataPtr, fftMagPtr: spectrumMag)
    }

    func calculateSpectrumIndB() {
        vDSP_vdbconD(spectrumMag, 1, &ref, spectrumMagdB, 1, fft.fftSize, 1)
    }

    func calculateSpectrumInNormalizeddB () {
        vDSP_vsmsaD(spectrumMagdB, 1, &normalMult, &normalAdd, spectrumMagdBNorm, 1, fft.fftSize)
    }

    func triggerUpdate(completion: () -> Void) {
        calculateSpectrumIndB()
        calculateSpectrumInNormalizeddB()
        completion()
    }

    func dumpData(ptr: UnsafeMutableRawPointer) {
        ptr.copyBytes(from: UnsafeRawPointer(spectrumMagdBNorm), count: fftSize * MemoryLayout<Double>.size)
    }


    func calculateNormalizationAffineTransform() {
        normalMult = 1.0/(maxdBValue - mindBValue)
        normalAdd = -mindBValue/(maxdBValue - mindBValue)
    }
}
