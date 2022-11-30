//
//  YKStatusMachineProtrocol.swift
//  YKSwiftBaseTools
//
//  Created by edward on 2021/10/21.
//

import UIKit


@objc
public protocol YKStatusMachineProtrocol: NSObjectProtocol{
    
    /// 当状态机进入本状态时回调
    /// - Parameters:
    ///   - statusMachine: 状态机
    ///   - state: 状态
    ///   - container: 状态协议
    func yk_statusMachine(_ statusMachine:YKStatusMachine, previousState state:String, enterToContainer container:YKStatusMachineContainerProtrocol)
    
    /// 当状态机将要离开本状态时回调
    /// - Parameters:
    ///   - statusMachine: 状态机
    ///   - nextState: 下一个状态
    func yk_statusMachine(_ statusMachine:YKStatusMachine, willExit nextState:String)
}


@objc
public protocol YKStatusMachineContainerProtrocol: NSObjectProtocol{
    
    
    /// 返回子状态
    /// - Returns: 子状态集
    func yk_statusMachineContainer_childState() -> [YKStatusMachineProtrocol];
    
    
    /// 获取供子类使用的容器
    /// - Returns: 容器
    func yk_statusMachineContainer_getContainer() -> Any;
    
    
    /// 加载内容
    /// - Returns: 内容
    @objc optional func yk_statusMachineContainer_getCustomUserInfo() -> [String:Any]
    
}

