//
//  TransferFunction.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/11/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import Accelerate

class TransferFunction {

    var srcSpectrum: ComplexSpectrum
    var refSpectrum: ComplexSpectrum

    var tfComplex: DSPDoubleSplitComplex
    var tfMag: UnsafeMutablePointer<Double>
    var tfMagdB: UnsafeMutablePointer<Double>
    var tfMagdBNorm: UnsafeMutablePointer<Double>

    var tfPha: UnsafeMutablePointer<Double>
    var tfPhaDeg: UnsafeMutablePointer<Double>
    var tfPhaNorm: UnsafeMutablePointer<Double>

    var maxdBValue: Double { return dB.limits.max }
    var mindBValue: Double { return dB.limits.min }
    private var normalMult: Double = 0;
    private var normalAdd:  Double = 0;
    private var normalPhaMult: Double = 1.0/(2 * Double.pi)
    private var normalPhaAdd: Double = 0.5;
    private var ref: Double = 1.0
    private var rad2DegVal: Double = 180.0/Double.pi

    var fftSize: Int { return srcSpectrum.fftSize }

    init(fftSize: UInt32, sampleRate: Double) {
        srcSpectrum = ComplexSpectrum(name: "Source", fftSize: fftSize, sampleRate: sampleRate)
        refSpectrum = ComplexSpectrum(name: "Reference", fftSize: fftSize, sampleRate: sampleRate)

        let array = UnsafeMutablePointer<Double>.allocate(capacity: 2 * Int(fftSize))

        tfComplex = DSPDoubleSplitComplex(realp: array, imagp: array.advanced(by: Int(fftSize)))
        tfMag = UnsafeMutablePointer<Double>.allocate(capacity: Int(fftSize))
        tfMagdB = UnsafeMutablePointer<Double>.allocate(capacity: Int(fftSize))
        tfMagdBNorm = UnsafeMutablePointer<Double>.allocate(capacity: Int(fftSize))

        tfPha = UnsafeMutablePointer<Double>.allocate(capacity: Int(fftSize))
        tfPhaDeg = UnsafeMutablePointer<Double>.allocate(capacity: Int(fftSize))
        tfPhaNorm = UnsafeMutablePointer<Double>.allocate(capacity: Int(fftSize))

    }

    deinit {
        tfComplex.realp.deallocate()
        tfMag.deallocate()
        tfPha.deallocate()
    }

    func computeTransferFunction(srcDataPtr: UnsafeMutablePointer<Double>, refDataPtr: UnsafeMutablePointer<Double>){
		srcSpectrum.computeSpectrum(dataPtr: srcDataPtr)
        refSpectrum.computeSpectrum(dataPtr: refDataPtr)
        vDSP_zvdivD(&srcSpectrum.spectrum, 1, &refSpectrum.spectrum, 1, &tfComplex, 1, vDSP_Length(fftSize))
    }

    func computeMagnitudeSpectrum() {
        vDSP_zvabsD(&tfComplex, 1, tfMag, 1, vDSP_Length(fftSize))
    }


    func computeMagnitudeSpectrumIndB() {
        vDSP_vdbconD(tfMag, 1, &ref, tfMagdB, 1, vDSP_Length(fftSize), 1)
    }

    func computeMagnitudeSpectrumInNormalizeddB () {
        vDSP_vsmsaD(tfMagdB, 1, &normalMult, &normalAdd, tfMagdBNorm, 1, vDSP_Length(fftSize))
    }

    func computePhaseSpectrum() {
        vDSP_zvphasD(&tfComplex, 1, tfPha, 1, vDSP_Length(fftSize))
    }

    func computePhaseSpectrumInDeg () {
        vDSP_vsmulD(tfPha, 1, &rad2DegVal, tfPhaDeg, 1, vDSP_Length(fftSize))
    }

    func computePhaseSpectrumNormalized () {
		vDSP_vsmsaD(tfPha, 1, &normalPhaMult, &normalPhaAdd, tfPhaNorm, 1, vDSP_Length(fftSize))
    }

    func triggerUpdate( completion: () -> Void ) {
        computeMagnitudeSpectrum()
        computeMagnitudeSpectrumIndB()
        computeMagnitudeSpectrumInNormalizeddB()
        computePhaseSpectrum()
        computePhaseSpectrumNormalized()
    }

    func dumpData(magPtr: UnsafeMutableRawPointer, phaPtr: UnsafeMutableRawPointer) {
        magPtr.copyMemory(from: tfMagdBNorm, byteCount: fftSize)
        phaPtr.copyMemory(from: tfPhaNorm, byteCount: fftSize)
    }
}
