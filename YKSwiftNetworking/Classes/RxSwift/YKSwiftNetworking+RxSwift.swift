//
//  YKSwiftNetworking+RxSwift.swift
//  YKSwiftNetworking
//
//  Created by linghit on 2022/10/11.
//

import UIKit
import RxSwift

public extension YKSwiftNetworking {
    
    //MARK: ====普通请求====
    /// 普通请求响应
    /// - Returns: 响应
    func rxexecute() -> Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)> {
        
        let observable = Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)>.create { [weak self] observer in
            guard let weakSelf = self else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"self处理错误",
                    NSLocalizedFailureReasonErrorKey:"self处理错误",
                    NSLocalizedRecoverySuggestionErrorKey:"self处理错误",
                ]))
                observer.onCompleted()
                return Disposables.create() }
            
            
            
            weakSelf.exectue { request, response, error in
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
    
    //MARK: ====上传请求====
    /// 上传响应
    /// - warning: 请务必调用uploadData(data:Data, filename:String, mimeType:String)
    /// - Returns: 响应
    func uploadDataSignal() -> Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)> {
        
        
        let observable = Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)>.create { [ weak self] observer in
            
            guard let weakSelf = self else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"self处理错误",
                    NSLocalizedFailureReasonErrorKey:"self处理错误",
                    NSLocalizedRecoverySuggestionErrorKey:"self处理错误",
                ]))
                observer.onCompleted()
                return Disposables.create() }
            
            weakSelf.executeupload { request, response, error in
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
    
    //MARK: ====下载请求====
    /// 下载响应
    /// - warning: 请务必调用downloadDestPath
    /// - Returns: 响应
    func downloadDataSignal() -> Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)> {
        
        let observable = Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)>.create { [weak self] observer in
            
            guard let weakSelf = self else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"self处理错误",
                    NSLocalizedFailureReasonErrorKey:"self处理错误",
                    NSLocalizedRecoverySuggestionErrorKey:"self处理错误",
                ]))
                observer.onCompleted()
                return Disposables.create() }
            
            guard let request = weakSelf.request.copy() as? YKSwiftNetworkRequest else { observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                NSLocalizedDescriptionKey:"request初始化错误",
                NSLocalizedFailureReasonErrorKey:"request初始化错误",
                NSLocalizedRecoverySuggestionErrorKey:"request初始化错误",
            ]))
                observer.onCompleted()
                return Disposables.create() }
            
            let canContinue = weakSelf.handleConfig(with: request)
            if !canContinue {
                weakSelf._request = nil
                observer.onNext((request,YKSwiftNetworkResponse()))
                observer.onCompleted()
                return Disposables.create()
            }
            
            if request.isShowLoading {
                weakSelf.loadingHandle?(true)
            }
            
            request.task = YKSwiftBaseNetworking.download(request: request, progressCallBack: { progress in
                request.progressBlock?(progress)
            }, successCallBack: { [weak self] response, request in
                observer.onNext((request,response))
                if let weakSelf = self {
                    if request.isShowLoading {
                        weakSelf.loadingHandle?(false)
                    }
                    weakSelf.saveTask(request: request, response: response, isException: false)
                }
                observer.onCompleted()
            }, failureCallBack: { [weak self] request, isCache, responseObject, error in
                
                if request.isShowLoading,
                   let weakSelf = self
                {
                    weakSelf.loadingHandle?(false)
                }
                
                if let err = error {
                    observer.onError(err)
                }else {
                    let ykresponse = YKSwiftNetworkResponse.init()
                    observer.onNext((request,ykresponse))
                    if let weakSelf = self {
                        weakSelf.saveTask(request: request, response: ykresponse, isException: true)
                    }
                }
                observer.onCompleted()
            })
            weakSelf._request = nil
            return Disposables.create()
        }
        return observable
    }
    
}
