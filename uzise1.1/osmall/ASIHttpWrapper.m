//
//  ASIHttpWrapper.m
//  uzise
//
//  Created by Wen Shane on 13-4-28.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import "ASIHttpWrapper.h"
#import "ASIDownloadCache.h"
#import "MBProgressHUD.h"



@implementation ASIHttpWrapper



+ (ASIHTTPRequest *)synLoadByURLStr:(NSString *)aURLStr withCachePolicy:(E_CACHE_POLICY)aCachePolicy
{
    return  [self synLoadByURLStr:aURLStr withCachePolicy:aCachePolicy withNotice:NO];
}

+ (ASIHTTPRequest *)synLoadByURLStr:(NSString *)aURLStr withCachePolicy:(E_CACHE_POLICY)aCachePolicy withNotice:(BOOL)aNeedNotice
{
    NSURL *url = [NSURL URLWithString:aURLStr];
    
    ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:url];
    
    [self setCachePolicyForRequest:request withCachePolicy:aCachePolicy];
    
    [request startSynchronous];
    
    if (aNeedNotice)
    {
        [self showNoticeForRequest:request];
    }
    
    if (request.error)
    {
        return nil;
    }
    else
    {
        return request;
    }
    
}

+ (void) setCachePolicyForRequest:(ASIHTTPRequest*)aRequest  withCachePolicy:(E_CACHE_POLICY)aCachePolicy
{
    if (aRequest
        && [aRequest isKindOfClass:[ASIHTTPRequest class]])
    {
        switch (aCachePolicy) {
            case E_CACHE_POLICY_NO_CACHE:
                break;
            case E_CACHE_POLICY_USE_CACHE_IF_NETWORK_FAILS_X_SESSION:
            {
                [aRequest setDownloadCache:[ASIDownloadCache sharedCache]];
                [aRequest setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
                [aRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
                
            }
                break;
            case E_CACHE_POLICY_USE_CACHE_IF_EXISTS_IN_SESSION:
            {
                [aRequest setDownloadCache:[ASIDownloadCache sharedCache]];
                [aRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
                [aRequest setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
            }
                break;
                
            default:
                break;
        }
        
    }
}

+ (void) showNoticeForRequest:(ASIHTTPRequest*)aRequest
{
    if (aRequest.error
        || aRequest.didUseCachedResponse)
    {
        [self showNotice:NSLocalizedString(@"Network error", nil)];
    }
}

+ (void)showNotice:(NSString*)aNoticeStr
{
//    MBProgressHUD* sHud = [[MBProgressHUD alloc] initWithView:self.view];
//    [[UIApplication sharedApplication].keyWindow addSubview:sHud];
//    sHud.labelText = aNoticeStr;
//    sHud.mode = MBProgressHUDModeText;
//    sHud.userInteractionEnabled = NO;
//    
//    [sHud show:YES];
//    [sHud hide:YES afterDelay:1.0f];
}

+ (void) cancelRequest:(ASIHTTPRequest*)aRequest
{
    [aRequest setDelegate:nil];
    [aRequest cancel];
}

+ (ASIHTTPRequest *)asynLoadByURLStr:(NSString *)aURLStr withCachePolicy:(E_CACHE_POLICY)aCachePolicy
{
    
    NSURL *url = [NSURL URLWithString:aURLStr];
    
    ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:url];
    [self setCachePolicyForRequest:request withCachePolicy:aCachePolicy];
    [request setDelegate:self];
    
    [request startAsynchronous];
    
    if (request.error)
    {
        return nil;
    }
    else
    {
        return request;
    }
    
}

@end
