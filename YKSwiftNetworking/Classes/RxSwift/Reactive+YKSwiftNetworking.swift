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
        let observable = Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)>.create { [weak base] observer in
            
            if let weakBase = base {
                weakBase.exectue { result in
                    switch result {
                    case .success(let yKSwiftNetworkRequest, let yKSwiftNetworkResponse):
                        observer.onNext((yKSwiftNetworkRequest, yKSwiftNetworkResponse))
                    case .failure(_, let error):
                        observer.onError(error)
                    }
                }
            } else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [NSLocalizedDescriptionKey:"rx base未获取"]))
            }
            observer.onCompleted()
            return Disposables.create()
            
        }
        
        return observable
    }
}

