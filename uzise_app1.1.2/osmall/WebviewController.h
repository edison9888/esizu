//
//  WebviewController.h
//  uzise
//
//  Created by Wen Shane on 13-4-25.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WebviewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *webView; 
}
@property(nonatomic,copy) NSString *url;

@end
