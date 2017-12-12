//
//  StereoViewController.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class StereoViewController: UIAnalyzerViewController {

    var analyzer: StereoImageAnalyzer!

    @IBOutlet weak var lissajousView: LissajousView!
    @IBOutlet weak var phaseMeterView: PhaseMeterView!

    override func viewDidLoad() {
        super.viewDidLoad()
        analyzer = StereoImageAnalyzer(controller: avController)
    }

    override func updateGUI() {
        let vals = analyzer.phaseMeter.getCurrentPhaseValues()
        let XY = analyzer.goniometer.getCurrentvalues()
        phaseMeterView.setValue(vals)
        lissajousView.setValue(x: CGFloat(XY.l), y: CGFloat(XY.r))
    }

    override func segueToConfigView() {
        performSegue(withIdentifier: "SegueToStereoImagesConfig", sender: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyzer.removeTap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyzer.runPerSample()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
