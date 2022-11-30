//
//  YKFragmentTopConfig.swift
//  YKSwiftViews
//
//  Created by edward on 2022/6/17.
//

import UIKit

public class YKFragmentTopConfig: NSObject {
    
    public var isSelect:Bool = false

    public var titleSelectColor:UIColor = UIColor.black
    
    public var titleNormalColor:UIColor = UIColor.gray
    
    public var titleSelectCornerRadius:CGFloat = 0
    
    public var titleNormalCornerRadius:CGFloat = 0
    
    public var titleSelectBgColor:UIColor = .clear
    
    public var titleNormalBgColor:UIColor = .clear
    
    public var titleSelectFont:UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    
    public var titleNormalFont:UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    public var cursorImageViewSize:CGSize = CGSize.zero
    
    public var cursorImageViewImage:UIImage? = nil
    
    public var cursorImageViewcornerRadius:CGFloat = 0
    
    internal var haveCursorImageView:Bool {
        get {
            return self.cursorImageViewSize == CGSize.zero
        }
    }
    
    public override init() {
        super.init()
        
    }
}
