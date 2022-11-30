//
//  YKBaseNetWorking.m
//  YKNetWorking
//
//  Created by edward on 2021/8/2.
//

#import "YKBaseNetWorking.h"
#import "YKNetworkingConfig.h"
#import "YKNetworkResponseSerializer.h"
#import <AFNetworking/AFNetworking.h>

@interface YKBaseNetWorkingSessionManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

@end

@implementation YKBaseNetWorkingSessionManager

+ (instancetype)sharedInstance
{
    static YKBaseNetWorkingSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[YKBaseNetWorkingSessionManager alloc] initWithBaseURL:nil];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
    });
    
    return _sharedClient;
}

@end

@implementation YKBaseNetWorking

+ (NSURLSessionTask *)requestWithRequest:(YKNetworkRequest *)request
                            successBlock:(successBlockType)successBlock
                            failureBlock:(failureBlockType)failureBlock
{
    __block NSURLSessionDataTask *dataTask = nil;
    
    if (request.mockData != nil) {
        if (successBlock) {
            YKNetworkResponse *resp = [[YKNetworkResponse alloc] init];
            resp.isCache = NO;
            resp.rawData = request.mockData;
            resp.code = 200;
            successBlock(resp,request);
            return nil;
        }
    }
    
    dataTask = [self executeTaskWith:request success:successBlock failure:failureBlock];
    
    return dataTask;
    
}


#pragma mark ============ 执行请求内容 ==========
+ (NSURLSessionDataTask *)executeTaskWith:(YKNetworkRequest *)request
                                  success:(_Nullable successBlockType)success
                                  failure:(_Nullable failureBlockType)failure
{
    YKBaseNetWorkingSessionManager *mgr = [YKBaseNetWorkingSessionManager sharedInstance];
    
    [YKBaseNetWorking configWithRequest:request manager:mgr];
    
    NSError *serializationError = nil;
    AFHTTPRequestSerializer *s = mgr.requestSerializer;
    NSMutableURLRequest *req = [s requestWithMethod:request.methodStr URLString:request.urlStr parameters:request.params error:&serializationError];
    
    if (serializationError != nil) {
        if (failure) {
            failure(request,NO,nil,serializationError);
        }
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [mgr dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (request.progressBlock) {
            request.progressBlock((float)downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSInteger code = 200;
        
        NSError *resultError = nil;
        
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            NSHTTPURLResponse *urlRespons = (NSHTTPURLResponse *)response;
            code = urlRespons.statusCode;
            if (!error) {
                resultError = [YKNetworkResponseSerializer verifyWithResponseType:request.responseType reponse:(NSHTTPURLResponse *)response reponseObject:responseObject];
            }else{
                resultError = [NSError errorWithDomain:@"YKNetworking" code:code userInfo:error.userInfo];
            }
        }else {
            resultError = error;
        }
        
        if (resultError) {
            if (failure) {
                failure(request,NO,responseObject,resultError);
            }
        }else{
            if (success) {
                YKNetworkResponse *resp = [[YKNetworkResponse alloc] init];
                resp.isCache = NO;
                resp.rawData = responseObject;
                resp.code = code;
                success(resp,request);
            }
        }
        
    }];
    [dataTask resume];
    
    return dataTask;
}


#pragma mark ============ 执行上传请求内容 ==========

+ (NSURLSessionDataTask *)uploadTaskWith:(YKNetworkRequest *)request
                                 success:(successBlockType)success
                                 failure:(failureBlockType)failure
{
    NSURLSessionDataTask *task = nil;
    
    if (request && request.uploadFileData&& request.uploadName&&request.uploadMimeType) {
        
        YKBaseNetWorkingSessionManager *manager = [YKBaseNetWorkingSessionManager sharedInstance];
        
        [YKBaseNetWorking configWithRequest:request manager:manager];
        
        task = [manager POST:request.urlStr parameters:request.params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (request.uploadFileData) {
                [formData appendPartWithFileData:request.uploadFileData name:request.fileFieldName fileName:request.uploadName mimeType:request.uploadMimeType];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (request.progressBlock) {
                request.progressBlock((float)uploadProgress.completedUnitCount / (float)uploadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                YKNetworkResponse *response = [[YKNetworkResponse alloc] init];
                response.isCache = NO;
                response.rawData = responseObject;
                response.code = 200;
                success(response,request);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(request,NO,nil,error);
            }
        }];
    }else{
        if (failure) {
            NSString *errormessage = @"没有上传文件或上传名称或上传mimtype";
            NSError *err = [NSError errorWithDomain:@"NSCommonErrorDomain" code:-100 userInfo:@{
                NSLocalizedDescriptionKey:errormessage,
                NSLocalizedFailureReasonErrorKey:errormessage,
                }];
            YKNetworkResponse *response = [[YKNetworkResponse alloc]init];
            response.rawData = errormessage;
            response.code = -100;
            failure(request,NO,errormessage,err);
        }
    }
    
    request.task = task;
    
    [task resume];
    
    return task;
}

#pragma mark ============ 执行下载请求内容 ==========

+ (NSURLSessionDownloadTask *)downloadTaskWith:(YKNetworkRequest *)request
                                       success:(successBlockType)success
                                       failure:(failureBlockType)failure
{
    
    YKBaseNetWorkingSessionManager *manager = [YKBaseNetWorkingSessionManager sharedInstance];
    
    [YKBaseNetWorking configWithRequest:request manager:manager];
    
    NSURL *downloadURL = [NSURL URLWithString:request.urlStr];
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:downloadURL];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (request.progressBlock) {
            request.progressBlock((float)downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *urllastPathComponent = [NSURL URLWithString:request.urlStr].lastPathComponent;
        
        if (request.destPath.length > 0) {
            if ([[request.destPath substringToIndex:1] isEqualToString:@"/"]) {
                cachePath = [cachePath stringByAppendingFormat:@"%@",request.destPath];
            }else {
                cachePath = [cachePath stringByAppendingFormat:@"%@",[request.destPath substringFromIndex:1]];
            }
        }
        
        NSString *lastCharInPrefix = [cachePath substringFromIndex:cachePath.length - 1];
        if (![lastCharInPrefix isEqualToString:@"/"]) {
            cachePath = [cachePath stringByAppendingString:@"/"];
        }
        
        NSURL *finalPath = [NSURL fileURLWithPath:cachePath];
        
        BOOL isDic;
        BOOL existes = [[NSFileManager defaultManager] fileExistsAtPath:finalPath.relativePath isDirectory:&isDic];
        
        
            
        if (existes && isDic) {
            
//            [cachePath stringByAppendingPathComponent:urllastPathComponent];
            cachePath = [cachePath stringByAppendingFormat:@"%@",urllastPathComponent];
            finalPath = [NSURL fileURLWithPath:cachePath];
        }else if (existes) {
            
        }else {
            NSError *err = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:finalPath.relativePath withIntermediateDirectories:YES attributes:@{} error:&err];
            if (err != nil) {
                cachePath = [cachePath stringByAppendingFormat:@"%@",urllastPathComponent];
                finalPath = [NSURL fileURLWithPath:cachePath];
            }
        }
        
        return finalPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (success && !error) {
            YKNetworkResponse *response = [[YKNetworkResponse alloc] init];
            response.isCache = NO;
            response.rawData = @{@"path":filePath.relativePath?:@"", @"code":@200};
            response.code = 200;
            success(response,request);
        }
        if (failure && error) {
            failure(request,NO,nil,error);
        }
    }];
    request.downloadTask = task;
    
    [task resume];
    
    return task;
}

+ (void)cacheWithRequest:(YKNetworkRequest *)request
            successBlock:(successBlockType)successBlock
            failureBlock:(failureBlockType)failureBlock
{
    
    //TODO:添加缓存机制
}

#pragma mark ============ 请求头统一处理 ==========
+ (void)configWithRequest:(YKNetworkRequest *)request manager:(AFHTTPSessionManager *)manager
{
    AFHTTPRequestSerializer *requestSerializer;
    
    if (request.paramsType == YKNetworkResponseTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }else{
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    
    if (request.header && request.header.count > 0) {
        [request.header enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    double timeoutInterval = [YKNetworkingConfig defaultConfig].timeoutInterval;
    if (timeoutInterval != 0) {
        requestSerializer.timeoutInterval = timeoutInterval;
    }else
    {
        requestSerializer.timeoutInterval = 30;
    }
    
    //设置请求内容
    if (request.requestSerializerBlock) {
        manager.requestSerializer = request.requestSerializerBlock(requestSerializer);
    }else{
        manager.requestSerializer = requestSerializer;
    }
    
    // 直接支持多种格式的返回
    manager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[
        [AFJSONResponseSerializer serializer],
        [AFImageResponseSerializer serializer],
        [AFHTTPResponseSerializer serializer],
        [AFPropertyListResponseSerializer serializer],
        [AFXMLParserResponseSerializer serializer]
    ]];
}

@end
