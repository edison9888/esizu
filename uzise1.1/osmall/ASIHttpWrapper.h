//
//  ASIHttpWrapper.h
//  uzise
//
//  Created by Wen Shane on 13-4-28.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

typedef enum  _E_CACHE_POLICY
{
    E_CACHE_POLICY_NO_CACHE,
    E_CACHE_POLICY_USE_CACHE_IF_NETWORK_FAILS_X_SESSION, //use cache if load fails, cross session
    E_CACHE_POLICY_USE_CACHE_IF_EXISTS_IN_SESSION,
}E_CACHE_POLICY;


@interface ASIHttpWrapper : NSObject


+(ASIHTTPRequest *)synLoadByURLStr:(NSString *)aURLStr withCachePolicy:(E_CACHE_POLICY)aCachePolicy withNotice:(BOOL)aNeedNotice;

+(ASIHTTPRequest *)synLoadByURLStr:(NSString *)dataURL withCachePolicy:(E_CACHE_POLICY)aCachePolicy;
+(ASIHTTPRequest *)asynLoadByURLStr:(NSString *)aURLStr withCachePolicy:(E_CACHE_POLICY)aCachePolicy;


@end
