//
//  YKSwiftNetworking+RxSwift.swift
//  YKSwiftNetworking
//
//  Created by linghit on 2022/10/12.
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
            
            weakSelf.execute { request, response, error in
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
            
            weakSelf.executeDownload { request, response, error in
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
