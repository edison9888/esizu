//
//  UserRegionSelectViewController.h
//  uzise
//
//  Created by edward on 12-11-1.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "UATitledModalPanel.h"

#import "PrettyKit.h"

@interface RegionSelectionController : UATitledModalPanel<UITableViewDataSource,UITableViewDelegate>{
    
    UIButton *nextButton;
    
    UITableView *table;
    
    UIView *view;
    
    NSArray *province_list;
    
    NSDictionary *province_dict;
    
    NSArray *city_list;
    
    NSDictionary *city_dict;
    
    NSArray *area_list;
    
    NSDictionary *area_dict;
    
    PrettyToolbar *toolbar;
    
    NSIndexPath *currentIndexPath;
    
    NSIndexPath *beforeIndexPath;
    
    NSInteger province_rowindex;
    
    NSInteger city_rowindex;
    
    NSInteger area_rowindex;
    
    NSMutableDictionary *newaddress_dict;
}

@property(nonatomic,strong)NSMutableDictionary *shop_dict;

@property(nonatomic,strong)NSMutableDictionary *newaddress_dict;

@property(nonatomic,strong)UITableView *table;;

@property(nonatomic,strong)NSIndexPath *currentIndexPath;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title dict:(NSMutableDictionary *)dict;

-(void)nextTableViewData:(UIButton *)sender;
@end
