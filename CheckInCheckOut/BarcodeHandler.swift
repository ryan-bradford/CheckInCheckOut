//
//  BarcodeHandeler.swift
//  CheckInCheckOut
//
//  Created by Ryan on 6/30/16.
//  Copyright © 2016 SDMFoundation. All rights reserved.
//

import Foundation

public class BarcodeHandler {
 
    var lastBarcode: String?
    var deviceManager: DeviceManager
    
    init(deviceManager: DeviceManager) {
        self.deviceManager = deviceManager
    }
    
    public func handleBarcode(currentBarcode: String) {
        deviceManager.deviceScanned(currentBarcode)
        lastBarcode = currentBarcode
    }
    
}