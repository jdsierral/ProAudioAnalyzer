//
//  DynamicsViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class DynamicsViewController: AnalyzerViewController {

    var analyzer: DynamicsAnalyzer!

    @IBOutlet weak var lMeterView: MeterView!
    @IBOutlet weak var rMeterView: MeterView!
    @IBOutlet weak var mMeterView: MeterView!
    @IBOutlet weak var sMeterView: MeterView!

    override func viewDidLoad() {
        super.viewDidLoad()
        analyzer = DynamicsAnalyzer(controller: audioController)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyzer.initialize()
        lMeterView.configureLabel()
        lMeterView.ticks.setNeedsDisplay()
        rMeterView.ticks.setNeedsDisplay()
        mMeterView.ticks.setNeedsDisplay()
        sMeterView.ticks.setNeedsDisplay()
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
        lMeterView.setDynamics(values: analyzer.lMeter.getCurrentNormalizedValues())
        rMeterView.setDynamics(values: analyzer.rMeter.getCurrentNormalizedValues())
        mMeterView.setDynamics(values: analyzer.mMeter.getCurrentNormalizedValues())
        sMeterView.setDynamics(values: analyzer.sMeter.getCurrentNormalizedValues())
    }
}

protocol PeriodicallyUpdatable {
    func updateGUI()
}
