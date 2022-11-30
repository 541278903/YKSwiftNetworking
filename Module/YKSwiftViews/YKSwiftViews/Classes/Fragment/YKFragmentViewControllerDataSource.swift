//
//  YKFragmentViewControllerDataSource.swift
//  YKSwiftViews
//
//  Created by edward on 2022/6/19.
//

import UIKit

@objc public protocol YKFragmentViewControllerDataSource: NSObjectProtocol {
    
    
    /// 总体设置顶部导航栏的内容
    /// - Parameters:
    ///   - fragmentViewController: 主控制器
    ///   - indexPath: 索引
    /// - Returns: 配置项
    func fragmentViewController(_ fragmentViewController:YKFragmentViewController, configForHeaderItem indexPath:IndexPath) -> YKFragmentTopConfig
    
    /// 滑动到某个页面显示时触发的代理
    /// - Parameters:
    ///   - fragmentViewController: 主控制器
    ///   - viewController: 将显示的子控制器
    /// - Returns: 无
    @objc optional func fragmentViewController(_ fragmentViewController:YKFragmentViewController, subViewControllerViewDidApper viewController:YKFragmentSubViewControllerDelegate) -> Void
    
    /// 设置当前顶部Item的总体宽度
    /// - Parameters:
    ///   - fragmentViewController: 主控制器
    ///   - indexPath: 索引
    ///   - title: 子控制器当前的title
    /// - Returns: 宽度
    @objc optional func fragmentViewController(_ fragmentViewController:YKFragmentViewController, widthForHeaderItem indexPath:IndexPath, title:String) -> CGFloat
    
    /// 设置当前顶部Item的Label的宽度
    /// - Parameters:
    ///   - fragmentViewController: 主控制器
    ///   - indexPath: 索引
    ///   - title: 子控制器当前的title
    /// - Returns: label的宽度
    @objc optional func fragmentViewController(_ fragmentViewController:YKFragmentViewController, widthForHeaderItemLabel indexPath:IndexPath, title:String) -> CGFloat
    
    /// 设置当前顶部Item的Label的高度
    /// - Parameters:
    ///   - fragmentViewController: 主控制器
    ///   - indexPath: 索引
    ///   - title: 子控制器当前的title
    /// - Returns: label的高度
    @objc optional func fragmentViewController(_ fragmentViewController:YKFragmentViewController, heightForHeaderItemLabel indexPath:IndexPath, title:String) -> CGFloat
    
    /// 设置当前顶部滑块的大小
    /// - Parameter fragmentViewController: 主控制器
    /// - Returns: 滑块大小
    @objc optional func fragmentViewControllerSizeForCursorImageView(_ fragmentViewController:YKFragmentViewController) -> CGSize
    
    /// 设置当前顶部滑块的背景颜色
    /// - Parameter fragmentViewController: 主控制器
    /// - Returns: 滑块背景颜色
    @objc optional func fragmentViewControllerBackgroundColorForCursorImageView(_ fragmentViewController:YKFragmentViewController) -> UIColor
    
    /// 设置当前顶部滑块的图片
    /// - Parameter fragmentViewController: 主控制器
    /// - Returns: 滑块图片
    @objc optional func fragmentViewControllerImageForCursorImageView(_ fragmentViewController:YKFragmentViewController) -> UIImage
    
    /// 设置当前顶部Item的红标偏移值
    /// - Parameters:
    ///   - fragmentViewController: 主控制器
    ///   - indexPath: 索引
    /// - Returns: 偏移值
    @objc optional func fragmentViewController(_ fragmentViewController:YKFragmentViewController, badgeOffsetAt indexPath:IndexPath) -> UIOffset
    
    /// 设置当前顶部Item的红标内容
    /// - Parameters:
    ///   - fragmentViewController: 主控制器
    ///   - indexPath: 索引
    /// - Returns: 红标内容
    @objc optional func fragmentViewController(_ fragmentViewController:YKFragmentViewController, badgeAt indexPath:IndexPath) -> String
    
    
    /// 设置当前顶部Header的左偏移量
    /// - Parameter fragmentViewController: 主控制器
    /// - Returns: 偏移量
    @objc optional func fragmentViewControllerHeaderLeftOffset(_ fragmentViewController:YKFragmentViewController) -> CGFloat
    
    /// 设置当前顶部Header的右偏移量
    /// - Parameter fragmentViewController: 主控制器
    /// - Returns: 偏移量
    @objc optional func fragmentViewControllerHeaderRightOffset(_ fragmentViewController:YKFragmentViewController) -> CGFloat
    
    /// 设置当前顶部Header与主体的Line颜色
    /// - Parameter fragmentViewController: 主控制器
    /// - Returns: 颜色
    @objc optional func fragmentViewControllerColorForHeaderBottomLine(_ fragmentViewController:YKFragmentViewController) -> UIColor
    
    
    /// 设置当前顶部header的背景颜色
    /// - Parameter fragmentViewController: 主控制器
    /// - Returns: 背景颜色
    @objc optional func fragmentViewControllerColorForHeaderBackgroundColor(_ fragmentViewController:YKFragmentViewController) -> UIColor
}
