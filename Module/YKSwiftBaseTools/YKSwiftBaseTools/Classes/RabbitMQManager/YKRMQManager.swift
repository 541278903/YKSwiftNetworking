//
//  YKRMQManager.swift
//  YKSwiftBaseTools
//
//  Created by edward on 2022/7/8.
//

import UIKit
import RMQClient

public class YKRMQManager: NSObject {
    
    private var mqCenter = RMQBasicReject()
    
    private var conn:RMQConnection?
    
    private var config:YKRMQManagerConfig?
    
    private var isConnect:Bool = false
    
    public weak var delegate:YKRMQManagerDelegate?
    
    override private init() {
        super.init()
    }

    public convenience init(delegate:YKRMQManagerDelegate? = nil) {
        self.init()
        self.delegate = delegate
    }
    
    deinit {
        self.endConnect()
        self.conn = nil
        self.delegate = nil
        #if DEBUG
            print("YKRMQ deinit")
        #endif
    }
}

public extension YKRMQManager {
    
    func config(_ config:YKRMQManagerConfig) -> Void {
        self.config = config
        let uri = "amqp://\(config.user):\(config.pwd)@\(config.host):\(config.port)"
        self.conn = RMQConnection(uri: uri, delegate: self)
    }
    
    func connect() -> Void {
//        if let isClose = self.conn?.isClosed(),
//           isClose
//        {
//            self.connectPri()
//        }else {
//            self.debugPrint("YKRMQ is already connected")
//        }
        if let conn = self.conn,
           !conn.isOpen()
        {
            self.connectPri()
        }else {
            self.debugPrint("YKRMQ is already connected")
        }
    }
    
    func endConnect() -> Void {
        self.conn?.close()
    }
    
    func mqIsColose() -> Bool {
        if let conn = self.conn {
            return !conn.isOpen()
        }else {
            return true
        }
    }
}

private extension YKRMQManager {
    
    func connectPri() -> Void {
        switch self.config?.connectType {
        case .Simplest:
            connectSimplest()
            break
        case .WorkQueues:
            connectWorkQueues()
            break
        case .Public:
            connectPublic()
            break
        case .Routing:
            connectRouting()
            break
        case .Topics:
            connectTopic()
            break
        case .RPC:
            connectRPC()
            break
        case .none:
            break
        }
    }
    
    func connectTopic() -> Void {
        self.conn?.start({ [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.isConnect = true
        })
        
        let ch = self.conn?.createChannel()
        let q = ch?.queue("ios_\(UUID.init().uuidString)",options: .exclusive)
        
        if let exchange = self.config?.exchangeName {
            
            if let bindingKeys = self.config?.bindingKeys,
               let x = ch?.topic(exchange)
            {
                for bindingKey in bindingKeys {
                    q?.bind(x, routingKey: bindingKey.toString())
                }
            }
        }
        self.debugPrint("Waiting for logs.")
        
        q?.subscribe(handler: { [weak self] message in
            guard let weakSelf = self else { return }
            let format = DateFormatter.init()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            format.timeZone = TimeZone.current
            let nowDate = Date.init(timeIntervalSinceNow: 0)
            weakSelf.delegate?.RMQManager(weakSelf, receiveData: message.body, routingKey: message.routingKey, consumerTag: message.consumerTag, exchangeName: message.exchangeName, receiveDate: format.string(from: nowDate))
        })
    }
    
    func connectSimplest() -> Void {
        
    }
    
    func connectWorkQueues() -> Void {
        
    }
    
    func connectPublic() -> Void {
        
    }
    
    func connectRouting() -> Void {
        
    }
    
    func connectRPC() -> Void {
        
    }
    
    func debugPrint(_ string:String) {
        #if DEBUG
            print("\(string)")
        #endif
    }
}

internal extension YKRMQManager {
    
}

extension YKRMQManager: RMQConnectionDelegate {
    
    /// socket 连接失败回调，超时或者地址有误
    public func connection(_ connection: RMQConnection!, failedToConnectWithError error: Error!) {
        self.isConnect = false
        self.delegate?.RMQManager(self, error, .overTimeOrAddressError)
    }
    
    /// 没有连接成功回调
    public func connection(_ connection: RMQConnection!, disconnectedWithError error: Error!) {
        self.isConnect = false
        self.delegate?.RMQManager(self, error, .connectFaild)
    }
    
    /// 自动
    public func willStartRecovery(with connection: RMQConnection!) {
        self.delegate?.RMQManager?(self, recovered: .willStart)
    }
    
    /// 正在开始恢复连接
    public func startingRecovery(with connection: RMQConnection!) {
        self.delegate?.RMQManager?(self, recovered: .starting)
    }
    
    /// 已经恢复连接的时候，调用
    public func recoveredConnection(_ connection: RMQConnection!) {
        self.delegate?.RMQManager?(self, recovered: .finish)
    }
    
    /// 连接过程中，信道异常调用
    public func channel(_ channel: RMQChannel!, error: Error!) {
        self.delegate?.RMQManager(self, error, .connectAbnormal)
    }
    
    
}
