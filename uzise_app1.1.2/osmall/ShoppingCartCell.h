//
//  ShoppingCartCell.h
//  uzise
//
//  Created by edward on 12-10-25.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductBean;
@interface ShoppingCartCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UILabel *productNameLable;

@property(nonatomic,strong)UILabel *productNOLable;

@property(nonatomic,strong)UILabel *productNO;

@property(nonatomic,strong)UILabel *productShopCountLable;

@property(nonatomic,strong)UILabel *shopCountLabel;

@property(nonatomic,strong)UITextField *shopCountTextField;

@property(nonatomic,strong)UILabel *productPriceLable;

@property(nonatomic,strong)UILabel *productPrice;
-(void)creatCell:(ProductBean *)product indexPath:(NSIndexPath *)indexPath;
@end
