//
//  SendTypeBean.m
//  uzise
//
//  Created by edward on 12-10-18.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "SendTypeBean.h"

@implementation SendTypeBean
@synthesize SendTypeID,SendTypeName;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:SendTypeName forKey:@"SendTypeName"];
    [aCoder encodeInteger:SendTypeID forKey:@"SendTypeID"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    SendTypeName= [aDecoder decodeObjectForKey:@"SendTypeName"] ;
    SendTypeID= [aDecoder decodeIntegerForKey:@"SendTypeID"];
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newSendType = [[[self class] allocWithZone: zone] init];
    
    [newSendType setSendTypeID:SendTypeID];
    [newSendType setSendTypeName:SendTypeName];
    
    return newSendType;
}

@end

@implementation OrderStatusBean;
@synthesize orderStatusID,orderStatusName;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:orderStatusName forKey:@"orderStatusName"];
    [aCoder encodeInteger:orderStatusID forKey:@"orderStatusID"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    orderStatusName= [aDecoder decodeObjectForKey:@"orderStatusName"] ;
    orderStatusID= [aDecoder decodeIntegerForKey:@"orderStatusID"];
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newOrderStatus = [[[self class] allocWithZone: zone] init];
    
    [newOrderStatus setOrderStatusID:orderStatusID];
    [newOrderStatus setOrderStatusName:orderStatusName];
    
    return newOrderStatus;
}

@end

@implementation OrderDetailsBean
@synthesize productId,productName,productNo,quantity,transactionPrice,transactionTotalPrice,product_pic;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:productName forKey:@"productName"];
    [aCoder encodeObject:productNo forKey:@"productNo"];
    [aCoder encodeObject:product_pic forKey:@"product_pic"];
    [aCoder encodeInteger:productId forKey:@"productId"];
    [aCoder encodeInteger:quantity forKey:@"quantity"];
    [aCoder encodeDouble:transactionPrice forKey:@"transactionPrice"];
    [aCoder encodeDouble:transactionTotalPrice forKey:@"transactionTotalPrice"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    productName= [aDecoder decodeObjectForKey:@"productName"] ;
    productNo= [aDecoder decodeObjectForKey:@"productNo"] ;
    product_pic= [aDecoder decodeObjectForKey:@"product_pic"] ;
    productId= [aDecoder decodeIntegerForKey:@"productId"];
    quantity= [aDecoder decodeIntegerForKey:@"quantity"];
    transactionPrice= [aDecoder decodeDoubleForKey:@"transactionPrice"];
    transactionTotalPrice= [aDecoder decodeDoubleForKey:@"transactionTotalPrice"];
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newOrderOrderDetails = [[[self class] allocWithZone: zone] init];
    
    [newOrderOrderDetails setProductId:productId];
    [newOrderOrderDetails setProductNo:productNo];
    [newOrderOrderDetails setProductName:productName];
    [newOrderOrderDetails setProduct_pic:product_pic];
    [newOrderOrderDetails setQuantity:quantity];
    [newOrderOrderDetails setTransactionPrice:transactionPrice];
    [newOrderOrderDetails setTransactionTotalPrice:transactionTotalPrice];
    
    return newOrderOrderDetails;
}
@end

@implementation ProvinceBean
@synthesize ProvinceID,ProvinceName;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:ProvinceName forKey:@"ProvinceName"];
    [aCoder encodeObject:ProvinceID forKey:@"ProvinceID"];
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    ProvinceName= [aDecoder decodeObjectForKey:@"ProvinceName"] ;
    ProvinceID= [aDecoder decodeObjectForKey:@"ProvinceID"];
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newProvince = [[[self class] allocWithZone: zone] init];
    
    [newProvince setProvinceID:ProvinceID];
    [newProvince setProvinceName:ProvinceName];
    
    return newProvince;
}

@end


@implementation CityBean
@synthesize CityID,CityName,provinceId;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:CityName forKey:@"CityName"];
    [aCoder encodeObject:CityID forKey:@"CityID"];
    [aCoder encodeObject:provinceId forKey:@"provinceId"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    CityName= [aDecoder decodeObjectForKey:@"CityName"] ;
    CityID= [aDecoder decodeObjectForKey:@"CityID"];
    provinceId= [aDecoder decodeObjectForKey:@"provinceId"];

    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newCity = [[[self class] allocWithZone: zone] init];
    
    [newCity setCityID:CityID];
    [newCity setCityName:CityName];
    [newCity setProvinceID:provinceId];
    
    return newCity;
}

@end

@implementation AreaBean
@synthesize AreaID,AreaName;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:AreaName forKey:@"AreaName"];
    [aCoder encodeObject:AreaID forKey:@"AreaID"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    AreaName= [aDecoder decodeObjectForKey:@"AreaName"] ;
    AreaID= [aDecoder decodeObjectForKey:@"AreaID"];
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newArea = [[[self class] allocWithZone: zone] init];
    
    [newArea setAreaID:AreaID];
    [newArea setAreaName:AreaName];
    
    return newArea;
}

@end

@implementation PayModeBean
@synthesize PayModeID,PayModeName;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:PayModeName forKey:@"PayModeName"];
    [aCoder encodeInteger:PayModeID forKey:@"PayModeID"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    PayModeName= [aDecoder decodeObjectForKey:@"PayModeName"] ;
    PayModeID= [aDecoder decodeIntegerForKey:@"PayModeID"];
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newPayMode = [[[self class] allocWithZone: zone] init];
    
    [newPayMode setPayModeID:PayModeID];
    [newPayMode setPayModeName:PayModeName];
    
    return newPayMode;
}

@end

@implementation UserAddressBean
@synthesize address,area,city,consignee,mobile,postcode,provence,telphone,addressId;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:address forKey:@"address"];
    [aCoder encodeObject:area forKey:@"area"];
    [aCoder encodeObject:city forKey:@"city"];
    [aCoder encodeObject:consignee forKey:@"consignee"];
    [aCoder encodeObject:mobile forKey:@"mobile"];
    [aCoder encodeObject:postcode forKey:@"postcode"];
    [aCoder encodeObject:provence forKey:@"provence"];
    [aCoder encodeObject:telphone forKey:@"telphone"];
    [aCoder encodeObject:addressId forKey:@"addressId"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    address= [aDecoder decodeObjectForKey:@"address"] ;
    area= [aDecoder decodeObjectForKey:@"area"] ;
    city= [aDecoder decodeObjectForKey:@"city"] ;
    consignee= [aDecoder decodeObjectForKey:@"consignee"] ;
    mobile= [aDecoder decodeObjectForKey:@"mobile"] ;
    postcode= [aDecoder decodeObjectForKey:@"postcode"] ;
    provence= [aDecoder decodeObjectForKey:@"provence"] ;
    telphone= [aDecoder decodeObjectForKey:@"telphone"] ;
    addressId= [aDecoder decodeObjectForKey:@"addressId"] ;
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newUserAddress = [[[self class] allocWithZone: zone] init];
    
    [newUserAddress setAddress:address];
    [newUserAddress setArea:area];
    [newUserAddress setCity:city];
    [newUserAddress setConsignee:consignee];
    [newUserAddress setMobile:mobile];
    [newUserAddress setPostcode:postcode];
    [newUserAddress setProvence:provence];
    [newUserAddress setTelphone:telphone];
    [newUserAddress setAddressId:addressId];
    return newUserAddress;
}
@end



