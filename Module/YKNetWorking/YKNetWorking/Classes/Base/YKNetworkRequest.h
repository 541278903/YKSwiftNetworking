//
//  YKNetWorkingRequest.h
//  YK_BaseTools
//
//  Created by edward on 2020/7/16.
//  Copyright © 2020 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "YKNetWorkingConst.h"
@class YKNetworkResponse,YKNetworkResponse;


typedef NS_ENUM(NSInteger, YKNetworkExecuteMode) {
    YKNetworkExecuteModeNormal = 0,
    YKNetworkExecuteModeUpload,
    YKNetworkExecuteModeDownload
};

NS_ASSUME_NONNULL_BEGIN

@interface YKNetworkRequest : NSObject<NSCopying>

/// 唯一标识符
@property (nonatomic, copy) NSString *name;

/// 请求地址
@property (nonatomic, copy)   NSString *urlStr;

/// 请求参数
@property (nonatomic, strong) NSMutableDictionary *params;

/// 请求头
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSString *> *header;

/// 请求方式
@property (nonatomic, assign) YKNetworkRequestMethod       method;

///  请求体类型 默认二进制形式
@property (nonatomic, assign) YKNetworkRequestParamsType   paramsType;

/// 本次请求的响应类型
@property (nonatomic,assign) YKNetworkResponseType responseType;

/// 获取当前的请求方式(字符串)
@property (nonatomic, copy) NSString *methodStr;

/// 禁止了动态参数
@property (nonatomic, assign) BOOL disableDynamicParams;

/// 禁止了动态请求头
@property (nonatomic, assign) BOOL disableDynamicHeader;

/// 是否禁用默认返回处理方式
@property (nonatomic, assign) BOOL disableHandleResponse;

/// 上传/下载进度
@property (nonatomic, copy) void(^progressBlock)(float progress);

/// 最短重复请求时间
@property (nonatomic, assign) float repeatRequestInterval;

/// 下载路径
@property (nonatomic, copy) NSString *destPath;

/// 上传文件的二进制
@property(nonatomic,strong) NSData *uploadFileData;

/// 上传文件名
@property(nonatomic,copy) NSString *uploadName;

/// mimetype
@property(nonatomic,copy) NSString *uploadMimeType;

/// 起始时间
@property(nonatomic,assign) NSTimeInterval startTimeInterval;

/// 假数据
@property (nonatomic, strong) id<NSCopying> mockData;

/// 请求上传文件的字段名
@property (nonatomic, copy) NSString *fileFieldName;

/// 处理AF请求体: 特殊情况下需要修改时使用 一般可以不用
@property (nonatomic, copy) AFHTTPRequestSerializer *(^requestSerializerBlock)(AFHTTPRequestSerializer *);

/// 处理AF响应体: 特殊情况下需要修改时使用 一般可以不用
@property (nonatomic, copy) AFHTTPResponseSerializer *(^responseSerializerBlock)(AFHTTPResponseSerializer *);

/// 请求Task 当启用假数据返回的时候为空
@property (nonatomic, strong) NSURLSessionTask  *task;

/// 下载Task
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

/// 根据需求处理回调信息判断是否是正确的回调 即中转统一处理源数据
@property (nonatomic, copy) NSError *(^handleResponse)(YKNetworkResponse *response,YKNetworkRequest *request);

/// 当前请求的执行模式
@property (nonatomic, assign) YKNetworkExecuteMode executeMode;




@end

NS_ASSUME_NONNULL_END
