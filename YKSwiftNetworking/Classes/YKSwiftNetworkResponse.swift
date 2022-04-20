//
//  YKSwiftNetworkResponse.swift
//  YK_Swift_Networking
//
//  Created by edward on 2021/5/10.
//

import Foundation

public class YKSwiftNetworkResponse: NSObject, NSCoding, NSMutableCopying
{
    public func encode(with coder: NSCoder) {
        coder.encode(self.rawData, forKey: "rawData")
        coder.encode(self.isCache, forKey: "isCache")
        coder.encode(self.code, forKey: "code")
    }
    
    public required init?(coder: NSCoder) {
        super.init()
        self.rawData = coder.decodeObject(forKey:"rawData")
        self.isCache = (coder.decodeObject(forKey:"isCache") as? Bool) ?? true
        self.code = (coder.decodeObject(forKey:"code") as? Int) ?? 0
    }
    
    public func mutableCopy(with zone: NSZone? = nil) -> Any {
        let resp = YKSwiftNetworkResponse.init()
        resp.rawData = self.rawData
        resp.isCache = self.isCache
        resp.code = self.code
        return resp
    }
    
    public var rawData:Any?
    public var isCache:Bool?
    public var code:Int = 0
    public override init() {
        super.init()
    }
}
