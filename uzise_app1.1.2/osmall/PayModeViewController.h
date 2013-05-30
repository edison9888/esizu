//
//  OrderPayModeViewController.h
//  uzise
//
//  Created by edward on 12-11-6.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "UATitledModalPanel.h"

@interface PayModeViewController : UATitledModalPanel<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *table;
    
    NSDictionary *paymode_dict;
    
    NSDictionary *paymode_temp_dict;
    
    NSIndexPath *currentIndexPath;
    
    NSIndexPath *beforeIndexPath;
    
    NSArray *paymode_list;
    
    NSInteger paymodeIndex;
    
    UIView *view;
   
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title dict:(NSMutableDictionary *)dict;

@property(nonatomic,copy)NSString *payModeKey;

@end
