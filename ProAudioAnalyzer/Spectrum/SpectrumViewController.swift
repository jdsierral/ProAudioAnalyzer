//
//  SpectrumViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class SpectrumViewController: AnalyzerViewController {


    var analyzer: SpectrumAnalyzer!

    @IBOutlet weak var lSpectrumView: SpectrumView!
    @IBOutlet weak var rSpectrumView: SpectrumView!

    override func viewDidLoad() {
        super.viewDidLoad()
        analyzer = SpectrumAnalyzer(controller: audioController)

        let fftSize = Int(audioController.bufferSize)
        lSpectrumView.initializeMemoryForPlot(forSize: fftSize)
        rSpectrumView.initializeMemoryForPlot(forSize: fftSize)
        setSpectrumViewNormalBins()
        lSpectrumView.fftSize = fftSize
        rSpectrumView.fftSize = fftSize
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyzer.run()
        runGUITimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyzer.stop()
        stopGUITimer()
    }

    override func updateGUI() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.analyzer.lSpectrum.triggerUpdate {
                let ptr = self.lSpectrumView.mags!
                DispatchQueue.main.async {
                    self.analyzer.lSpectrum.dumpData(ptr: ptr)
                    self.lSpectrumView.setNeedsDisplay()
                }
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            self.analyzer.rSpectrum.triggerUpdate {
                let ptr = self.rSpectrumView.mags!
                DispatchQueue.main.async {
                    self.analyzer.rSpectrum.dumpData(ptr: ptr)
                    self.rSpectrumView.setNeedsDisplay()
                }
            }
        }
    }

    func setSpectrumViewNormalBins() {
        var linNormBins = ( 0..<Int(analyzer.bufferSize)).map{ Double($0)/(Double(analyzer.bufferSize)) }
        let min = linNormBins[1]
        let max = 1.0
        let logBins = linNormBins.map{ log(($0 + min)/min) / log(max/min) }

        lSpectrumView.setNormLogBins(logBins)
        rSpectrumView.setNormLogBins(logBins)
    }
}
