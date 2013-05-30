//
//  SendTypeBean.h
//  uzise
//
//  Created by edward on 12-10-18.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendTypeBean : NSObject<NSCopying,NSCoding>

@property(nonatomic,copy)NSString *SendTypeName;

@property NSInteger SendTypeID;


@end


@interface OrderStatusBean : NSObject<NSCopying,NSCoding>

@property(nonatomic,copy)NSString *orderStatusName;

@property NSInteger orderStatusID;

@end


@interface OrderDetailsBean : NSObject<NSCopying,NSCoding>

@property(nonatomic,copy)NSString *productNo;

@property NSInteger productId;

@property(nonatomic,copy)NSString *productName;
//实际成交价
@property double transactionPrice;

@property NSInteger quantity;
//实际成交总价
@property double transactionTotalPrice;

@property(nonatomic,strong)UIImageView *product_pic;

@end

@interface ProvinceBean : NSObject<NSCopying,NSCoding>

@property(nonatomic,copy)NSString *ProvinceName;

@property(nonatomic,copy)NSString *ProvinceID;

@end

@interface CityBean : NSObject<NSCopying,NSCoding>

@property(nonatomic,copy)NSString *CityName;

@property(nonatomic,copy)NSString *CityID;

@property(nonatomic,copy)NSString *provinceId;

@end

@interface AreaBean : NSObject<NSCopying,NSCoding>

@property(nonatomic,copy)NSString *AreaName;

@property(nonatomic,copy)NSString *AreaID;

@property(nonatomic,copy)NSString *CityID;

@end

@interface PayModeBean : NSObject<NSCopying,NSCoding>

@property(nonatomic,copy)NSString *PayModeName;

@property NSInteger PayModeID;

@end


@interface UserAddressBean : NSObject<NSCopying,NSCoding>

@property(nonatomic,copy)NSString *addressId;

@property(nonatomic,copy)NSString *consignee;

@property(nonatomic,copy)NSString *telphone;

@property(nonatomic,copy)NSString *mobile;

@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)NSString *postcode;

@property(nonatomic,strong)ProvinceBean *provence;

@property(nonatomic,strong)CityBean *city;

@property(nonatomic,strong)AreaBean *area;

@end
