//
//  Keychainer.h
//  uzise
//
//  Created by Wen Shane on 13-5-2.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychainer : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;


@end
