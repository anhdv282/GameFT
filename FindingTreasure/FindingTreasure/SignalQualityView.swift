//
//  SignalQualityViewController.swift
//  edkFramework
//
//  Created by Tu on 3/11/15.
//  Copyright (c) 2015 nvtu. All rights reserved.
//

import UIKit

class SignalQualityView : UIView{
    var arraySingals: [UIView] = [UIView]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        for i in 101...105{
            arraySingals.append(self.viewWithTag(i)!)
        }
        
        for sensor in arraySingals {
            sensor.clipsToBounds = true
            sensor.layer.cornerRadius = sensor.bounds.width * 0.5
            sensor.backgroundColor = getColor(0)
        }
    }
    
    func getColor(value : Int32) -> UIColor{
        switch (value){
        case 3:
            return UIColor(hex: 0x46FB77)
        case 4:
            return UIColor(hex: 0x46FB77)
        case 1:
            return UIColor(hex: 0xFF6145)
        case 2:
            return UIColor(hex: 0xFFE645)
        default:
            return UIColor(hex: 0x979797)
        }
    }
    
    func onHeadsetRemoved(headsetID: Int32) {
        for sensor in arraySingals {
            sensor.backgroundColor = getColor(0)
        }
    }
    
    func getSignalChanels(valueSignalAF3: Int32, af4Channel valueSignalAF4: Int32, t7Channel valueSignalT7: Int32, t8Channel valueSignalT8: Int32, pzChannel valueSignalPz: Int32) {
        arraySingals[0].backgroundColor = self.getColor(valueSignalAF3)
        arraySingals[1].backgroundColor = self.getColor(valueSignalT7)
        arraySingals[2].backgroundColor = self.getColor(valueSignalPz)
        arraySingals[3].backgroundColor = self.getColor(valueSignalT8)
        arraySingals[4].backgroundColor = self.getColor(valueSignalAF4)
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
