//
//  TransferFunctionViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class TransferFunctionViewController: AnalyzerViewController {

    var analyzer: TransferFunctionAnalyzer!

    @IBOutlet weak var magSpectrumView: SpectrumView!
    @IBOutlet weak var phaSpectrumView: SpectrumView!

    override func viewDidLoad() {
        super.viewDidLoad()
        analyzer = TransferFunctionAnalyzer(controller: audioController)

        let fftSize = Int(audioController.bufferSize)
        magSpectrumView.initializeMemoryForPlot(forSize: fftSize)
        phaSpectrumView.initializeMemoryForPlot(forSize: fftSize)
        setSpectrumViewNormalBins()
        magSpectrumView.fftSize = fftSize
        phaSpectrumView.fftSize = fftSize
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyzer.run()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyzer.stop()
    }

    override func updateGUI() {
        analyzer.transferFunction.triggerUpdate {
            let magPtr = magSpectrumView.mags!
            let phaPtr = phaSpectrumView.mags!
            analyzer.transferFunction.dumpData(magPtr: magPtr, phaPtr: phaPtr)
            magSpectrumView.setNeedsDisplay()
            phaSpectrumView.setNeedsDisplay()
        }
    }

    func setSpectrumViewNormalBins() {
        var linNormBins = ( 0..<Int(audioController.bufferSize)).map{ Double($0)/(Double(audioController.bufferSize)) }
        let min = linNormBins[1]
        let max = 1.0
        let logBins = linNormBins.map{ log(($0 + min)/min) / log(max/min) }

        magSpectrumView.setNormLogBins(logBins)
        phaSpectrumView.setNormLogBins(logBins)
    }
}
