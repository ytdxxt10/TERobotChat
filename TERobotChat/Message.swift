//
//  Message.swift
//  TERobotChat
//
//  Created by offcn on 15/9/7.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

import UIKit
import Foundation
class Message {
    
    let incoming: Bool
    let text: String
    let sentDate: NSDate
    var url = ""
    init(incoming:Bool,text:String,sentDate:NSDate) {
        self.incoming = incoming
        self.text = text
        self.sentDate = sentDate
        
        
    }

}
