//
//  TransferFunctionAnalyzer.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/11/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import Accelerate

class TransferFunctionAnalyzer: AudioAnalyzer {

    private var srcBuf: UnsafeMutablePointer<Double>!
    private var refBuf: UnsafeMutablePointer<Double>!
    var transferFunction: TransferFunction!


    private var writePos = 0 {
        didSet {
            if writePos == bufferSize {
                transferFunction.computeTransferFunction(srcDataPtr: srcBuf, refDataPtr: refBuf)
                writePos = 0
            }
        }
    }

    override func initialize() {

		transferFunction = TransferFunction(fftSize: bufferSize, sampleRate: sampleRate)

        srcBuf = UnsafeMutablePointer<Double>.allocate(capacity: Int(bufferSize))
        refBuf = UnsafeMutablePointer<Double>.allocate(capacity: Int(bufferSize))
    }

    deinit {
        srcBuf.deallocate()
        refBuf.deallocate()
    }

    override func process(leftInput: Double, rightInput: Double) {
        srcBuf[writePos] = Double(leftInput)
        refBuf[writePos] = Double(rightInput)
        writePos += 1
    }
}
