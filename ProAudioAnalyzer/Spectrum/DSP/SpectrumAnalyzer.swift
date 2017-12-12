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
            if writePos == bufSize {
                lSpectrum.computeSpectrum(dataPtr: lBuf)
                rSpectrum.computeSpectrum(dataPtr: rBuf)
                writePos = 0
            }
        }
    }

    override func initialize() {
        lSpectrum = MagnitudeSpectrum(name: "Left", fftSize: bufSize, sampleRate: sampleRate)
        rSpectrum = MagnitudeSpectrum(name: "Rigth", fftSize: bufSize, sampleRate: sampleRate)
        lBuf = UnsafeMutablePointer<Double>.allocate(capacity: Int(bufSize))
        rBuf = UnsafeMutablePointer<Double>.allocate(capacity: Int(bufSize))
    }

    override func process(leftInput: Float, rightInput: Float) {
        lBuf[writePos] = Double(leftInput)
        rBuf[writePos] = Double(rightInput)
        writePos += 1
    }

}

