//
//  DynamicsViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class DynamicsViewController: UIAnalyzerViewController {

    var analyzer: DynamicsAnalyzer!

    @IBOutlet weak var lMeterView: MeterView!
    @IBOutlet weak var rMeterView: MeterView!
    @IBOutlet weak var mMeterView: MeterView!
    @IBOutlet weak var sMeterView: MeterView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var resetButton: UIButton!



    override func viewDidLoad() {
        super.viewDidLoad()
        analyzer = DynamicsAnalyzer(controller: avController)
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
        analyzer.runPerSample()
    }

    override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        analyzer.removeTap()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }


    @IBAction func resetButtonPressed(_ sender: UIButton) {
        analyzer.initialize()
    }

    override func updateGUI() {
        lMeterView.setDynamics(values: analyzer.lMeter.getCurrentNormalizedValues())
        rMeterView.setDynamics(values: analyzer.rMeter.getCurrentNormalizedValues())
        mMeterView.setDynamics(values: analyzer.mMeter.getCurrentNormalizedValues())
        sMeterView.setDynamics(values: analyzer.sMeter.getCurrentNormalizedValues())

        label1.text = String(format: "Pk: %.1f dB", dB.mag2dB(mag: analyzer.mMeter.peak.holder.value ))
        label2.text = String(format: "Pk: %.1f dB", dB.mag2dB(mag: analyzer.mMeter.peak.value ))
        label3.text = String(format: "RMS: %.1f dB", dB.mag2dB(mag: analyzer.mMeter.vu.value ))
    }

    override func segueToConfigView() {
        performSegue(withIdentifier: "SegueToDynamicsConfig", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
