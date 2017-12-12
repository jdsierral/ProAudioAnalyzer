//
//  AudioController.swift
//  AudioTest3
//
//  Created by Juan David Sierra on 11/28/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation

class AVAudioController {

    var sampleRate: Double {
        set { configureAudioSession(sampleRate: newValue,
                                    bufSize: UInt32(session.ioBufferDuration * newValue))
        }
        get { return session.sampleRate }
    }
    var bufSize: UInt32 {
        set { configureAudioSession(sampleRate: sampleRate, bufSize: newValue) }
        get { let size = UInt32(session.ioBufferDuration * sampleRate)
            return size.isPowOf2 ? size : size.nextPowOf2
        }
    }

    var session: AVAudioSession
    var engine: AVAudioEngine!
    var input: AVAudioInputNode!
    var output: AVAudioOutputNode!
    var mixer: AVAudioMixerNode!

    init(sampleRate: Double, bufSize: UInt32) {
        session = AVAudioSession.sharedInstance()
        initializeAudioSession(sampleRate: sampleRate, bufSize: bufSize)
        engine = AVAudioEngine()
        configureAudioEngine()
        runAudioEngine()
        registerObservers()
        if DBG { printAudioConfiguration() }
    }

    deinit {
        stopAudioEngine()
        terminateAudioSession()
    }

    func runAudioEngine() {
        engine.prepare()
        do     {
            try engine.start()
        }    catch    {
            print("Couldnt load the engine: \(error)")
        }
    }

    func stopAudioEngine() {
        engine.stop()
    }

    func configureAudioEngine() {
        input = engine.inputNode
        output = engine.outputNode
        mixer = engine.mainMixerNode
        engine.connect(input, to: mixer, format: input.outputFormat(forBus: 0))
        mixer.outputVolume = 0.0
    }

    func initializeAudioSession(sampleRate: Double, bufSize: UInt32) {
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, mode: AVAudioSessionModeMeasurement, options: AVAudioSessionCategoryOptions.interruptSpokenAudioAndMixWithOthers)
            session.requestRecordPermission({ (success) in
                if success { print("Permission Granted") } else {
                    print("Permission Denied")
                }
            })
            configureAudioSession(sampleRate: sampleRate, bufSize: bufSize)
        }    catch    {
            print("Audio session not loaded properly \(error)")
        }
    }

    func configureAudioSession(sampleRate: Double, bufSize: UInt32) {
        do {
            let portDescriptions = session.availableInputs!
            for port in portDescriptions {
                if (port.channels?.count ?? 0) > 1 {
                    print(port)
                    try session.setPreferredInput(port)
                    try session.setPreferredInputNumberOfChannels(2)
                }
            }
            try session.setPreferredSampleRate(sampleRate)
            try session.setPreferredIOBufferDuration(Double(bufSize)/sampleRate)
        } catch {
            print("Audio Session Couldnt be setup: \(error)")
        }
    }

    func restartAudioSession() {
        terminateAudioSession()
        initializeAudioSession(sampleRate: sampleRate, bufSize: bufSize)
        engine = AVAudioEngine()
        configureAudioEngine()
        runAudioEngine()
    }

    func terminateAudioSession() {
		stopAudioEngine()
    }

    func printAudioConfiguration() {
        print("SampleRate is: \(sampleRate)")
        print("BufSize is: \(bufSize)")
        print("Current Route Inputs: \(session.currentRoute.inputs.map{$0.portName})")
        print("Current Route Outputs: \(session.currentRoute.outputs.map{$0.portName})")
        print("Available Inputs \(session.availableInputs!.map{ $0.portName })")
        print("Number of Inputs: \(input.numberOfInputs)")
        print("Input Formtat: \(input.inputFormat(forBus: 0))")
        print("Number of Outputs: \(output.numberOfOutputs)")
    }

    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(AudioSessionInterrupted), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AudioRouteChanged), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AudioEngineChanged), name: NSNotification.Name.AVAudioEngineConfigurationChange, object: nil)
    }

    func deregisterObservers() {
        // TODO
    }
}

extension AVAudioController {
    @objc func AudioSessionInterrupted() {
        print("Audio Session Interrupted")
        stopAudioEngine()
        terminateAudioSession()
        initializeAudioSession(sampleRate: sampleRate, bufSize: bufSize)
        configureAudioEngine()
        runAudioEngine()
    }

    @objc func AudioRouteChanged() {
        print("Audio Route Change")
        stopAudioEngine()
        terminateAudioSession()
        initializeAudioSession(sampleRate: sampleRate, bufSize: bufSize)
        configureAudioEngine()
        runAudioEngine()
    }

    @objc func AudioEngineChanged() {
        print("Audio Engine Changed")
        stopAudioEngine()
        terminateAudioSession()
        initializeAudioSession(sampleRate: sampleRate, bufSize: bufSize)
        configureAudioEngine()
        runAudioEngine()
    }
}

extension UInt32 {
    var nextPowOf2: UInt32 {
		var x = self
        if x == 0 { return x }
        x -= 1
        x |= x >> 1
        x |= x >> 2
        x |= x >> 4
        x |= x >> 8
        x |= x >> 16
		x += 1
        return x
        // Taken from bit Twiddling hacks page
    }

    var isPowOf2: Bool {
        var x = self
        x |= x-1
        return 0 == x
    }
}
