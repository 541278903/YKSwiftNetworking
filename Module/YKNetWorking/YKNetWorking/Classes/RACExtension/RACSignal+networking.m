//
//  RACSignal+networking.m
//  YK_BaseMediator
//
//  Created by edward on 2020/11/10.
//  Copyright © 2020 Edward. All rights reserved.
//

#import "RACSignal+networking.h"
#import "YKNetworkResponse.h"

@implementation RACSignal (networking)

- (RACSignal *)mapWithRawData
{
    return [self map:^id(RACTuple *tuple) {
        YKNetworkResponse *resp = tuple.second;
        if([resp.rawData isKindOfClass:[NSNull class]]) {
            return nil;
        } else if ([resp.rawData isKindOfClass:NSDictionary.class]){
            NSMutableDictionary *tempDic = [resp.rawData mutableCopy];
            [resp.rawData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [tempDic removeObjectForKey:key];
                }
            }];
            resp.rawData = tempDic;
            return resp.rawData;
        } else {
            return resp.rawData;
        }
    }];
}

- (RACSignal *(^)(NSString *))mapWithSomething
{
    return ^RACSignal *(NSString *someThing) {
        return [self map:^id(RACTuple *tuple) {
            YKNetworkResponse *resp = tuple.second;
            id data = resp.rawData[someThing];
            if ([data isKindOfClass:NSNull.class]) {
                return nil;
            } else {
                return data;
            }
        }];
    };
}
@end
