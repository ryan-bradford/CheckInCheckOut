//
//  CheckedOutView.swift
//  CheckInCheckOut
//
//  Created by Ryan on 6/30/16.
//  Copyright © 2016 SDMFoundation. All rights reserved.
//

import Foundation
import UIKit
public class CheckedOutView: UIButton {
    
    var checkedOutTexts = Array<UILabel>()
    var manager: DeviceManager?
    var height = 50
    var viewController: ViewController?
    var switchScreens: UILabel?
    var width: Int?
    
    init(x: Int, y: Int, width: Int, height: Int, manager: DeviceManager, viewController: ViewController) {
        self.manager = manager
        self.width = width
        self.viewController = viewController
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        self.addTarget(self, action: #selector(CheckedOutView.pressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.backgroundColor = UIColor.clearColor()
        switchScreens = UILabel(frame: CGRect(x: 10, y: height - 50, width: width, height: 50))
        switchScreens!.text = "Press to View Checked Out Devices"
        switchScreens?.font = UIFont(name: "Times New Roman", size: 25)
        self.addSubview(switchScreens!)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func drawRect(rect: CGRect) {
        
        redrawButtons()
        
    }
    
    func redrawButtons() {
        for checkOut in checkedOutTexts {
            checkOut.removeFromSuperview()
        }
        checkedOutTexts.removeAll()
        for device in (manager?.devices!)! {
            if device.isCheckedOut {
                addText(device)
            }
        }
    }
    
    func addText(device: Device) {
        let toAdd = UILabel(frame: CGRect(x: 10, y: height * (checkedOutTexts.count + 1), width: Int(self.frame.width), height: height))
        var hours = (NSDate().timeIntervalSince1970 - device.timeCheckedOut!) / 3600
        switchScreens?.font = UIFont(name: "Times New Roman", size: 25)
        let remainder = hours % 1
        hours -= remainder
        let mins = round(remainder * 60)
        var text = device.personID! + " has checked out "
        text += device.deviceName + " (" + device.deviceID + ") for "
        text += String(hours) + " hours and " + String(mins) + " minutes"
        toAdd.text = text
        self.addSubview(toAdd)
        checkedOutTexts.append(toAdd)
    }
    
    func pressed(sender: UIButton!) {
        switchScreens!.frame = CGRect(x: 10, y: 20, width: width!, height: 30)
        self.redrawButtons()
        viewController?.paused  = !(viewController?.paused)!
        var y1 = 0
        var y2 = Int(self.frame.height)
        switchScreens!.text = "Press to View the Scanner"
        if(viewController?.paused == false) {
            switchScreens!.text = "Press to View Checked Out Devices"
            y2 = 0
            y1 = Int(self.frame.height - 50)
        }
        UIView.animateWithDuration(1.0, animations: {
            self.viewController!.holdingView?.frame = CGRectMake(0, CGFloat(y2), self.frame.width, self.frame.height - 50)
            self.frame = CGRectMake(0, CGFloat(y1), self.frame.width, self.frame.height)
        })
    }
    
}