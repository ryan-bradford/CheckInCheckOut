//
//  Device.swift
//  CheckInCheckOut
//
//  Created by Ryan on 6/30/16.
//  Copyright © 2016 SDMFoundation. All rights reserved.
//

import Foundation

public class Device {
    
    public var deviceName: String
    public var deviceID: String
    public var isCheckedOut: Bool
    public var timeCheckedIn: Double?
    public var timeCheckedOut: Double?
    public var personID: String?
    public var hoursCheckedIn: Array<Int>
    public var useCheckOut: Array<Int>?
    public var useCheckIn: Array<Int>?
    public var totalTimeOut: Array<Double>?

    init(name: String, id: String) {
        self.deviceName = name
        self.deviceID = id
        isCheckedOut = false
        hoursCheckedIn = Array<Int>()
        useCheckOut = Array<Int>()
        useCheckIn = Array<Int>()
        totalTimeOut = Array<Double>()
    }
    
    func setCheckedOut(personID: String, currentTime: Double, use: Int) {
        timeCheckedOut = currentTime
        self.personID = personID
        isCheckedOut = true
        self.useCheckOut?.append(use)
    }
    
    func setCheckedIn() {
        timeCheckedIn = NSDate().timeIntervalSince1970
        let calendar = NSCalendar.currentCalendar()
        let hourCheckedIn = calendar.component(NSCalendarUnit.Hour, fromDate: NSDate())
        hoursCheckedIn.append(hourCheckedIn)
        personID = nil
        isCheckedOut = false
        useCheckIn?.append((useCheckOut?.last)!)
    }
    
}