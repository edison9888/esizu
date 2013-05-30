//
//  CartManager.m
//  uzise
//
//  Created by Wen Shane on 13-4-26.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import "CartManager.h"
#import "AppDelegate.h"
#import "CartProduct.h"
#import "Global.h"

@implementation CartManager


+ (CartManager*) shared
{
    static CartManager* S_CartManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
          S_CartManager = [[self alloc] init];
    });
    
    return S_CartManager;
}


+ (AppDelegate*) getAppDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL) addProduct:(ProductBean*)aProductBean
{
    return [self addProduct:aProductBean withNotification:YES];
}

- (BOOL) addProduct:(ProductBean*)aProductBean withNotification:(BOOL)aNeedNotification
{
    CartProduct* sCartProduct = nil;
    sCartProduct = [self getExistingProductByProductID:aProductBean.productId];
    if (sCartProduct)
    {
        NSInteger sOldShopCount = sCartProduct.shopCount.integerValue;
        NSInteger sNewShopCount = aProductBean.shopcount;
        NSInteger sTotalShopCount = sOldShopCount+sNewShopCount;
        
        [sCartProduct setShopCount:[NSNumber numberWithInteger:sTotalShopCount]];
        
    }
    else
    {
        sCartProduct = (CartProduct *)[NSEntityDescription insertNewObjectForEntityForName:@"CartProduct" inManagedObjectContext:[CartManager getAppDelegate].managedObjectContext];
        
        [sCartProduct setProductID: [NSNumber numberWithInteger:aProductBean.productId]];
        [sCartProduct setProductName:aProductBean.productName];
        [sCartProduct setProductTypeName:aProductBean.productTypeName];
        [sCartProduct setPrice:[NSNumber numberWithDouble:aProductBean.price]];
        [sCartProduct setRetailPrice:[NSNumber numberWithDouble:aProductBean.retallPrice]];
        [sCartProduct setShopPrice:[NSNumber numberWithDouble:aProductBean.shopPrice]];
        [sCartProduct setQuantity:[NSNumber numberWithInteger:aProductBean.quantity]];
        [sCartProduct setDateTime:aProductBean.datetime];
        [sCartProduct setProductNO:aProductBean.productNO];
        [sCartProduct setProductTypeID:[NSNumber numberWithInteger:aProductBean.productTypeId]];
        [sCartProduct setShopCount:[NSNumber numberWithInteger:aProductBean.shopcount]];
        [sCartProduct setSellCount:[NSNumber numberWithInteger:aProductBean.sellCount]];
        [sCartProduct setIntroduce:aProductBean.introduce];
        [sCartProduct setComments:[NSNumber numberWithInteger:aProductBean.comments]];
        [sCartProduct setProductURL:aProductBean.product_url];

    }
    
    NSError* sErr = nil;
    BOOL sSuccess = [[CartManager getAppDelegate].managedObjectContext save:&sErr];
    
    if (sSuccess
        && aNeedNotification)
    {
        [self pushNotification];
    }

    return sSuccess;
}


- (BOOL) removeProductByID:(NSInteger)aProductID
{
    BOOL sSuccess = NO;

    CartProduct* sCartProduct = nil;
    sCartProduct = [self getExistingProductByProductID:aProductID];
    if (sCartProduct)
    {
        [[CartManager getAppDelegate].managedObjectContext deleteObject:sCartProduct];
        NSError* sError;
        sSuccess = [[CartManager getAppDelegate].managedObjectContext save:&sError];
    }
    
    if (sSuccess)
    {
        [self pushNotification];
    }

    return sSuccess;
}


- (BOOL) changeShopCount:(NSInteger)aQuantity byProductID:(NSInteger)aProductID
{
    BOOL sSuccess = NO;
    
    CartProduct* sCartProduct = nil;
    sCartProduct = [self getExistingProductByProductID:aProductID];
    if (aQuantity>0
        && sCartProduct)
    {
        [sCartProduct setShopCount:[NSNumber numberWithInteger:aQuantity]];
        NSError* sErr = nil;
        sSuccess = [[CartManager getAppDelegate].managedObjectContext save:&sErr];
    }
    
    if (sSuccess)
    {
        [self pushNotification];
    }
    return sSuccess;
}

- (BOOL) clearCart
{
    return [self clearCartWithNotification:YES];
}

- (BOOL) clearCartWithNotification:(BOOL)aNeedNotification
{
    NSArray* sAllProducts = [self getAllProducts];
    for (CartProduct* sProduct in sAllProducts)
    {
        [[CartManager getAppDelegate].managedObjectContext deleteObject:sProduct];
    }
    
    NSError* sError;
    BOOL sSuccess = [[CartManager getAppDelegate].managedObjectContext save:&sError];

    if (sSuccess
        && aNeedNotification)
    {
        [self pushNotification];
    }
    return sSuccess;
}

- (BOOL) replaceWithItems:(NSArray*)aItems
{
    BOOL sStatus = [self clearCartWithNotification:NO];
    
    if (sStatus)
    {
        for (ProductBean* sProductBean in aItems)
        {
            if (![self addProduct:sProductBean withNotification:NO])
            {
                return NO;
            }
        }

    }
    
    if (sStatus)
    {
        [self pushNotification];
    }
    
    return sStatus;
}

- (NSInteger) getCartProductsCount
{
    NSInteger sTotal = 0;
    NSArray* sProducts = [self getAllProducts];
    
    for (CartProduct* sCartProduct in sProducts)
    {
        sTotal += sCartProduct.shopCount.integerValue;
    }
    return sTotal;
}

- (NSArray*) getAllCartProducts
{
    NSMutableArray* sProductBeans = [NSMutableArray array];
    
    NSArray* sArrayOfCartProduct = [self getAllProducts];
    for (CartProduct* sCartProduct in sArrayOfCartProduct)
    {
        ProductBean* sProductBean = [[ProductBean alloc] init];
        
        [sProductBean setProductId: sCartProduct.productID.integerValue];
        [sProductBean setProductName:sCartProduct.productName];
        [sProductBean setProductTypeName:sCartProduct.productTypeName];
        [sProductBean setPrice:sCartProduct.price.doubleValue];
        [sProductBean setRetallPrice:sCartProduct.retailPrice.doubleValue];
        [sProductBean setShopPrice:sCartProduct.shopPrice.doubleValue];
        [sProductBean setQuantity:sCartProduct.quantity.integerValue];
        [sProductBean setDatetime:sCartProduct.dateTime];
        [sProductBean setProductNO:sCartProduct.productNO];
        [sProductBean setProductTypeId:sCartProduct.productTypeID.integerValue];
        [sProductBean setShopcount: sCartProduct.shopCount.integerValue];
        [sProductBean setSellCount: sCartProduct.sellCount.integerValue];
        [sProductBean setIntroduce: sCartProduct.introduce];
        [sProductBean setComments: sCartProduct.comments.integerValue];
        [sProductBean setProduct_url: sCartProduct.productURL];
        
        [sProductBeans addObject:sProductBean];
    }
    
    return sProductBeans;
}

//an array of CartProducts
- (NSArray*) getAllProducts
{
    
    NSFetchRequest* sFetchRequest = [[NSFetchRequest alloc] init];
    
    //entity
    NSEntityDescription* sCartProductEntity = [NSEntityDescription entityForName:@"CartProduct" inManagedObjectContext:[CartManager getAppDelegate].managedObjectContext];
    [sFetchRequest setEntity:sCartProductEntity];
    
    //sort
    NSSortDescriptor* sSortDescriptor = [[NSSortDescriptor alloc]
                                         initWithKey:@"productID" ascending:YES];
    NSArray* sSortDescriptors = [[NSArray alloc] initWithObjects: sSortDescriptor, nil];
    [sFetchRequest setSortDescriptors:sSortDescriptors];
    
    //
    [sFetchRequest setFetchLimit:10];
    NSError* error;
    NSArray* sResults = [[CartManager getAppDelegate].managedObjectContext executeFetchRequest:sFetchRequest error:&error];
    
    NSMutableArray* sArr = [NSMutableArray array];
    if (sResults.count > 0)
    {
        [sArr addObjectsFromArray:sResults];
    }

    return sArr;
}

- (CartProduct*) getExistingProductByProductID:(NSInteger)aProductID
{
    NSFetchRequest* sFetchRequest = [[NSFetchRequest alloc] init];
    
    //entity
    NSEntityDescription* sCartProductEntity = [NSEntityDescription entityForName:@"CartProduct" inManagedObjectContext:[CartManager getAppDelegate].managedObjectContext];
    [sFetchRequest setEntity:sCartProductEntity];
    
    //predicate
    NSPredicate* sPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"productID=%d", aProductID]];
    [sFetchRequest setPredicate:sPredicate];
    
    //sort
    NSSortDescriptor* sSortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"productID" ascending:YES];
    NSArray* sSortDescriptors = [[NSArray alloc] initWithObjects: sSortDescriptor, nil];
    [sFetchRequest setSortDescriptors:sSortDescriptors];
    
    //
    [sFetchRequest setFetchLimit:10];
    NSError* error;
    NSArray* sResults = [[CartManager getAppDelegate].managedObjectContext executeFetchRequest:sFetchRequest error:&error];
    
    if (sResults.count > 0)
    {
        return [sResults objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}

- (void) pushNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CART_CHANGE object:self];
}

@end
