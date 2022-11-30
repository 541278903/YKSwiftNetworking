//
//  YKColor.swift
//  YKSwiftCommandModule
//
//  Created by linghit on 2022/7/5.
//

import UIKit

public enum YKColorMode {
    case light
    case dark
}

public class YKColor: NSObject {
    
    override init() {
        super.init()
    }
    
    convenience init(hex:String) {
        self.init()
    }
    
    
}

private extension YKColor {
    
}

public extension YKColor {
    
    func color() -> UIColor {
        
        return .clear
    }
}
