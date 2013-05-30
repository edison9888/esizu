

#import "ProductViewController.h"

#import "ProductListController.h"

#import "ProductInfoController.h"

#import "Constant.h"

#import "NewBaseCellCell.h"

#import "ProductListController.h"

#import <QuartzCore/QuartzCore.h>

#import "CustomLabel.h"

#import "ProductCommentController.h"

#import "CartViewController.h"

#import "ProductPictureViewController.h"
#import "ProductParametersController.h"

#import "UserBean.h"
#import "CartManager.h"
#import "Global.h"
#import "UserManager.h"
#import "MobClick.h"
#import "NSString+MyString.h"
#import <QuartzCore/CAAnimation.h>

@interface ProductViewController ()

-(void)viewPic:(UITapGestureRecognizer *)sender;

-(void)cartButtonControl:(UIButton *)sender;

-(void)finishAction;

-(void)registerKeyboard;

- (void)handleKeyboardDidShow:(NSNotification *)notification;

- (void)handleKeyboardWillHide:(NSNotification *)notification;

@property(nonatomic,strong)NSMutableArray *big_pic_list;

@property(nonatomic,strong)ASIHTTPRequest *product_request;

@property(nonatomic,strong)ASIHTTPRequest *comment_request;

@property NSInteger quantity_count;

@property BOOL isShow;

@property BOOL onceLoad;

@property NSInteger pic_count;
@property (nonatomic, strong) UIButton *mAddCartButton;

@property (nonatomic, strong) UILabel* mFlyingTag;
@property (nonatomic, strong) CAAnimation* mFlyingAnimation;

@end

@implementation ProductViewController
@synthesize product,isShow,pic_list,product_id,backTitle,big_pic_list,isViewPic,product_request,comment_request,onceLoad,pic_count,quantity_count;
@synthesize mAddCartButton;
@synthesize mFlyingTag;
@synthesize mFlyingAnimation;

- (id) initWithProductName:(NSString*)aProductName
{
    self = [super init];
    if (self)
    {
        self.title = aProductName;
    }
    return self;
}

-(void)registerKeyboard
{
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    if (doneInKeyboardButton.superview)
    {
        [doneInKeyboardButton removeFromSuperview];
    }
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    if (doneInKeyboardButton == nil)
    {
        doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        if(screenHeight==568.0f){//爱疯5
            doneInKeyboardButton.frame = CGRectMake(0, 568 - 53, 106, 53);
        }else{//3.5寸
            doneInKeyboardButton.frame = CGRectMake(0, 480 - 53, 106, 53);
        }
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        //图片直接抠腾讯财付通里面的= =!
        [doneInKeyboardButton setImage:[UIImage imageNamed:@"btn_done_up@2x.png"] forState:UIControlStateNormal];
        [doneInKeyboardButton setImage:[UIImage imageNamed:@"btn_done_down@2x.png"] forState:UIControlStateHighlighted];
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    if (doneInKeyboardButton.superview == nil)
    {
        [tempWindow addSubview:doneInKeyboardButton];    // 注意这里直接加到window上
    }
    
}

-(void)finishAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerKeyboard];
    
    if (!self.mIsLoading)
    {
        if (!product
            || !product.productName
            || product.productName.length <= 0)
        {
            self.view.userInteractionEnabled = NO;
            [self loadData];
        }
    }
}

-(void)loadData
{
    NSString *url = [NSString stringWithFormat:@"%@?pid=%d", URL_PRODUCT_DETAIL, self.product_id];
    
    NSString* sAppKey = [[UserManager shared] getSessionAppKey];
    if (sAppKey.length > 0)
    {
        url = [NSString stringWithFormat:@"%@&appkey=%@", url, sAppKey];
    }
    
    product_request =[self asynLoadByURLStr:url withCachePolicy:E_CACHE_POLICY_USE_CACHE_IF_EXISTS_IN_SESSION];
    [self.mRequests addObject:product_request];
    
    [self showHud];
    
    url =nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    //[self.tableView setSeparatorColor:[UIColor clearColor]];
    
    isShow =YES;
    
    onceLoad =YES;
    
    quantity_count = 0;
    
    
    //
    mAddCartButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [mAddCartButton setBackgroundImage:[UIImage imageNamed:@"cartbutton"] forState:UIControlStateNormal];
    [mAddCartButton setTitle:NSLocalizedString(@"Add_Cart", @"Add_Cart") forState:UIControlStateNormal];
    mAddCartButton.frame=CGRectMake(170, 5, 130, 40);
    [mAddCartButton addTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    
    UIView* sBgView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    sBgView.backgroundColor = [UIColor whiteColor];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setBackgroundView:sBgView];
    
    [self.view setBackgroundColor:BG_COLOR];
    
    //
    UITapGestureRecognizer *sTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(dismissKeyboard)];
    [sTapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:sTapGestureRecognizer];

    
    
    //customize the back title for the pushed controller: comment controller, product info controller;
    NSString* sNormalizedBackTitle = [self.title stringReducedToWidth:50 withFont:[UIFont systemFontOfSize:10]];
    UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithTitle:sNormalizedBackTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
}

- (void) dismissKeyboard
{
    [prodcut_quantity_field resignFirstResponder];
}

-(void)viewPic:(UITapGestureRecognizer *)sender
{
    isViewPic =NO;
    ProductPictureViewController *viewController = [[ProductPictureViewController alloc] init];
    [viewController setImageViewList:[NSArray arrayWithArray:big_pic_list]];
    [viewController setIndex:sender.view.tag];
    [viewController setProductNO:[product productNO]];
    [viewController setPic_count:pic_count];
    [self presentModalViewController:viewController animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{   
    if (isViewPic) {
        UINavigationController *nav =(UINavigationController *)self.navigationController;
        
        for (UIImageView *view in nav.navigationBar.subviews) {
            if (view.tag==100) {
                [view setHidden:NO];
            }
        }
    }
    
       [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)viewDidDisappear:(BOOL)animated{
     
    [super viewDidDisappear:animated];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(void)cartButtonControl:(UIButton *)sender{
    quantity_count = [[prodcut_quantity_field text] integerValue];
    quantity_count = quantity_count +sender.tag;
    if (quantity_count<=0) {
        quantity_count=1;
    }
    
    [prodcut_quantity_field setText:[NSString stringWithFormat:@"%d",quantity_count ]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        switch (indexPath.row) {
            case 0:{
               static NSString *CellIdentifier = @"ADCell";
                
              if ([pic_list count]!=0) {
                  
                   static NSString *NewCellIdentifier = @"NewADCell";
                    NewBaseCellCell *cell = [tableView dequeueReusableCellWithIdentifier:NewCellIdentifier];
                    if (cell==nil) {
                    cell =[[NewBaseCellCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewCellIdentifier isShowPageControl:YES isLoopScrollView:NO scrollCiewDataScoure:pic_list ScrollViewCellHeight:230 scrollContentY:0 pageControlPointY:220 Timing:-3.0f];
                    }
                    UITableViewCell  *cell_x = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    [cell_x removeFromSuperview];
                     return cell;
                }else{
                   
                    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell ==nil) {
                        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    return cell;
                }
               
                break;
             }
            case 1:{
                 static NSString *ProductCellIdentifier = @"ProductCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier];
                if (cell==nil) {
                    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ProductCellIdentifier];
                }
                
                for (UIView *view in cell.contentView.subviews) {
                    [view removeFromSuperview];
                }
                
                UILabel *product_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
                [product_label setText:[NSString stringWithFormat:@"%@：",NSLocalizedString(@"Product_NO", @"Product_NO")]];
                [product_label setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
               
                UILabel *product_no_label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 100, 30)];
                [product_no_label setText:[product productNO]];
                [product_no_label setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
                
                UILabel *product_introduction_lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 100, 30)];
                [product_introduction_lable setText:[NSString stringWithFormat:@"%@：",NSLocalizedString(@"Product_Introduction", @"Product_Introduction")] ];
                [product_introduction_lable setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
               
                UILabel *introduction_lable = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 210, 30)];
                [introduction_lable setText:[product introduce]];
                [introduction_lable setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
          //      [introduction_lable setLineBreakMode:UILineBreakModeWordWrap];
            //    [introduction_lable setNumberOfLines:5];
                
                UILabel *retallPrice_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 30)];
                [retallPrice_label setText:[NSString stringWithFormat:@"%@：",NSLocalizedString(@"Product_retallPrice", @"Product_retallPrice")]];
                [retallPrice_label setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
                
                
                CustomLabel *retallPric = [[CustomLabel alloc] initWithFrame:CGRectMake(80, 60, 100, 30)];
                [retallPric setText:[NSString stringWithFormat:@"%.1f",[product retallPrice]]];
                [retallPric setIsWithStrikeThrough:YES];
                [retallPric setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
               
                
                UILabel *price_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 100, 30)];
                [price_label setText:[NSString stringWithFormat:@"%@：",NSLocalizedString(@"Product_Price", @"Product_Price")]];
                [price_label setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
                
                UILabel *product_price_label = [[UILabel alloc] initWithFrame:CGRectMake(80, 90, 100, 30)];
                [product_price_label setText:[NSString stringWithFormat:@"%.1f",[product price]]];
                [product_price_label setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
                [product_price_label setTextColor:[UIColor redColor]];
                
                [cell.contentView addSubview:product_label];
                [cell.contentView addSubview:product_no_label];
                [cell.contentView addSubview:product_introduction_lable];
                [cell.contentView addSubview:introduction_lable];
                [cell.contentView addSubview:retallPrice_label];
                [cell.contentView addSubview:retallPric];
                [cell.contentView addSubview:price_label];
                [cell.contentView addSubview:product_price_label];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
                break;
            }
            case 2:{
                
                static NSString *productIntroductionCellIdentifier = @"productParameters";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productIntroductionCellIdentifier];
                
                if (cell==nil) {
                    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:productIntroductionCellIdentifier];
                }
                NSArray *views = [cell.contentView subviews];
                
                for (UIView *view in views) {
                    [view removeFromSuperview];
                }
                
                cell.textLabel.text = NSLocalizedString(@"Product Parameters", nil);
                [cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
                break;
            }
            case 3:{
                            
                static NSString *addCartCellIdentifier = @"addCartCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addCartCellIdentifier];
                if (cell==nil) {
                    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCartCellIdentifier];
                }
                NSArray *views = [cell.contentView subviews];
                
                for (UIView *view in views) {              
                        [view removeFromSuperview];
                }
                
    
                
                UIButton *add_button =[UIButton buttonWithType:UIButtonTypeCustom];
                [add_button setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
                add_button.frame=CGRectMake(25, 13, 25, 25);
                add_button.tag =1;
                [add_button addTarget:self action:@selector(cartButtonControl:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *minus_button =[UIButton buttonWithType:UIButtonTypeCustom];
                [minus_button setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
                minus_button.frame=CGRectMake(125, 13, 25, 25);
                minus_button.tag =-1;
                [minus_button addTarget:self action:@selector(cartButtonControl:) forControlEvents:UIControlEventTouchUpInside];
                
                 prodcut_quantity_field = [[UITextField alloc] initWithFrame:CGRectMake(65, 10, 50, 30)];
                 [prodcut_quantity_field setBorderStyle:UITextBorderStyleBezel];
                
                if (quantity_count>0) {
                    [prodcut_quantity_field setText:[NSString stringWithFormat:@"%d",quantity_count ]];
                }else{
                    [prodcut_quantity_field setText:[NSString stringWithFormat:@"%d",1 ]];
                }
  
                 [prodcut_quantity_field setKeyboardType:UIKeyboardTypeNumberPad];
                
                 [mAddCartButton removeFromSuperview];
                 [cell.contentView addSubview:mAddCartButton];
                 [cell.contentView addSubview:add_button];
                 [cell.contentView addSubview:minus_button];
                 [cell.contentView addSubview:prodcut_quantity_field];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;

            }
            case 4:{
                           
                static NSString *productCommentCellIdentifier = @"productComment";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productCommentCellIdentifier];
                
                if (cell==nil) {
                    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:productCommentCellIdentifier];
                }
                NSArray *views = [cell.contentView subviews];
                
                for (UIView *view in views) {
                        [view removeFromSuperview];
                }
               
                cell.textLabel.text=[NSString stringWithFormat:@"%@", NSLocalizedString(@"Product_Comment", @"Product_Comment")];
                [cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
                break;
            }
            default:{
                break;
            }
        }
       


    return nil;
}

-(void) addToCart
{
    NSInteger sShopCount = 1;
    if ([prodcut_quantity_field text]!=nil)
    {
        sShopCount = [[prodcut_quantity_field text] integerValue];
    }
    [self.product setShopcount:sShopCount];

    
    //trigger an product-adding animation
    if (!self.mFlyingTag)
    {
        UILabel* sFlyingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        sFlyingLabel.textColor = [UIColor redColor];
        sFlyingLabel.backgroundColor = [UIColor clearColor];
        [[[UIApplication sharedApplication]keyWindow] addSubview:sFlyingLabel];
        
        self.mFlyingTag = sFlyingLabel;
    }
    
    [[[UIApplication sharedApplication]keyWindow] bringSubviewToFront:self.mFlyingTag];
    self.mFlyingTag.text = [NSString stringWithFormat:@"+%d", prodcut_quantity_field.text.integerValue];
    
    if (!self.mFlyingAnimation)
    {
        
        CGPoint fromPoint = [prodcut_quantity_field.superview convertPoint:prodcut_quantity_field.center toView:[[UIApplication sharedApplication]keyWindow]];
        CGPoint toPoint =  CGPointMake([[UIApplication sharedApplication]keyWindow].bounds.size.width/2, [[UIApplication sharedApplication]keyWindow].bounds.size.height - self.tabBarController.tabBar.bounds.size.height/2);
        //tune a little
        fromPoint = CGPointMake(fromPoint.x+10, fromPoint.y);
        toPoint = CGPointMake(toPoint.x+15, toPoint.y-10);
        
        CAKeyframeAnimation* sAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        sAnimation.calculationMode = kCAAnimationPaced;
        
        CGMutablePathRef sCurvedPath = CGPathCreateMutable();
        CGPathMoveToPoint(sCurvedPath, NULL, fromPoint.x, fromPoint.y);
        CGPathAddCurveToPoint(sCurvedPath, NULL, (fromPoint.x+toPoint.x)/2, fromPoint.y-50, toPoint.x, fromPoint.y-50, toPoint.x, toPoint.y);
        sAnimation.path = sCurvedPath;
        CGPathRelease(sCurvedPath);
        
        sAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        sAnimation.fillMode = kCAFillModeForwards;
        sAnimation.removedOnCompletion = YES;
        sAnimation.duration = 1.0;
        sAnimation.delegate = self;

        self.mFlyingAnimation = sAnimation;
    }
    
    [self.mFlyingTag.layer addAnimation:self.mFlyingAnimation forKey:@"to_cart_animation"];
    
  
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [[CartManager shared] addProduct:self.product];
    //
    NSDictionary* sDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.product.productName, @"product", nil];
    [MobClick event:@"UEID_ADD_PRODUCT" attributes: sDict];
    
    return;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 230;
            break;
        case 1:
            return 120;
            break;
        case 2:
            return 50;
            break;
        default:
            return 50;
            break;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 1:
        {
            ProductInfoController *productDetailViewController  =[[ProductInfoController alloc] init];
            [productDetailViewController setUrl: URL_PRODUCT_INFO(self.product_id)];
            [productDetailViewController setTitle: NSLocalizedString(@"ProductIntroduction", nil)];
            productDetailViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:productDetailViewController animated:YES];
            break;
        }
        case 2:
        {
            ProductParametersController *productDetailViewController  =[[ProductParametersController alloc] init];
            [productDetailViewController setUrl: URL_PRODUCT_PARAMETERS(self.product_id)];
            [productDetailViewController setTitle: NSLocalizedString(@"Product Parameters", nil)];
            productDetailViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:productDetailViewController animated:YES];
            
            break;
        }
        case 4:
        {
            ProductCommentController *commentViewController  =[[ProductCommentController alloc] initWithStyle:UITableViewStylePlain];
            [commentViewController setComment_product_id:self.product_id];
            [commentViewController setProduct_name:[product productName]];
            commentViewController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:commentViewController animated:YES];
            
            break;
         }   
        default:
            break;
    }
    
}



- (void)requestFinished:(ASIHTTPRequest *)request
{    
    if (request
        && ![request error]&&[request isEqual:product_request])
    {
        
        if (!product)
        {
            product =[[ProductBean alloc] init];
        }
        
        NSDictionary *product_dict =[[request responseString] JSONValue];
            
        [product setProductId:[[product_dict objectForKey:@"productId"] integerValue]];
        
        [product setProductName:[product_dict objectForKey:@"productName"]];
        
        [product setProductNO:[product_dict objectForKey:@"productNo"]];
        
        [product setIntroduce:[product_dict objectForKey:@"introduce"]];
        
        [product setPrice:[[product_dict objectForKey:@"price"] doubleValue]];
        
        [product setRetallPrice:[[product_dict objectForKey:@"retailPrice"] doubleValue]];
        
        [product setQuantity:[[product_dict objectForKey:@"productCount"] integerValue]];
        
        [product setDatetime:[NSDate dateWithTimeIntervalSince1970:[[product_dict objectForKey:@"creatTime"] doubleValue]/1000.0]];
        
        [product setSellCount:[[product_dict objectForKey:@"sellCount"] integerValue]];
        
        [product setProductTypeName:[[product_dict objectForKey:@"category"] objectForKey:@"typeName"] ];
        
        [product setProductTypeId:[[[product_dict objectForKey:@"category"] objectForKey:@"typeId"]  integerValue]];
        
        [product setProduct_url:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/App_Product_Image/%@/120/1.png",[product productNO]]];
        
        [self setTitle:(backTitle==nil?[product_dict objectForKey:@"productName"]:backTitle)];
        
         pic_count = 1;
        
        if ([[product_dict objectForKey:@"groupsproduct"] isEqual:@"-1"]) {
            pic_count=4;
        }
        
        self.view.userInteractionEnabled = YES;
    }

    [self performSelectorOnMainThread:@selector(endsLoading) withObject:nil waitUntilDone:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self performSelectorOnMainThread:@selector(endsLoading) withObject:nil waitUntilDone:NO];
}

-(void)endsLoading
{
    [self hideHud];
    isViewPic =YES;
    isShow =NO;
    
    [self.tableView reloadData];
    
    [self performSelector:@selector(loadingProductPic) withObject:nil afterDelay:0.5];
    
}

-(void)loadingProductPic
{
    if (onceLoad) {
        
        pic_list =[[NSMutableArray alloc] initWithCapacity:pic_count];
        
        big_pic_list =[NSMutableArray array];
          
        for (int i =1; i<=pic_count; i++) {
            UIImageView *imageView =[[UIImageView alloc] init];
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/App_Product_Image/%@/400/%d.png",[product productNO],i]];
            
            UIView *coordinate_view = [[UIView alloc] init];
            
            [coordinate_view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bh"]]];
            
//            [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder400×400.png"] options:SDWebImageProgressiveDownload];
            
            [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder400×400.png"]];

            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPic:)];
            [imageView setTag:i-1];
            [imageView setFrame:CGRectMake((self.view.bounds.size.width/2.0f) - (200/2.0f), 10, 200, 200)];
            [imageView addGestureRecognizer:singleTap];
            [imageView setUserInteractionEnabled:YES];
            
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 6.0;
            imageView.layer.borderWidth = 1.0;
            imageView.layer.borderColor = [[UIColor grayColor] CGColor];
            
            [coordinate_view addSubview:imageView];
            singleTap =nil;
            
            [pic_list addObject:coordinate_view];
            coordinate_view =nil;
            imageView =nil;
            
        }
       
        [self.tableView reloadData];
        
      
    }
    onceLoad=NO;
    
    
}

@end
