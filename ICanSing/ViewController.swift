//
//  ViewController.swift
//  ICanSing
//
//  Created by ashu sharma on 2/24/19.
//  Copyright © 2019 AshuSharma. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mergedTrackExportPath = mixTwoAudioResources()
        print("export path is \(mergedTrackExportPath)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func mixTwoAudioResources() -> String {
        var exportPath = ""
        let composition = AVMutableComposition()
        
        // Initializing first audio track
        let urlFirst = URL.init(fileURLWithPath: Bundle.main.path(forResource: "a1", ofType: "mp3")!)
        let audioAssetFirst = AVURLAsset(url: urlFirst, options: nil)
        
        
        // Initializing second audio track
        let urlSecond = URL.init(fileURLWithPath: Bundle.main.path(forResource: "a2", ofType: "mp3")!)
        let audioAssetSecond = AVURLAsset(url: urlSecond, options: nil)

        
        
        let audioTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        
        var error: Error?
        
        try? audioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAssetFirst.duration), of: audioAssetFirst.tracks(withMediaType: AVMediaTypeAudio)[0], at: kCMTimeZero)
        if error != nil {
            print("\(String(describing: error?.localizedDescription))")
        }
        
        try? audioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAssetSecond.duration), of: audioAssetSecond.tracks(withMediaType: AVMediaTypeAudio)[0], at: kCMTimeZero)
        if error != nil {
            print("\(String(describing: error?.localizedDescription))")
        }
        
        let _assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
       
        let mixedAudio: String = "mixedAudioF.m4a"
        exportPath = NSTemporaryDirectory() + (mixedAudio)
        let exportURL = URL(fileURLWithPath: exportPath)
        if FileManager.default.fileExists(atPath: exportPath) {
            try? FileManager.default.removeItem(atPath: exportPath)
        }
        
        _assetExport?.outputFileType = AVFileTypeAppleM4A
        _assetExport?.outputURL = exportURL
        _assetExport?.shouldOptimizeForNetworkUse = true
        _assetExport?.exportAsynchronously(completionHandler: {() -> Void in
            //self.hideActivityIndicator()
            print("Completed Sucessfully")
        })

        return exportPath
        
    }
}

