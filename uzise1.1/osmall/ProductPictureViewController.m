//
//  ProductPictureViewController.m
//  uzise
//
//  Created by edward on 12-11-5.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "ProductPictureViewController.h"

#import "ProductViewController.h"

#import "Constant.h"

#define Height self.view.bounds.size.height
@interface ProductPictureViewController ()

-(void)completePic;

@property BOOL isHidden;
@property float scale_;

@property(nonatomic,strong)UINavigationBar *navigationBar;


@property(nonatomic,strong)UINavigationItem *navigationItem;
@end

@implementation ProductPictureViewController
@synthesize imageScrollView;
@synthesize scale_,imageViewList,index,isHidden,navigationBar,productNO,pic_count,navigationItem;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    offset = 0.0;
    scale_ = 1.0;
    
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-20, 0, 360, Height)];
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    self.imageScrollView.scrollEnabled = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    self.imageScrollView.contentSize = CGSizeMake(360*pic_count, Height);
    
 
    for (int i = 0; i<pic_count; i++){
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [doubleTap setNumberOfTapsRequired:1];
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(360*i, 0, 360, Height)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(360, Height);
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.tag = i+1;
        [s setZoomScale:1.0];
        
        UIImageView *imageview =[[UIImageView alloc] init];
        //        imageview.frame = [self resizeImageSize:imageview.image];
        imageview.frame = CGRectMake(20, 0, 320, 460);
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.userInteractionEnabled = YES;
        imageview.tag = i+1;
        [imageview addGestureRecognizer:doubleTap];
        [imageview addGestureRecognizer:singleTap];
    
        NSURL *big_url =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/App_Product_Image/%@/%d.png",self.productNO,(i+1)]];
      
        [imageview setImageWithURL:big_url placeholderImage:[UIImage imageNamed:@"placeholder400×400.png"] options:SDWebImageProgressiveDownload];
        
        
        [s addSubview:imageview];
        
        [self.imageScrollView addSubview:s];
  
    }
    
    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    //[navigationBar setTintColor:[UIColor clearColor]];
    [navigationBar setTranslucent:YES];
    [navigationBar setBarStyle:UIBarStyleBlackTranslucent];
     navigationItem=[[UINavigationItem alloc]initWithTitle:nil];
    [navigationItem setTitle:[NSString stringWithFormat:@"%d/%d",(self.index+1),pic_count]];
    
    
    UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Return", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(completePic)];
    navigationItem.rightBarButtonItem =backItem;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationBar setHidden:YES];
    

    [self.view addSubview:self.imageScrollView];
    [self.imageScrollView setContentOffset:CGPointMake(360*index, 0)];
    [self.view addSubview:navigationBar];
}

-(void)completePic{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)changeCenter:(id)sender{
    
}

#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.imageScrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    UIImageView *image = [[s subviews] objectAtIndex:0];
                    image.frame = CGRectMake(20, 0, 320, Height);
                }
            }
        }
    }
   int page = floor((scrollView.contentOffset.x - 320 / 2) / 320) + 2;
    
    [navigationItem setTitle:[NSString stringWithFormat:@"%d/%d",page,pic_count]];
    
   
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    UIView *v = [scrollView.subviews objectAtIndex:0];
    if ([v isKindOfClass:[UIImageView class]]){
        if (scrollView.zoomScale<1.0){
            //         v.center = CGPointMake(scrollView.frame.size.width/2.0, scrollView.frame.size.height/2.0);
        }
    }
}

#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    UIView *view = gesture.view.superview;
    if ([view isKindOfClass:[UIScrollView class]]){
        UIScrollView *s = (UIScrollView *)view;
        [s zoomToRect:zoomRect animated:YES];
    }
}

-(void)handleTap:(UIGestureRecognizer *)gesture{
    if (isHidden) {
        [navigationBar setHidden:YES];
         isHidden =NO;
    }else{
        [navigationBar setHidden:NO];
        isHidden =YES;
    }
}

#pragma mark - Utility methods

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(CGRect)resizeImageSize:(CGRect)rect{
    //    NSLog(@"x:%f y:%f width:%f height:%f ", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGRect newRect;
    
    CGSize newSize;
    CGPoint newOri;
    
    CGSize oldSize = rect.size;
    if (oldSize.width>=320.0 || oldSize.height>=Height){
        float scale = (oldSize.width/320.0>oldSize.height/Height?oldSize.width/320.0:oldSize.height/Height);
        newSize.width = oldSize.width/scale;
        newSize.height = oldSize.height/scale;
    }
    else {
        newSize = oldSize;
    }
    newOri.x = (320.0-newSize.width)/2.0;
    newOri.y = (Height-newSize.height)/2.0;
    
    newRect.size = newSize;
    newRect.origin = newOri;
    
    return newRect;
}
@end
