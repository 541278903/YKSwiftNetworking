//
//  YKViewModel.swift
//  YKSwiftBaseClass
//
//  Created by edward on 2021/6/10.
//

import Foundation
@_exported import RxSwift
@_exported import YKSwiftNetworking
import YKSwiftAlert

open class YKViewModel : NSObject ,YKSwiftNetworkingDelegate  {
    
    private let disposeBag = DisposeBag()
    
    public lazy var networking:YKSwiftNetworking = {
        let networking = YKSwiftNetworking.init()
        networking.delegate = self
        networking.dynamicParamsConfig = { [weak self]
            request in
            var params:[String:Any] = [:]
            guard let strongself = self else {
                return params
            }
            if request.method == .GET {
                params["size"] = strongself.size
                params["page"] = strongself.page
            }
            return params
        }
        
        
        return networking
    }()
    public var size:Int = 20
    public var page:Int = 1
    public var errorBlock:((_ error:Error) -> Void)? = nil
    
    public override init() {
        super.init()//在需要调用到self的时候必须先调用完super.init()才能使用self
    }
    
    
    public func handlePageData(_ dataSource:inout [Any]?,_ newData:[Any])->Void{
        
        assert(dataSource != nil, "")
        
        if self.page == 1 {
            dataSource!.removeAll()
        }
        for new in newData {
            dataSource!.append(new)
        }
    }
    
    
    /// 网络请求协议
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    ///   - isException: 是否报错
    open func cacheRequest(request: YKSwiftNetworkRequest, response: YKSwiftNetworkResponse, isException: Bool) {
        
    }
    
    
    
}
