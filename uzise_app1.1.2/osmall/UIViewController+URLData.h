//
//  UIViewController+URLData.h
//  uzise
//
//  Created by edward on 12-10-7.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIHttpWrapper.h"

@interface UIViewController (URLData)<ASIHTTPRequestDelegate>

-(ASIHTTPRequest *)synLoadByURLStr:(NSString *)aURLStr withCachePolicy:(E_CACHE_POLICY)aCachePolicy withNotice:(BOOL)aNeedNotice;

-(ASIHTTPRequest *)synLoadByURLStr:(NSString *)dataURL withCachePolicy:(E_CACHE_POLICY)aCachePolicy;
-(ASIHTTPRequest *)asynLoadByURLStr:(NSString *)aURLStr withCachePolicy:(E_CACHE_POLICY)aCachePolicy;


-(NSData *)loadURLToData:(NSString *)dataURL;

-(void)roundNaviationBar;

-(void)showAlert:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

- (void)showNotice:(NSString*)aNoticeStr;
- (void) cancelRequest:(ASIHTTPRequest*)aRequest;

@end

