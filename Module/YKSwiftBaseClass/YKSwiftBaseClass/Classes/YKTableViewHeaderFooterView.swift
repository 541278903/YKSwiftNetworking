//
//  YKTableViewHeaderFooterView.swift
//  YKSwiftBaseClass
//
//  Created by edward on 2021/11/18.
//

import UIKit

open class YKTableViewHeaderFooterView: UITableViewHeaderFooterView {

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        autoExecute()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open var handleBlock:((_ eventName:String, _ userInfo:[String:Any]) -> Void)? = nil
    
    open func autoExecute() {
        
    }
    
    open func didSetupUI(view: UIView) -> Void{
        
    }
    
    open func didBindData() -> Void {
        
    }
    
    open func configData(viewModel:YKViewModel, indexPath:IndexPath, dataSource:[Any]) -> Void{
        
    }
}
