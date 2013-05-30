

#import "NewsBean.h"

@implementation NewsBean
@synthesize newsid,date,title,author,contentURL;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:newsid forKey:@"newsid"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:author forKey:@"author"];
    [aCoder encodeObject:contentURL forKey:@"contentURL"];
    [aCoder encodeObject:date forKey:@"date"];
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    newsid= [aDecoder decodeIntegerForKey:@"newsid"];
    date= [aDecoder decodeObjectForKey:@"date"];
    title= [aDecoder decodeObjectForKey:@"title"];
    author= [aDecoder decodeObjectForKey:@"author"];
    contentURL=[aDecoder decodeObjectForKey:@"contentURL"];
    
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id news = [[[self class] allocWithZone: zone] init];
    [news setNewsid:(newsid)];
    [news setTitle:title];
    [news setDate:date];
    [news setAuthor:author];
    [news setContentURL:contentURL];
    return news; 
}
@end
