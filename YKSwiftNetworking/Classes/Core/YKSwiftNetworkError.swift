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
}

extension YKSwiftNetworkError {
    
    internal var underlyingError: Swift.Error? {
        switch self {
        case .normal(errorMsg: let errorMsg):
            return NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                NSLocalizedDescriptionKey:errorMsg,
                NSLocalizedFailureReasonErrorKey:errorMsg,
                NSLocalizedRecoverySuggestionErrorKey:errorMsg,
            ])
        case .inCreate(error: let error):
            return error
        }
    }
}

extension Error {
    /// Returns the instance cast as an `AFError`.
    public var asYKSwiftNetworkError: YKSwiftNetworkError? {
        self as? YKSwiftNetworkError
    }
}
