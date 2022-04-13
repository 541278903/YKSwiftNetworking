//
//  Observable+networking.swift
//  YKSwiftNetworking
//
//  Created by edward on 2021/6/16.
//

import Foundation
import RxSwift
import KakaJSON


extension Observable
{
    public func mapWithRawData() -> Observable<Any> {
        return self.map { Element in
            if let element = Element as? [String:Any],
               let response = element["response"] as? YKSwiftNetworkResponse,
               let rawData = response.rawData
            {
                return rawData
            }
            return Element
        }
    }
    
    public func listMapWithRawData<D: Convertible>(listName:String, className:D.Type) -> Observable<[D]> {
        return self.map { Element in
            if let element = Element as? [String:Any],
               let response = element["response"] as? YKSwiftNetworkResponse,
               let rawData = response.rawData as? [String:Any],
               let list = rawData[listName] as? [Any]
            {
                return list.kj.modelArray(className)
            }
            return []
            
        }
    }
    
    public func modelMapWithRawData<D: Convertible>(_ className:D.Type) -> Observable<D> {
        return self.map { Element in
            if let element = Element as? [String:Any],
               let response = element["response"] as? YKSwiftNetworkResponse,
               let rawData = response.rawData as? [String:Any]
            {
                return rawData.kj.model(className)
            }
            return D.init()
        }
    }
}
