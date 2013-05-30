//
//  CartManager.h
//  uzise
//
//  Created by Wen Shane on 13-4-26.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductBean.h"

@interface CartManager : NSObject

+ (CartManager*) shared;

//if there are already products with same product id, just add shop count to them.
- (BOOL) addProduct:(ProductBean*)aProductBean;

//do nothing if there is no product with the required product ID.
- (BOOL) removeProductByID:(NSInteger)aProductID;

//if there is no product with aProductID, just do nothing.
- (BOOL) changeShopCount:(NSInteger)aQuantity byProductID:(NSInteger)aProductID;

//
- (BOOL) clearCart;

//
- (BOOL) replaceWithItems:(NSArray*)aItems;



//an array of product beans if any
- (NSArray*) getAllCartProducts;
- (NSInteger) getCartProductsCount;


//
- (void) pushNotification;

@end
