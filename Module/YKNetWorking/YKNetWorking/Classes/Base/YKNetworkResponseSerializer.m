//
//  YKNetworkResponseSerializer.m
//  YKNetWorking
//
//  Created by linghit on 2021/9/22.
//

#import "YKNetworkResponseSerializer.h"
#import <AFNetworking/AFURLResponseSerialization.h>

@implementation YKNetworkResponseSerializer

+ (NSError *)verifyWithResponseType:(YKNetworkResponseType)type reponse:(NSHTTPURLResponse *)response reponseObject:(id)responseObject
{
    NSError *error;
    AFHTTPResponseSerializer *serializer;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
    switch (type) {
        case YKNetworkResponseTypeJSON:
            serializer = [AFJSONResponseSerializer serializer];
            [serializer validateResponse:response data:data error:&error];
            break;
        case YKNetworkResponseTypeHTTP:
            serializer = [AFHTTPResponseSerializer serializer];
            [serializer validateResponse:response data:data error:&error];
            break;
        case YKNetworkResponseTypeImage:
            serializer = [AFImageResponseSerializer serializer];
            [serializer validateResponse:response data:data error:&error];
            break;
        case YKNetworkResponseTypeXML:
            serializer = [AFXMLParserResponseSerializer serializer];
            [serializer validateResponse:response data:data error:&error];
            break;
        case YKNetworkResponseTypePlist:
            serializer = [AFPropertyListResponseSerializer serializer];
            [serializer validateResponse:response data:data error:&error];
            break;
        case YKNetworkResponseTypeAnyThing:
            serializer = [AFHTTPResponseSerializer serializer];
            [serializer validateResponse:response data:data error:&error];
            break;
        default:
            break;
    }
    
    return error;
}

@end
