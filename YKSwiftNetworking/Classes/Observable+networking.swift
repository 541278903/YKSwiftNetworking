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
    public func mapWithRawData()->Observable
    {
        return self.map { Element in
            if Element is Dictionary<String,Any>{
                let response = ((Element as! Dictionary<String,Any>)["response"]) as! YKSwiftNetworkResponse
                return response.rawData as! Element
            }
            return Element
        }
    }
}
