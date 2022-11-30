//
//  YKSwiftMainDelegate.swift
//  YKSwiftCommandModule
//
//  Created by linghit on 2022/4/14.
//

import UIKit

@objc public protocol YKSwiftMainDelegate
{
    //MARK: -设置debug工具
    @objc optional func setupDebugTool()->Void
    
    //MARK: -设置根控制器
    @objc optional func setupController()->UIViewController
    
    //MARK: -设置根控制器后的设置
    @objc optional func afterSetup()->Void
    
    //MARK: -设置根控制器后的设置媒体
    @objc optional func registMedia()->Void
    
}

@objc public protocol YKSwiftMainAppDelegate: YKSwiftMainDelegate
{
    //MARK: -设置根控制器后的设置通知
    @objc optional  func registNotification(center:NotificationCenter, launchOptions:[UIApplication.LaunchOptionsKey : Any]?)->Void
}

@objc public protocol YKSwiftMainSceneDelegate: YKSwiftMainDelegate
{
    //MARK: -设置根控制器后的设置通知
    @objc optional  func registNotification(center:NotificationCenter, session: UISceneSession, options:UIScene.ConnectionOptions)->Void
}
