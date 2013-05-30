//
//  MyAlipay.h
//  uzise
//
//  Created by Wen Shane on 13-5-29.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAlipay : NSObject<UIAlertViewDelegate>


+ (MyAlipay*) shared;
- (void) startPayWithOrderNo:(NSString*)aOrderNo productName:(NSString*)aProductName productDesp:(NSString*)aProductDesp amount:(double)aAmount;

@end
