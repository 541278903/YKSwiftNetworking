//
//  YKViewModelProtocol.swift
//  YKSwiftBaseClass
//
//  Created by linghit on 2022/4/13.
//

import UIKit

public protocol YKViewModelProtocol {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input?)
}
