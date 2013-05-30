//
//  BaseViewController.m
//  uzise
//
//  Created by Wen Shane on 13-4-25.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIHTTPRequest.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize mRequests;
@synthesize mHud;
@synthesize mDarkenView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mRequests = [NSMutableArray arrayWithCapacity:3];
        self.mDarkenView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.mDarkenView.backgroundColor = [UIColor blackColor];
        self.mDarkenView.alpha = 0.3;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super viewDidUnload];
    [self hideHud];
    
    [self.mHud removeFromSuperview];
    self.mHud = nil;
    
    for (ASIHTTPRequest* sRequest in self.mRequests)
    {
        if ([sRequest isKindOfClass:[ASIHTTPRequest class]])
        {
            [sRequest setDelegate:nil];
            [sRequest cancel];
        }
    }

}

- (void) showHud
{
    MBProgressHUD* sHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:sHUD];
    sHUD.userInteractionEnabled = NO;
    sHUD.delegate = self;
    [sHUD show:YES];
    self.mHud = sHUD;
}

- (void) hideHud
{
    [self.mHud hide:YES];
}

- (void) hideHudWithNotice:(NSString*)aNotice afterDelay:(NSTimeInterval)aSeconds
{
    self.mHud.labelText = aNotice;
    [self.mHud hide:YES afterDelay:aSeconds];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.mHud removeFromSuperview];
    self.mHud = nil;
}


@end
