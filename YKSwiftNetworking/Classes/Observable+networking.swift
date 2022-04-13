//
//  Observable+networking.swift
//  YKSwiftNetworking
//
//  Created by edward on 2021/6/16.
//

import Foundation
import RxSwift


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
    
}
