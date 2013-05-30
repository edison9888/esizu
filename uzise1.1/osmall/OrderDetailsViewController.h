//
//  OrderDetailsViewController.h
//  uzise
//
//  Created by edward on 12-10-18.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

#import "OrderBean.h"

@interface OrderDetailsViewController : BaseTableViewController
{
    OrderBean *order;
}

- (id) initWithOrderID:(NSString*)aOrderID;

@property(nonatomic,copy)NSString *user_appkey;

@property(nonatomic,copy)NSString *order_id;


@end
