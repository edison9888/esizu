//
//  ShoppingOrderViewController.m
//  uzise
//
//  Created by edward on 12-10-26.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "OrderLandingViewController.h"

#import "Constant.h"

#import "ProductBean.h"

#import "UserBean.h"

#import "SendTypeBean.h"

#import "AddressListController.h"

#import "PayModeViewController.h"

#import "ShippingTypeViewController.h"

#import "InvoiceViewController.h"

#import "AddressEditorController.h"
#import "CartManager.h"
#import "Global.h"
#import "UserManager.h"
#import "MobClick.h"
#import "DTCustomColoredAccessory.h"


#define TAG_REQUEST_ADDRESSLIST  1
#define TAG_REQUEST_ADDRESS      2

@interface OrderLandingViewController ()

@property(nonatomic,strong)UITableView *mTableView;

@property(nonatomic,strong)PrettyToolbar *shoppingTotalMoneyToolBar;

@property(nonatomic,strong)UIView *bottomSettleBar;

@property(nonatomic,strong)UILabel *shopping_total_money;

@property(nonatomic,strong)NSUserDefaults *userDefault;

@property(nonatomic,strong)NSArray *product_list;
//送货方式
@property(nonatomic,strong)NSDictionary *sendtypeDict;
//支付
@property(nonatomic,strong)NSDictionary *payModeDict;
//送货时间
@property(nonatomic,strong)NSDictionary *sendTimeDict;
//发票抬头
@property(nonatomic,strong)NSDictionary *invoiceContentDict;
//是否需要发票
@property(nonatomic,strong)NSDictionary *isinvoiceDict;
//总价
@property double mTotalprice;
//优惠价格
@property double retailTotalPrice;

//运费
@property double freight;

//支付方式
@property(nonatomic,strong)UILabel *user_payment;
//配送方式
//@property(nonatomic,strong)UILabel *distribution_way_lable;
//送货时间
@property(nonatomic,strong)UILabel *order_deliverTime;
//送货方式
@property(nonatomic,strong)UILabel *order_sendtype;
//发票抬头
@property(nonatomic,strong)UILabel *order_invoice_name;
//发票抬头 lable
@property(nonatomic,strong)UILabel *order_invoice_name_lable;
//发票内容
@property(nonatomic,strong)UILabel *order_invoice_Content;
//发票内容 lable
@property(nonatomic,strong)UILabel *order_invoice_content_lable;

@property(nonatomic,strong)UserAddressBean *mSelectedAddress;

@property(nonatomic,strong)UIView *title_view;

@property(nonatomic,strong)UserBean *user;

@property(nonatomic,strong)UIAlertView *alert;

@property(nonatomic,copy)NSString *alertString;

@property(nonatomic,strong) PayModeViewController *modalPanel;

@property (nonatomic, strong) NSMutableArray* mAddressList;

@property (nonatomic, strong) UIButton* mCreateOrderButton;

-(void)dimissOrderViewController;

-(void)createOrder;

-(void)loadAddressList;

-(void)loadLocalData;

@end

@implementation OrderLandingViewController
@synthesize mTableView;
//@synthesize  shoppingTotalMoneyToolBar;
//@synthesize bottomSettleBar;
@synthesize shopping_total_money;
@synthesize userDefault;
@synthesize product_list;
@synthesize mTotalprice;
@synthesize retailTotalPrice;
@synthesize freight;
@synthesize user_payment,order_deliverTime,order_sendtype,order_invoice_name,order_invoice_Content,order_invoice_name_lable,order_invoice_content_lable;
@synthesize shopping_dict,sendtypeDict,payModeDict,sendTimeDict,invoiceContentDict,isinvoiceDict;
@synthesize mSelectedAddress;
@synthesize title_view;
@synthesize user;
@synthesize alert,alertString;
@synthesize modalPanel=_modalPanel;
@synthesize mAddressList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithTotalPrice:(double)aTotalPrice
{
    self = [super init];
    if (self)
    {
        self.mTotalprice = aTotalPrice;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!mSelectedAddress)
    {
        self.view.userInteractionEnabled = NO;
        [self.view addSubview:self.mDarkenView];
        [self showHud];
        [self loadAddressList];
    }
    [self.mTableView reloadData];
}

-(void)loadAddressList
{    
    ASIHTTPRequest *useraddress_reuqest =[self asynLoadByURLStr:[NSString stringWithFormat:@"%@?appkey=%@", URL_GET_ADDRESS_LIST, [[UserManager shared] getSessionAppKey]] withCachePolicy:E_CACHE_POLICY_NO_CACHE];
    useraddress_reuqest.tag = TAG_REQUEST_ADDRESSLIST;
    [self.mRequests addObject:useraddress_reuqest];
}

-(void)loadLocalData
{
    sendtypeDict = [NSDictionary dictionaryWithContentsOfFile:  [IOSFactory getMainPath:@"sendtype" oftype:@"plist"]]  ;

    payModeDict  = [NSDictionary dictionaryWithContentsOfFile:  [IOSFactory getMainPath:@"paymode" oftype:@"plist"]]  ;[shopping_dict objectForKey:@"payMode"];
    
    sendTimeDict =[NSDictionary dictionaryWithContentsOfFile:  [IOSFactory getMainPath:@"sendtime" oftype:@"plist"]]  ; [shopping_dict objectForKey:@"sendTime"];
    
    invoiceContentDict =[[NSDictionary dictionaryWithContentsOfFile:  [IOSFactory getMainPath:@"invoice" oftype:@"plist"]] objectForKey:@"invoicetitle"] ;
    
    isinvoiceDict = [[NSDictionary dictionaryWithContentsOfFile:  [IOSFactory getMainPath:@"invoice" oftype:@"plist"]] objectForKey:@"isinvoice"];
    
    if (![shopping_dict objectForKey:@"payMode"]) {
        [shopping_dict setValue:@"2" forKey:@"payMode"];
    }
    if (![shopping_dict objectForKey:@"sendType"]) {
        [shopping_dict setValue:@"1" forKey:@"sendType"];
    }
    if (![shopping_dict objectForKey:@"sendTime"]) {
        [shopping_dict setValue:@"1" forKey:@"sendTime"];
    }
    
    if (![shopping_dict objectForKey:@"isinvoice"]) {
        [shopping_dict setValue:@"1" forKey:@"isinvoice"];
    }
    if (![shopping_dict objectForKey:@"invoicetitle"]) {
        [shopping_dict setValue:@"1" forKey:@"invoicetitle"];
    }
    if (![shopping_dict objectForKey:@"invoicecontent"]) {
        [shopping_dict setValue:nil forKey:@"invoicecontent"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self roundNaviationBar];
    self.title=NSLocalizedString(@"Create_Order", @"Create_Order");
    
    UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(dimissOrderViewController)];
    
      self.navigationItem.rightBarButtonItem=backItem;
    
    mTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50-44) style:UITableViewStyleGrouped];
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [self.view addSubview:mTableView];
    
    PrettyToolbar* shoppingTotalMoneyToolBar =[[PrettyToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-50-44, self.view.bounds.size.width, 50)];
    UIView* bottomSettleBar =[[UIView alloc] initWithFrame:CGRectMake(12, 6, 296, 33)];
    
    UILabel  *shopping_total_money_lable  =[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 90, 33)];
    [shopping_total_money_lable setBackgroundColor:[UIColor clearColor]];
    [shopping_total_money_lable setFont:[UIFont fontWithName:@"AppleGothic" size:17.0]];
    [shopping_total_money_lable setText:[NSString stringWithFormat:@"%@：",NSLocalizedString(@"Total_payable", @"Total_payable")]];
    [shopping_total_money_lable setTextColor:[UIColor blackColor]];
    
    shopping_total_money =[[UILabel alloc] initWithFrame:CGRectMake(90, 5, 120, 33)];
    [shopping_total_money setTextColor:[UIColor whiteColor]];
    [shopping_total_money setBackgroundColor:[UIColor clearColor]];
    [shopping_total_money setFont:[UIFont fontWithName:@"ArialMT" size:15.0]];
    
    [shopping_total_money setText:[NSString stringWithFormat:@"￥%.1f",mTotalprice]];

    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"cartbutton" ] forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"Land order", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(createOrder) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13]];
    [button setFrame:CGRectMake(220, 50/2-20, 80, 30)];
    [button.titleLabel setTextAlignment:UITextAlignmentCenter];
    self.mCreateOrderButton = button;
    
    [bottomSettleBar addSubview:button];
    [bottomSettleBar addSubview:shopping_total_money];
    [bottomSettleBar addSubview:shopping_total_money_lable];
    
    [shoppingTotalMoneyToolBar addSubview:bottomSettleBar];
     [self.view addSubview:shoppingTotalMoneyToolBar];
    
    userDefault =[NSUserDefaults standardUserDefaults];
    
    shopping_dict =[[NSMutableDictionary alloc] initWithCapacity:3];
    
    [self loadLocalData];
    
    [self.mTableView setBackgroundColor:[UIColor clearColor]];
    [self.mTableView setBackgroundView:nil];
    [self.view setBackgroundColor:BG_COLOR];

    
}


-(void)createOrder
{

    ASIFormDataRequest *order_post = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString: URL_LAND_ORDER]];
    NSArray* sProductList = [[CartManager shared] getAllCartProducts];

    for (ProductBean *p in sProductList)
    {
        [order_post addPostValue:[NSString stringWithFormat:@"%d",[p productId]] forKey:@"pid"];
        [order_post addPostValue:[NSString stringWithFormat:@"%d",[p shopcount]] forKey:@"num"];
    }
    [order_post setPostValue:[shopping_dict objectForKey:@"sendType"] forKey:@"stid"];
    
    [order_post setPostValue:[shopping_dict objectForKey:@"sendTime"] forKey:@"sdid"];
    
    [order_post setPostValue:[shopping_dict objectForKey:@"payMode"] forKey:@"pmid"];
    [order_post setPostValue:[mSelectedAddress addressId] forKey:@"aid"];
    [order_post setPostValue:[[UserManager shared] getSessionAppKey] forKey:@"appkey"];
    //1不要 0 要发票
    if ([[shopping_dict objectForKey:@"isinvoice"] isEqual:@"1"]) {
        [order_post setPostValue:@"0" forKey:@"isInvoice"];
    }
    if ([[shopping_dict objectForKey:@"isinvoice"] isEqual:@"2"]) {
        [order_post setPostValue:@"1" forKey:@"isInvoice"];
        [order_post setPostValue:[invoiceContentDict objectForKey:[shopping_dict objectForKey:@"invoicetitle"]] forKey:@"invoiceContent"];
        [order_post setPostValue:[shopping_dict objectForKey:@"invoicecontent"] forKey:@"invoiceName"];
        
    }
    //1不要 0 要会员价
    [order_post setPostValue:@"0" forKey:@"isMemberPrice"];
    [order_post startSynchronous];
    
    if (![order_post error]) {
        NSDictionary *dict =  [[order_post responseString] JSONValue];
        
        if ([dict objectForKey:@"status"])
        {
            alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Order_Success", @"Order_Success") message:NSLocalizedString(@"Order_Message", @"Order_Message") delegate:self cancelButtonTitle:NSLocalizedString(@"Order_GOMyAcount", "Order_GOMyAcount") otherButtonTitles: nil];
            [alert setDelegate:self];
            [alert show];
            alertString=@"success";            
            [[CartManager shared] clearCart];
            
            NSDictionary* sDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"1", @"result", nil];
            [MobClick event:@"UEID_LAND_ORDER" attributes:sDict];
        }
        else
        {
            alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Order_Fail", @"Order_Fail") message:NSLocalizedString(@"Order_Fail_Message", @"Order_Fail_Message") delegate:self cancelButtonTitle:NSLocalizedString(@"I_Know", "I_Know") otherButtonTitles:NSLocalizedString(@"Order_Phone", "Order_Phone"), nil];
            [alert setDelegate:self];
            [alert show];
            alertString=@"fail";
            
            NSDictionary* sDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"0", @"result", nil];
            [MobClick event:@"UEID_LAND_ORDER" attributes:sDict];
        }
    }
    
}


//-(void)createOrder{
//    ASIFormDataRequest *order_post = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.uzise.com/api/order/create.json" ]];
//     product_list =[NSArray arrayWithArray: [self createProductList]];
//    for (ProductBean *p in product_list) {
//        [order_post addPostValue:[NSString stringWithFormat:@"%d",[p productId]] forKey:@"pid"];
//        [order_post addPostValue:[NSString stringWithFormat:@"%d",[p shopcount]] forKey:@"num"];
//    }
//    [order_post setPostValue:[shopping_dict objectForKey:@"sendType"] forKey:@"stid"];
//  
//    [order_post setPostValue:[shopping_dict objectForKey:@"sendTime"] forKey:@"sdid"];
//    
//    [order_post setPostValue:[shopping_dict objectForKey:@"payMode"] forKey:@"pmid"];
//    [order_post setPostValue:[userAddressBean addressId] forKey:@"aid"];
//    [order_post setPostValue:[user appkey] forKey:@"appkey"];
//    //1不要 0 要发票
//    if ([[shopping_dict objectForKey:@"isinvoice"] isEqual:@"1"]) {
//        [order_post setPostValue:@"0" forKey:@"isInvoice"];
//    }
//    if ([[shopping_dict objectForKey:@"isinvoice"] isEqual:@"2"]) {
//        [order_post setPostValue:@"1" forKey:@"isInvoice"];
//        [order_post setPostValue:[invoiceTitleDict objectForKey:[shopping_dict objectForKey:@"invoicetitle"]] forKey:@"invoiceContent"];
//        [order_post setPostValue:[shopping_dict objectForKey:@"invoicecontent"] forKey:@"invoiceName"];
//        
//    }
//     //1不要 0 要会员价
//    [order_post setPostValue:@"0" forKey:@"isMemberPrice"];
//    [order_post startSynchronous];
//    
//    if (![order_post error]) {
//        NSDictionary *dict =  [[order_post responseString] JSONValue];
//               
//        if ([dict objectForKey:@"status"]) {
//            alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Order_Success", @"Order_Success") message:NSLocalizedString(@"Order_Message", @"Order_Message") delegate:self cancelButtonTitle:NSLocalizedString(@"Order_GOMyAcount", "Order_GOMyAcount") otherButtonTitles: nil];
//            [alert setDelegate:self];
//            [alert show];
//             alertString=@"success";
//            [userDefault setValue:nil forKey:Shopping_Cart];
//            [userDefault synchronize];
//            UITabBarItem *tabBarItem = [[[self.tabBarController tabBar] items] objectAtIndex:2];
//            
//            [tabBarItem setBadgeValue:nil];
//            
//        }else{
//            alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Order_Fail", @"Order_Fail") message:NSLocalizedString(@"Order_Fail_Message", @"Order_Fail_Message") delegate:self cancelButtonTitle:NSLocalizedString(@"I_Know", "I_Know") otherButtonTitles:NSLocalizedString(@"Order_Phone", "Order_Phone"), nil];
//            [alert setDelegate:self];
//            [alert show];
//            alertString=@"fail";
//        }
//    }
//
//}
-(void)dimissOrderViewController
{    
    [self dismissModalViewControllerAnimated:YES];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            //支付方式
            return 1;
            break;
        case 1:
            //配送方式
            return 2;
            break;
        case 2:
            
            //发票信息
            return 2;
            break;
        case 3:
            //优惠券/礼品卡
            return 0;
            break;
        case 4:
            //余额
            return 0;
            break;
        case 5:
            //金额
            return 6;
            break;
        default:
            break;
    }
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ShoppingOrderCellIdentifier = @"ShoppingOrderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShoppingOrderCellIdentifier];
    
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ShoppingOrderCellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    switch (indexPath.section) {
        case 0:{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setBackgroundColor:[UIColor whiteColor]];
             [tableView setSeparatorColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
         /*   UILabel *user_payment_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 30)];
            [user_payment_lable setText:NSLocalizedString(@"Payment", @"Payment")];
            [user_payment_lable setBackgroundColor:[UIColor clearColor]];
            [user_payment_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
          */
            
            [cell.textLabel setText:NSLocalizedString(@"Payment", @"Payment")];
            [cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
          
            user_payment = [[UILabel alloc] initWithFrame:CGRectMake(90, 7, 230, 30)];
           
            [user_payment setText: [payModeDict objectForKey:[shopping_dict objectForKey:@"payMode"]]];
           
            [user_payment setBackgroundColor:[UIColor clearColor]];
            [user_payment setTextColor:[UIColor grayColor]];
            [user_payment setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
            [user_payment setNumberOfLines:0];
            [user_payment setLineBreakMode:UILineBreakModeWordWrap];
            
         //   [cell.contentView addSubview:user_payment_lable];
            [cell.contentView addSubview:user_payment];
            break;
        }
        case 1:{
           
            [cell setBackgroundColor:[UIColor whiteColor]];
             [tableView setSeparatorColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
            switch (indexPath.row) {
                case 0:{
                   [cell setAccessoryType:UITableViewCellAccessoryNone];  
                    [cell.textLabel setText:NSLocalizedString(@"Distribution_way", @"Distribution_way")];
                    [cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
                   /*
                    
                    distribution_way_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 230, 30)];
                    [distribution_way_lable setText:@"普通快递"];
                    [distribution_way_lable setBackgroundColor:[UIColor clearColor]];
                    [distribution_way_lable setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
                    [distribution_way_lable setTextColor:[UIColor grayColor]];
                    [cell.contentView addSubview:distribution_way_lable];
                    */
                   
                    break;
                }
                case 1:{
                    
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                     [tableView setSeparatorColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
                    
                    //配送物流
                    UILabel *order_sendtype_lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 30)];
                    [order_sendtype_lable setText:[NSLocalizedString(@"Logistics", @"Logistics") stringByAppendingString:@"："]];
                    [order_sendtype_lable setBackgroundColor:[UIColor clearColor]];
                    [order_sendtype_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_sendtype_lable setTextColor:[UIColor grayColor]];
                    //配送日期
                    UILabel *order_deliverTime_lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 100, 50)];
                    [order_deliverTime_lable setText:[NSLocalizedString(@"DeliverTime", @"DeliverTime") stringByAppendingString:@"："]];
                    
                    [order_deliverTime_lable setBackgroundColor:[UIColor clearColor]];
                    [order_deliverTime_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_deliverTime_lable setTextColor:[UIColor grayColor]];
                    
                    
                    order_sendtype = [[UILabel alloc] initWithFrame:CGRectMake(70, 4, 200, 30)];
               
                    [order_sendtype setBackgroundColor:[UIColor clearColor]];
                    [order_sendtype setTextColor:[UIColor grayColor]];
                    [order_sendtype setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_sendtype setNumberOfLines:0];
                    [order_sendtype setLineBreakMode:UILineBreakModeWordWrap];
                    
                    order_deliverTime = [[UILabel alloc] initWithFrame:CGRectMake(70, 42, 200, 50)];
                 
                    [order_deliverTime setBackgroundColor:[UIColor clearColor]];
                    [order_deliverTime setTextColor:[UIColor grayColor]];
                    [order_deliverTime setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_deliverTime setNumberOfLines:0];
                    [order_deliverTime setLineBreakMode:UILineBreakModeWordWrap];
                    
            
                    [order_sendtype setText:[sendtypeDict objectForKey:[shopping_dict objectForKey:@"sendType"]]];
                    
                    [order_deliverTime setText:[sendTimeDict objectForKey:[shopping_dict objectForKey:@"sendTime"]]];
 
                    [cell.contentView addSubview:order_sendtype_lable];
                    [cell.contentView addSubview:order_sendtype];
                    [cell.contentView addSubview:order_deliverTime_lable];
                    [cell.contentView addSubview:order_deliverTime];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        case 2:{
           
            [cell setBackgroundColor:[UIColor whiteColor]];
             [tableView setSeparatorColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
            switch (indexPath.row) {
                case 0:{
                     [cell setAccessoryType:UITableViewCellAccessoryNone];
                    /*UILabel *user_nvoice_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 30)];
                    [user_nvoice_lable setText:NSLocalizedString(@"Invoice", @"Invoice")];
                    [user_nvoice_lable setBackgroundColor:[UIColor clearColor]];
                    [user_nvoice_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
                    
                    [cell.contentView addSubview:user_nvoice_lable];
                    */
                    [cell.textLabel setText:NSLocalizedString(@"Invoice", @"Invoice")];
                    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
                    [cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
                    break;
                }
                case 1:{
                    
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    //发票抬头lable
                    order_invoice_name_lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 30)];
                    [order_invoice_name_lable setText:[NSLocalizedString(@"Invoice_Name", @"Invoice_Name") stringByAppendingString:@"："]];
                    [order_invoice_name_lable setBackgroundColor:[UIColor clearColor]];
                    [order_invoice_name_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_invoice_name_lable setTextColor:[UIColor grayColor]];
                    [order_invoice_name_lable setHidden:YES];
                    //发票内容lable
                    order_invoice_content_lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 100, 50)];
                    [order_invoice_content_lable setText:[NSLocalizedString(@"Invoice_Content", @"Invoice_Content") stringByAppendingString:@"："]];
                    
                    [order_invoice_content_lable setBackgroundColor:[UIColor clearColor]];
                    [order_invoice_content_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_invoice_content_lable setTextColor:[UIColor grayColor]];
                    
                    
                    order_invoice_name = [[UILabel alloc] initWithFrame:CGRectMake(70, 2, 200, 30)];
                    [order_invoice_name setHidden:YES];
                 
                    [order_invoice_name setBackgroundColor:[UIColor clearColor]];
                    [order_invoice_name setTextColor:[UIColor grayColor]];
                    [order_invoice_name setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_invoice_name setNumberOfLines:0];
                    [order_invoice_name setLineBreakMode:UILineBreakModeWordWrap];
                    
                    order_invoice_Content = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 200, 50)];
         
                    [order_invoice_Content setBackgroundColor:[UIColor clearColor]];
                    [order_invoice_Content setTextColor:[UIColor grayColor]];
                    [order_invoice_Content setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_invoice_Content setNumberOfLines:0];
                    [order_invoice_Content setLineBreakMode:UILineBreakModeWordWrap];
                    
                    
                  //  [order_invoice_Content setText:[isinvoiceDict objectForKey:[shopping_dict objectForKey:@"isinvoice"]]];
                    
                    if ([[shopping_dict objectForKey:@"isinvoice"] isEqual:@"1"]) {
                        [order_invoice_name_lable setHidden:YES];
                        [order_invoice_name setHidden:YES];
                        [order_invoice_content_lable setFrame:CGRectMake(10, 30, 100, 30)];
                        [order_invoice_Content setFrame:CGRectMake(70, 30, 200, 30)];
                        [order_invoice_Content setText:[isinvoiceDict objectForKey:[shopping_dict objectForKey:@"isinvoice"]]];
                    }
                    
                    if ([[shopping_dict objectForKey:@"isinvoice"] isEqual:@"2"]) {
                        [order_invoice_name_lable setHidden:YES];
                        [order_invoice_name setHidden:YES];
                       
                        [order_invoice_name_lable setHidden:NO];
                        [order_invoice_name setHidden:NO];
                        [order_invoice_content_lable setFrame:CGRectMake(10, 40, 100, 50)];
                        [order_invoice_Content setFrame:CGRectMake(70, 40, 200, 50)];
                        
                        [order_invoice_name setText:[shopping_dict objectForKey:@"invoicecontent"]];
                        [order_invoice_Content setText:[invoiceContentDict objectForKey:[shopping_dict objectForKey:@"invoicetitle"]]];
                    }
            
                    [cell.contentView addSubview:order_invoice_name_lable];
                    [cell.contentView addSubview:order_invoice_name];
                    [cell.contentView addSubview:order_invoice_content_lable];
                    [cell.contentView addSubview:order_invoice_Content];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        case 3:{
             [tableView setSeparatorColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setText:NSLocalizedString(@"Gift_Card", @"Gift_Card")];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];

         //   UILabel *cash_lable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, <#CGFloat height#>)]
            
            break;
        }
        case 4:{
            [tableView setSeparatorColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setText:NSLocalizedString(@"Balance", @"Balance")];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];

            break;
        }
        case 5:{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
             [cell.textLabel setText:nil];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [tableView setSeparatorColor:[UIColor clearColor]];
            switch (indexPath.row) {
                case 0:{
                   
                /*    UIView* hideSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20, 30)];
                    hideSeparatorView.backgroundColor = [UIColor whiteColor];
                    hideSeparatorView.layer.masksToBounds = YES;
                    hideSeparatorView.layer.cornerRadius = 6.0;
                   // hideSeparatorView.layer.borderWidth = 1.0;
                    hideSeparatorView.layer.borderColor = [[UIColor grayColor] CGColor];
                  */ 
                    
                    
                    
                    UILabel *order_carsh_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_carsh_lable setText:NSLocalizedString(@"Order_Shopping_Cash", @"Order_Shopping_Cash")];
                    [order_carsh_lable setBackgroundColor:[UIColor clearColor]];
                    [order_carsh_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                  //  [order_carsh_lable setTextColor:[UIColor whiteColor]];
                    
                    UILabel *order_carsh = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_carsh setText:[NSString stringWithFormat:@"￥%.1lf",mTotalprice]];
                    [order_carsh setBackgroundColor:[UIColor clearColor]];
                    [order_carsh setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                  //  [order_carsh setTextColor:[UIColor whiteColor]];
                    [order_carsh setTextAlignment:UITextAlignmentRight];
                  //  [cell.contentView addSubview:hideSeparatorView];
                    [cell.contentView addSubview:order_carsh_lable];
                    [cell.contentView addSubview:order_carsh];
                    
                    break;
                }
                case 1:{
                    
                    UIView* hideSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20, 30)];
                    hideSeparatorView.backgroundColor = [UIColor whiteColor];
                    
                    
                    
                    UILabel *order_shopping_cash_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_shopping_cash_lable setText:NSLocalizedString(@"Order_Shopping_Freight", @"Order_Shopping_Freight")];
                    [order_shopping_cash_lable setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_cash_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_shopping_cash_lable setTextColor:[UIColor grayColor]];
                    
                    
                    UILabel *order_shopping_cash = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_shopping_cash setText:[NSString stringWithFormat:@"￥%.1lf",freight]];
                    [order_shopping_cash setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_cash setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_shopping_cash setTextColor:[UIColor redColor]];
                    [order_shopping_cash setTextAlignment:UITextAlignmentRight];
                    
                    //[hideSeparatorView addSubview:order_carsh_lable];
                  //  [cell.contentView addSubview:hideSeparatorView];
                    [cell.contentView addSubview:order_shopping_cash_lable];
                    [cell.contentView addSubview:order_shopping_cash];
                    break;
                }
                case 2:{
                    UIView* hideSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20, 30)];
                    hideSeparatorView.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *order_shopping_freight_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_shopping_freight_lable setText:NSLocalizedString(@"Order_Shopping_Preferential", @"Order_Shopping_Preferential")];
                    [order_shopping_freight_lable setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_freight_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_shopping_freight_lable setTextColor:[UIColor grayColor]];
                    
                    
                    
                    UILabel *order_shopping_freight = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_shopping_freight setText:[NSString stringWithFormat:@"￥%.1lf",retailTotalPrice]];
                    [order_shopping_freight setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_freight setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_shopping_freight setTextColor:[UIColor redColor]];
                    [order_shopping_freight setTextAlignment:UITextAlignmentRight];
                    
                 //   [cell.contentView addSubview:hideSeparatorView];
                    [cell.contentView addSubview:order_shopping_freight_lable];
                    [cell.contentView addSubview:order_shopping_freight];
                 //   [cell setBackgroundColor:[UIColor whiteColor]];
                    
                    break;
                }
                case 3:{
                    UIView* hideSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20, 30)];
                    hideSeparatorView.backgroundColor = [UIColor whiteColor];
                    
                    
                    UILabel *order_shopping_preferential_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_shopping_preferential_lable setText:NSLocalizedString(@"Order_Shopping_payedMoney", @"Order_Shopping_payedMoney")];
                    [order_shopping_preferential_lable setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_preferential_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_shopping_preferential_lable setTextColor:[UIColor grayColor]];
                    
                    
                    UILabel *order_shopping_preferential = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_shopping_preferential setText:[NSString stringWithFormat:@"-￥%.1f",fabs(0.0)]];
                    [order_shopping_preferential setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_preferential setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_shopping_preferential setTextColor:[UIColor redColor]];
                    [order_shopping_preferential setTextAlignment:UITextAlignmentRight];
                    
                    
                 //   [cell.contentView addSubview:hideSeparatorView];
                    [cell.contentView addSubview:order_shopping_preferential_lable];
                    [cell.contentView addSubview:order_shopping_preferential];
                  //  [cell setBackgroundColor:[UIColor whiteColor]];
                    break;
                }
                case 4:{
                    UIView* hideSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20, 30)];
                    hideSeparatorView.backgroundColor = [UIColor whiteColor];
                    [cell.contentView addSubview:hideSeparatorView];
                    
                    UILabel *order_shopping_payed_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_shopping_payed_lable setText:NSLocalizedString(@"Balance", @"Balance")];
                    [order_shopping_payed_lable setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_payed_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_shopping_payed_lable setTextColor:[UIColor grayColor]];
                    
                    
                    
                    UILabel *order_shopping_payed = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_shopping_payed setText:[NSString stringWithFormat:@"-￥%.1f",fabs(0.0)]];
                    [order_shopping_payed setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_payed setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_shopping_payed setTextColor:[UIColor redColor]];
                    [order_shopping_payed setTextAlignment:UITextAlignmentRight];
                    
                //    [cell.contentView addSubview:hideSeparatorView];
                    [cell.contentView addSubview:order_shopping_payed_lable];
                    [cell.contentView addSubview:order_shopping_payed];
                 //   [cell setBackgroundColor:[UIColor whiteColor]];
                    break;
                }
                case 5:{
                    
                    UILabel *order_shopping_balance_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_shopping_balance_lable setText:NSLocalizedString(@"Cash_back", @"Cash_back")];
                    [order_shopping_balance_lable setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_balance_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_shopping_balance_lable setTextColor:[UIColor grayColor]];
                    
                    
                    UILabel *order_shopping_balance = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_shopping_balance setText:[NSString stringWithFormat:@"-￥%.1f",fabs(0.0)]];
                    [order_shopping_balance setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_balance setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_shopping_balance setTextColor:[UIColor redColor]];
                    [order_shopping_balance setTextAlignment:UITextAlignmentRight];
                    
                    [cell.contentView addSubview:order_shopping_balance_lable];
                    [cell.contentView addSubview:order_shopping_balance];
              //      [cell setBackgroundColor:[UIColor whiteColor]];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        default:
            break;
    }
    
    
    return cell;

}

-(void)viewAddressList
{
    AddressListController* sAddressListController =[[AddressListController alloc] initWithAddressList:self.mAddressList andSelectedAddressID:self.mSelectedAddress.addressId];
    sAddressListController.mDelegate = self;
    
    [self.navigationController pushViewController:sAddressListController animated:YES];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        for (UIView *view in [title_view subviews]) {
            [view removeFromSuperview];
        }
        for (UIGestureRecognizer *gestureRecognizer in [title_view gestureRecognizers]) {
            [gestureRecognizer removeTarget:self action:@selector(viewAddressList)];
        }
        
        
        title_view =nil;
  
        title_view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 90.5)];
        
        [title_view setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *singleGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAddressList)];
        
        [title_view addGestureRecognizer:singleGestureRecognizer];
        
        UILabel *userAddress_name =[[UILabel alloc] initWithFrame:CGRectMake(15, 12, 120, 30)];
        
        
        [userAddress_name setBackgroundColor:[UIColor clearColor]];
        [userAddress_name setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:13.0]];
        [userAddress_name setTextColor:[UIColor blackColor]];
//        [UIFont boldSystemFontOfSize:30];
        UILabel *userAddress_mobile =[[UILabel alloc] initWithFrame:CGRectMake(110, 12, 120, 30)];
        [userAddress_mobile setBackgroundColor:[UIColor clearColor]];
        [userAddress_mobile setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:13.0]];
        [userAddress_mobile setTextColor:[UIColor blackColor]];
        
        UILabel *userAddress_address =[[UILabel alloc] initWithFrame:CGRectMake(15, 45, 260, 30)];
     //   [order_status setText:[[order order_Status] orderStatusName]];
        [userAddress_address setBackgroundColor:[UIColor clearColor]];
        [userAddress_address setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:13.0]];
        [userAddress_address setTextColor:[UIColor blackColor]];
        
        [userAddress_address setLineBreakMode:UILineBreakModeWordWrap];
        [userAddress_address setNumberOfLines:0];

        
        DTCustomColoredAccessory* sAccessory = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeRight enabled:NO];
        sAccessory.frame = CGRectMake(276, 40, 15, 15);
        
        UIImageView *imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address"]];
        imageView.layer.cornerRadius = 8;
        [imageView setFrame:CGRectMake(10, 10, 300, 90.5)];
        [imageView setUserInteractionEnabled:YES];
        //需要添加手指触摸功能
        [title_view addSubview:imageView];
        
        
        [imageView addSubview:userAddress_name];
        [imageView addSubview:userAddress_mobile];
        [imageView addSubview:userAddress_address];
        [imageView addSubview:sAccessory];
        
        //
        if (mSelectedAddress)
        {
            [userAddress_name setText:[mSelectedAddress consignee]];
            [userAddress_mobile setText:[mSelectedAddress mobile]];
            [userAddress_address setText:[NSString stringWithFormat:@"%@%@%@%@",[[mSelectedAddress provence] ProvinceName],[[mSelectedAddress city] CityName],[[mSelectedAddress area] AreaName],[mSelectedAddress address] ]];
        }
       
        return title_view;
    }else
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 110;
    }
    else return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 44;
            break;
        case 1:if (indexPath.row==1) {
            return 100;
        }else
            return 44;
            break;
        case 2:{
            if (indexPath.row==1) {
                return 100;
            }else
            return 44;
            break;
        }
        case 3:
            return 44;
            break;
        case 4:{    
                return 44;
           
            break;
        }
        case 5:{
                return 30;
            break;
        }
        default:
            return 44;
            break;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            //disable   paymode  setting
//            if (_modalPanel!=nil) {
//                [_modalPanel removeFromSuperview];
//                _modalPanel =nil;
//            }
//            //  [self.orderTableView setScrollEnabled:NO];
//            _modalPanel = [[PayModeViewController alloc] initWithFrame:self.view.bounds title:NSLocalizedString(@"Please_Selet", @"Please_Selet") dict:shopping_dict] ;
//            _modalPanel.delegate = self;
//            // _modalPanel.shop_dict = [NSMutableDictionary dictionaryWithDictionary:_address_dict];
//            
//            [self.view addSubview:_modalPanel];
//            [_modalPanel showFromPoint:CGPointMake(tableView.center.x, tableView.center.y)];
            break;
        }
        case 1:{
            ShippingTypeViewController *orderSendTypeViewController =[[ShippingTypeViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [orderSendTypeViewController setShopping_dict:shopping_dict];
            [self.navigationController pushViewController:orderSendTypeViewController animated:YES];
            
            break;
        }
        case 2:{
            InvoiceViewController *orderInvoiceViewController  =[[InvoiceViewController alloc] init];
            [orderInvoiceViewController setShopping_dict:shopping_dict];
            [self.navigationController pushViewController:orderInvoiceViewController animated:YES];
            break;
        }
        default:
            break;
    }
       
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertString isEqualToString:@"success" ]) {
        
        if (buttonIndex==0) {
            [self dismissModalViewControllerAnimated:YES];
            
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            
            UITabBarController *tabBarController =(UITabBarController *)window.rootViewController;
            
            //跳转回首页
            [tabBarController setSelectedIndex:3];
            [self removeFromParentViewController];
        }
        
    }
    //注册失败
    if ([alertString isEqualToString:@"fail" ]) {
        if (buttonIndex==0) {
            [self dimissOrderViewController];
        }
        if (buttonIndex==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-716-1818"]];
        }
    }
}


#pragma mark - UAModalDisplayPanelViewDelegate

// Optional: This is called before the open animations.
//   Only used if delegate is set.
- (void)willShowModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"willShowModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called after the open animations.
//   Only used if delegate is set.
- (void)didShowModalPanel:(PayModeViewController *)modalPanel {
	UADebugLog(@"didShowModalPanel called with modalPanel: %@", modalPanel);
    //  UITableView *t = [modalPanel table];
    //[t selectRowAtIndexPath:[modalPanel currentIndexPath] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
}

// Optional: This is called when the close button is pressed
//   You can use it to perform validations
//   Return YES to close the panel, otherwise NO
//   Only used if delegate is set.
- (BOOL)shouldCloseModalPanel:(PayModeViewController *)modalPanel {
	UADebugLog(@"shouldCloseModalPanel called with modalPanel: %@", modalPanel);
    
    
	return YES;
}

// Optional: This is called when the action button is pressed
//   Action button is only visible when its title is non-nil;
//   Only used if delegate is set and not using blocks.
- (void)didSelectActionButton:(UAModalPanel *)modalPanel {
	UADebugLog(@"didSelectActionButton called with modalPanel: %@", modalPanel);
}

// Optional: This is called before the close animations.
//   Only used if delegate is set.
- (void)willCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"willCloseModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called after the close animations.
//   Only used if delegate is set.
- (void)didCloseModalPanel:(PayModeViewController *)modalPanel
{
	UADebugLog(@"didCloseModalPanel called with modalPanel: %@", modalPanel);
    
    NSString *key =[modalPanel payModeKey];
   
    [shopping_dict setValue:key forKey:@"payMode"];
    
    [self.mTableView reloadData];
 
}


#pragma mark -
- (void)requestFinished:(ASIHTTPRequest *)useraddress_reuqest
{
    if (useraddress_reuqest
        && ![useraddress_reuqest error])
    {
            NSArray* sAddressList = [[useraddress_reuqest responseString] JSONValue];
            //打开新建收货地址窗口
            if (!sAddressList
                || [sAddressList count]<=0)
            {
                AddressEditorController *userAddressEditViewController =[[AddressEditorController alloc] initWithAddress:nil create:YES];
                userAddressEditViewController.mDelegate = self;
                [self.navigationController pushViewController:userAddressEditViewController animated:YES];
            }
            else
            {
                if (!self.mAddressList)
                {
                    self.mAddressList = [NSMutableArray arrayWithCapacity:sAddressList.count];
                }
                
                for (NSDictionary* userAddress_dict in sAddressList)
                {
                    UserAddressBean* sAddress =[[UserAddressBean alloc] init];
                    //    NSLog(@"id==%@",[userAddress_dict objectForKey:@"id"]);
                    [sAddress setAddressId:[userAddress_dict objectForKey:@"id"]];
                    [sAddress setConsignee:[userAddress_dict objectForKey:@"consignee"]];
                    [sAddress setTelphone:[userAddress_dict objectForKey:@"telphone"]];
                    [sAddress setMobile:[userAddress_dict objectForKey:@"mobile"]];
                    AreaBean *area =[[AreaBean alloc] init];
                    [area setAreaID:[[userAddress_dict objectForKey:@"area"] objectForKey:@"id"]];
                    [area setAreaName:[[userAddress_dict objectForKey:@"area"] objectForKey:@"name"]];
                    [area setCityID:[[userAddress_dict objectForKey:@"area"] objectForKey:@"cityId"]];
                    
                    CityBean *city =[[CityBean alloc] init];
                    [city setCityID:[[userAddress_dict objectForKey:@"city"] objectForKey:@"id"]];
                    [city setCityName:[[userAddress_dict objectForKey:@"city"] objectForKey:@"name"]];
                    [city setProvinceId:[[userAddress_dict objectForKey:@"city"] objectForKey:@"provinceId"]];
                    
                    ProvinceBean *province =[[ProvinceBean alloc] init];
                    [province setProvinceID:[[userAddress_dict objectForKey:@"province"] objectForKey:@"id"]];
                    [province setProvinceName:[[userAddress_dict objectForKey:@"province"] objectForKey:@"name"]];
                    
                    [sAddress setArea:area];
                    [sAddress setCity:city];
                    [sAddress setProvence:province];
                    
                    [sAddress setPostcode:[userAddress_dict objectForKey:@"postcode"]];
                    
                    [sAddress setAddress:[userAddress_dict objectForKey:@"address"]];

                    [self.mAddressList addObject:sAddress];
                    
                    if ([sAddress.addressId isEqualToString:[[UserManager shared] getLastAddressID]])
                    {
                        self.mSelectedAddress = sAddress;
                    }
                        
                }
                
                //
                if (!self.mSelectedAddress)
                {
                    self.mSelectedAddress = [self.mAddressList objectAtIndex:0];
                }
                
                [mTableView reloadData];
                self.view.userInteractionEnabled = YES;
                
                [UIView animateWithDuration:0.5 animations:^
                {
                    self.mDarkenView.alpha = 0;
                }
                completion:^(BOOL finished)
                {
                    [self.mDarkenView removeFromSuperview];
                    self.mDarkenView.alpha = 0.3;
                }];
            }
    }
    
    [self hideHud]; 
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideHud];
}

#pragma mark - AddressSettingDelegate
- (void) changedWithModifiedAddress:(UserAddressBean*)aModifiedAddress
{
    self.mSelectedAddress = aModifiedAddress;
}

- (void) changeWithNewAddress:(UserAddressBean*)aNewAddress
{
    self.mSelectedAddress = aNewAddress;
    
    [self.mAddressList addObject:aNewAddress];
}

- (void) changeWithSelectAddress:(UserAddressBean*)aNewAddress
{
    self.mSelectedAddress = aNewAddress;
}


@end
