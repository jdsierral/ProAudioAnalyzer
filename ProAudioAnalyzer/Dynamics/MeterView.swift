//
//  MeterView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/30/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

@IBDesignable
class MeterView: UIView {
    func setDynamics(values: SignalDynamics) {
        bar.setDynamics(values)
        if label.text == String() {
            configureLabel()
        }
    }

    var bar		= MeterBarView()
    var ticks   = MeterTicksView()
    var label   = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        isOpaque = false
        bar.backgroundColor = UIColor.clear
        ticks.backgroundColor = UIColor.clear
        bar.isOpaque = false
        ticks.isOpaque = false

        configureLabel()

        addSubview(bar)
        addSubview(ticks)

    }

    func configureLabel() {
        label.text = bar.dynamics.name
        label.sizeToFit()
        addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let sizeClass = traitCollection.horizontalSizeClass

        if sizeClass == .regular {
            let meterFrame = bounds.topFrac(by: 0.9)
            bar.frame = meterFrame.leftFrac(by: 0.7).zoom(by: 0.9)
            ticks.frame = meterFrame.rightFrac(by: 0.3).zoom(by: 0.9)
            label.frame.origin = CGPoint(x: meterFrame.midX - label.frame.width/2.0, y: meterFrame.maxY)
        } else if sizeClass == .compact {
			let meterFrame = bounds.leftFrac(by: 0.9)
            bar.frame = meterFrame.topFrac(by: 0.7).zoom(by: 0.9)
            ticks.frame = meterFrame.bottomFrac(by: 0.3).zoom(by: 0.9)
            label.frame.origin = CGPoint(x: meterFrame.maxX, y: meterFrame.midY - label.frame.height/2.0)
        }
        ticks.setNeedsDisplay()
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }

    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }

    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }

    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }

    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth)/2, dy: (height - newHeight)/2)
    }

    func zoom(byX xScale: CGFloat, byY yScale: CGFloat) -> CGRect {
        let newWidth = width * xScale
        let newHeight = height * yScale
        return insetBy(dx: (width - newWidth)/2, dy: (height - newHeight)/2)
    }

    func leftFrac(by frac: CGFloat) -> CGRect {
		let newWidth = width * frac
        return CGRect(origin: origin, size: CGSize(width: newWidth, height: height))
    }

    func topFrac(by frac: CGFloat) -> CGRect {
        let newHeight = height * frac
        return CGRect(origin: origin, size: CGSize(width: width, height: newHeight))
    }

    func rightFrac(by frac: CGFloat) -> CGRect {
        let newWidth = width * frac
        let newOrigin = origin.offsetBy(dx: width * (1.0 - frac), dy: 0.0)
        return CGRect(origin: newOrigin, size: CGSize(width: newWidth, height: height))
    }

    func bottomFrac(by frac: CGFloat) -> CGRect {
		let newHeight = height * frac
        let newOrigin = origin.offsetBy(dx: 0.0, dy: height * (1.0 - frac))
        return CGRect(origin: newOrigin, size: CGSize(width: width, height: newHeight))
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

