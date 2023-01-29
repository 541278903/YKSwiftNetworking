//
//  YKSwiftNetworking+RxSwift.swift
//  YKSwiftNetworking
//
//  Created by linghit on 2022/10/12.
//

import UIKit
import RxSwift

public extension Reactive where Base: YKSwiftNetworking {
    
    //MARK: ====普通请求====
    /// 普通请求响应
    /// - Returns: 响应
    func request() -> Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)> {
        let observable = Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)>.create { observer in
            
//            guard let weakSelf = self else {
//                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
//                    NSLocalizedDescriptionKey:"self处理错误",
//                    NSLocalizedFailureReasonErrorKey:"self处理错误",
//                    NSLocalizedRecoverySuggestionErrorKey:"self处理错误",
//                ]))
//                observer.onCompleted()
//                return Disposables.create() }
//
//            weakSelf.executeDownload { request, response, error in
//                if let err = error {
//                    observer.onError(err)
//                }else {
//                    observer.onNext((request,response))
//                }
//                observer.onCompleted()
//            }
            base.execute { result in
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
