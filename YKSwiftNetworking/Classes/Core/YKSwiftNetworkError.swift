//
//  YKSwiftNetworkError.swift
//  YKSwiftNetworking
//
//  Created by linghit on 2023/1/29.
//

import UIKit
import Foundation

public enum YKSwiftNetworkError: Error {
    
    case normal(errorMsg:String)
    case inCreate(error:Error)
    case weakError
    case unexpectedlyStop
    
}

public extension YKSwiftNetworkError {
    
    var underlyingError: Swift.Error {
        switch self {
        case .normal(errorMsg: let errorMsg):
            return NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                NSLocalizedDescriptionKey:errorMsg,
                NSLocalizedFailureReasonErrorKey:errorMsg,
                NSLocalizedRecoverySuggestionErrorKey:errorMsg,
            ])
        case .inCreate(error: let error):
            return error
        case .weakError:
            return NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                NSLocalizedDescriptionKey:"初始化发生错误",
                NSLocalizedFailureReasonErrorKey:"初始化发生错误",
                NSLocalizedRecoverySuggestionErrorKey:"初始化发生错误",
            ])
        case .unexpectedlyStop:
            return NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                NSLocalizedDescriptionKey:"请求已中断",
                NSLocalizedFailureReasonErrorKey:"请求已中断",
                NSLocalizedRecoverySuggestionErrorKey:"请求已中断",
            ])
            
        }
    }
    
    var errorMsg:String {
        
        return self.underlyingError.localizedDescription
    }
}

extension Error {
    /// Returns the instance cast as an `AFError`.
    public var asYKSwiftNetworkError: YKSwiftNetworkError? {
        .inCreate(error: self)
    }
}
