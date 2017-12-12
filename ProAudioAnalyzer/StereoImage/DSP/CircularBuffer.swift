//
//  CircularBuffer.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/11/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation


class CircularBuffer<Element> {

    var buffer: [Element]
    var readIndex: Int = 0 { didSet { if readIndex == length { readIndex = 0 } } }
    var writeIndex: Int = 0 { didSet { if writeIndex == length { writeIndex = 0 } } }
    var length = 0

    init(maxSize: Int, initValue: Element) {
        buffer = [Element](repeating: initValue, count: maxSize)
    }

    convenience init(maxSize: Int, length: Int, initValue: Element) {
        self.init(maxSize: maxSize, initValue: initValue)
        setLength(length)

    }

    func setLength(_ length: Int) {
        self.length = length
        readIndex = ((writeIndex - length) + buffer.count) % buffer.count
    }

    func tick(_ element: Element) {
        buffer[writeIndex] = element
        writeIndex += 1
        readIndex += 1
    }

    subscript(index: Int) -> Element {
        get {
            return buffer[(readIndex + index) % length]
        }
        set{
            buffer[(readIndex + index) % length] = newValue
        }
    }

    var indices: CountableRange<Int> {
        return 0..<length
    }


}
