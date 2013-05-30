//
//  HomeBean.h
//  uzise
//
//  Created by edward on 12-10-8.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeBean :  NSObject<NSCopying,NSCoding>

@property NSInteger sequence;

@property(nonatomic,copy)NSString *product_name;

@property NSInteger product_id;

@property(nonatomic,copy)NSString *pic_url;

@property(nonatomic,strong)UIView *view;

@end
