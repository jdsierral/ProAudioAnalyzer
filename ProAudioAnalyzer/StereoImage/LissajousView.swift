//
//  LissajousView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/5/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class LissajousView: UIView {

    enum Mode {
        case point
        case trace
    }

    static var maxTraceLength = 100
	static var traceLength = 50
    var xVal: CGFloat = 0.0
    var yVal: CGFloat = 0.0
    var gain: CGFloat = 10.0
    var isRotated45Degrees = true
    var mode: Mode = .trace

    var xTrace = CircularBuffer(maxSize: LissajousView.maxTraceLength,
                                length: LissajousView.traceLength,
                                initValue: CGFloat(0.0))
    var yTrace = CircularBuffer(maxSize: LissajousView.maxTraceLength,
                                length: LissajousView.traceLength,
                                initValue: CGFloat(0.0))

    func setValue (x: CGFloat, y: CGFloat){
        if x.isNaN || y.isNaN { return }
        if isRotated45Degrees {
            xVal = (x - y) * gain
            yVal = (x + y) * gain
        } else {
            xVal = x * gain
            yVal = -y * gain
        }
        if mode == .trace {
			xTrace.tick(xVal)
            yTrace.tick(yVal)
        }
        setNeedsDisplay()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        isOpaque = false
    }

    override func draw(_ rect: CGRect) {
		let border = UIBezierPath(rect: rect)
        UIColor.black.setStroke()
        border.stroke()
        let axis = UIBezierPath()
        axis.move(to: CGPoint(x: rect.minX, y: rect.midY))
        axis.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        axis.move(to: CGPoint(x: rect.midY, y: rect.minY))
        axis.addLine(to: CGPoint(x: rect.midY, y: rect.maxY))
        axis.stroke()

        if mode == .point {
            drawPoint(rect)
        }	else	{
            drawTrace(rect)
        }



    }

    func drawPoint(_ rect: CGRect) {
        let xPos = rect.midX + xVal * rect.width/2.0
        let yPos = rect.midY + yVal * rect.width/2.0

        let value = UIBezierPath(arcCenter: CGPoint(x: xPos, y: yPos), radius: 5.0, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: true)

        value.stroke()
    }

    func drawTrace(_ rect: CGRect) {
        let trace = UIBezierPath()
        trace.lineCapStyle = .round
        trace.lineJoinStyle = .round
        trace.lineWidth = 2.0
        for n in xTrace.indices {
            let xPos = rect.midX + xTrace[n] * rect.width/2.0
            let yPos = rect.midY + yTrace[n] * rect.width/2.0
            if n == 0 {
                trace.move(to: CGPoint(x: xPos, y: yPos))
            } else {
                trace.addLine(to: CGPoint(x: xPos, y: yPos))
            }
        }

        trace.stroke()
    }

}
