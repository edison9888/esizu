//
//  OrderBean.h
//  uzise
//
//  Created by edward on 12-10-17.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserBean,ProductBean,UserAddressBean,PayModeBean,ProvinceBean,CityBean,AreaBean,SendTypeBean,OrderDetailsBean,OrderStatusBean;
@interface OrderBean : NSObject<NSCopying,NSCoding>

@property(nonatomic,copy)NSDate *createTime;

@property(nonatomic,copy)NSString *orderId;

@property(nonatomic,copy)NSString *orderNumber;

@property(nonatomic,copy)NSString *orderStatus;

@property(nonatomic,copy)NSString *payMode;

@property(nonatomic,copy)NSString *deliverTime;

@property(nonatomic,strong)UserBean *user;

@property(nonatomic,strong)UserAddressBean *userAddress;

@property(nonatomic,strong)PayModeBean *pay_Mode;

@property(nonatomic,strong)ProvinceBean *province;

@property(nonatomic,strong)CityBean *city;

@property(nonatomic,strong)AreaBean *area;

@property(nonatomic,strong)SendTypeBean *sendType;

@property(nonatomic,strong)NSArray *orderDetails;

@property(nonatomic,strong)OrderStatusBean *order_Status;

@property(nonatomic,strong)NSArray *product_list;

@property(nonatomic,strong)NSArray *product_imageview_list;

@property double toPrice;

@property double freight;

@property BOOL isInvoice;

@property(nonatomic,copy)NSString *invoiceContent;

@property(nonatomic,copy)NSString *invoiceName;

@property(nonatomic,copy)NSString *address;
//优惠金额
@property double preferentialMoney;
//应收金额
@property double needPayMoney;
//客户留言
@property(nonatomic,copy)NSString *note;

//已经支付的金额
@property double payedMoney;
//积分换购
@property NSInteger useBonus;

@property double transactionTotalPrice;


@end
