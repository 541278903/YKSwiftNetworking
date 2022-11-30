//
//  YKRMQManagerConfig.swift
//  YKSwiftBaseTools
//
//  Created by edward on 2022/7/12.
//

import UIKit

public enum YKRMQManagerType {
    case Simplest
    case WorkQueues
    case Public
    case Routing
    case Topics
    case RPC
}

public class YKRMQManagerConfig: NSObject {
    
    public var connectType:YKRMQManagerType = .Topics
    
    public var port:String = ""
    
    public var host:String = "5672"
    
    public var user:String = "guest"
    
    public var pwd:String = "guest"
    
    public var bindingKeys:[YKRMQKey] = []
    
    public var exchangeName:String = ""
    
    public override init() {
        super.init()
    }
}
