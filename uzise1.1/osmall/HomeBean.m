//
//  HomeBean.m
//  uzise
//
//  Created by edward on 12-10-8.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "HomeBean.h"

@implementation HomeBean
@synthesize pic_url,product_id,product_name,sequence,view;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:product_name forKey:@"product_name"];
    [aCoder encodeObject:pic_url forKey:@"pic_url"];
    [aCoder encodeInteger:product_id forKey:@"product_id"];
    [aCoder encodeInteger:sequence forKey:@"sequence"];
    [aCoder encodeObject:view forKey:@"view"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    product_name= [aDecoder decodeObjectForKey:@"product_name"] ;
    product_id= [aDecoder decodeIntegerForKey:@"product_id"];
    pic_url= [aDecoder decodeObjectForKey:@"pic_url"];
    sequence= [aDecoder decodeIntegerForKey:@"sequence"];
    view =[aDecoder decodeObjectForKey:@"view"] ;
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id homebean = [[[self class] allocWithZone: zone] init];
    
    [homebean setProduct_id:product_id];
    [homebean setProduct_name:product_name];
    [homebean setSequence:sequence];
    [homebean setPic_url:pic_url];
    [homebean setView:view];
    return homebean;
}


@end
