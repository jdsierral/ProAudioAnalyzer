//
//  SpectrumAnalyzer.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/2/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation
import Accelerate

class SpectrumAnalyzer : AudioAnalyzer {

    var lSpectrum: MagnitudeSpectrum!
    var rSpectrum: MagnitudeSpectrum!
    private var lBuf: UnsafeMutablePointer<Double>!
    private var rBuf: UnsafeMutablePointer<Double>!

    private var writePos = 0 {
        didSet {
            if writePos == bufferSize {
                lSpectrum.computeSpectrum(dataPtr: lBuf)
                rSpectrum.computeSpectrum(dataPtr: rBuf)
                writePos = 0
            }
        }
    }

    deinit {
        lBuf.deallocate()
        rBuf.deallocate()
    }

    override func initialize() {
        lSpectrum = MagnitudeSpectrum(name: "Left", fftSize: bufferSize, sampleRate: sampleRate)
        rSpectrum = MagnitudeSpectrum(name: "Rigth", fftSize: bufferSize, sampleRate: sampleRate)
        lBuf = UnsafeMutablePointer<Double>.allocate(capacity: Int(bufferSize))
        rBuf = UnsafeMutablePointer<Double>.allocate(capacity: Int(bufferSize))
    }

    override func process(leftInput: Double, rightInput: Double) {
        lBuf[writePos] = leftInput
        rBuf[writePos] = rightInput
        writePos += 1
    }

}

