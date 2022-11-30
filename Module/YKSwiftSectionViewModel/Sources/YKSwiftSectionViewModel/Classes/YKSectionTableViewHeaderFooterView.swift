//
//  YKSectionTableViewHeaderFooterView.swift
//  YKSwiftSectionViewModel
//
//  Created by edward on 2022/6/2.
//

import UIKit

open class YKSectionTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    private var _clickEvent:((_ eventName:String, _ userInfo:[String:Any]?)->Void)?
    public var clickEvent:((_ eventName:String, _ userInfo:[String:Any]?)->Void)? {
        get {
            return self._clickEvent
        }
    }
    
    internal func toSetClickEvent(eventCallBack:@escaping (_ eventName:String, _ userInfo:[String:Any]?)->Void) {
        self._clickEvent = eventCallBack
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        autoExecute()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func autoExecute() {
        
    }

}
