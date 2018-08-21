//
//  StereoViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class StereoViewController: AnalyzerViewController {

    var analyzer: StereoImageAnalyzer!

    @IBOutlet weak var lissajousView: LissajousView!
    @IBOutlet weak var phaseMeterView: PhaseMeterView!

    override func viewDidLoad() {
        super.viewDidLoad()
        analyzer = StereoImageAnalyzer(controller: audioController)
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
        let vals = analyzer.phaseMeter.getCurrentPhaseValues()
        let XY = analyzer.goniometer.getCurrentvalues()
        phaseMeterView.setValue(vals)
        lissajousView.setValue(x: CGFloat(XY.l), y: CGFloat(XY.r))
    }

}
