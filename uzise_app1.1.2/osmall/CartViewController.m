//
//  ShoppingCartViewController.m
//  uzise
//
//  Created by edward on 12-10-24.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//


#import "CartViewController.h"

#import "OSMallTools.h"

#import "ProductBean.h"

#import "ProductViewController.h"

#import "LoginViewController.h"

#import "Constant.h"

#import "ProductBean.h"

#import "ShoppingCartCell.h"

#import "OrderLandingViewController.h"

#import "UserBean.h"
#import "CartManager.h"
#import "Global.h"
#import "UserManager.h"

#import "TPKeyboardAvoidingTableView.h"

#import "PrettyNavigationController.h"

#import "MobClick.h"

#define MAX_SHOP_COUNT 1000

@interface CartViewController ()

@property(nonatomic,strong) UIButton *doneInKeyboardButton;

@property(nonatomic,strong) NSMutableArray *cartItems;

@property(nonatomic,strong) UIBarButtonItem *clearButton;

@property(nonatomic,strong) NSMutableDictionary *dict;

@property(nonatomic,strong) UINavigationController *orderNavigationController;

@property(nonatomic,strong) UINavigationController *loginNavigationController ;

//@property(nonatomic,strong) NSUserDefaults *userDefault;

@property(nonatomic,strong) UIView *cartEmptyNoticeView;

@property(nonatomic,strong) TPKeyboardAvoidingTableView *mTableView;

@property(nonatomic,strong)UINavigationBar *mSummaryBoard;

@property(nonatomic,strong)UISegmentedControl *segmentedControl;
//总数lable
@property(nonatomic,strong)UILabel *shopp_count_lable;
//商品总额lable
@property(nonatomic,strong)UILabel *shopp_money_count_lable;
//运费
@property(nonatomic,strong)UILabel *freightLabel;

//总计lable
@property(nonatomic,strong)UILabel *favorableLabel;

@property (nonatomic, assign) NSInteger mShopCount;
@property (nonatomic, assign) double mTotalMoney;
@property (nonatomic, assign) double mTotalLessMoney;
@property (nonatomic, assign) double mFreight;

@property (nonatomic, strong) UIButton* mSettleButton;
@property (atomic) BOOL mIsSummaryGot;

@property (nonatomic, strong) NSLock* mLock;
//结算按钮
-(void)settle;

//清空购物车
-(void)clearCart;

//键盘事件注册关闭键盘
-(void)finishAction;

//键盘事件注册
- (void)handleKeyboardDidShow:(NSNotification *)notification;
//键盘事件注册
- (void)handleKeyboardWillHide:(NSNotification *)notification;

@end

@implementation CartViewController
@synthesize cartEmptyNoticeView,mTableView,loginNavigationController,orderNavigationController,dict,clearButton,cartItems,mSummaryBoard,segmentedControl,favorableLabel,shopp_money_count_lable,shopp_count_lable,doneInKeyboardButton,freightLabel, mSettleButton, mIsSummaryGot;
@synthesize mLock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mLock = [[NSLock alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChanged) name:NOTIFICATION_CART_CHANGE object:nil];
    }
    return self;
}

- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"mShopCount"];
    [self removeObserver:self forKeyPath:@"mTotalMoney"];
    [self removeObserver:self forKeyPath:@"mTotalLessMoney"];
    [self removeObserver:self forKeyPath:@"mFreight"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.editing)
    {
        [self setEditing:NO animated:YES];       
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

-(void)clearCart
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Cart_Message", @"Cart_Message") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Ok", nil), nil];
    [alert setDelegate:self];
    [alert show];
}

- (void) cartInterfaceWhenEmptyOrNot
{
    BOOL sIsEmpty = !(self.cartItems.count > 0);

    if (sIsEmpty)
    {
        self.navigationItem.leftBarButtonItem =nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = clearButton;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    [mTableView setHidden:sIsEmpty];
    
    [mSummaryBoard setHidden:sIsEmpty];
    
    [cartEmptyNoticeView setHidden:!sIsEmpty];
}

- (void) updateSummaryBoard
{
    //
    mIsSummaryGot = NO;
    [shopp_count_lable setText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Quantity", @"Quantity"), NSLocalizedString(@"...", nil)]];
    [shopp_money_count_lable setText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Shopping_Total_Price", @"Shopping_Total_Price"),NSLocalizedString(@"...", nil)]];
    [favorableLabel setText:NSLocalizedString(@"...", nil)];    
    [freightLabel setText:NSLocalizedString(@"...", nil)];

    ASIFormDataRequest *order_post = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString: URL_CART_SUMMARY]];
    
    NSInteger sTotalShopCount = 0;
    
    [self.mLock lock];
    for (ProductBean *p in cartItems)
    {
        [order_post addPostValue:[NSString stringWithFormat:@"%d",[p productId]] forKey:@"pid"];
        [order_post addPostValue:[NSString stringWithFormat:@"%d",[p shopcount]] forKey:@"num"];
        sTotalShopCount += p.shopcount;
    }
    [self.mLock unlock];
  
    self.mShopCount = sTotalShopCount;
    NSString* sAppKey = [[UserManager shared] getSessionAppKey];
    if (sAppKey.length > 0)
    {
        [order_post setPostValue:sAppKey forKey:@"appkey"];
    }
    
    [order_post startSynchronous];
    
    if (![order_post error]) {
        
        NSDictionary *di_ct =  [[order_post responseString] JSONValue];
        
        self.mFreight = fabs(((NSNumber*)[di_ct objectForKey:@"freight"]).doubleValue);
        self.mTotalMoney = fabs(((NSNumber*)[di_ct objectForKey:@"totalPrice"]).doubleValue);
        self.mTotalLessMoney = fabs(((NSNumber*)[di_ct objectForKey:@"totalLess"]).doubleValue);
        self.mShopCount = sTotalShopCount;
        
        mIsSummaryGot = YES;
    }
    else
    {
        mIsSummaryGot = NO;
    }
}

- (void) updateProductsInfo
{    
    //create a temp array to hold cart items, in case of cart items removal during products info fetching.
    NSArray* sTempCartItems = [NSArray arrayWithArray:cartItems];
    
    for (ProductBean *product in sTempCartItems) {
                
        NSString *url = [NSString stringWithFormat:@"%@?pid=%d",URL_PRODUCT_DETAIL, [product productId]];
        
        NSString* sAppKey = [[UserManager shared] getSessionAppKey];
        if (sAppKey.length > 0)
        {
            url = [NSString stringWithFormat:@"%@&appkey=%@", url, sAppKey];
        }        
        ASIHTTPRequest *request =[self synLoadByURLStr:url withCachePolicy:E_CACHE_POLICY_NO_CACHE];
                
        if (request
            && ![request error])
        {
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
            
            [product setProduct_url:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/App_Product_Image/%@/120/1.png",[product productNO]]];            
        }
        
        url=nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mTableView reloadData];
    });
}

- (void) saveData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[CartManager shared] replaceWithItems:cartItems];
    });
}

- (void) loadData
{
    [self.mLock lock];
    cartItems = [NSMutableArray arrayWithArray:[[CartManager shared] getAllCartProducts]];
    [self.mLock unlock];
    
    [self cartInterfaceWhenEmptyOrNot];
    
    if (!self.mTableView.hidden)
    {
        [mTableView reloadData];
    }

    [self performSelectorInBackground:@selector(updateProductsInfo) withObject:nil];
    [self performSelectorInBackground:@selector(updateSummaryBoard) withObject:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self roundNaviationBar];    
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    clearButton =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Clear_Cart", @"Clear_Cart") style:UIBarButtonItemStyleBordered target:self action:@selector(clearCart)];
    
    self.navigationItem.leftBarButtonItem=clearButton;
    
    mSummaryBoard =[[PrettyNavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 54)];
    
    UINavigationItem *navigationItem=[[UINavigationItem alloc]initWithTitle:nil];
    
    UIView *view =[[UIView alloc] initWithFrame:mSummaryBoard.frame];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"cartbutton" ] forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"settlement", @"settlement") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(settle) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13]];
    [button setFrame:CGRectMake(220, mSummaryBoard.center.y/2-5, 80, 30)];
    [button.titleLabel setTextAlignment:UITextAlignmentCenter];
    [view addSubview:button];
    mSettleButton = button;
    
    UIImageView *imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"80-shopping-cart"]];
    imageView.frame =CGRectMake(10, mSummaryBoard.center.y/2, 15, 15);
    [view addSubview:imageView];
    
    UITabBarItem *tabBarItem = [[[self.tabBarController tabBar] items] objectAtIndex:2];
    
    //数量
    shopp_count_lable =[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 80, 30)];
    [shopp_count_lable setText:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Quantity", @"Quantity"),[tabBarItem badgeValue]]];
    [shopp_count_lable setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13]];
    [shopp_count_lable setBackgroundColor:[UIColor clearColor]];
    [view addSubview:shopp_count_lable];
    
    //商品总额
    shopp_money_count_lable =[[UILabel alloc] initWithFrame:CGRectMake(40, 20, 180, 30)];
    [shopp_money_count_lable setText:[NSString stringWithFormat:@"%@:%@\t",NSLocalizedString(@"Shopping_Total_Price", @"Shopping_Total_Price"),NSLocalizedString(@"IVision", @"IVision")]];
    [shopp_money_count_lable setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13]];
    [shopp_money_count_lable setBackgroundColor:[UIColor clearColor]];
    [shopp_money_count_lable setTextColor:[UIColor whiteColor]];
    
    [view addSubview:shopp_money_count_lable];
    
    
    //运费
    UILabel *freightNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(150, 20, 180, 30)];
    [freightNameLabel setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Freight", @"Freight")]];
    [freightNameLabel setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13]];
    [freightNameLabel setBackgroundColor:[UIColor clearColor]];
    
    [view addSubview:freightNameLabel];
    
    freightLabel =[[UILabel alloc] initWithFrame:CGRectMake(185, 20, 100, 30)];
    [freightLabel setText:NSLocalizedString(@"IVision", @"IVision")];
    [freightLabel setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13]];
    [freightLabel setBackgroundColor:[UIColor clearColor]];
    [freightLabel setTextColor:[UIColor redColor]];
    
    [view addSubview:freightLabel];
    
    //优惠金额
    UILabel *favorableNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 30)];
    [favorableNameLabel setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Order_Shopping_Preferential", @"Order_Shopping_Preferential")]];
    [favorableNameLabel setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13]];
    [favorableNameLabel setBackgroundColor:[UIColor clearColor]];
    
    [view addSubview:favorableNameLabel];
    
    favorableLabel =[[UILabel alloc] initWithFrame:CGRectMake(165, 0, 180, 30)];
    [favorableLabel setText:NSLocalizedString(@"IVision", @"IVision")];
    [favorableLabel setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13]];
    [favorableLabel setBackgroundColor:[UIColor clearColor]];
    [favorableLabel setTextColor:[UIColor redColor]];
    [view addSubview:favorableLabel];
    
    
    [mSummaryBoard pushNavigationItem:navigationItem animated:NO];
    
    //将横向列表添加到导航栏
    navigationItem.titleView = view;
    
    [self.view addSubview:mSummaryBoard];
    
    
//    userDefault =[NSUserDefaults standardUserDefaults];
    
    mTableView =[[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, mSummaryBoard.frame.size.height, self.view.bounds.size.width,  self.view.bounds.size.height-mSummaryBoard.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-self.tabBarController.tabBar.bounds.size.height) style:UITableViewStylePlain];
    [mTableView setSeparatorColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:mTableView];
    
    
    cartEmptyNoticeView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,  self.view.bounds.size.height) ];
    [cartEmptyNoticeView setBackgroundColor: BG_COLOR];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(mTableView.center.x/2-35, mTableView.center.y/2+20, 250, 100)];
    
    lable.text= NSLocalizedString(@"Shopping_Cart_Empty", @"Shopping_Cart_Empty");
    //   lable.tag=1000;
    [lable setBackgroundColor:[UIColor clearColor]];
    UIImageView *cart_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"80-shopping-cart@2x.png"]];
    cart_imageView.frame =CGRectMake(mTableView.center.x/2+40, mTableView.center.y/2+15, 52, 38);
    // imageView.tag=100;
    [cartEmptyNoticeView addSubview:cart_imageView];
    [cartEmptyNoticeView addSubview:lable];
    [self.view addSubview:cartEmptyNoticeView];
    

    //
    [self addObserver:self forKeyPath:@"mShopCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"mTotalMoney" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"mTotalLessMoney" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"mFreight" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    
    //

}

- (void) cartChanged
{
    self.view;
    [self loadData];
}

- (void) viewDidUnload
{
    [self removeObserver:self forKeyPath:@"mShopCount"];
    [self removeObserver:self forKeyPath:@"mTotalMoney"];
    [self removeObserver:self forKeyPath:@"mTotalLessMoney"];
    [self removeObserver:self forKeyPath:@"mFreight"];
}

- (NSString*) getNormalizedDouble:(double)aNumber
{
    NSString* sNomralStr = nil;
    if (aNumber>=10000)
    {
        double sX = aNumber/10000;
        sNomralStr = [NSString stringWithFormat:@"%.1f%@+", sX-0.05, NSLocalizedString(@"ten thounsands", nil)];
    }
    else
    {
        sNomralStr = [NSString stringWithFormat:@"%.1f", aNumber];
    }
    return sNomralStr;
}

#pragma mark - NSKeyValueObserving protocol
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([keyPath isEqualToString:@"mShopCount"])
        {
            [shopp_count_lable setText:[NSString stringWithFormat:@"%@: %d",NSLocalizedString(@"Quantity", @"Quantity"), ((NSNumber*)[self valueForKey:@"mShopCount"]).integerValue]];
        }
        else if ([keyPath isEqualToString:@"mTotalMoney"])
        {
            [shopp_money_count_lable setText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Shopping_Total_Price", @"Shopping_Total_Price"),[self getNormalizedDouble:((NSNumber*)[self valueForKey:@"mTotalMoney"]).doubleValue]]];
        }
        else if ([keyPath isEqualToString:@"mTotalLessMoney"])
        {
            [favorableLabel setText:[NSString stringWithFormat:@"%@",[self getNormalizedDouble:((NSNumber*)[self valueForKey:@"mTotalLessMoney"]).doubleValue]]];
        }
        else if ([keyPath isEqualToString:@"mFreight"])
        {
            [freightLabel setText:[NSString stringWithFormat:@"%.1f",((NSNumber*)[self valueForKey:@"mFreight"]).doubleValue]];
        }
        else
        {
            //nothing done.
        }
    });
}

-(void) updateShopCounts
{        
    NSInteger cartRowsInSection =[mTableView numberOfRowsInSection:0];
    
    //读取数据
    for (int j = 0; j <cartRowsInSection; j++)
    {

        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:j inSection:0];
        
        ShoppingCartCell *cell = (ShoppingCartCell *)[mTableView cellForRowAtIndexPath:indexPath];
        
        ProductBean *product = [cartItems objectAtIndex:j];
                
        NSInteger sShopCount  = 0;
        if (cell.shopCountTextField.text.integerValue > 0
            && cell.shopCountTextField.text.integerValue <= MAX_SHOP_COUNT)
        {
            sShopCount = cell.shopCountTextField.text.integerValue;
        }
        else
        {
            if (!cell.shopCountTextField.text
                || cell.shopCountTextField.text.integerValue <= 0)
            {
                sShopCount = 1;
            }
            else
            {
                sShopCount = MAX_SHOP_COUNT;
            }
            
            cell.shopCountTextField.text = [NSString stringWithFormat:@"%d", sShopCount];
            cell.shopCountLabel.text = cell.shopCountTextField.text;
        }
        
        [product setShopcount:sShopCount];
    }
}

#pragma mark - overide methods
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [mTableView setEditing:editing animated:YES];

    if (editing)
    {
        mTableView.tag = 10000;
    }
    else
    {
        [self updateShopCounts];
//        [self performSelectorInBackground:@selector(updateSummaryBoard) withObject:nil];
        [self performSelectorInBackground:@selector(saveData) withObject:nil];
        mTableView.tag = 0;
        [self cartInterfaceWhenEmptyOrNot];
    }
}

-(void)settle
{
    [MobClick event:@"UEID_SETTLE_CART"];

    if (self.editing)
    {
        self.editing = NO;
    }
    
    if (!self.mIsSummaryGot)
    {
        [self showNotice:NSLocalizedString(@"Summary not ready yet", nil)];
        [self performSelectorInBackground:@selector(updateSummaryBoard) withObject:nil];
        return;
    }
    
    if ([[UserManager shared] isInsession])
    {
        [self showOrderViewContoller];
    }
    else
    {
        LoginViewController* sLoginViewController = [[LoginViewController alloc] init];
        PrettyNavigationController* sNavLoginController = [[PrettyNavigationController alloc] initWithRootViewController: sLoginViewController];
        self.loginNavigationController = sNavLoginController;
        self.loginNavigationController.view.tag =1000;
        [self presentModalViewController:self.loginNavigationController animated:YES];
    }    
}

-(void)showOrderViewContoller
{
    OrderLandingViewController* sShoppingOrderViewController = [[OrderLandingViewController alloc] initWithTotalPrice:self.mTotalMoney];
    PrettyNavigationController* sNavShoppingOrderViewController = [[PrettyNavigationController alloc] initWithRootViewController: sShoppingOrderViewController];
    self.orderNavigationController = sNavShoppingOrderViewController;
    [self presentModalViewController:self.orderNavigationController animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cartItems count];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < [cartItems count]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

//删除功能
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *indexPathArray = [NSArray arrayWithObject:indexPath];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.mLock lock];
        [cartItems removeObjectAtIndex:indexPath.row];
        [self.mLock unlock];

        [mTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (cartItems.count <= 0)
        {
            [self setEditing:NO animated:YES];
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return UITableViewCellEditingStyleDelete;
        
    }else
        return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *ShoppingCartellIdentifier = @"ShoppingCartell";
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ShoppingCartellIdentifier];
    if (cell==nil) {
        cell =[[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShoppingCartellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (indexPath.row < [cartItems count]) {
        
        ProductBean *product =[cartItems objectAtIndex:indexPath.row];
        [cell creatCell:product indexPath:indexPath];
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==[cartItems count]) {
        return 53;
    }else{
        return 108;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductBean *product =[cartItems objectAtIndex:indexPath.row];
    
    ProductViewController *productViewController = [[ProductViewController alloc] initWithProductName:product.productName];
    [productViewController setProduct_id:[product productId]];
    // productViewController.title =[product productName];
    
    [self.navigationController pushViewController:productViewController animated:YES];
    
    // [NSThread detachNewThreadSelector:@selector(cartBackgroundLoadingData:) toTarget:self withObject:productViewController];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (self.isEditing)
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
}

-(void)finishAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.cartItems removeAllObjects];
        [self.mTableView reloadData];

        [self setEditing:NO];
    }
}
@end
