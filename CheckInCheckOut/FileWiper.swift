//
//  FileWiper.swift
//  CheckInCheckOut
//
//  Created by Ryan on 7/1/16.
//  Copyright © 2016 SDMFoundation. All rights reserved.
//

import Foundation
import UIKit

public class FileWiper: UIButton {
    
    var devManager: DeviceManager?
    
    init(devManager: DeviceManager, width: Int) {
        self.devManager = devManager
        super.init(frame: CGRect(x: 10, y: 20, width: width - 20, height: 30))
        self.addTarget(self, action: #selector(CheckedOutView.pressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.backgroundColor = UIColor.redColor()
    }
    
    func pressed(sender: UIButton!) {
        self.backgroundColor = UIColor.greenColor()
        let alert = UIAlertController(title: "Delete Confirmation", message: "Type OK to confirm you would like to delete the date", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
            let textf1 = alert.textFields![0] as UITextField
            let name = textf1.text
            if name == "OK" {
                self.devManager?.wipeFiles()
                self.backgroundColor = UIColor.redColor()
            }
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Joe Smith 7811234567"
            textField.secureTextEntry = false
        })
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}