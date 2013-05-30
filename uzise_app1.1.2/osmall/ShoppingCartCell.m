//
//  ShoppingCartCell.m
//  uzise
//
//  Created by edward on 12-10-25.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "ShoppingCartCell.h"

#import "Constant.h"

#import "ProductBean.h"
#import "Global.h"

@implementation ShoppingCartCell
@synthesize imageView,productNameLable,productNOLable,productNO,productShopCountLable,shopCountLabel,shopCountTextField,productPriceLable,productPrice;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)creatCell:(ProductBean *)product indexPath:(NSIndexPath *)indexPath{
   
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    imageView =[[UIImageView alloc] initWithFrame:CGRectMake(18, 18, 70, 70)];
    
    [imageView setImageWithURL:[NSURL URLWithString:[product product_url]] placeholderImage:[UIImage imageNamed:@"Icon"]];
    
    //产品名字
    productNameLable =[[UILabel alloc] initWithFrame:CGRectMake(120, 8, 200, 31)];
    [productNameLable setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16]];
    [productNameLable setText:[product productName]];
    [productNameLable setBackgroundColor:[UIColor clearColor]];
    //产品编号lable
    productNOLable =[[UILabel alloc] initWithFrame:CGRectMake(120, 28, 160, 31)];
    [productNOLable setTextColor:[UIColor grayColor]];
    [productNOLable setText:[NSString stringWithFormat:@"%@：",NSLocalizedString(@"ProductNO", @"ProductNO")]];
    [productNOLable setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:15]];
    [productNOLable setBackgroundColor:[UIColor clearColor]];
    //产品编号
    productNO =[[UILabel alloc] initWithFrame:CGRectMake(170, 28, 80, 31)];
    [productNO setBackgroundColor:[UIColor clearColor]];
    [productNO setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
    [productNO setText:[product productNO]];
    //产品数量lable
    productShopCountLable =[[UILabel alloc] initWithFrame:CGRectMake(120, 50, 160, 31)];
    [productShopCountLable setBackgroundColor:[UIColor clearColor]];
    [productShopCountLable setText:[NSString stringWithFormat:@"%@：",NSLocalizedString(@"Quantity", @"Quantity")]];
    [productShopCountLable setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:15]];
    [productShopCountLable setTextColor:[UIColor grayColor]];
    //产品数量
    shopCountLabel =[[UILabel alloc] initWithFrame:CGRectMake(170, 52, 63, 25)];
    [shopCountLabel setBackgroundColor:[UIColor clearColor]];
    [shopCountLabel setText:[NSString stringWithFormat:@"%d",[product shopcount]]];
    [shopCountLabel setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
    [shopCountLabel setTag:indexPath.row+1000];
  //产品数量 text
    shopCountTextField =[[UITextField alloc] initWithFrame:shopCountLabel.frame];
    [shopCountTextField setText:[NSString stringWithFormat:@"%d",[product shopcount]]];
    shopCountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    shopCountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [shopCountTextField setBorderStyle:UITextBorderStyleBezel];
    [shopCountTextField setTag:indexPath.row+2000];
    [shopCountTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    //产品价格lable
    productPriceLable =[[UILabel alloc] initWithFrame:CGRectMake(120, 73, 160, 31)];
    [productPriceLable setBackgroundColor:[UIColor clearColor]];
    [productPriceLable setText:[NSString stringWithFormat:@"%@：",NSLocalizedString(@"Price", @"Price")]];
    [productPriceLable setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:15]];
    [productPriceLable setTextColor:[UIColor grayColor]];
    //产品价格
    productPrice =[[UILabel alloc] initWithFrame:CGRectMake(170, 73, 160, 31)];
    [productPrice setBackgroundColor:[UIColor clearColor]];
    [productPrice setText:[NSString stringWithFormat:@"￥%.1f",[product price]]];
    [productPrice setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
    [productPrice setTextColor:[UIColor redColor]];
    
    [self.contentView addSubview:shopCountLabel];
    [self.contentView addSubview:shopCountTextField];
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:productNameLable];
    [self.contentView addSubview:productNOLable];
    [self.contentView addSubview:productNO];
    [self.contentView addSubview:productShopCountLable];
    [self.contentView addSubview:productPriceLable];
    [self.contentView addSubview:productPrice];
    
    
    UIView* sSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 107, 320, 1)];
    sSeperatorView.backgroundColor = RGBA_COLOR(222, 222, 222, 1);
    sSeperatorView.layer.shadowColor = [RGBA_COLOR(224, 224, 224, 1) CGColor];
    sSeperatorView.layer.shadowOffset = CGSizeMake(0, 0);
    sSeperatorView.layer.shadowOpacity = .5f;
    sSeperatorView.layer.shadowRadius = 20.0f;
    sSeperatorView.clipsToBounds = NO;
    sSeperatorView.layer.cornerRadius = 5;
    
    [self.contentView addSubview:sSeperatorView];

    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    UITableView *tableview =(UITableView *)[super superview];
    
    
    if ([super isEditing]&&tableview.tag==10000) {
        [self.shopCountLabel setHidden:YES];
        
        [UIView animateWithDuration:1 animations:^{
            [self.shopCountTextField setHidden:NO];
        }];
     
    }else{
        [self.shopCountTextField setHidden:YES];
        [self.shopCountLabel setHidden:NO];
        [self.shopCountLabel setText:self.shopCountTextField.text];
        [self.shopCountTextField resignFirstResponder];
    }
}

//#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (!textField.text
//        || textField.text.integerValue <= 0)
//    {
//        textField.text = [NSString stringWithFormat:@"%d", 1];
//    }
//    else if (textField.text.integerValue > 100)
//    {
//        textField.text = [NSString stringWithFormat:@"%d", 99];
//    }
//    else
//    {
//        
//    }
//    return YES;
//}
//


@end
