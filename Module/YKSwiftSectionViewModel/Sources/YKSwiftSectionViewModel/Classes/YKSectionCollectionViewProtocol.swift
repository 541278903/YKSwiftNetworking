//
//  YKSectionCollectionViewProtocol.swift
//  YKSwiftSectionViewModel
//
//  Created by edward on 2021/12/7.
//

import Foundation
import UIKit

@objc public protocol YKSectionCollectionViewProtocol : YKSectionMainProtocol
{
    /// 获取当前cell的尺寸
    /// - Parameters:
    ///   - width: 当前collectionview宽度
    ///   - atIndexPath: 索引
    /// - Returns: 尺寸
    func yksc_sizeOfItem(with width:CGFloat, atIndexPath:IndexPath) -> CGSize
    
    /// 获取当前头部尺寸
    /// - Parameter width: 当前collectionview宽度
    /// - Returns: 尺寸
    @objc optional func yksc_sizeOfHeader(with width:CGFloat) -> CGSize
    
    /// 获取当前底部尺寸
    /// - Parameter width: 当前collectionview宽度
    /// - Returns: 尺寸
    @objc optional func yksc_sizeOfFooter(with width:CGFloat) -> CGSize
    
    /// 获取最小行间距
    /// - Returns: 距离
    @objc optional func yksc_sectionMinimumLineSpacing() -> CGFloat
    
    /// 获取最小列距离
    /// - Returns: 距离
    @objc optional func yksc_sectionMinimumInteritemSpacing() -> CGFloat
    
    
    /// 获取edge大小
    /// - Returns: 内部空间压缩
    @objc optional func yksc_cellEdge() -> UIEdgeInsets
    
}
