//
//  OrderBean.m
//  uzise
//
//  Created by edward on 12-10-17.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "OrderBean.h"

@implementation OrderBean
@synthesize createTime,orderId,orderNumber,orderStatus,payMode,toPrice,user,product_list,product_imageview_list,address,area,city,deliverTime,freight,invoiceContent,invoiceName,isInvoice,needPayMoney,note,order_Status,userAddress,orderDetails,pay_Mode,payedMoney,preferentialMoney,province,sendType,useBonus,transactionTotalPrice;


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:createTime forKey:@"createTime"];
    [aCoder encodeObject:orderId forKey:@"orderId"];
    [aCoder encodeObject:orderNumber forKey:@"orderNumber"];
    [aCoder encodeObject:orderStatus forKey:@"orderStatus"];
    [aCoder encodeObject:payMode forKey:@"payMode"];
    [aCoder encodeObject:user forKey:@"user"];
    [aCoder encodeObject:product_list forKey:@"product_list"];
    [aCoder encodeObject:product_imageview_list forKey:@"product_imageview_list"]; 
    [aCoder encodeDouble:toPrice forKey:@"toPrice"];
    [aCoder encodeDouble:transactionTotalPrice forKey:@"transactionTotalPrice"];
    
    [aCoder encodeInteger:useBonus forKey:@"useBonus"];
    [aCoder encodeDouble:preferentialMoney forKey:@"preferentialMoney"];
    [aCoder encodeDouble:needPayMoney forKey:@"needPayMoney"];
    [aCoder encodeDouble:freight forKey:@"freight"];
    [aCoder encodeDouble:payedMoney forKey:@"payedMoney"];
    [aCoder encodeBool:isInvoice forKey:@"isInvoice"];
    [aCoder encodeObject:address forKey:@"address"];
    [aCoder encodeObject:area forKey:@"area"];
    [aCoder encodeObject:city forKey:@"city"];
    [aCoder encodeObject:deliverTime forKey:@"deliverTime"];
    [aCoder encodeObject:invoiceContent forKey:@"invoiceContent"];
    [aCoder encodeObject:invoiceName forKey:@"invoiceName"];
    [aCoder encodeObject:note forKey:@"note"];
    [aCoder encodeObject:order_Status forKey:@"order_Status"];
    [aCoder encodeObject:userAddress forKey:@"userAddress"];
    [aCoder encodeObject:orderDetails forKey:@"orderDetails"];
    [aCoder encodeObject:pay_Mode forKey:@"pay_Mode"];
    [aCoder encodeObject:province forKey:@"province"];
    [aCoder encodeObject:sendType forKey:@"sendType"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    createTime= [aDecoder decodeObjectForKey:@"createTime"] ;
    orderId= [aDecoder decodeObjectForKey:@"orderId"];
    orderNumber= [aDecoder decodeObjectForKey:@"orderNumber"];
    orderStatus= [aDecoder decodeObjectForKey:@"orderStatus"];
    payMode= [aDecoder decodeObjectForKey:@"payMode"];
    user= [aDecoder decodeObjectForKey:@"user"];
    product_list= [aDecoder decodeObjectForKey:@"product_list"];
    product_imageview_list= [aDecoder decodeObjectForKey:@"product_imageview_list"];
    toPrice= [aDecoder decodeDoubleForKey:@"toPrice"];
    transactionTotalPrice= [aDecoder decodeDoubleForKey:@"transactionTotalPrice"];
   
    preferentialMoney= [aDecoder decodeDoubleForKey:@"preferentialMoney"];
    needPayMoney= [aDecoder decodeDoubleForKey:@"needPayMoney"];
    freight= [aDecoder decodeDoubleForKey:@"freight"];
    payedMoney= [aDecoder decodeDoubleForKey:@"payedMoney"];
    useBonus= [aDecoder decodeIntegerForKey:@"useBonus"];
    isInvoice= [aDecoder decodeBoolForKey:@"isInvoice"];
    
    address= [aDecoder decodeObjectForKey:@"address"];
    area= [aDecoder decodeObjectForKey:@"area"];
    city= [aDecoder decodeObjectForKey:@"city"];
    deliverTime= [aDecoder decodeObjectForKey:@"deliverTime"];
    invoiceContent= [aDecoder decodeObjectForKey:@"invoiceContent"];
    invoiceName= [aDecoder decodeObjectForKey:@"invoiceName"];
    order_Status= [aDecoder decodeObjectForKey:@"order_Status"];
    userAddress= [aDecoder decodeObjectForKey:@"userAddress"];
    orderDetails= [aDecoder decodeObjectForKey:@"orderDetails"];
    pay_Mode= [aDecoder decodeObjectForKey:@"pay_Mode"];
    province= [aDecoder decodeObjectForKey:@"province"];
    sendType= [aDecoder decodeObjectForKey:@"sendType"];
    note= [aDecoder decodeObjectForKey:@"note"];
    
    
   
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newOrder = [[[self class] allocWithZone: zone] init];
    
    [newOrder setOrderId:orderId];
    [newOrder setOrderNumber:orderNumber];
    [newOrder setOrderStatus:orderStatus];
    [newOrder setPayMode:payMode];
    [newOrder setCreateTime:createTime];
    [newOrder setUser:user];
    [newOrder setProduct_list:product_list];
    [newOrder setToPrice:toPrice];
    [newOrder setProduct_imageview_list:product_imageview_list];
    
    [newOrder setPreferentialMoney:preferentialMoney];
    [newOrder setNeedPayMoney:needPayMoney];
    [newOrder setFreight:freight];
    [newOrder setPayedMoney:payedMoney];
    [newOrder setUseBonus:useBonus];
    [newOrder setIsInvoice:isInvoice];
    
    [newOrder setAddress:address];
    [newOrder setArea:area];
    [newOrder setCity:city];
    [newOrder setDeliverTime:deliverTime];
    [newOrder setInvoiceContent:invoiceContent];
    [newOrder setInvoiceName:invoiceName];
    [newOrder setOrder_Status:order_Status];
    [newOrder setUserAddress:userAddress];
    [newOrder setOrderDetails:orderDetails];
    [newOrder setPay_Mode:pay_Mode];
    [newOrder setProvince:province];
    [newOrder setSendType:sendType];
    [newOrder setNote:note];
    [newOrder setTransactionTotalPrice:transactionTotalPrice];
    

    return newOrder;
}

@end
