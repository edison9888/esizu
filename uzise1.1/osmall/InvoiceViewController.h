//
//  OrderInvoiceViewController.h
//  uzise
//
//  Created by edward on 12-11-6.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong)NSMutableDictionary *shopping_dict;

@end
