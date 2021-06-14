//
//  YKSwiftNetworkResponse.swift
//  YK_Swift_Networking
//
//  Created by edward on 2021/5/10.
//

import Foundation


public class YKSwiftNetworkResponse:NSObject,NSCoding,NSMutableCopying
{
    public func encode(with coder: NSCoder) {
        coder.encode(self.rawData, forKey: "rawData")
        coder.encode(self.isCache, forKey: "isCache")
    }
    
    public required init?(coder: NSCoder) {
        super.init()
        self.rawData = coder.decodeObject(forKey:"rawData")
        self.isCache = (coder.decodeObject(forKey:"isCache") as? Bool) ?? true
    }
    
    public func mutableCopy(with zone: NSZone? = nil) -> Any {
        let resp = YKSwiftNetworkResponse.init()
        resp.rawData = self.rawData
        resp.isCache = self.isCache
        return resp
    }
    
    public var rawData:Any?
    public var isCache:Bool?
    public override init() {
        super.init()
    }
}
