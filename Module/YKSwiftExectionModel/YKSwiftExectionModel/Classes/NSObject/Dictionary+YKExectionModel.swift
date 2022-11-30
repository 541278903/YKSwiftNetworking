//
//  Dictionary+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by linghit on 2021/11/19.
//

import Foundation

public extension Dictionary
{
    func enumerateObjectsUsingBlock(enumerBlock:(_ key:Key,_ value:Value,_ index:Int)->Void)->Void
    {
        for (i,item) in self.enumerated() {
            enumerBlock(item.key,item.value,i)
        }
    }
    
    subscript (dicKey key:Key) -> [String:Any] {
        
        if let value = self[key] as? [String:Any] {
            return value
        }else {
            return [:]
        }
    }
    
    
    
    public func yk_dicJson() -> String {
        let stringData = try! JSONSerialization.data(withJSONObject: self, options: [])
        if let str = String(data: stringData, encoding: .utf8)
        {
            return str
        }else {
            return ""
        }
    }
}
