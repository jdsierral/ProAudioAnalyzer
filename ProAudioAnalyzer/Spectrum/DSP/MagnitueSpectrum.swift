//
//  MagnitudeSpectrum.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/11/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import Accelerate


class MagnitudeSpectrum : Spectrum{

    var ID: String

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
        let fftSz = Int(fftSize)
        spectrumMag = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        spectrumMagdB = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        spectrumMagdBNorm = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        super.init()
        calculateNormalizationAffineTransform()
        fft = FFT(fftSize: fftSize)
        fft.setWindowTypeForCurrentSetup(type: .hamming)
    }

    deinit {
        spectrumMag.deallocate()
        spectrumMagdB.deallocate()
        spectrumMagdBNorm.deallocate()
    }

    override func computeSpectrum(dataPtr: UnsafeMutablePointer<Double>) {
		fft.process(dataPtr: dataPtr, fftMagPtr: spectrumMag)
    }

    func calculateSpectrumIndB() {
        vDSP_vdbconD(spectrumMag, 1, &ref, spectrumMagdB, 1, fft.fftSize, 1)
    }

    func calculateSpectrumInNormalizeddB () {
        vDSP_vsmsaD(spectrumMagdB, 1, &normalMult, &normalAdd, spectrumMagdBNorm, 1, fft.fftSize)
    }

    override func triggerUpdate(completion: () -> Void) {
        calculateSpectrumIndB()
        calculateSpectrumInNormalizeddB()
        completion()
    }

    override func dumpData(ptr: UnsafeMutableRawPointer) {
        ptr.copyMemory(from: UnsafeRawPointer(spectrumMagdBNorm), byteCount: fftSize * MemoryLayout<Double>.size)
    }


    func calculateNormalizationAffineTransform() {
        normalMult = 1.0/(maxdBValue - mindBValue)
        normalAdd = -mindBValue/(maxdBValue - mindBValue)
    }
}
