//
//  YKSectionCollectionHeaderFooterView.swift
//  YKSwiftSectionViewModel
//
//  Created by edward on 2022/6/2.
//

import UIKit

open class YKSectionCollectionHeaderFooterView: UICollectionReusableView {
    
    private var _clickEvent:((_ eventName:String, _ userInfo:[String:Any]?)->Void)?
    public var clickEvent:((_ eventName:String, _ userInfo:[String:Any]?)->Void)? {
        get {
            return self._clickEvent
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoExecute()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func autoExecute() {
        
    }
    
    internal func toSetClickEvent(eventCallBack:@escaping (_ eventName:String, _ userInfo:[String:Any]?)->Void) {
        self._clickEvent = eventCallBack
    }
}

