//
//  YKSwiftNetworkError.swift
//  YKSwiftNetworking
//
//  Created by edward on 2023/1/29.
//

import UIKit
import Foundation

public enum YKSwiftNetworkError: Error {
    
}

extension Error {
    /// Returns the instance cast as an `AFError`.
    public var asYKSwiftNetworkError: YKSwiftNetworkError? {
        self as? YKSwiftNetworkError
    }
}
