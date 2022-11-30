//
//  YKNetWorking+BasePrivate.h
//  YKNetWorking
//
//  Created by edward on 2022/9/30.
//

#import "YKNetWorking.h"
@class YKNetworkRequest;
@class YKNetworkResponse;

NS_ASSUME_NONNULL_BEGIN

@interface YKNetWorking (BasePrivate)


//MARK: private
- (BOOL)handleConfigWithRequest:(YKNetworkRequest *)request;

- (void)saveTask:(YKNetworkRequest *)request response:(YKNetworkResponse *)response isException:(BOOL)isException;

- (BOOL)handleError:(YKNetworkRequest *)request response:(YKNetworkResponse *)response isCache:(BOOL)isCache error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
