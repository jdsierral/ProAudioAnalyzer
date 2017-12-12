//
//  ConfigViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    var avController: AVAudioController { return (UIApplication.shared.delegate as! AppDelegate).audioController }

    @IBOutlet weak var engineLabel: UILabel!
    @IBOutlet weak var sampleRateLabel: UILabel!
    @IBOutlet weak var bufSizeLabel: UILabel!

    @IBOutlet weak var left1Button: UIButton!
    @IBOutlet weak var right1Button: UIButton!
    @IBOutlet weak var left2Button: UIButton!
    @IBOutlet weak var right2Button: UIButton!
    @IBOutlet weak var left3Button: UIButton!
    @IBOutlet weak var right3Button: UIButton!


    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender == left1Button {
			avController.selectNextAudioEngine()
        }
        if sender == right1Button {
			avController.selectPreviousAudioEngine()
        }
        if sender == left2Button {
			avController.selectNextSampleRate()
        }
        if sender == right2Button {
			avController.selectPreviousSampleRate()
        }
        if sender == left3Button {
			avController.selectNextBufferSize()
        }
        if sender == right3Button {
			avController.selectPreviousBufferSize()
        }
        updateLabels()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		updateLabels()
    }

    func updateLabels() {
        engineLabel.text = avController.getCurrentEnginesName()
        sampleRateLabel.text = String(avController.sampleRate)
        bufSizeLabel.text = String(avController.bufSize)
    }
}
