//
//  SpectrumViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class SpectrumViewController: UIAnalyzerViewController {

    var analyzer: SpectrumAnalyzer!

    @IBOutlet weak var lSpectrumView: SpectrumView!
    @IBOutlet weak var rSpectrumView: SpectrumView!

    override func viewDidLoad() {
        super.viewDidLoad()
        analyzer = SpectrumAnalyzer(controller: avController)

        let fftSize = Int(avController.bufSize)
        lSpectrumView.initializeMemoryForPlot(forSize: fftSize)
        rSpectrumView.initializeMemoryForPlot(forSize: fftSize)
        setSpectrumViewNormalBins()
        lSpectrumView.fftSize = fftSize
        rSpectrumView.fftSize = fftSize

    }

    override func updateGUI() {
        analyzer.lSpectrum.triggerUpdate {
            let ptr = lSpectrumView.mags!
            analyzer.lSpectrum.dumpData(ptr: ptr)
            lSpectrumView.setNeedsDisplay()
        }
        analyzer.rSpectrum.triggerUpdate {
            let ptr = rSpectrumView.mags!
            analyzer.rSpectrum.dumpData(ptr: ptr)
            rSpectrumView.setNeedsDisplay()
        }
    }

    func setSpectrumViewNormalBins() {
        var linNormBins = ( 0..<Int(analyzer.bufSize)).map{ Double($0)/(Double(analyzer.bufSize)) }
        let min = linNormBins[1]
        let max = 1.0
        let logBins = linNormBins.map{ log(($0 + min)/min) / log(max/min) }

        lSpectrumView.setNormLogBins(logBins)
        rSpectrumView.setNormLogBins(logBins)
    }


    override func segueToConfigView() {
        performSegue(withIdentifier: "SegueToSpectrumsConfig", sender: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyzer.removeTap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyzer.runPerSample()
    }
}
