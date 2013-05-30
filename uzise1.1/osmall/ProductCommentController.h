//
//  CommentViewController.h
//  uzise
//
//  Created by edward on 12-10-15.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@class CommentBean;
@interface ProductCommentController : BaseTableViewController
@property NSInteger comment_product_id;

@property(nonatomic,copy) NSString *product_name;
@end
