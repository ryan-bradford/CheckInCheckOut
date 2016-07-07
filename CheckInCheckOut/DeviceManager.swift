//
//  DeviceManager.swift
//  CheckInCheckOut
//
//  Created by Ryan on 6/30/16.
//  Copyright © 2016 SDMFoundation. All rights reserved.
//

import Foundation
import UIKit

public class DeviceManager {
    
    var uses: Array<String>
    var mapName = "devices"
    var checkedOutName = "checkedOut"
    var tempDevID = ""
    var devices: Array<Device>?
    var view: ViewController?
    var statsManager: StatisticsManager?
    
    init(view: ViewController) {
        uses = Array<String>()
        uses.append("One on One Use")
        uses.append("Trial Use")
        uses.append("Lesson Use")
        readDevicesText()
        setCheckedOut()
        self.view = view
        statsManager = StatisticsManager(devManager: self)
    }
    
    func readDevicesText() {
        devices = Array<Device>()
        let path = NSBundle.mainBundle().pathForResource(mapName, ofType: "txt")
        do {
            let text = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            initDevices(text)
        } catch _ {
            
        }
    }
    
    func initDevices(devicesText: String) {
        let devicesArr = devicesText.characters.split{$0 == "\n"}.map(String.init)
        for device in devicesArr {
            let deviceParts = device.characters.split{$0 == ","}.map(String.init)
            let toAdd = Device(name: deviceParts[1], id: deviceParts[0])
            devices?.append(toAdd)
        }
    }
    
    func setCheckedOut() {
        do {
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            let path = paths.stringByAppendingPathComponent("checkedOut.txt")
            let text = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            let checkedOutArr = text.characters.split{$0 == "\n"}.map(String.init)
            for textPiece in checkedOutArr {
                let parts = textPiece.characters.split{$0 == ","}.map(String.init)
                if(parts.count != 4) {
                    break
                }
                for device in self.devices! {
                    if device.deviceID == parts[0] {
                        if let currentUse = Int(parts[3]) {
                            device.setCheckedOut(parts[2], currentTime: Double(parts[1])!, use: currentUse)
                        }
                    }
                }
            }
        } catch _ {
            
        }
    }
    
    func writeCheckedOut() {
        var toWrite = ""
        for device in devices! {
            if(device.isCheckedOut) {
                var devData = device.deviceID + ","
                devData += String(device.timeCheckedOut!) + "," + device.personID! + ","
                devData += String(device.useCheckOut![device.useCheckOut!.count - 1])
                toWrite += devData + "\n"
            }
        }
        do {
            let filename = getDocumentsDirectory().stringByAppendingPathComponent(checkedOutName + ".txt")
            try toWrite.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch _ {
            
        }
    }
    
    func deviceScanned(id: String) {
        var device: Device?
        for trialDevice in devices! {
            if trialDevice.deviceID == id {
                device = trialDevice
            }
        }
        if  device != nil {
            if device!.isCheckedOut {
                checkInDevice(id)
                let refreshAlert = UIAlertController(title: "Check In", message: "That Device Was Checked In", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                    self.view!.paused = false
                }))
                view?.presentViewController(refreshAlert, animated: true, completion: nil)
            } else {
                view?.checkedOutView?.backgroundColor = UIColor.greenColor()
                checkOutDevice(id)
                if(id == "2016 40") {
                    idScanned("Joe Phill")
                } else {
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.becomeFirstResponder()
                    let alert = UIAlertController(title: "Person ID", message: "Please enter a form of identification", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
                        let textf1 = alert.textFields![0] as UITextField
                        let name = textf1.text
                        self.idScanned(name!)
                    }))
                    alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
                        textField.placeholder = "Joe Smith 7811234567"
                        textField.secureTextEntry = false
                    })
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func idScanned(id: String) {
        let checkOut = CheckOutOptions(x: 10, y: 50, width: Int(UIScreen.mainScreen().bounds.width) - 20, height: 100, viewController: view!, deviceManager: self, personID: id, deviceID: tempDevID)
        view!.view.addSubview(checkOut)
    }
    
    func checkOutDevice(code: String) {
        tempDevID = code
    }
    
    func checkInDevice(code: String) {
        var device: Device?
        for trialDevice in devices! {
            if trialDevice.deviceID == code {
                device = trialDevice
            }
        }
        device!.setCheckedIn();
        statsManager?.deviceCheckedIn(device!)
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func wipeFiles() {
        statsManager?.wipeFiles()
    }
}