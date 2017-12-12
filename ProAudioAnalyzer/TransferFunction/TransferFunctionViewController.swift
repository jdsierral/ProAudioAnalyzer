//
//  TransferFunctionViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class TransferFunctionViewController: UIAnalyzerViewController {


    var analyzer: TranferFunctionAnalyzer!


    @IBOutlet weak var magSpectrumView: UIView!
    @IBOutlet weak var phaSpectrumView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        analyzer = TransferFunctionAnalyzer(controler: avController)
//
//        let fftSize = Int(avController.bufSize)
//        magSpectrumView.initializeMemoryForPlot(forSize: fftSize)
//        magSpectrumView.initializeMemoryForPlot(forSize: fftSize)
//        setSpectrumViewNormalBins()
//        magSpectrumView.fftSize = fftSize
//        phaSpectrumView.fftSize = fftSize
    }

    override func updateGUI() {

    }

//    func setSpectrumViewNormalBins() {
//        var linNormBins = ( 0..<Int(analyzer.bufSize)).map{ Double($0)/(Double(analyzer.bufSize)) }
//        let min = linNormBins[1]
//        let max = 1.0
//        let logBins = linNormBins.map{ log(($0 + min)/min) / log(max/min) }
//
//        lSpectrumView.setNormLogBins(logBins)
//        rSpectrumView.setNormLogBins(logBins)
//    }

    override func segueToConfigView() {
        performSegue(withIdentifier: "SegueToTransferFunctionsConfig", sender: nil) // AudioAnalyzerSettings
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyzer.removeTap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
