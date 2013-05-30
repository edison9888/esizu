//
//  CartProduct.h
//  uzise
//
//  Created by Wen Shane on 13-4-26.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CartProduct : NSManagedObject

@property (nonatomic, retain) NSNumber * productID;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSString * productTypeName;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * retailPrice;
@property (nonatomic, retain) NSNumber * shopPrice;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSString * productNO;
@property (nonatomic, retain) NSNumber * productTypeID;
@property (nonatomic, retain) NSNumber * shopCount;
@property (nonatomic, retain) NSNumber * sellCount;
@property (nonatomic, retain) NSString * introduce;
@property (nonatomic, retain) NSNumber * comments;
@property (nonatomic, retain) NSString * productURL;

@end
