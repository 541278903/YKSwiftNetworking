//
//  YKBaseModel.m
//  YYKPodLib_Sec
//
//  Created by edward on 2020/10/9.
//  Copyright © 2020 edward. All rights reserved.
//

#import "YKModel.h"

@interface YKModel ()

@end

@implementation YKModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id",@"desc":@"description"};
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Address:%@ \n Description: %@", [super description],self.mj_JSONObject];
}

@end
