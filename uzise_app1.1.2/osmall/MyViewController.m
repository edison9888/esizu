

#import "MyViewController.h"

#import "UserBean.h"

#import "LoginViewController.h"

#import "Constant.h"

#import "AddressListController.h"

#import "UIViewController+URLData.h"

#import "OrderListViewController.h"

#import "ProductBean.h"

#import "NewBaseCellCell.h"

#import "ProductViewController.h"
#import "PrettyNavigationController.h"
#import "UserManager.h"
#import "Global.h"
#import "TaggedView.h"

@interface MyViewController ()
//订单列表
-(void)orderlist:(id)sender;
//用户注销
-(void)userLoginOut:(id)sender;
//控件注册
-(void)registerControl;
//判断当前用户是否登陆
-(void)loginIfNecessary;
//点击产品跳转
-(void)viewProductController:(UIGestureRecognizer *)gestureRecognizer;

@property(nonatomic,strong)UIView *mHeaderView;

@property(nonatomic,strong) NSArray *product_hot_list;

@property Boolean isLogin;

@property(nonatomic,strong) UserBean *user;

@end

@implementation MyViewController
@synthesize user,isLogin,mHeaderView,product_hot_list;

-(void)orderlist:(id)sender{
    
    OrderListViewController *order_list=[[OrderListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [order_list setUser_appkey:[user appkey]];
    
    [self.navigationController pushViewController:order_list animated:YES];
    
    
}

-(void)userLoginOut:(id)sender
{
    [[UserManager shared] logout];
    
    LoginViewController* sLoginViewController = [[LoginViewController alloc] init];
    PrettyNavigationController* sNavLoginController = [[PrettyNavigationController alloc] initWithRootViewController: sLoginViewController];
    [self  presentModalViewController:sNavLoginController animated:YES];
    
    //登录时候清空数值
    [self setUser:nil];
        
    for (UIView *view in self.view.subviews) {
        if (view.tag==1000||view.tag==2000) {
            [view removeFromSuperview];
        }
    }
    
    [mTableView reloadData];
    
    isLogin =NO;
    
    [mTableView reloadData];
    [self reloadInputViews];
    
    
}


//-(void)userLoginOut:(id)sender
//{
//    LoginViewController* sLoginViewController = [[LoginViewController alloc] init];
//    PrettyNavigationController* sNavLoginController = [[PrettyNavigationController alloc] initWithRootViewController: sLoginViewController];
//    [self  presentModalViewController:sNavLoginController animated:YES];
//    
//    //登录时候清空数值
//    [self setUser:nil];
//    
//    [nsUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:User_Online];
//    
//    [nsUserDefaults setObject:[NSNumber numberWithBool:YES]forKey:App_First_Start];
//    
//    for (UIView *view in self.view.subviews) {
//        if (view.tag==1000||view.tag==2000) {
//            [view removeFromSuperview];
//        }
//    }
//   
//    [table reloadData];
//    
//    [nsUserDefaults setValue:[NSNumber numberWithBool:NO]forKey:Remember_LoginUser_Button];
//    
//    [nsUserDefaults setValue:nil forKey:User_Session];
//    
//    [nsUserDefaults synchronize];
//    
//    isLogin =NO;
//    
//    [table reloadData];
//    [self reloadInputViews];
//    
//  
//}


-(void)registerControl
{
    for (UIView *view in self.view.subviews) {
        if (view.tag==1000||view.tag==2000) {
            [view removeFromSuperview];
        }
    }
    
    loginOut = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Log_Out", @"Log_Out") style:UIBarButtonItemStyleBordered target:self action:@selector(userLoginOut:)];
    
    [self.navigationItem setRightBarButtonItem:loginOut];
    [loginOut setTag:1000];
        
    carousel =[[iCarousel alloc] initWithFrame:CGRectMake(0, 200, 320, mainScreenHeight-200-80)];
    carousel.type = iCarouselTypeCoverFlow2;
    
    carousel.delegate =self;
    carousel.dataSource =self;
      [carousel setTag:2000];
    
    [self.view addSubview:carousel];
  
    [carousel reloadData];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loginIfNecessary];
}

- (void) loginIfNecessary
{
    if ([[UserManager shared] isInsession])
    {
        UserBean* sUserBean = [[UserManager shared] getSessionUserBean];
        [self setUser:sUserBean];
        
        NSArray *host_product_list = [[UserManager shared] getSessionHotProduts];
        [self setProduct_hot_list:host_product_list];
        
        isLogin=YES;
        [mTableView reloadData];
        [self registerControl];
        return;
    }
    
    NSString* sUserName = [[UserManager shared] getLastLoginUserName];
    NSString* sUserPassword = [[UserManager shared] getLastPassword];
                              
    if (sUserName.length > 0
        && sUserPassword.length > 0)
    {
        [self showHud];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            E_LOGIN_RESULT_TYPE sLoginResultType = [[UserManager shared] loginWithName:sUserName andPassword:sUserPassword];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideHud];
                
                if (sLoginResultType == E_LOGIN_RESULT_TYPE_SUCCESS)
                {
                    UserBean* sUserBean = [[UserManager shared] getSessionUserBean];
                    [self setUser:sUserBean];
                    
                    NSArray *host_product_list = [[UserManager shared] getSessionHotProduts];
                    [self setProduct_hot_list:host_product_list];
                    
                    isLogin=YES;
                    [mTableView reloadData];
                    [self registerControl];
                    return;
                }//if
                else
                {
                    LoginViewController* sLoginViewController = [[LoginViewController alloc] init];
                    PrettyNavigationController* sNavLoginController = [[PrettyNavigationController alloc] initWithRootViewController: sLoginViewController];
                    [self.tabBarController presentModalViewController:sNavLoginController animated:YES];
                }
            });


        });

    }//if
    else
    {
        LoginViewController* sLoginViewController = [[LoginViewController alloc] init];
        PrettyNavigationController* sNavLoginController = [[PrettyNavigationController alloc] initWithRootViewController: sLoginViewController];
        [self.tabBarController presentModalViewController:sNavLoginController animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) style:UITableViewStyleGrouped];
    [mTableView setDataSource:self];
    [mTableView setDelegate:self];
    [mTableView setBackgroundColor:BG_COLOR];
    [mTableView setBackgroundView:nil];
    mTableView.scrollEnabled = NO;
    [self.view addSubview:mTableView];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bh"]]];
    [self roundNaviationBar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return isLogin?1:0; //自己用5
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (isLogin)
    {
        if (section==0)
        {
            return  2; //自己用4
        }
//        if (section==1) {
//            return  2;
//        }
//        if (section==2) {
//            return  1;
//        }
//        if (section==3) {
//            return  2;
//        }
//        if (section==4) {
//            return  1;
//        }
        
    }
        return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (isLogin) {
        
        static NSString *myCellIdentifier = @"MyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCellIdentifier];
             [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }

        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        switch (indexPath.section) {
            case 0:{
                
                switch (indexPath.row) {
                    case 0:
                    {
                               
                        cell.textLabel.text=NSLocalizedString(@"Address_Management", @"Address_Management");
                        cell.imageView.image=[UIImage imageNamed:@"38-airplane"];
                        [cell.textLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0]];
//                        [cell.textLabel setTextColor:[UIColor grayColor]];
                        break;
                    }
                    case 1:
                    {
                       
                        cell.textLabel.text=NSLocalizedString(@"My_Order", @"My_Order");
                        cell.imageView.image=[UIImage imageNamed:@"259-list"];
                        [cell.textLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0]];
//                        [cell.textLabel setTextColor:[UIColor grayColor]];
                        break;
                    }
//                    case 2:{
//                        cell.textLabel.text=NSLocalizedString(@"User_Point_Management", @"User_Point_Management");
//                        cell.imageView.image=[UIImage imageNamed:@"97-puzzle-piece"];
//                        
//                        [cell.textLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0]];
//                        [cell.textLabel setTextColor:[UIColor grayColor]];
//                        
//                        break;
//                    }
//                    case 3:{
//                        
//                        cell.textLabel.text=NSLocalizedString(@"Group_Order_Management", @"Group_Order_Management");
//                        cell.imageView.image=[UIImage imageNamed:@"96-book"];
//                        [cell.textLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0]];
//                        [cell.textLabel setTextColor:[UIColor grayColor]];
//                        break;
//                    }
                    default:
                        break;
                }
                
                break;
            }
            case 1:{
                
                switch (indexPath.row) {
                    case 0:{
                        cell.textLabel.text=NSLocalizedString(@"Cash_Card_Management", @"Cash_Card_Management");
                        cell.imageView.image=[UIImage imageNamed:@"162-receipt"];
                        [cell.textLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0]];
                        [cell.textLabel setTextColor:[UIColor grayColor]];
                        break;
                    }
                    case 1:{
                        
                        cell.textLabel.text=NSLocalizedString(@"Invite_Friend", @"Invite_Friend");
                        cell.imageView.image=[UIImage imageNamed:@"24-gift"];
                        [cell.textLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0]];
                        [cell.textLabel setTextColor:[UIColor grayColor]];
                        break;
                    }
                        default:
                        break;
                }
       
                break;
            }
            case 2:{
                cell.textLabel.text=NSLocalizedString(@"Pallet_Management", @"Pallet_Management");
                cell.imageView.image=[UIImage imageNamed:@"257-box3"];
                [cell.textLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0]];
                [cell.textLabel setTextColor:[UIColor grayColor]];
                break;
            }
            case 3:{
                switch (indexPath.row) {
                    case 0:{
                        cell.textLabel.text=NSLocalizedString(@"Product_Comment", @"Product_Comment");
                        cell.imageView.image=[UIImage imageNamed:@"09-chat-2"];
                        [cell.textLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0]];
                        [cell.textLabel setTextColor:[UIColor grayColor]];
                        break;
                    }
                    case 1:{
                        
                        cell.textLabel.text=NSLocalizedString(@"My_Question", @"My_Question");
                        cell.imageView.image=[UIImage imageNamed:@"216-compose"];
                        [cell.textLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0]];
                        [cell.textLabel setTextColor:[UIColor grayColor]];
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
    
    // Configure the cell...
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        
        if (isLogin) {
            for (UIView *view in [mHeaderView subviews]) {
                [view removeFromSuperview];
            }
            
            mHeaderView =nil;
            
            mHeaderView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 120)];
            
            [mHeaderView setUserInteractionEnabled:YES];
            
            UIImageView *user_pic_imageview =[[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 90, 90)];
            [user_pic_imageview setImage:[UIImage imageNamed:@"noavatar.png"]];
            [user_pic_imageview.layer setCornerRadius:5.0];
            [user_pic_imageview.layer setMasksToBounds:YES];
           // [user_pic_imageview.layer setBorderWidth:1.0];
            
            UILabel *user_name_lable =[[UILabel alloc] initWithFrame:CGRectMake(110, 12, 130, 21)];
            [user_name_lable setText:[user userName] ];
            [user_name_lable setBackgroundColor:[UIColor clearColor]];
            [user_name_lable setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:16.0]];

            UILabel *user_levelname_lable =[[UILabel alloc] initWithFrame:CGRectMake(240, 12, 80, 21)];
            [user_levelname_lable setText:[user levelName]];
            [user_levelname_lable setTextAlignment:UITextAlignmentCenter];
            [user_levelname_lable setBackgroundColor:[UIColor clearColor]];
            [user_levelname_lable setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:16.0]];
            
            UILabel *user_point_lable =[[UILabel alloc] initWithFrame:CGRectMake(110, 39, 180, 21)];
            [user_point_lable setText:[NSString stringWithFormat:@"%@: %d",NSLocalizedString(@"Point", @"Point"),[user points]]];
            [user_point_lable setBackgroundColor:[UIColor clearColor]];
            [user_point_lable setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:16.0]];
            
            UILabel *user_cash_lable  =[[UILabel alloc] initWithFrame:CGRectMake(110, 68, 180, 21)];
            [user_cash_lable setText:[NSString stringWithFormat:@"%@: %.1f%@",NSLocalizedString(@"Balance", @"Balance"),0.00, NSLocalizedString(@"Currency Unit", nil)]];
            [user_cash_lable setBackgroundColor:[UIColor clearColor]];
            [user_cash_lable setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:16.0]];
            
            [mHeaderView addSubview:user_pic_imageview];
            
            [mHeaderView addSubview:user_levelname_lable];
            
            [mHeaderView addSubview:user_name_lable];
            
            [mHeaderView addSubview:user_point_lable];
            
            [mHeaderView addSubview:user_cash_lable];
            
            
            return mHeaderView;
        }else{
            return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
        }
        
    }else
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
//        return 120;
        return [self tableView:tableView viewForHeaderInSection:0].bounds.size.height;
    }
    else return 1;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            AddressListController *userAddressViewController =[[AddressListController alloc] initWithSelectedAddressID:[[UserManager shared] getLastAddressID]];
            userAddressViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userAddressViewController animated:YES];
        }
        else if (indexPath.row==1)
        {
            OrderListViewController *order_list=[[OrderListViewController alloc] initWithStyle:UITableViewStyleGrouped];
            order_list.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:order_list animated:YES];
        }
        else
        {
            //
        }
    }
}

#pragma mark -
#pragma mark iCarousel methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [product_hot_list count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewProductController:)];
        
        
        ProductBean *p  =[product_hot_list objectAtIndex:index] ;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120.0f, 120.0f)];
         [imageView setImageWithURL:[NSURL URLWithString:[p product_url]] placeholderImage: [UIImage imageNamed:@"placeholder400×400.png"]];
        view = [[[TaggedView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)] autorelease];
        UILabel *productName_lable =[[UILabel alloc] initWithFrame:CGRectMake(0, 110, 120.0f, 51.0f)];
        [productName_lable setBackgroundColor:[UIColor clearColor]];
        [productName_lable setText:[p productName]];
        [productName_lable setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:13.0]];
        [productName_lable setTextAlignment:UITextAlignmentCenter];
        [productName_lable setNumberOfLines:0];
        [productName_lable setLineBreakMode:UILineBreakModeWordWrap];
 
        UILabel *price_lable =[[UILabel alloc] initWithFrame:CGRectMake(0, 140, 120.0f, 31.0f)];
        [price_lable setBackgroundColor:[UIColor clearColor]];
        [price_lable setText:[NSString stringWithFormat:@"现价:%.1f",[p price]]];
        [price_lable setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:13.0]];
        [price_lable setTextAlignment:UITextAlignmentCenter];
      //  [((UIImageView *)view) setImageWithURL:[NSURL URLWithString:[[product_hot_list objectAtIndex:index] product_url]] placeholderImage:nil];
        view.contentMode = UIViewContentModeCenter;
        view.tag =[p productId];
        ((TaggedView*)view).mTag = [p productName];
        
        [view addGestureRecognizer:singleTap];
        [view addSubview:imageView];
        [view addSubview:productName_lable];
        [view addSubview:price_lable];
       
    }
    return view;
}


-(void)viewProductController:(UIGestureRecognizer *)gestureRecognizer
{
    TaggedView* sView = (TaggedView*)gestureRecognizer.view;
    
    ProductViewController *productViewController = [[ProductViewController alloc] initWithProductName:sView.mTag];
   
    [productViewController setProduct_id:sView.tag];
    
    [self.navigationController pushViewController:productViewController animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    if (![request error]) {
        
            
            
            if ([[[request responseString] JSONValue] objectForKey:@"error.code"]) {
                
                [self showAlert:NSLocalizedString(@"User_Password_Error", @"User_Password_Error") cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                
                return;
            }else{
                NSDictionary *user_dict =[[request responseString] JSONValue];
                UserBean *userbean =[[UserBean alloc] init];
                [userbean setEmail:[user_dict objectForKey:@"email"]];
                [userbean setUserid:[[user_dict objectForKey:@"id"] integerValue]];
                [userbean setMobile:[user_dict objectForKey:@"mobile"] ];
                [userbean setLevelName:[user_dict objectForKey:@"levelName"]];
                [userbean setPoints:[[user_dict objectForKey:@"points"] integerValue]];
                
                [userbean setUserName:[user_dict objectForKey:@"userName"]];
                [userbean setRealName:[user_dict objectForKey:@"realName"]];
                [userbean setSex:[[user_dict objectForKey:@"sex"] integerValue]];
                [userbean setSex:[[user_dict objectForKey:@"sex"] integerValue]];
                [userbean setAppkey:[user_dict objectForKey:@"appkey"]];
                [self setUser:userbean];
                isLogin=YES;
                
                //热门推荐
                NSMutableArray *host_product_list =[NSMutableArray array];
                
                NSArray *list  =[user_dict objectForKey:@"hotproductList"];
                // NSLog(@"%@",list);
                for (NSDictionary *p_dict in list) {
                    ProductBean * p =[[ProductBean alloc] init];
                    [p setPrice:[[p_dict objectForKey:@"price"] doubleValue]];
                    [p setProductId:[[p_dict objectForKey:@"productId"] integerValue]];
                    [p setProductName:[p_dict objectForKey:@"productName"]];
                    [p setProductNO:[p_dict objectForKey:@"productNo"]];
                    [p setRetallPrice:[[p_dict objectForKey:@"retailPrice"] doubleValue]];
                    [p setShopPrice:[[p_dict objectForKey:@"shopPrice"] doubleValue]];
                    [p setProduct_url:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/App_Product_Image/%@/120/1.png",[p_dict objectForKey:@"productNo"]]];
                    [host_product_list addObject:p];
                    
                    p=nil;
                }
                [self setProduct_hot_list:host_product_list];
            }
        [mTableView reloadData];
        
        isLogin =YES;
        
        [self registerControl];
    }
   
    // [self.tableView reloadData];
    
    // Use when fetching binary data
    //NSData *responseData = [request responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //NSError *error = [request error];
}

@end
