//
//  MenuViewController.swift
//  FindingTreasure
//
//  Created by mac on 6/15/16.
//  Copyright © 2016 Emotiv. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,EngineWidgetDelegate {
    private var selectDevice : SelectHeadsetViewController?
    var mainstoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showHeadsetPicket()
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

    @IBAction func clickListDevices(sender: AnyObject) {
        showHeadsetPicket()
    }
    
    func headsetConnect() {
        
    }
    
    func headsetDisconnect() {
        showHeadsetPicket()
    }
}

