//
//  YKNetworkResponse.m
//
//


#import "YKNetworkResponse.h"


@implementation YKNetworkResponse

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_rawData forKey:@"rawData"];
    [aCoder encodeObject:@(_isCache) forKey:@"isCache"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _rawData = [aDecoder decodeObjectForKey:@"rawData"];
        _isCache = [[aDecoder decodeObjectForKey:@"isCache"] boolValue];
    }
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    YKNetworkResponse *resp = [[YKNetworkResponse alloc] init];
    resp.rawData = [self.rawData mutableCopy];
    resp.isCache = self.isCache;
    return resp;
}

@end
