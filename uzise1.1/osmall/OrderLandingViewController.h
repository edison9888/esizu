//
//  ShoppingOrderViewController.h
//  uzise
//
//  Created by edward on 12-10-26.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UAModalPanel.h"
#import "BaseViewController.h"
#import "AddressSettingDelegate.h"


@interface OrderLandingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UAModalPanelDelegate, AddressSettingDelegate>

- (id) initWithTotalPrice:(double)aTotalPrice;

@property(nonatomic,strong)NSMutableDictionary *shopping_dict;

@property NSInteger select_address_index;

@property(nonatomic,copy)NSString  *mSelectedAddressID;

@end
