//
//  CommentBean.m
//  uzise
//
//  Created by edward on 12-10-15.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "CommentBean.h"

@implementation CommentBean
@synthesize comment,commentId,dateTime,start,userName;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:comment forKey:@"comment"];
    [aCoder encodeObject:commentId forKey:@"commentId"];
    [aCoder encodeObject:dateTime forKey:@"dateTime"];
    [aCoder encodeObject:userName forKey:@"userName"];
    [aCoder encodeInteger:start forKey:@"start"];
       
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    comment= [aDecoder decodeObjectForKey:@"comment"] ;
    start= [aDecoder decodeIntegerForKey:@"start"];
    dateTime= [aDecoder decodeObjectForKey:@"dateTime"];
    userName= [aDecoder decodeObjectForKey:@"userName"];
    commentId= [aDecoder decodeObjectForKey:@"commentId"];
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newComment = [[[self class] allocWithZone: zone] init];
    [newComment setCommentId:commentId];
    [newComment setComment:comment];
    [newComment setStart:start];
    [newComment setUserName:userName];
    [newComment setDateTime:dateTime];
    return newComment;
}



@end
