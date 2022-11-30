//
//  YKBaseNetWorking.h
//  YKNetWorking
//
//  Created by edward on 2021/8/2.
//

#import <Foundation/Foundation.h>
#import "YKNetworkRequest.h"
#import "YKNetworkResponse.h"
#import "YKNetworkingConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YKBaseNetWorking : NSObject

typedef void(^complateBlockType)( id _Nullable responData ,NSError * _Nullable error);

typedef void(^progressBlockType)(float progress);

typedef void(^successBlockType)(YKNetworkResponse *response, YKNetworkRequest *request);

typedef void(^failureBlockType)(YKNetworkRequest *request, BOOL isCache, id _Nullable responseObject, NSError *error);


+ (NSURLSessionTask *)requestWithRequest:(YKNetworkRequest *)request
                            successBlock:(successBlockType)successBlock
                            failureBlock:(failureBlockType)failureBlock;

//执行上传内容
+ (NSURLSessionDataTask *)uploadTaskWith:(YKNetworkRequest *)request
                                 success:(_Nullable successBlockType)success
                                 failure:(_Nullable failureBlockType)failure;

//执行下载内容
+ (NSURLSessionDownloadTask *)downloadTaskWith:(YKNetworkRequest *)request
                                       success:(_Nullable successBlockType)success
                                       failure:(_Nullable failureBlockType)failure;

+ (void)cacheWithRequest:(YKNetworkRequest *)request
            successBlock:(successBlockType)successBlock
            failureBlock:(failureBlockType)failureBlock;
@end

NS_ASSUME_NONNULL_END
