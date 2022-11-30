//
//  YKRMQManagerDelegate.swift
//  YKSwiftBaseTools
//
//  Created by edward on 2022/7/12.
//

import UIKit

public enum YKRMQManagerConnectStatic {
    case linking
    case connected
    case close
}

@objc public enum YKMQManagerRecoveredType:Int {
    case finish                     ///已经恢复连接
    case willStart                  ///正在恢复连接
    case starting                   ///开始恢复连接
}

@objc public enum YKRMQManagerErrorType:Int {
    case connectAbnormal          ///连接过程通道异常
    case connectFaild                ///没有连接成功回调
    case overTimeOrAddressError     ///socket连接失败
}

@objc
public protocol YKRMQManagerDelegate: NSObjectProtocol {
    
    func RMQManager(_ manager:YKRMQManager, receiveData data:Data?, routingKey key:String, consumerTag tag:String, exchangeName name:String, receiveDate date:String) -> Void
    
    func RMQManager(_ manager:YKRMQManager, _ error:Error, _ type:YKRMQManagerErrorType)
    
    @objc optional func RMQManager(_ manager:YKRMQManager, recovered connectionType:YKMQManagerRecoveredType)
}
