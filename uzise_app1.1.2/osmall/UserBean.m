

#import "UserBean.h"

@implementation UserBean

@synthesize userid,mobile,email,sex,address,password,realName,telphone,userName,levelName,points,appkey,isLogin;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:email forKey:@"email"];
    [aCoder encodeObject:userName forKey:@"userName"];
    [aCoder encodeObject:mobile forKey:@"mobile"];
    [aCoder encodeObject:address forKey:@"address"];
    [aCoder encodeObject:password forKey:@"password"];
    [aCoder encodeObject:realName forKey:@"realName"];
    [aCoder encodeObject:telphone forKey:@"telphone"];
    [aCoder encodeObject:levelName forKey:@"levelName"];
    [aCoder encodeInteger:sex forKey:@"sex"];
    [aCoder encodeInteger:userid forKey:@"userid"];
    [aCoder encodeInteger:points forKey:@"points"];
    [aCoder encodeObject:appkey forKey:@"appkey"];
    [aCoder encodeBool:isLogin forKey:@"isLogin"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    email= [aDecoder decodeObjectForKey:@"email"] ;
    sex= [aDecoder decodeIntegerForKey:@"sex"];
    userid= [aDecoder decodeIntegerForKey:@"userid"];
    mobile= [aDecoder decodeObjectForKey:@"mobile"];
    address= [aDecoder decodeObjectForKey:@"address"];
    password= [aDecoder decodeObjectForKey:@"password"];
    realName= [aDecoder decodeObjectForKey:@"realName"];
    telphone= [aDecoder decodeObjectForKey:@"telphone"];
    userName= [aDecoder decodeObjectForKey:@"userName"];
    levelName= [aDecoder decodeObjectForKey:@"levelName"];
    points= [aDecoder decodeIntegerForKey:@"points"];
    appkey= [aDecoder decodeObjectForKey:@"appkey"];
    isLogin = [aDecoder decodeBoolForKey:@"isLogin"];
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newUser = [[[self class] allocWithZone: zone] init];
    
    [newUser setEmail:email];
    [newUser setUserName:userName];
    [newUser setMobile:mobile];
    [newUser setAddress:address];
    [newUser setPassword:password];
    [newUser setRealName:realName];
    [newUser setTelphone:telphone];
    [newUser setLevelName:levelName];
    [newUser setSex:sex];
    [newUser setUserid:userid];
    [newUser setPoints:points];
    [newUser setAppkey:appkey];
    [newUser setIsLogin:isLogin];
    return newUser; 
}


@end
