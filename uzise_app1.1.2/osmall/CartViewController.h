//
//  ShoppingCartViewController.h
//  uzise
//
//  Created by edward on 12-10-24.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

-(void)loadData;

-(void)showOrderViewContoller;

@end
