//
//  TransferFunctionAnalyzer.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/11/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation

class TransferFunctionAnalyzer: AudioAnalyzer {
    var magSpectrum: Spectrum!
    var phaSpectrum: Spectrum!
    private var lBuf: UnsafeMutablePointer<Double>!
    private var rBuf: UnsafeMutablePointer<Double>!

    private var writePos = 0 {
        didSet {
            if writePos == bufSize {
                magSpectrum.computeSpectrum(dataPtr: lBuf)
                phaSpectrum.computeSpectrum(dataPtr: rBuf)
            }
        }
    }

    override func initialize() {
        magSpectrum = Spectrum(name: "Mag", fftSize: bufSize, sampleRate: sampleRate)
        phaSpectrum = Spectrum(name: "Pha", fftSize: bufSize, sampleRate: sampleRate)

        lBuf = UnsafeMutablePointer<Double>.allocate(capacity: Int(bufSize))
        rBuf = UnsafeMutablePointer<Double>.allocate(capacity: Int(bufSize))
    }

    override func process(leftInput: Float, rightInput: Float) {
        lBuf[writePos] = Double(leftInput)
        rBuf[writePos] = Double(rightInput)
        writePos += 1
    }
}
