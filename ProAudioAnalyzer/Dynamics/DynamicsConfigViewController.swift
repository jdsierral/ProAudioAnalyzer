//
//  DynamicsConfigViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class DynamicsConfigViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var mod: MeterDynamicsSettings { return Meter.settings }
    var max: MeterDynamicsSettings { return DefaultSettings.defaultMaxMeterSettings }

    override func viewDidLoad() {
        super.viewDidLoad()
        peakTimeSlider.value = Float(mod.peakAttackTime / max.peakAttackTime)
        rmsTimeSlider.value = Float(mod.rmsTime / max.rmsTime)
        vuTimeSlider.value = Float(mod.vuTime / max.vuTime)
        peakHoldTimeSlider.value = Float(mod.peakHolderTime / max.peakHolderTime)
        rmsHoldTimeSlider.value = Float(mod.rmsHolderTime / max.rmsHolderTime)
        dBLowerLimitSlider.value = Float( dB.limits.min / DefaultSettings.defaultMinMaxdBLimits.min )
        pickerView.delegate = self
        pickerView.dataSource = self

        pickerView.selectRow(dB.dBType.rawValue, inComponent: 0, animated: true)
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		dB.dBType = dB.dBRef(rawValue: row)!
    }


    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var peakTimeSlider: UISlider!
    @IBOutlet weak var rmsTimeSlider: UISlider!
    @IBOutlet weak var vuTimeSlider: UISlider!
    @IBOutlet weak var peakHoldTimeSlider: UISlider!
    @IBOutlet weak var rmsHoldTimeSlider: UISlider!
    @IBOutlet weak var dBLowerLimitSlider: UISlider!

	var pickerData = ["UK PPM", "EBU PPM", "IEEE PPM", "IEEE VU", "DIN PPM", "K-20", "K-14", "K-12"]






    @IBAction func sliderMoved(_ sender: UISlider) {
        if sender == peakTimeSlider {
            Meter.settings.peakAttackTime = Double(sender.value) * max.peakAttackTime
        }

        if sender == rmsTimeSlider {
            Meter.settings.rmsTime = Double(sender.value) * max.rmsTime
        }

        if sender == vuTimeSlider {
            Meter.settings.vuTime = Double(sender.value) * max.vuTime
        }

        if sender == peakHoldTimeSlider {
            Meter.settings.peakHolderTime = Double(sender.value) * max.peakHolderTime
            Meter.settings.peakReleaseTime = Double(sender.value) * max.peakReleaseTime
        }

        if sender == rmsHoldTimeSlider {
            Meter.settings.rmsHolderTime = Double(sender.value) * max.rmsHolderTime
        }

        if sender == dBLowerLimitSlider {
            let val = Double(dBLowerLimitSlider.value) * DefaultSettings.defaultMinMaxdBLimits.min
            dB.limits = (val, dB.limits.max)
        }
    }
}
