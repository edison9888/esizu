//
//  WebviewController.m
//  uzise
//
//  Created by Wen Shane on 13-4-25.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//



#import "WebviewController.h"

#import "Constant.h"
#import "ASIWebPageRequest.h"
#import "ASIDownloadCache.h"
#import "UIWebView+Clean.h"

@interface WebviewController ()

@end

@implementation WebviewController
@synthesize url;

-(void)webreload
{
    if (webView)
    {
        [webView reload];
    }
    else
    {
        webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height)];
        [webView setDelegate:self];
        [self.view addSubview:webView];
        
        NSURLRequest* sRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
        [webView loadRequest:sRequest];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [webView cleanForDealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self loadURL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height)];
    [webView setDelegate:self];
    [webView setScalesPageToFit:YES];
    [self.view addSubview:webView];
    NSURLRequest* sRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    [webView loadRequest:sRequest];

    [self showHud];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    webView =nil;
    url=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)webViewDidFinishLoad:(UIWebView *)uiwebView
{
    [self hideHud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud];
}

//- (void) loadURL
//{
//    ASIWebPageRequest* sASIWebPageRequest = [ASIWebPageRequest requestWithURL:[NSURL URLWithString:url]];
//    [sASIWebPageRequest setDelegate:self];
//    [sASIWebPageRequest setDidFinishSelector:@selector(webPageFetchSucceeded:)];
//    [sASIWebPageRequest setUrlReplacementMode:ASIReplaceExternalResourcesWithData];
//
//    [sASIWebPageRequest setDownloadCache:[ASIDownloadCache sharedCache]];
//    [sASIWebPageRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
//    [sASIWebPageRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
//    [sASIWebPageRequest setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:sASIWebPageRequest]];
////    [sASIWebPageRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
//    [sASIWebPageRequest startAsynchronous];
//}
//
//- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
//{
//    //encoding not right, may be because of the improper encoding setting of the web page.
//    NSString *response = [NSString stringWithContentsOfFile:
//                          [theRequest downloadDestinationPath] encoding:theRequest.responseEncoding error:nil];
//    [webView loadHTMLString:response baseURL:[theRequest url]];
//}
//

@end
