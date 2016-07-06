//
//  CheckOutOptions.swift
//  CheckInCheckOut
//
//  Created by Ryan on 7/5/16.
//  Copyright © 2016 SDMFoundation. All rights reserved.
//

import Foundation
import UIKit

public class CheckOutOptions: UIView {
    
    var viewController: ViewController?
    var deviceManager: DeviceManager?
    var deviceID: String?
    var personID: String?
    
    init(x: Int, y: Int, width: Int, height: Int, viewController: ViewController, deviceManager: DeviceManager, personID: String, deviceID: String) {
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        self.deviceManager  = deviceManager
        self.personID = personID
        self.deviceID = deviceID
        self.viewController = viewController
        let oneOnOne = OptionButton(x: 10, y: 10, width: width / 4, height: height - 20, name: deviceManager.uses[0], toReturn: self, num: 1)
        let trialUse = OptionButton(x: 10 + width / 3, y: 10, width: width / 4, height: height - 20, name: deviceManager.uses[1], toReturn: self, num: 2)
        let lessonUse = OptionButton(x: 10 + 2 * width / 3, y: 10, width: width / 4, height: height - 20, name: deviceManager.uses[2], toReturn: self, num: 3)
        self.addSubview(oneOnOne)
        self.addSubview(trialUse)
        self.addSubview(lessonUse)
        self.backgroundColor = UIColor.blackColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func done(value: Int) {
        var toUse: Device?
        for device in deviceManager!.devices! {
            if device.deviceID == deviceID! {
                toUse = device
            }
        }
        toUse!.setCheckedOut(personID!, currentTime: NSDate().timeIntervalSince1970, use: value);
        self.viewController?.checkedOutView?.backgroundColor = UIColor.clearColor()
        self.viewController?.paused = false
        self.removeFromSuperview()
    }
    
}
