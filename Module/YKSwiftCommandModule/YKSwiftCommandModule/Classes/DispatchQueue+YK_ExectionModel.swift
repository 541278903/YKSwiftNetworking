//
//  DispatchQueue+YK_ExectionModel.swift
//  YK_Swift_CommandModule
//
//  Created by edward on 2021/5/20.
//

import Foundation


public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
    
    class func once(classes:AnyClass, block:()->Void){
        self.once(token: "com.swift.yk.\(NSStringFromClass(classes))", block: block)
    }
}
