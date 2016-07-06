//
//  OptionButton.swift
//  CheckInCheckOut
//
//  Created by Ryan on 7/5/16.
//  Copyright © 2016 SDMFoundation. All rights reserved.
//

import Foundation
import UIKit

public class OptionButton: UIButton {
    
    var toReturn: CheckOutOptions?
    var name: String?
    var num: Int?
    var displayName: UILabel?
    
    public init(x: Int, y: Int, width: Int, height: Int, name: String, toReturn: CheckOutOptions, num: Int) {
        self.num = num
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        self.toReturn = toReturn
        self.name  = name
        self.addTarget(self, action: #selector(CheckedOutView.pressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.backgroundColor = UIColor.whiteColor()
        displayName = UILabel(frame: CGRectMake(10, 0, self.frame.width, self.frame.height))
        displayName!.text = name
        displayName?.font = UIFont(name: "Times New Roman", size: 30)
        self.addSubview(displayName!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
       // toDraw.size
    }
    
    func pressed(sender: UIButton!) {
        toReturn!.done(num!)
    }
    
}