//
//  MeterBarView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/30/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class MeterBarView: UIView {

    private var peakValue: CGFloat	{ return CGFloat(dynamics.peakValue) }
    private var rmsValue: CGFloat   { return CGFloat(dynamics.rmsValue) }
    private var vuValue: CGFloat    { return CGFloat(dynamics.vuValue) }
    private var peakMax: CGFloat    { return CGFloat(dynamics.peakMax) }
    private var rmsMax: CGFloat     { return CGFloat(dynamics.rmsMax) }
    private var ispMax: CGFloat     { return CGFloat(dynamics.ispMax) }
    private var clip: Bool          { return dynamics.clip }

    var dynamics = SignalDynamics(name: String(),
                            peakValue: 0.0,
                            rmsValue: 0.0,
                            vuValue: 0.0,
                            peakMax: 0.0,
                            rmsMax: 0.0,
                            ispMax: 0.0,
                            clip: false) { didSet { setNeedsDisplay() } }

    func setDynamics(_ newValues: SignalDynamics) { dynamics = newValues }

    override func draw(_ rect: CGRect) {
        let meterBorder = UIBezierPath(roundedRect: rect, cornerRadius: 5)

        UIColor.black.setStroke()
        meterBorder.stroke()

        let classSize = traitCollection.horizontalSizeClass


        if classSize == .compact {
            drawHorizontalSlider(rect)
        } else {
            drawVerticalSlider(rect)
        }
    }

    func drawVerticalSlider(_ rect: CGRect) {
        let peakIndicator = UIBezierPath(rect: CGRect(x: 0, y: rect.height * (1.0 - peakValue), width: rect.width, height: 5.0))

        peakIndicator.stroke()
        UIColor.white.setFill()
        peakIndicator.fill()

        let rmsIndicator = UIBezierPath(rect: CGRect(x: 0, y: rect.height * (1.0 - rmsValue), width: rect.width, height: rect.height * rmsValue))

        rmsIndicator.stroke()

        let hue = hueForLevel(val: peakValue)
        UIColor(hue: hue, saturation: 1.0, brightness: 0.8, alpha: 1.0).setFill()
        rmsIndicator.fill()

        let vuIndicator = UIBezierPath(rect: CGRect(x: 0, y: rect.height * (1.0 - vuValue), width: rect.width, height: 5.0))

        vuIndicator.stroke()
        UIColor.white.setFill()
        vuIndicator.fill()
    }

    func drawHorizontalSlider(_ rect: CGRect) {
        let peakIndicator = UIBezierPath(rect: CGRect(x: rect.width * peakValue, y: rect.height, width: 5.0, height: rect.height))

        peakIndicator.stroke()
        UIColor.white.setFill()
        peakIndicator.fill()

        let rmsIndicator = UIBezierPath(rect: CGRect(x: 0, y: 0, width: rect.width * rmsValue, height: rect.height))

        let hue = hueForLevel(val: peakValue)
        UIColor(hue: hue, saturation: 1.0, brightness: 0.8, alpha: 1.0).setFill()
        rmsIndicator.fill()

        let vuIndicator = UIBezierPath(rect: CGRect(x: rect.width * vuValue, y: rect.height, width: 5.0, height: rect.height))

        vuIndicator.stroke()
        UIColor.white.setFill()
        vuIndicator.fill()
    }

    func hueForLevel(val: CGFloat) -> CGFloat {
        return (-exp(5.0 * (val - 1.0)) + 1.0)/2.0
    }
}
