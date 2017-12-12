//
//  Spectrum.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/11/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//



import Foundation

class Spectrum {
    var fft: FFT!
    var fftSize: Int { return Int(fft.fftSize) }


    func computSpectrum(dataPtr: UnsafeMutablePointer<Double>) {
    }

    func triggerUpdate(completion: () -> Void) {
    }

    func dumpData(ptr: UnsafeMutableRawPointer) {
    }
}
