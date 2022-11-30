//
//  YKSectionCollectionViewCell.swift
//  YKSwiftSectionViewModel
//
//  Created by edward on 2022/5/26.
//

import UIKit

open class YKSectionCollectionViewCell: UICollectionViewCell {
    
    private var _clickEvent:((_ eventName:String, _ userInfo:[String:Any]?)->Void)?
    public var clickEvent:((_ eventName:String, _ userInfo:[String:Any]?)->Void)? {
        get {
            return self._clickEvent
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        autoExecute()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func autoExecute() {
        
    }
    
    internal func toSetClickEvent(eventCallBack:@escaping (_ eventName:String, _ userInfo:[String:Any]?)->Void) {
        self._clickEvent = eventCallBack
    }
}
