//
//  YKFont.swift
//  YKSwiftCommandModule
//
//  Created by linghit on 2022/7/5.
//

import UIKit

public enum YKFontMode {
    case xxm
    case xm
    case m
    case l
    case xl
    case xxl
}

public class YKFont: NSObject {
    
    private var fontSize:CGFloat = 0
    
    private var mode:YKFontMode = .l
    
    override init() {
        super.init()
    }
    
    convenience init(size:CGFloat) {
        self.init()
    }
    
}


private extension YKFont {
    
}

public extension YKFont {
    
    func font() -> UIFont {
        return .systemFont(ofSize: 12)
    }
    
}

