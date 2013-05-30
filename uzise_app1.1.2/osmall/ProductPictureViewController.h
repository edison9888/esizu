//
//  ProductPictureViewController.h
//  uzise
//
//  Created by edward on 12-11-5.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductPictureViewController : UIViewController<UIScrollViewDelegate>{
    CGFloat offset;
}


@property (nonatomic, strong) UIScrollView *imageScrollView;


-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center;

@property (nonatomic, strong) NSArray *imageViewList;

@property (nonatomic,copy)NSString *productNO;

@property NSInteger pic_count;

@property NSInteger index;

@end
