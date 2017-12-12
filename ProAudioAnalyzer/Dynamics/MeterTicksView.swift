//
//  MeterTicksView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/30/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit


class MeterTicksView: UIView {

    static var tickValues = (-10...0).map{-Double($0) * dB.limits.min / 10.0}
    static var limits: (min: Double, max: Double) { return dB.limits }
    static var range: Double { return MeterTicksView.limits.max - MeterTicksView.limits.min }
    static func fracOfLimits(from value: Double) -> Double {
        return (value - MeterTicksView.limits.min) / MeterTicksView.range
    }
    static var tickFontSize: CGFloat {
        return UIFont.smallSystemFontSize
    }
    static var tickFont: UIFont {
        return UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .footnote), size: MeterTicksView.tickFontSize)
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))

        let sizeClass = traitCollection.horizontalSizeClass

        if sizeClass == .compact {
            let tickMarkerSize: CGFloat = rect.height/10.0
            for tick in MeterTicksView.tickValues {
                let frac = CGFloat(MeterTicksView.fracOfLimits(from: tick))
                if frac > 1 { continue }
                let tickOrigin = CGPoint(x: frac * rect.width, y: rect.minY)
                path.move(to: tickOrigin)
                path.addLine(to: tickOrigin.offsetBy(dx: 0.0, dy: tickMarkerSize))
                drawTickText(value: Int(tick), rect:
                    CGRect(origin: tickOrigin.offsetBy(dx: 0.0, dy: tickMarkerSize), size: CGSize(width: 50.0, height: rect.width - tickMarkerSize)))
            }
        }	else 	{
            let tickMarkerSize: CGFloat = rect.width/10.0
            for tick in MeterTicksView.tickValues {
                let frac = CGFloat(1.0 - MeterTicksView.fracOfLimits(from: tick))
                if frac > 1 { continue }
                let tickOrigin = CGPoint(x: rect.minX, y: frac * rect.height)
                path.move(to: tickOrigin)
                path.addLine(to: tickOrigin.offsetBy(dx: tickMarkerSize, dy: 0.0))
                drawTickText(value: Int(tick), rect: CGRect(origin: tickOrigin.offsetBy(dx: tickMarkerSize, dy: 0.0), size: CGSize(width: rect.width - tickMarkerSize, height: 50.0)))
            }
        }


        UIColor.black.setStroke()
        path.stroke()

        //        if DBG {
        //            let border = UIBezierPath(rect: bounds)
        //            UIColor.red.setStroke()
        //            border.stroke()
        //        }
    }

    func drawTickText(value: Int, rect: CGRect) {
        let textFont = MeterTicksView.tickFont
        let attributes = [NSAttributedStringKey.font: textFont,
                          NSAttributedStringKey.strokeColor: UIColor.black]
        let text = NSAttributedString(string: String(value), attributes: attributes)
        text.draw(in: rect)
    }
}
