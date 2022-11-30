//
//  YKCollectionViewCell.swift
//  YKSwiftBaseClass
//
//  Created by linghit on 2021/11/17.
//

import UIKit

open class YKCollectionViewCell: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        autoExecute()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open var handleBlock:((_ eventName:String, _ userInfo:[String:Any]) -> Void)? = nil
    
    open func autoExecute() {
        
    }
    
    open func didSetupUI(view: UIView) -> Void {
        
    }
    
    open func didBindData() -> Void {
        
    }
    
    open func configData(viewModel:YKViewModel, indexPath:IndexPath, dataSource:[Any]) ->Void {
        
    }
    
}
