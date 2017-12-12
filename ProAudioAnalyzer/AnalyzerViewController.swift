//
//  AnalyzerController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import UIKit


class UIAnalyzerViewController: UIViewController {
    var avController: AVAudioController { return (UIApplication.shared.delegate as! AppDelegate).audioController }
	var timer = Timer()
    var timerInterval: Double = 0.02

    @IBAction func EditButtonWasPressed(_ sender: UIBarButtonItem) {
        segueToConfigView()
    }

    func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { (timer) in
            self.updateGUI()
        })
        if DBG { print("Timer Started") }
    }

    func stopTimer() {
        if DBG { print("Timer Stopped") }
        timer.invalidate()
    }

    func updateGUI() {
        assertionFailure("Must Override")
    }

    func segueToConfigView() {
        assertionFailure("Must Override")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
}
