////
////  Observable+Networking.swift
////  YKSwiftNetworking
////
////  Created by edward on 2021/6/16.
////
//
//import Foundation
//import RxSwift
//import YKSwiftNetworking
//
//extension Observable {
//    
//    /// 构建回调数据
//    /// - Parameter key: 可选：需要取出的字典key，若返回数据未字典类型，会优先抽取对应key的值返回出去
//    /// - Returns: Observable<Any?>
//    public func mapWithRawData(_ key:String? = nil) -> Observable<Any?> {
//        return self.map { Element in
//            if let data = Element as? (request:YKSwiftNetworkRequest,response:YKSwiftNetworkResponse)
//            {
//                let rawData = data.response.rawData
//                if let rawDataDic = rawData as? [String:Any],
//                   let dicKey = key {
//                    return rawDataDic[dicKey]
//                }
//                return rawData
//            }
//            return Element
//        }
//    }
//    
//}
