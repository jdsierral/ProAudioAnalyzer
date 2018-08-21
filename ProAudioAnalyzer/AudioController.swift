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

    var sampleRate: Double { return session.sampleRate }
    var bufferSize: AVAudioFrameCount { return session.bufferSizeInSamples }
    var input: AVAudioNode { return engine.inputNode }

    var session: AVAudioSession { return AVAudioSession.sharedInstance() }
    var engine:  AVAudioEngine!

    init(sampleRate: Double, bufferSize: AVAudioFrameCount) {
        initializeAudioSession()
        configureAudioSession(sampleRate, bufferSize)
        initializeAudioEngine()
        registerObservers()
        if DBG { printAudioConfiguration() }
    }

    deinit {
        stopAudioEngine()
        terminateAudioSession()
    }

    func initializeAudioSession() {
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, mode: AVAudioSessionModeMeasurement)
            session.requestRecordPermission { (success) in
                if success {
                    print("Permission Granted")
                } else {
                    print("Permission Denied")
                }
            }
        }    catch    {
            print("Audio session not loaded properly \(error)")
        }
    }

    func configureAudioSession() {
        configureAudioSession(48000, AVAudioFrameCount(512))
    }

    func configureAudioSession(_ sampleRate: Double, _ bufferSize: AVAudioFrameCount) {
        do {
            let portDescriptions = session.availableInputs!
            for port in portDescriptions {
                if (port.channels?.count ?? 0) > 1 {
                    print(port)
                    try session.setPreferredInput(port)
                    try session.setPreferredInputNumberOfChannels(2)
                }
            }
            try session.setPreferredSampleRate( sampleRate )
            try session.setPreferredIOBufferDuration( Double(bufferSize) / sampleRate )
        } catch {
            print("Couldnt configure Audio Session: \(error)")
        }
    }

    func initializeAudioEngine() {
        engine = AVAudioEngine()
        let audioFormat: AVAudioFormat = engine.inputNode.outputFormat(forBus: 0)
        engine.connect(engine.inputNode, to: engine.mainMixerNode, format: audioFormat)
        engine.mainMixerNode.outputVolume = 0.0

        DispatchQueue.global().async {
            self.engine.prepare()
            DispatchQueue.main.async {
                self.runAudioEngine()
            }
        }
    }


    func runAudioEngine() {
        do     {
            try engine.start()
        }    catch    {
            print("Couldnt load the engine: \(error)")
        }
    }

    func stopAudioEngine() {
        engine.stop()
    }

    func restartAudioSession() {
        let currentSampleRate = sampleRate;
        let currentBufferSize = bufferSize;
        terminateAudioSession()
        initializeAudioSession()
        configureAudioSession(currentSampleRate, currentBufferSize)
        initializeAudioEngine()
    }

    func terminateAudioSession() {
		stopAudioEngine()
    }

    func printAudioConfiguration() {
        print("SampleRate is: \(sampleRate)")
        print("Buffer Size is: \(bufferSize)")
        print("Current Route Inputs: \(session.currentRoute.inputs.map{$0.portName})")
        print("Current Route Outputs: \(session.currentRoute.outputs.map{$0.portName})")
        print("Available Inputs \(session.availableInputs!.map{ $0.portName })")
        print("Number of Inputs: \(engine.inputNode.numberOfInputs)")
        print("Input Formtat: \(engine.inputNode.inputFormat(forBus: 0))")
        print("Number of Outputs: \(engine.outputNode.numberOfOutputs)")
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
        initializeAudioSession()
        runAudioEngine()
    }

    @objc func AudioRouteChanged() {
        print("Audio Route Change")
        stopAudioEngine()
        terminateAudioSession()
        initializeAudioSession()
        runAudioEngine()
    }

    @objc func AudioEngineChanged() {
        print("Audio Engine Changed")
        stopAudioEngine()
        terminateAudioSession()
        initializeAudioSession()
        runAudioEngine()
    }
}

extension AVAudioController {

    func getCurrentEnginesName() -> String{
        return session.currentRoute.inputs.first?.portName ?? String()
    }
}

extension AVAudioSession  {
    var bufferSizeInSamples: AVAudioFrameCount { return AVAudioFrameCount(self.sampleRate * self.ioBufferDuration) }
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
