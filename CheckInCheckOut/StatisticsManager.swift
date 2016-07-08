//
//  StatisticsManager.swift
//  CheckInCheckOut
//
//  Created by Ryan on 6/30/16.
//  Copyright © 2016 SDMFoundation. All rights reserved.
//

import Foundation

public class StatisticsManager {
    //ID,NAME,TOTAL TIME OUT, HOUR CHECKED IN
    //Date,Total,9-12 Checks,12-2 Checks,2-4 Checks,Missing Devices
    var inOutFile = "inOut.csv"
    var dailyFile = "daily.csv"
    var devManager: DeviceManager
    var inOutHeader = "ID,NAME,TOTAL TIME OUT (mins),HOUR CHECKED IN,USE"
    var dailyHeader = "Date,Total,9-12 Checks,12-2 Checks,2-4 Checks,Missing Devices,One on One Checks,Trial Use Checks,Lesson Checks,Avg Time Out (mins),Kindle Count,Mac Count,iPad Count,Chromebook Count,Windows Count,Guest Count"
    init(devManager: DeviceManager) {
        self.devManager = devManager
    }
    
    public func deviceCheckedIn(device: Device) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let path = paths.stringByAppendingPathComponent(inOutFile)
        do {
            var text = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            
            let ID = device.deviceID
            let name = device.deviceName
            let timeOut = round(1 * (NSDate().timeIntervalSince1970 - device.timeCheckedOut!) / 6) /  10
            device.totalTimeOut?.append(timeOut)
            let calendar = NSCalendar.currentCalendar()
            let hour = calendar.component(NSCalendarUnit.Hour, fromDate: NSDate())
            var toWrite = ID + "," + name + ","
            toWrite += String(timeOut) + "," + String(hour)
            toWrite += "," + devManager.uses[device.useCheckOut!.last! - 1]
            if(text != "") {
                text += "\n"
            }
            var total = text + toWrite
            
            if(total.containsString(inOutHeader)) {
                
            } else {
                wipeInOutFile()
                total = inOutHeader + "\n" + total
            }
            
            do {
                let filename = getDocumentsDirectory().stringByAppendingPathComponent(inOutFile)
                try total.writeToFile(filename, atomically: false, encoding: NSUTF8StringEncoding)
            } catch _ {
                
            }
        } catch _ {
            wipeFiles()
            deviceCheckedIn(device)
        }
    }
    
    func updateDay() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let path = paths.stringByAppendingPathComponent(dailyFile)
        do {
            let text = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            
            let calendar = NSCalendar.currentCalendar()
            let day = calendar.component(NSCalendarUnit.Day, fromDate: NSDate())
            let month = calendar.component(NSCalendarUnit.Month, fromDate: NSDate())
            let year = calendar.component(NSCalendarUnit.Year, fromDate: NSDate())
            let date = String(month) + "-" + String(day) + "-" + String(year)
            
            var totalChecks = 0
            var toSubtract = 0
            
            var nineTwelveChecks = 0
            var twelveTwoChecks = 0
            var twoFourChecks = 0
            
            var missingDevices = 0
            
            var oneOnOneChecks = 0
            var trialUseChecks = 0
            var lessonUseChecks = 0
            
            var totalTime = 0.0
            
            var macCount = 0
            var windowsCount = 0
            var kindleCount = 0
            var iPadCount = 0
            var chromebookCount = 0
            var outsideDevCount = 0
            
            for currentDevice in devManager.devices! {
                totalChecks += currentDevice.hoursCheckedIn.count
                for hour in currentDevice.hoursCheckedIn {
                    if(hour < 12) {
                        nineTwelveChecks += 1
                    } else if(hour < 14) {
                        twelveTwoChecks += 1
                    } else {
                        twoFourChecks += 1
                        
                    }
                }
                for use in currentDevice.useCheckIn! {
                    if(use == 1) {
                        oneOnOneChecks += 1
                    } else if(use == 2) {
                        trialUseChecks += 1
                    } else if(use == 3) {
                        lessonUseChecks += 1
                    }
                }
                if(currentDevice.deviceID == "2016 40") {
                    toSubtract += 1
                } else {
                    for deviceTime in currentDevice.totalTimeOut! {
                        totalTime += deviceTime
                    }
                }
                if(currentDevice.isCheckedOut) {
                    missingDevices += 1
                }
                let upperCase = currentDevice.deviceName.uppercaseString
                if(upperCase.containsString("MAC")) {
                    macCount += currentDevice.hoursCheckedIn.count
                } else if(upperCase.containsString("IPad")) {
                    iPadCount += currentDevice.hoursCheckedIn.count
                } else if(upperCase.containsString("KINDLE")) {
                    kindleCount += currentDevice.hoursCheckedIn.count
                } else if(upperCase.containsString("SURFACE") || upperCase.containsString("DELL")) {
                    windowsCount += currentDevice.hoursCheckedIn.count
                } else if(upperCase.containsString("CHROMEBOOK")) {
                    chromebookCount += currentDevice.hoursCheckedIn.count
                } else if(upperCase.containsString("GUEST")) {
                    outsideDevCount += currentDevice.hoursCheckedIn.count
                }
            }
            
            var textArr = text.characters.split{$0 == "\n"}.map(String.init)
            if(textArr.count >= 1) {
                let todaysText = textArr.last!
                let todaysTextArr = todaysText.characters.split{$0 == ","}.map(String.init)
                if(todaysTextArr[0] == date && todaysTextArr.count > 15) {
                    textArr.removeLast()
                    totalChecks += Int(todaysTextArr[1])!
                    nineTwelveChecks += Int(todaysTextArr[2])!
                    twelveTwoChecks += Int(todaysTextArr[3])!
                    twoFourChecks += Int(todaysTextArr[4])!
                    oneOnOneChecks += Int(todaysTextArr[6])!
                    trialUseChecks += Int(todaysTextArr[7])!
                    lessonUseChecks += Int(todaysTextArr[8])!
                    if(todaysTextArr[9] != "nan") {
                        totalTime += Double(todaysTextArr[9])! * (Double(todaysTextArr[1])! - Double(todaysTextArr[15])!)
                    }
                    toSubtract += Int(todaysTextArr[15])!
                    kindleCount += Int(todaysTextArr[10])!
                    macCount += Int(todaysTextArr[11])!
                    iPadCount += Int(todaysTextArr[12])!
                    chromebookCount += Int(todaysTextArr[13])!
                    windowsCount += Int(todaysTextArr[14])!
                    outsideDevCount += Int(todaysTextArr[15])!
                }
            }
            totalTime /= Double(totalChecks - toSubtract)
            var today = date + "," + String(totalChecks) + ","
            today += String(nineTwelveChecks) + "," + String(twelveTwoChecks) + ","
            today += String(twoFourChecks) + "," + String(missingDevices)
            today += "," + String(oneOnOneChecks) + "," + String(trialUseChecks)
            today += "," + String(lessonUseChecks) + "," + String(totalTime)
            today += "," + String(kindleCount)
            today += "," + String(macCount)
            today += "," + String(iPadCount)
            today += "," + String(chromebookCount)
            today += "," + String(windowsCount)
            today += "," + String(outsideDevCount)
            var toWrite = ""
            for part in textArr {
                toWrite += part + "\n"
            }
            toWrite += today
            
            if(toWrite.containsString(dailyHeader)) {
                
            } else {
                wipeDailyFile()
                toWrite = dailyHeader + "\n" + toWrite
            }
            do {
                let filename = getDocumentsDirectory().stringByAppendingPathComponent(dailyFile)
                try toWrite.writeToFile(filename, atomically: false, encoding: NSUTF8StringEncoding)
            } catch _ {
            }
        } catch _ {
            wipeFiles()
            updateDay()
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func wipeDailyFile() {
        let total = ""
        do {
            let filename = getDocumentsDirectory().stringByAppendingPathComponent(dailyFile)
            try total.writeToFile(filename, atomically: false, encoding: NSUTF8StringEncoding)
        } catch _ {
        }
    }
    
    func wipeInOutFile() {
        let total = ""
        do {
            let filename = getDocumentsDirectory().stringByAppendingPathComponent(inOutFile)
            try total.writeToFile(filename, atomically: false, encoding: NSUTF8StringEncoding)
        } catch _ {
            
        }
    }
    
    func wipeFiles() {
        wipeDailyFile()
        wipeInOutFile()
    }
    
}