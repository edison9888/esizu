//
//  CommentBean.h
//  uzise
//
//  Created by edward on 12-10-15.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentBean : NSObject<NSCopying,NSCoding>

@property NSInteger start;

@property(nonatomic,copy)NSString *comment;

@property(nonatomic,copy)NSString *dateTime;

@property(nonatomic,copy)NSString *userName;

@property(nonatomic,copy)NSString *commentId;

@end
