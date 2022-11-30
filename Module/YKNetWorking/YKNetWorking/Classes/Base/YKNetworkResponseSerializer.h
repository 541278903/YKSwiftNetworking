//
//  YKNetworkResponseSerializer.h
//  YKNetWorking
//
//  Created by linghit on 2021/9/22.
//

#import <Foundation/Foundation.h>
#import "YKNetWorkingConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface YKNetworkResponseSerializer : NSObject

+ (NSError *)verifyWithResponseType:(YKNetworkResponseType)type reponse:(NSHTTPURLResponse *)response reponseObject:(id)responseObject;

@end

NS_ASSUME_NONNULL_END
