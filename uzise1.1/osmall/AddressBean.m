

#import "AddressBean.h"

@implementation AddressBean
@synthesize userid,addressid,city,code,district,province,road;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:city forKey:@"email"];
    [aCoder encodeObject:code forKey:@"userName"];
    [aCoder encodeObject:district forKey:@"mobile"];
    [aCoder encodeObject:province forKey:@"address"];
    [aCoder encodeObject:road forKey:@"password"];
    [aCoder encodeInteger:userid forKey:@"userid"];
    [aCoder encodeInteger:addressid forKey:@"points"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    city= [aDecoder decodeObjectForKey:@"city"] ;
    addressid= [aDecoder decodeIntegerForKey:@"addressid"];
    userid= [aDecoder decodeIntegerForKey:@"userid"];
    district= [aDecoder decodeObjectForKey:@"district"];
    province= [aDecoder decodeObjectForKey:@"province"];
    road= [aDecoder decodeObjectForKey:@"road"];
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newAddress = [[[self class] allocWithZone: zone] init];
    [newAddress setUserid:userid];
    [newAddress setAddressid:addressid];
    [newAddress setCode:code];
    [newAddress setDistrict:district];
    [newAddress setProvince:province];
    [newAddress setRoad:road];
    [newAddress setCity:city];
    return newAddress;
}

@end
