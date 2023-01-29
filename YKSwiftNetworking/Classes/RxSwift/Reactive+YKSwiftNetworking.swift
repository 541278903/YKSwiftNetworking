//
//  Reactive+YKSwiftNetworking.swift
//  YKSwiftNetworking
//
//  Created by edward on 2022/10/11.
//

import UIKit
import RxSwift

public extension Reactive where Base: YKSwiftNetworking {
    
    //MARK: ====普通请求====
    /// 普通请求响应
    /// - Returns: 响应
    func request() -> Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)> {
        let observable = Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)>.create { observer in
            
            base.exectue { result in
                switch result {
                case .success(let yKSwiftNetworkRequest, let yKSwiftNetworkResponse):
                    observer.onNext((yKSwiftNetworkRequest,yKSwiftNetworkResponse))
                case .failure(_, let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
            
        }
        
        return observable
    }
}

