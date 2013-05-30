//
//  AddressSettingDelegate.h
//  uzise
//
//  Created by Wen Shane on 13-5-7.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendTypeBean.h"

@protocol AddressSettingDelegate <NSObject>

- (void) changedWithModifiedAddress:(UserAddressBean*)aModifiedAddress;
- (void) changeWithNewAddress:(UserAddressBean*)aNewAddress;

- (void) changeWithSelectAddress:(UserAddressBean*)aNewAddress;

@end
