//
//  OpenChestViewController.swift
//  FindingTreasure
//
//  Created by mac on 6/16/16.
//  Copyright © 2016 Emotiv. All rights reserved.
//

import UIKit

class OpenChestViewController: UIViewController {

    var currentPhotoID : Int?
    var displayLink : CADisplayLink?
    var arrayImage: NSMutableArray?
    var currentAct: MentalAction_t?
    var currentPow: Float?
    var currentIndex: Int?
    var isBloom: Bool?
    @IBOutlet weak var chestImage: UIImageView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startDisplayLink()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector:#selector(bloomFlower(_:)))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink?.paused = true
    }
    
    func bloomFlower (displayLink : CADisplayLink) {
        var stringAppend:String = String(format: "chest%02d",currentPhotoID!)
        if currentPow > 0 {
            if ++currentPhotoID! >= 22 {
                currentPhotoID = 22
            } else {
                if --currentPhotoID! <= 1 {
                    currentPhotoID = 1
                }
            }
        }
        let fileString =  (NSBundle.mainBundle().pathForResource(stringAppend, ofType: "jpg"))!
        chestImage.image = UIImage(contentsOfFile: fileString)
    }
    
    func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @IBAction func clickNeutral(sender: UIButton) {
    }
    
    @IBAction func clickOpen(sender: UIButton) {
    }
    
}

extension OpenChestViewController:EngineWidgetDelegate {
    func emoStateUpdate(currentAction: MentalAction_t, power currentPower: Float) {
        
    }
    func onMentalCommandTrainingStarted() {
        
    }
    func onMentalCommandTrainingSuccessed() {
        
    }
    func onMentalCommandTrainingFailed() {
        
    }
    func onMentalCommandTrainingCompleted() {
    
    }
    func onMentalCommandTrainingRejected() {
        
    }
    func onMentalCommandTrainingDataErased() {
        
    }
    func onMentalCommandTrainingDataReset() {
        
    }
    func onMentalCommandTrainingSignatureUpdated() {
        
    }
    
    /*signal quality*/
    func updateSignalQuality (valueSignalAF3: Int32, af4Channel valueSignalAF4: Int32, t7Channel valueSignalT7: Int32, t8Channel valueSignalT8: Int32, pzChannel valueSignalPz: Int32) {
    
    }
    
    func updateSignalQuality(array: [AnyObject]!) {
        
    }
    /*battery level*/
    func updateBatteryLevel(lv : Int32, maxValue maxLv:Int32) {
    
    }
    
    /*engine delegate*/
    func headsetConnect() {
        
    }
    
    func headsetDisconnect() {
        
    }
    
    func showChooseView(numberDevice: Int32) {
        
    }
}