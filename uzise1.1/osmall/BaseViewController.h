//
//  BaseViewController.h
//  uzise
//
//  Created by Wen Shane on 13-4-25.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController<MBProgressHUDDelegate>
{
    NSMutableArray* mRequests;
    MBProgressHUD* mHud;
    UIView* mDarkenView;

}

@property (nonatomic, strong)     NSMutableArray* mRequests;
@property (nonatomic, strong)     MBProgressHUD* mHud;
@property (nonatomic, strong)     UIView* mDarkenView;
- (void) showHud;
- (void) hideHud;
- (void) hideHudWithNotice:(NSString*)aNotice afterDelay:(NSTimeInterval)aSeconds;

@end
