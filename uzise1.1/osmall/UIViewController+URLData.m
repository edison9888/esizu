//
//  UIViewController+URLData.m
//  uzise
//
//  Created by edward on 12-10-7.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "UIViewController+URLData.h"

#import "ASIHTTPRequest.h"

#import "PrettyKit.h"

#import "UIViewController_PropertyExtension.h"

#import "Constant.h"

#import "UserBean.h"
#import "ASIDownloadCache.h"
#import "MBProgressHUD.h"


@implementation UIViewController (URLData)

-(ASIHTTPRequest *)synLoadByURLStr:(NSString *)aURLStr withCachePolicy:(E_CACHE_POLICY)aCachePolicy
{
    return  [self synLoadByURLStr:aURLStr withCachePolicy:aCachePolicy withNotice:NO];
}

-(ASIHTTPRequest *)synLoadByURLStr:(NSString *)aURLStr withCachePolicy:(E_CACHE_POLICY)aCachePolicy withNotice:(BOOL)aNeedNotice
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

- (void) setCachePolicyForRequest:(ASIHTTPRequest*)aRequest  withCachePolicy:(E_CACHE_POLICY)aCachePolicy
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

- (void) showNoticeForRequest:(ASIHTTPRequest*)aRequest
{
    if (aRequest.error
        || aRequest.didUseCachedResponse)
    {
        [self showNotice:NSLocalizedString(@"Network error", nil)];
    }
}

- (void)showNotice:(NSString*)aNoticeStr
{
    MBProgressHUD* sHud = [[MBProgressHUD alloc] initWithView:self.view];
    [[UIApplication sharedApplication].keyWindow addSubview:sHud];
    sHud.labelText = aNoticeStr;
    sHud.mode = MBProgressHUDModeText;
    sHud.userInteractionEnabled = NO;
    
    [sHud show:YES];
    [sHud hide:YES afterDelay:1.0f];
}

- (void) cancelRequest:(ASIHTTPRequest*)aRequest
{
    [aRequest setDelegate:nil];
    [aRequest cancel];
}

-(ASIHTTPRequest *)asynLoadByURLStr:(NSString *)aURLStr withCachePolicy:(E_CACHE_POLICY)aCachePolicy
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

-(NSData *)loadURLToData:(NSString *)dataURL
{
    NSURL *url = [NSURL URLWithString:dataURL];
    
    ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    
    if (!error) {
        
        NSData *response_data = [request responseData];
        return response_data;

    }
    return nil;
}

-(void)roundNaviationBar
{
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    navBar.tintColor = navBar.gradientEndColor;
    navBar.roundedCornerRadius = 8;
}

-(void)showAlert:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    
    UIAlertView  *alert;
    
    if (otherButtonTitle==nil) {
        alert  = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
        
    }else{
        alert  = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles: otherButtonTitle,nil];
    }
    
    [alert setDelegate:self];
    [alert show];
    alert =nil;
    
}
@end
