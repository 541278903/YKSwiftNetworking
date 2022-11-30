//
//  YKSectionTableViewProtocol.swift
//  YKSwiftSectionViewModel
//
//  Created by edward on 2022/1/22.
//

import Foundation
import UIKit

@objc public protocol YKSectionTableViewProtocol : YKSectionMainProtocol
{
    /// 获取当前cell的高度
    /// - Parameters:
    ///   - row: 索引
    /// - Returns: cell的高度
    func yksc_heightOfRow(at row:Int) -> CGFloat
    
    /// 获取当前cell的估高
    /// - Returns: 估高
    @objc optional func yksc_estimatedHeightOfRow(at row:Int) -> CGFloat
    
    /// 获取当前头部高度
    /// - Returns: 头部的高度
    @objc optional func yksc_heightOfHeader() -> CGFloat
    
    /// 获取当前头部估高
    /// - Returns: 估高
    @objc optional func yksc_estimatedHeightOfHeader() -> CGFloat
    
    /// 获取当前底部高度
    /// - Returns: 高度
    @objc optional func yksc_heightOfFooter() -> CGFloat
    
    /// 获取当前底部高度
    /// - Returns: 估高
    @objc optional func yksc_estimatedHeightOfFooter() -> CGFloat
    
    /// 获取当前底部cell
    /// - Returns: 是否可以编辑
    @objc optional func yksc_canEdit(at row:Int) -> Bool
    
    
}
