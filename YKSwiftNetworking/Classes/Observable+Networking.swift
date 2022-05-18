//
//  Observable+Networking.swift
//  YKSwiftNetworking
//
//  Created by edward on 2021/6/16.
//

import Foundation
import RxSwift

extension Observable
{
    public func mapWithRawData() -> Observable<Any?> {
        return self.map { Element in
            if let data = Element as? (request:YKSwiftNetworkRequest,response:YKSwiftNetworkResponse)
            {
                return data.response.rawData
            }
            return Element
        }
    }
    
}
