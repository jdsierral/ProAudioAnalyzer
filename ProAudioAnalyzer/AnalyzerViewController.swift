//
//  AnalyzerViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 8/21/18.
//  Copyright © 2018 JuanSaudio. All rights reserved.
//

import Foundation
import UIKit


class AnalyzerViewController: UIViewController {

    var audioController: AVAudioController { return (UIApplication.shared.delegate as! AppDelegate).audioController }
//    var analyzer: AudioAnalyzer!
    var timer = Timer()
    let timerInterval = 0.02

    func runGUITimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { (timer) in
            self.updateGUI()
        })
    }

    func stopGUITimer() {
        timer.invalidate()
    }

    func updateGUI() {
        assertionFailure("Must override this function")
    }


}
