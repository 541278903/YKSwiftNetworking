//
//  YKRMQKey.swift
//  YKSwiftBaseTools
//
//  Created by linghit on 2022/7/12.
//

import UIKit

public class YKRMQKey: NSObject {
    
    private var keys:[String] = []
    
    private override init() {
        super.init()
    }
    
    
}

public extension YKRMQKey {
    
    @discardableResult
    func addKey(_ key:String) -> YKRMQKey {
        self.keys.append(key)
        return self
    }
    
    @discardableResult
    func addKeys(_ keys:[String]) -> YKRMQKey {
        self.keys.append(contentsOf: keys)
        return self
    }
    
    @discardableResult
    func join(_ mqKey:YKRMQKey) -> YKRMQKey {
        self.keys.append(contentsOf: mqKey.keys)
        return self
    }
    
    func removeLastKey() -> Void {
        let _ = self.keys.removeLast()
    }
    
    func toString() -> String {
        return self.keys.joined(separator: ".")
    }
    
    static func createKey(_ keys:[String] = []) -> YKRMQKey {
        let mqKey = YKRMQKey()
        mqKey.keys = keys
        return mqKey
    }
    
    func currentKeys() -> [String] {
        return self.keys
    }
}
