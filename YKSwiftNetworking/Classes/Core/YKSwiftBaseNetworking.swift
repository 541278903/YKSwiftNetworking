//
//  YKSwiftBaseNetworking.swift
//  YKSwiftNetworking
//
//  Created by edward on 2021/9/1.
//

import UIKit
import Alamofire

internal class YKSwiftBaseNetworking: NSObject {
    
    static func request(request:YKSwiftNetworkRequest, progressCallBack:@escaping (_ progress:Double )->Void, successCallBack:@escaping (_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:@escaping (_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any?, _ error:Error?)->Void) -> Request?
    {
        YKSwiftBaseNetworking.configWith(request: request)
        
        if request.mockData != nil {
            let ykresponse = YKSwiftNetworkResponse.init()
            ykresponse.rawData = YKSwiftBaseNetworking.resultToChang(data: request.mockData!)
            ykresponse.isCache = false
            ykresponse.code = 200
            successCallBack(ykresponse,request)
            return nil
        }
        
        var encoding:ParameterEncoding = URLEncoding.default
        if request.encoding == .JSONEncoding {
            encoding = JSONEncoding.default
        }
        let af = AF.request(request.urlStr, method: request.methodStr, parameters: request.params, encoding: encoding, headers: HTTPHeaders.init(request.header), interceptor: nil, requestModifier: {
            if let requestTimeOut = request.timeoutInterval {
                $0.timeoutInterval = requestTimeOut
            } else {
                $0.timeoutInterval = YKSwiftNetworkingConfig.share.timeoutInterval
            }
            $0.httpBody = request.httpBody
        })
            
        let task = af.downloadProgress { progress in
            progressCallBack(progress.fractionCompleted)
        }.response(queue: .main) { response in
            switch response.result {
            case .success(let data):
                let ykresponse = YKSwiftNetworkResponse.init()
                ykresponse.rawData = YKSwiftBaseNetworking.resultToChang(data: data)
                ykresponse.isCache = false
                ykresponse.code = response.response?.statusCode ?? 0
                successCallBack(ykresponse,request)
                break
                
            case .failure(let error):
                failureCallBack(request,false,nil,error.getError())
                break
            }
        }
        task.resume()
        return task
    }
    
    static func upload(request:YKSwiftNetworkRequest, progressCallBack:@escaping (_ progress:Double )->Void, successCallBack:@escaping (_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:@escaping (_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any?, _ error:Error?)->Void) -> Request?
    {
        YKSwiftBaseNetworking.configWith(request: request)
        
        if request.mockData != nil {
            let ykresponse = YKSwiftNetworkResponse.init()
            ykresponse.rawData = YKSwiftBaseNetworking.resultToChang(data: request.mockData!)
            ykresponse.isCache = false
            ykresponse.code = 200
            successCallBack(ykresponse,request)
            return nil
        }
        
        let task =  AF.upload(multipartFormData: { [weak request] multipartFormData in
            guard let req = request else { return }
            multipartFormData.append(req.uploadFileData!, withName: req.formDataName!, fileName: req.uploadName!, mimeType: req.uploadMimeType!)
            
            for (key,value) in req.params {
                let data = "\(value)".data(using: String.Encoding.utf8) ?? Data.init()
                multipartFormData.append(data, withName: key)
            }
            
        }, to: request.urlStr, method: request.methodStr, headers: HTTPHeaders.init(request.header), requestModifier: {
            if let requestTimeOut = request.timeoutInterval {
                $0.timeoutInterval = requestTimeOut
            } else {
                $0.timeoutInterval = YKSwiftNetworkingConfig.share.timeoutInterval
            }
            $0.httpBody = request.httpBody
        }).uploadProgress { progress in
            progressCallBack(progress.fractionCompleted)
        }.response { response in
            switch response.result {
            case .success(let data):
                let ykresponse = YKSwiftNetworkResponse.init()
                ykresponse.rawData = YKSwiftBaseNetworking.resultToChang(data: data)
                ykresponse.isCache = false
                ykresponse.code = response.response?.statusCode ?? 0
                successCallBack(ykresponse,request)
                break
            case .failure(let error):
                failureCallBack(request,false,nil,error.getError())
                break
            }
        }
        task.resume()
        return task
    }
    
    static func download(request:YKSwiftNetworkRequest, progressCallBack:@escaping (_ progress:Double )->Void, successCallBack:@escaping (_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:@escaping (_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any?, _ error:Error?)->Void) -> Request?
    {
        YKSwiftBaseNetworking.configWith(request: request)
        
        if request.mockData != nil {
            let ykresponse = YKSwiftNetworkResponse.init()
            ykresponse.rawData = YKSwiftBaseNetworking.resultToChang(data: request.mockData!)
            ykresponse.isCache = false
            ykresponse.code = 200
            successCallBack(ykresponse,request)
            return nil
        }
            
        let destination: DownloadRequest.Destination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]

            let urllastPathComponent = URL.init(string: request.urlStr)!.lastPathComponent

            if request.destPath.count > 0 {
                if (request.destPath as NSString).substring(to: 1) == "/" {
                    documentsURL.appendPathComponent((request.destPath as NSString).substring(from: 1))
                }else {
                    documentsURL.appendPathComponent(request.destPath)
                }
            }
            var isDic: ObjCBool = ObjCBool(false)
            let exists: Bool = FileManager.default.fileExists(atPath: documentsURL.relativePath, isDirectory: &isDic)
            //todo:创建文件夹
            if exists && isDic.boolValue {
                // Exists. Directory.
                documentsURL.appendPathComponent("\(urllastPathComponent)")
            } else if exists {
                // Exists.
            } else {
                try? FileManager.default.createDirectory(atPath: documentsURL.relativePath, withIntermediateDirectories: true, attributes: nil)
                documentsURL.appendPathComponent("\(urllastPathComponent)")

            }

            return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        var encoding:ParameterEncoding = URLEncoding.default
        if request.encoding == .JSONEncoding {
            encoding = JSONEncoding.default
        }
        let task = AF.download(request.urlStr, method: request.methodStr, parameters: request.params, encoding: encoding, headers: HTTPHeaders.init(request.header), interceptor: nil, requestModifier: {
            if let requestTimeOut = request.timeoutInterval {
                $0.timeoutInterval = requestTimeOut
            } else {
                $0.timeoutInterval = YKSwiftNetworkingConfig.share.timeoutInterval
            }
            $0.httpBody = request.httpBody
        }, to: destination).downloadProgress(closure: { progress in
            progressCallBack(progress.fractionCompleted)
        }).response { response in
            switch response.result {
            case .success(let url):
                let ykresponse = YKSwiftNetworkResponse.init()
                ykresponse.rawData = ["url":url]
                ykresponse.isCache = false
                ykresponse.code = response.response?.statusCode ?? 0
                successCallBack(ykresponse,request)
                break
            case .failure(let error):
                failureCallBack(request,false,nil,error.getError())
                break
            }
        }
        task.resume()
        return task
    }

    
}

private extension YKSwiftBaseNetworking {
    
    static func configWith(request:YKSwiftNetworkRequest) -> Void {
        
    }
    
    static func resultToChang(data:Any?)->Any?
    {
        return data
    }
    
}

fileprivate extension AFError {
    
    func getError() -> Error? {
        
        return NSError.init(domain: "com.yk.swift.networking", code: self.responseCode ?? -1, userInfo: [
            NSLocalizedDescriptionKey:self.errorDescription ?? "error",
            NSLocalizedFailureReasonErrorKey:self.errorDescription ?? "error"
        ])
        
    }
}
