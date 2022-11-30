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
            
            base.exectue { request, response, error in
                if let err = error {
                    observer.onError(err)
                }else {
                    observer.onNext((request,response))
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
            
        }
        
        return observable
    }
}

