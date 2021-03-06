//
//  AppDelegate.swift
//  ProAudioAnalyzer
//
//  Created by Juan David Sierra on 12/10/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit
import AVFoundation

let DBG = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let sampleRate = 44100.0
    private let bufferSize: UInt32 = 512
    var audioController: AVAudioController!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let session = AVAudioSession.sharedInstance()
        
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
        
        let portDescriptions = session.availableInputs!
        let modes = session.availableModes
        let categories = session.availableCategories
        
        let inputSources = session.inputDataSources!
        let outputSources = session.outputDataSources!
        
        print("//====================================//")
        print("//====================================//")
        print("//====================================//")
        print("Port Descriptions \(portDescriptions)")
        print("//====================================//")
        print("Modes \(modes)")
        print("//====================================//")
        print("Categories \(categories)")
        print("//====================================//")
        print("Input Sources \(inputSources)")
        print("//====================================//")
        print("Output Sources \(outputSources)")
        print("//====================================//")
        print("//====================================//")
        print("//====================================//")

        audioController = AVAudioController(sampleRate: sampleRate, bufferSize: bufferSize)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        audioController.terminateAudioSession()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        audioController.terminateAudioSession()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        audioController.restartAudioSession()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        audioController.restartAudioSession()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        audioController.terminateAudioSession()
    }


}

