//
//  OpenChestViewController.swift
//  FindingTreasure
//
//  Created by mac on 6/16/16.
//  Copyright © 2016 Emotiv. All rights reserved.
//

import UIKit

class OpenChestViewController: UIViewController {
    private var selectDevice : SelectHeadsetViewController?
    var mainstoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let emoEngine: EngineWidget = EngineWidget.shareInstance() as EngineWidget
    var currentPhotoID : Int?
    var displayLink : CADisplayLink?
    var arrayImage: NSMutableArray?
    var channelName:NSArray?
    var currentAct: MentalAction_t?
    var currentPow: Float?
    var currentIndex: Int?
    var isBloom: Bool?
    var isTraining: Bool?
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var neutralBtn: UIButton!
    @IBOutlet weak var chestImage: UIImageView!
    @IBOutlet weak var signalView: SignalQualityView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.startDisplayLink()
        // Do any additional setup after loading the view.
        channelName = ["f3","t7","pz","t8","f4"]
        emoEngine.delegate = self
        isTraining = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showHeadsetPicket()
    }
    
    func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector:#selector(bloomFlower(_:)))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink?.paused = true
    }
    
    func bloomFlower (displayLink : CADisplayLink) {
        let stringAppend:String = String(format: "chest%02d",currentPhotoID!)
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
    
    func showHeadsetPicket(){
        if self.selectDevice == nil{
            self.selectDevice = mainstoryboard.instantiateViewControllerWithIdentifier("SelectHeadsetViewController") as? SelectHeadsetViewController
            self.selectDevice?.removeViewAction = {
                self.selectDevice?.view.removeFromSuperview()
            }
        }
        
        self.selectDevice?.view.frame = UIScreen.mainScreen().bounds
        self.selectDevice?.showInView(true, aView: self.view)
    }
    
    func updateChest() {
        let range:Float? = currentPow
        if ((currentAct == Mental_Push) && range > 0) {
            displayLink?.paused = false
            displayLink?.frameInterval = changeFrame(range!)
        }
    }
    
    func changeFrame(range:Float) -> Int {
        var frame:Int = (Int)(1-range) * 10 + 1
        frame = (frame >= 10 ) ? 15 :frame
        return frame
    }
    
    func onCognitivInTraining() {
        
    }
    
    @IBAction func clickNeutral(sender: UIButton) {
        if !isTraining! {
            self.emoEngine.setActiveAction(Mental_Neutral)
            self.emoEngine.setTrainingAction(Mental_Neutral)
            self.emoEngine.setTrainingControl(Mental_Start)
            isTraining = true
            //Update Status here
            self.openBtn.enabled = false
        }
        
    }
    
    @IBAction func clickOpen(sender: UIButton) {
        if !isTraining! {
            self.emoEngine.setActiveAction(Mental_Push)
            self.emoEngine.setTrainingAction(Mental_Push)
            self.emoEngine.setTrainingControl(Mental_Start)
            isTraining = true
            self.neutralBtn.enabled = false
        }
    }
    
    @IBAction func clickListDevice(sender: UIButton) {
        showHeadsetPicket()
    }
    
}

extension OpenChestViewController:EngineWidgetDelegate {
    func emoStateUpdate(currentAction: MentalAction_t, power currentPower: Float) {
        currentAct = currentAction
        currentPow = currentPower
        self.updateChest()
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
    
    func getSignalChanels(valueSignalAF3: Int32, af4Channel valueSignalAF4: Int32, t7Channel valueSignalT7: Int32, t8Channel valueSignalT8: Int32, pzChannel valueSignalPz: Int32) {
        self.signalView.getSignalChanels(valueSignalAF3, af4Channel: valueSignalAF4, t7Channel: valueSignalPz, t8Channel: valueSignalT7, pzChannel: valueSignalT8)
    }

    /*signal quality*/
    func updateSignalQuality(array: [AnyObject]!) {
        
    }
//    func updateSignalQuality(array: [AnyObject]!) {
//        
//    }
    
    /*battery level*/
    func updateBatteryLevel(lv : Int32, maxValue maxLv:Int32) {
    
    }
    
    /*engine delegate*/
    func headsetConnect() {
        
    }
    
    func headsetDisconnect() {
        showHeadsetPicket()
    }
    
    func showChooseView(numberDevice: Int32) {
        
    }
}