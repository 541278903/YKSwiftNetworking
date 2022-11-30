//
//  YKNetworkResponse.h


#import <Foundation/Foundation.h>

@interface YKNetworkResponse : NSObject<NSCoding,NSMutableCopying>

/** 原始数据 */
@property (nonatomic, strong) id rawData;

/** 是否是取缓存的响应 */
@property (nonatomic, assign) BOOL isCache;

/// 响应码
@property (nonatomic,assign) NSInteger code;

@end
