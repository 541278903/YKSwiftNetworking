//
//  YKFragmentSubViewControllerDelegate.swift
//  YKSwiftViews
//
//  Created by edward on 2021/12/9.
//

import Foundation

@objc public protocol YKFragmentSubViewControllerDelegate
{
    func fragmentSubViewController(viewHeight height:CGFloat)
    
    @objc optional func fragmentSubViewControllerTitle() -> String
    
    @objc optional func fragmentSubViewControllerRefresh()
    
    @objc optional func fragmentSubViewController(with badgeCallBack:@escaping (_ badgeString:String)->Void)
}
