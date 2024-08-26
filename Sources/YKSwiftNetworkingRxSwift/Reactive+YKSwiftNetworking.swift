////
////  Reactive+YKSwiftNetworking.swift
////  YKSwiftNetworking
////
////  Created by edward on 2022/10/11.
////
//
//import Foundation
//import RxSwift
//import YKSwiftNetworking
//
//public extension Reactive where Base: YKSwiftNetworking {
//    
//    //MARK: ====普通请求====
//    /// 普通请求响应
//    /// - Returns: 响应
//    func request() -> Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)> {
//        
//        let currentRequest = base.getRequestForRxSwift()
//        
//        let observable = Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)>.create { [weak base] observer in
//            
//            if let weakBase = base {
//                weakBase.exectue(currentRequest) { result in
//                    switch result {
//                    case .success(let yKSwiftNetworkRequest, let yKSwiftNetworkResponse):
//                        observer.onNext((yKSwiftNetworkRequest, yKSwiftNetworkResponse))
//                        observer.onCompleted()
//                    case .failure(let yKSwiftNetworkRequest, let error):
//                        let errorMessagee = error.errorMsg
//                        let failureReason = "FROM:\(yKSwiftNetworkRequest.urlStr) \r\nREASON:\(errorMessagee)"
//                        
//                        let newError = NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
//                            NSLocalizedDescriptionKey:failureReason,
//                            NSLocalizedFailureReasonErrorKey:failureReason
//                        ])
//                        observer.onError(newError)
//                        observer.onCompleted()
//                    }
//                }
//            } else {
//                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [NSLocalizedDescriptionKey:"rx base未获取"]))
//                observer.onCompleted()
//            }
//            
//            return Disposables.create {
//                currentRequest?.task?.cancel()
//            }
//            
//        }
//        
//        return observable
//    }
//}
//
