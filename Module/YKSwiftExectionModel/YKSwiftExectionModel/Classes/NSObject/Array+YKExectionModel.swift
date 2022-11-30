//
//  Array+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by linghit on 2021/11/19.
//

import Foundation


extension Array {
    public func enumerateObjectsUsingBlock(enumerBlock:(_ obj:Element,_ index:Int)->Void) -> Void {
        for (i,item) in self.enumerated() {
            enumerBlock(item,i)
        }
    }
    
    public func safeGetObject(index:Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    
    public subscript (safe index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    
    public subscript (arrayKey index:Int) -> [Any] {
        if let value = self[index] as? [Any] {
            return value
        }else {
            return []
        }
    }
    
    public func map(arrayMap:((_ obj:Element) -> Element)) -> [Element] {
        
        var a:[Element] = []
        
        self.enumerateObjectsUsingBlock { obj, index in
            a.append(arrayMap(obj))
        }
        
        return a
    }
    
    public func filter(arrayFilter:((_ obj:Element, _ idx:Int) -> Bool)) -> [Element] {
        var a:[Element] = []
        
        self.enumerateObjectsUsingBlock { obj, index in
            if arrayFilter(obj,index) {
                a.append(obj)
            }
        }
        
        return a
    }
    
    
    
    public func yk_arrayJson() -> String {
        let stringData = try! JSONSerialization.data(withJSONObject: self, options: [])
        if let str = String(data: stringData, encoding: .utf8)
        {
            return str
        }else {
            return ""
        }
    }
}
