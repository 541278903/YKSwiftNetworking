//
//  YKView.swift
//  YKSwiftBaseClass
//
//  Created by edward on 2021/5/25.
//

import UIKit

open class YKView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        autoExecute()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func autoExecute() {
        
    }
    
    open func didSetupUI(view: UIView) -> Void {
        
    }
    
    open func didBindData() -> Void {
        
    }
    
    open var handleBlock:((_ eventName:String, _ userInfo:[String:Any]) -> Void)? = nil
    
    open func configData(viewModel: YKViewModel) -> Void {
        
    }
    
}

