//
//  FFT.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/3/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import Accelerate

class FFT {

    enum WinType {
        case none
        case hanning
        case hamming
    }

    private let N: vDSP_Length
    private let NLog: vDSP_Length
    private var setup: FFTSetup
    private var complexPtr: UnsafeMutablePointer<Double>
    private var complex: DSPDoubleSplitComplex
    private var fftFact: Double
    var winType: WinType = .none
    var fftSize: vDSP_Length {return N/4}

    var windowPtr: UnsafeMutablePointer<Double>?

    init(fftSize: UInt32) {
        N = vDSP_Length(fftSize * 4)
        NLog = vDSP_Length(log2(Double(N)))
        setup = vDSP_create_fftsetupD(NLog, FFTRadix(FFT_RADIX2))!
        fftFact = 1.0 / (Double(fftSize))
        complexPtr = UnsafeMutablePointer<Double>.allocate(capacity: Int(N))
        complex = DSPDoubleSplitComplex(realp: complexPtr, imagp: complexPtr.advanced(by: Int(N/2)))
    }

    deinit {
        complexPtr.deallocate(capacity: Int(fftSize))
        windowPtr?.deallocate(capacity: Int(fftSize))
        vDSP_destroy_fftsetupD(setup)
    }

    func setWindowTypeForCurrentSetup(type: WinType) {
        if type == .none { return }
        windowPtr = UnsafeMutablePointer<Double>.allocate(capacity: Int(fftSize))
        if type == .hamming {
            let tempBuf = UnsafeMutablePointer<Double>.allocate(capacity: Int(fftSize))
            vDSP_hamm_windowD(tempBuf, fftSize, 1)
            vDSP_vsmulD(tempBuf, 1, &fftFact, windowPtr!, 1, fftSize)
            tempBuf.deallocate(capacity: Int(fftSize))
            //TODO: Implement correct Scaling for windowed FFT
        }
        if type == .hanning {
            let tempBuf = UnsafeMutablePointer<Double>.allocate(capacity: Int(fftSize))
            vDSP_hann_windowD(tempBuf, fftSize, Int32(vDSP_HANN_NORM))
            vDSP_vsmulD(tempBuf, 1, &fftFact, windowPtr!, 1, fftSize)
            tempBuf.deallocate(capacity: Int(fftSize))
            //TODO: Implement correct Scaling for windowed FFT
        }
    }

    func process(dataPtr: UnsafeMutablePointer<Double>, fftMagPtr: UnsafeMutablePointer<Double>) {
        vDSP_vsmulD(dataPtr, 1, &fftFact, complexPtr, 1, fftSize)
        vDSP_vclrD(complexPtr.advanced(by: Int(fftSize)), 1, 3 * fftSize)
        vDSP_fft_zripD(setup, &complex, 1, NLog, FFTDirection(FFT_FORWARD))

        complex.imagp[0] = Double(0.0)

        vDSP_zvabsD(&complex, 1, fftMagPtr, 1, fftSize)
    }

    func processWindowing(dataPtr: UnsafeMutablePointer<Double>, fftMagPtr: UnsafeMutablePointer<Double>) {
        vDSP_vmulD(dataPtr, 1, windowPtr!, 1, complexPtr, 1, fftSize)
        vDSP_vclrD(complexPtr.advanced(by: Int(fftSize)), 1, 3 * fftSize)
        vDSP_fft_zripD(setup, &complex, 1, NLog, FFTDirection(FFT_FORWARD))

        complex.imagp[0] = Double(0.0)

        vDSP_zvabsD(&complex, 1, fftMagPtr, 1, fftSize)
    }

    func process(dataPtr: UnsafeMutablePointer<Double>, specPtr: UnsafePointer<DSPDoubleSplitComplex>) {
        vDSP_vsmulD(dataPtr, 1, &fftFact, complexPtr, 1, fftSize)
        vDSP_vclrD(complexPtr.advanced(by: Int(fftSize)), 1, 3 * fftSize)
        vDSP_fft_zripD(setup, &complex, 1, NLog, FFTDirection(FFT_FORWARD))
        complex.imagp[0] = Double(0.0)

        vDSP_zvmovD(&complex, 1, specPtr, 1, fftSize)
    }

    func processWindowing(dataPtr: UnsafeMutablePointer<Double>, specPtr: UnsafePointer<DSPDoubleSplitComplex>) {
        vDSP_vmulD(dataPtr, 1, windowPtr!, 1, complexPtr, 1, fftSize)
        vDSP_vclrD(complexPtr.advanced(by: Int(fftSize)), 1, 3 * fftSize)
        vDSP_fft_zripD(setup, &complex, 1, NLog, FFTDirection(FFT_FORWARD))
        complex.imagp[0] = Double(0.0)

        vDSP_zvmovD(&complex, 1, specPtr, 1, fftSize)
    }

}
