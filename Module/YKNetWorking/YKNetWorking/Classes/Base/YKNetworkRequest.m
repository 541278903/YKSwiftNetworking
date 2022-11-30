//
//  YKNetWorkingRequest.m
//  YK_BaseTools
//
//  Created by edward on 2020/7/16.
//  Copyright © 2020 Edward. All rights reserved.
//

#import "YKNetworkRequest.h"

@interface YKNetworkRequest ()

#pragma mark -----------❌unUse❌(后续拓展才会真正使用到，敬请期待)------------
/** SSL证书 */
@property (nonatomic, copy) NSString *sslCerPath;

/** 文件名 */
@property (nonatomic, strong) NSMutableArray<NSString *> *fileName;
/** 上传的数据 */
@property (nonatomic, strong) NSMutableArray<NSData *> *data;

/** 文件类型 */
@property (nonatomic, strong) NSMutableArray<NSString *> *mimeType;

/** 是否需要清理缓存 */
@property (nonatomic, assign) BOOL clearCache;

/** 忽略最短请求间隔 强制发出请求 */
@property (nonatomic, assign, getter=isForce) BOOL force;

/** 自定义属性 */
@property (nonatomic, strong) NSMutableDictionary<NSString *,id<NSCopying>> *customProperty;
#pragma mark -----------❌unUse❌(后续拓展才会真正使用到，敬请期待)------------




@end

@implementation YKNetworkRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.responseType = YKNetworkResponseTypeJSON;
        self.executeMode = YKNetworkExecuteModeNormal;
        self.disableDynamicParams = NO;
        self.disableDynamicHeader = NO;
        self.disableHandleResponse = NO;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    YKNetworkRequest *request = [[YKNetworkRequest allocWithZone:zone] init];
    request.name = self.name;
    request.urlStr = self.urlStr;
    request.params = self.params;
    request.header = self.header;
    request.method = self.method;
    request.paramsType = self.paramsType;
    request.disableDynamicParams = self.disableDynamicParams;
    request.disableDynamicHeader = self.disableDynamicHeader;
    request.disableHandleResponse = self.disableHandleResponse;
    request.progressBlock = self.progressBlock;
    request.repeatRequestInterval = self.repeatRequestInterval;
    request.destPath = self.destPath;
    request.uploadFileData = self.uploadFileData;
    request.uploadName = self.uploadName;
    request.responseType = self.responseType;
    request.uploadMimeType = self.uploadMimeType;
    request.startTimeInterval = self.startTimeInterval;
    request.mockData = self.mockData;
    request.fileFieldName = self.fileFieldName;
    request.requestSerializerBlock = self.requestSerializerBlock;
    request.responseSerializerBlock = self.responseSerializerBlock;
    request.task = self.task;
    request.downloadTask = self.downloadTask;
    request.handleResponse = self.handleResponse;
    request.executeMode = self.executeMode;
    return request;
}
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (NSMutableDictionary<NSString *,NSString *> *)header
{
    if (!_header) {
        _header = [NSMutableDictionary dictionary];
    }
    return _header;
}
- (NSString *)methodStr {
    switch (self.method) {
        case YKNetworkRequestMethodGET:
            return @"GET";
        case YKNetworkRequestMethodPOST:
            return @"POST";
        case YKNetworkRequestMethodDELETE:
            return @"DELETE";
        case YKNetworkRequestMethodPUT:
            return @"PUT";
        case YKNetworkRequestMethodPATCH:
            return @"PATCH";
        default:
            return @"GET";
            break;
    }
}

- (NSMutableArray<NSString *> *)fileName
{
    if (!_fileName) {
        _fileName = [NSMutableArray array];
    }
    return _fileName;
}

- (NSMutableArray<NSData *> *)data
{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSMutableArray<NSString *> *)mimeType
{
    if (!_mimeType) {
        _mimeType = [NSMutableArray array];
    }
    return _mimeType;
}
@end
