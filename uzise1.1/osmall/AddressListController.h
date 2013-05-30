//
//  UserAddressViewController.h
//  uzise
//
//  Created by edward on 12-10-27.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "AddressSettingDelegate.h"



@interface AddressListController : BaseTableViewController<AddressSettingDelegate>


- (id) initWithAddressList:(NSArray*)aAddressList andSelectedAddressID:(NSString*)aSelectedAddressID;
- (id) initWithSelectedAddressID:(NSString*)aSelectedAddressID;



@property (weak) id<AddressSettingDelegate> mDelegate;

@end
