//
//  SelectHeadsetViewController.swift
//  FindingTreasure
//
//  Created by mac on 6/15/16.
//  Copyright © 2016 Emotiv. All rights reserved.
//

import UIKit
class SelectHeadsetViewController: UIViewController {

    private var listDevice : [HeadsetDevice]! = [HeadsetDevice]()
    private var device : HeadsetDevice?
    var removeViewAction : (() -> (Void))?
    @IBOutlet weak var popOverView: UIView!
    
    @IBOutlet weak var tableViewDevices: UITableView!
    
    let emoEngine: EngineWidget = EngineWidget.shareInstance() as EngineWidget
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popOverView.layer.cornerRadius = 5
        self.popOverView.layer.shadowOpacity = 0.8
        self.popOverView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        tableViewDevices.dataSource = self
        tableViewDevices.delegate = self
        emoEngine.listDeviceDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override  func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func notificationReceived(notification : NSNotification)
    {
        if(notification.name == "userAddedNotification"){
            self.removeAnimate()
        }else if(notification.name == "userRemovedNotification"){
            let alert = UIAlertController(title: nil, message: "The headset is disconnected", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showInView(animated: Bool, aView: UIView)
    {
        let currentWindow = UIApplication.sharedApplication().keyWindow;
        currentWindow?.addSubview(self.view)
        currentWindow?.bringSubviewToFront(self.view)
        if (animated){
            self.showAnimate();
        }
    }
    
    func removeAnimate()
    {
        NSLog("remove animate")
        NSNotificationCenter.defaultCenter().removeObserver(self)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.popOverView.transform = CGAffineTransformMakeScale(0.05, 0.05);
            self.popOverView.alpha = 0.0;
        }) { (isFinish) -> Void in
            if isFinish{
                if(self.removeViewAction != nil){
                    self.removeViewAction!()
                }
            }
        }
    }
    
    func showAnimate()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.notificationReceived(_:)), name: "userAddedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.notificationReceived(_:)), name: "userRemovedNotification", object: nil)
        self.popOverView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        self.popOverView.alpha = 0.0
        UIView.animateWithDuration(0.5) { () -> Void in
            self.popOverView.alpha = 1.0;
            self.popOverView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    }
}

extension SelectHeadsetViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(listDevice.count > 0){
            device = listDevice[indexPath.row]
        }
        
        if(device!.type == 0){
            if(emoEngine.connnectDevice(Int32(indexPath.row), type: 0)){
                self.removeAnimate()
            }
        }else if(device!.type == 1){
            if(emoEngine.connnectDevice(Int32(indexPath.row), type: 1)){
                self.removeAnimate()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDevice.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SelectDeviceCell") else{
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "SelectDeviceCell")
            
            let item = listDevice[indexPath.row]
            
            cell.textLabel?.text = item.name
            cell.textLabel?.textAlignment = .Center
            
            return cell
        }
        
        let item = listDevice[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.textLabel?.textAlignment = .Center
        
        return cell
    }
}

extension SelectHeadsetViewController : EngineWidgetDelegate
{
    func reloadListDevice(array: [AnyObject]!) {
        if let list = array as? [HeadsetDevice]{
            listDevice = list
            self.tableViewDevices.reloadData()
        }
    }
}