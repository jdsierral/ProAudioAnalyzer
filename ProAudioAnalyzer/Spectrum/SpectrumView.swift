//
//  SpectrumView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/3/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class SpectrumView: UIView {

    var mags: UnsafeMutablePointer<Double>?
    var normLogBins = [CGFloat]()
    var indxToPlot = [Int]()
    var fftSize: Int?
    

    func initializeMemoryForPlot(forSize size: Int) {
        mags = UnsafeMutablePointer<Double>.allocate(capacity: size)
    }

    func setNormLogBins(_ bins: [Double]) {
        normLogBins = bins.map{ CGFloat(( $0.isNaN ? 0.0 : $0 )) }
        calculateIndexesToPlot()
    }

    func calculateIndexesToPlot() {
        indxToPlot = normLogBins.indices.map{Int($0)}
        var lastIndx = 0
        for n in indxToPlot {
            if n == 0 { continue }
            let dif = normLogBins[n] - normLogBins[lastIndx]
            let mag = bounds.width * dif
            if mag < 1.0 {
                indxToPlot[n] = -1
            } else {
                lastIndx = n
            }
        }
        indxToPlot = indxToPlot.filter{$0 >= 0}
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        isOpaque = false

    }

    override func draw(_ rect: CGRect) {
        let limits = UIBezierPath(roundedRect: bounds, cornerRadius: 5)
        limits.stroke()
        drawSpectralPath(rect: rect)
    }

    func printMags() {
        for i in 0..<normLogBins.count {
            print(mags![i])
        }
    }

    func drawSpectralPath(rect: CGRect) {
        let trace = UIBezierPath()
        for n in indxToPlot {
            let mag = CGFloat(mags![n])
            if n == 0 {
                trace.move(to: CGPoint(x: rect.minX, y: rect.midY - rect.midY * mag))
            } else {
                trace.addLine(to: CGPoint(x: rect.minX + rect.maxX * normLogBins[n], y: rect.midY - rect.midY * mag))
            }
        }
        UIColor.blue.setStroke()
        trace.stroke()
    }
}
