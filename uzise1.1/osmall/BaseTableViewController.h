//
//  BaseTableViewController.h
//  uzise
//
//  Created by Wen Shane on 13-4-25.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"


@interface BaseTableViewController : UITableViewController<MBProgressHUDDelegate>
{
    NSMutableArray* mRequests;
    MBProgressHUD* mHud;
    BOOL* mIsLoading;
}

@property (nonatomic, strong)     NSMutableArray* mRequests;
@property (nonatomic, strong)     MBProgressHUD* mHud;
@property (nonatomic, assign)     BOOL* mIsLoading;

- (void) showHud;
- (void) hideHud;
@end
