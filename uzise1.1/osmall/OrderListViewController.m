//
//  OrderListViewController.m
//  uzise
//
//  Created by edward on 12-10-17.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "OrderListViewController.h"

#import "UIViewController+URLData.h"

#import "OrderBean.h"

#import "UserBean.h"

#import "ProductBean.h"

#import "Constant.h"

#import "OrderDetailsViewController.h"
#import "UserManager.h"
#import "Global.h"

#define DEFAULT_PAGE_SIZE 5

@interface OrderListViewController ()
//动态显示变量
@property(nonatomic,strong)NSMutableArray *order_view_list;

@property(nonatomic,strong)NSMutableArray *order_list;

@property BOOL mIsLoadingMore;
//分页
@property NSInteger mPageIndex;
//分页
@property NSInteger total_order_page;

-(void)fetchData;

-(UIView*)createTableFooter;

- (void) loadDataEnd;

- (void) loadMore;

@end

@implementation OrderListViewController
@synthesize user_appkey,order_view_list,order_list,mPageIndex,total_order_page,mIsLoadingMore;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        user_appkey = [[UserManager shared] getSessionAppKey];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"My_Order", @"My_Order")];
    
    mPageIndex = 0;
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    [self.view setBackgroundColor:BG_COLOR];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!order_list
        || order_list.count <= 0)
    {
        [self showHud];
        [self fetchData];
    }
}

-(void) fetchData
{
    mPageIndex++;
    
    ASIHTTPRequest* sRequest =[self asynLoadByURLStr:[NSString stringWithFormat:@"%@?appkey=%@&page_no=%d&pageSize=%d", URL_GET_ORDERS, user_appkey, mPageIndex, DEFAULT_PAGE_SIZE] withCachePolicy:E_CACHE_POLICY_NO_CACHE];
    
    [self.mRequests addObject:sRequest];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 80;
            break;
        case 1:
            return 80;
            break;
        case 2:
            return 30;
            break;
        default:
            return 30;
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [order_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    OrderBean *row_order  =[order_list objectAtIndex:indexPath.section];
    
    switch (indexPath.row) {
        case 0:{
      
            UILabel *order_number_lable =[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 20)];
            [order_number_lable setText:[NSLocalizedString(@"Order_Number", @"Order_Number") stringByAppendingString:@"："]];
            [order_number_lable setBackgroundColor:[UIColor clearColor]];
            [order_number_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
            [order_number_lable setTextColor:[UIColor grayColor]];
            
            
            UILabel *order_number =[[UILabel alloc] initWithFrame:CGRectMake(85, 5, 150, 20)];
            [order_number setText:[row_order orderNumber] ];
            [order_number setBackgroundColor:[UIColor clearColor]];
            [order_number setFont:[UIFont fontWithName:@"ArialMT" size:15.0]];
            
            UILabel *order_price_lable =[[UILabel alloc] initWithFrame:CGRectMake(5, 30, 150, 20)];
            [order_price_lable setText:[NSLocalizedString(@"Order_Cash", @"Order_Cash") stringByAppendingString:@"："]];
            [order_price_lable setBackgroundColor:[UIColor clearColor]];
            [order_price_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
            [order_price_lable setTextColor:[UIColor grayColor]];
            
            UILabel *order_price =[[UILabel alloc] initWithFrame:CGRectMake(83, 30, 150, 20)];
            [order_price setText:[NSString stringWithFormat:@"￥%.1f",[row_order toPrice]] ];  
            [order_price setBackgroundColor:[UIColor clearColor]];
            [order_price setFont:[UIFont fontWithName:@"ArialMT" size:15.0]];
            [order_price setTextColor:[UIColor redColor]];
           
            
            UILabel *order_createtime_lable =[[UILabel alloc] initWithFrame:CGRectMake(5, 55, 150, 20)];
            [order_createtime_lable setText:[NSLocalizedString(@"Order_CreateTime", @"Order_CreateTime") stringByAppendingString:@"："]];
            [order_createtime_lable setBackgroundColor:[UIColor clearColor]];
            [order_createtime_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
            [order_createtime_lable setTextColor:[UIColor grayColor]];
            
            
            UILabel *order_createtime =[[UILabel alloc] initWithFrame:CGRectMake(85, 55, 150, 20)];
            [order_createtime setText:[IOSFactory NSDateToNSString:[row_order createTime] ]];
            [order_createtime setBackgroundColor:[UIColor clearColor]];
            [order_createtime setFont:[UIFont fontWithName:@"ArialMT" size:15.0]];
           // [order_createtime setTextColor:[UIColor redColor]];
            
            
            [cell.contentView addSubview:order_number];
            [cell.contentView addSubview:order_number_lable];
            [cell.contentView addSubview:order_price_lable];
            [cell.contentView addSubview:order_price];
            [cell.contentView addSubview:order_createtime_lable];
            [cell.contentView addSubview:order_createtime];
             [cell setAccessoryType:UITableViewCellAccessoryNone];
            break;
        }
            
        case 1:{
            
             if ([[row_order product_list] count]==1) {
            
                 UILabel *single_productName_lable =[[UILabel alloc] initWithFrame:CGRectMake(85, 30, 180, 20)];
                 [single_productName_lable setText:[[[row_order product_list] objectAtIndex:0] productName]];
                 [single_productName_lable setBackgroundColor:[UIColor clearColor]];
                 [single_productName_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
                 [cell.contentView addSubview:single_productName_lable];
                 
                 
                 UIImageView *imageview = [[UIImageView alloc] init];
                 [imageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/App_Product_Image/%@/120/1.png",[[[row_order product_list] objectAtIndex:0] productNO]]]placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
                 
                 [imageview setBackgroundColor:[UIColor clearColor]];
                 imageview.frame =CGRectMake(6, 10, 60, 60);
                 [cell.contentView addSubview:imageview];
                 imageview =nil;
             }else{
                 for (int i =0 ;i< [[row_order product_list]count];i++ ) {
                     
                     if (i==4) {
                         break;
                     }
                     
                     ProductBean *p = [[row_order product_list] objectAtIndex:i];
                     
                     @autoreleasepool {
                         UIImageView *imageview = [[UIImageView alloc] init];
                         [imageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/App_Product_Image/%@/120/1.png",[p productNO]]]placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
                         
                         [imageview setBackgroundColor:[UIColor clearColor]];
                          imageview.frame =CGRectMake(6+68*i, 10, 60, 60);
                         
                         [cell.contentView addSubview:imageview];
                         imageview =nil;
                         p=nil;
                     }
                     
                 }
             }
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
          /*
            NSArray *list  =[row_order product_imageview_list];
            
            if ([list count]>1) {
               
                for (int i =0; i<[list count]; i++) {
                    
                    if (i==4) {
                        break;
                    }

                    UIImageView *imageview =[list objectAtIndex:i];
                                   
                   imageview.frame =CGRectMake(6+68*i, 10, 60, 60);
                   
                    [cell.contentView addSubview:imageview];
                }
                    
            
            }else{
                if ([list count]>0) {
                    UIImageView *imageview =[list objectAtIndex:0];
                    imageview.frame =CGRectMake(6, 10, 60, 60);
                    [cell.contentView addSubview:imageview];
                }
               
            
                if ([[row_order product_list] count]>0) {
                    UILabel *single_productName_lable =[[UILabel alloc] initWithFrame:CGRectMake(85, 30, 180, 20)];
                    [single_productName_lable setText:[[[row_order product_list] objectAtIndex:0] productName]];
                    [single_productName_lable setBackgroundColor:[UIColor clearColor]];
                    [single_productName_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
                    [cell.contentView addSubview:single_productName_lable];
                }
                
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            */
            break;
        }
        case 2:{
            
            UILabel *order_status_lable =[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 20)];
            [order_status_lable setText:[NSLocalizedString(@"Order_Status", @"Order_Status") stringByAppendingString:@"："]];
            [order_status_lable setBackgroundColor:[UIColor clearColor]];
            [order_status_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
            [order_status_lable setTextColor:[UIColor grayColor]];
            
            UILabel *order_status =[[UILabel alloc] initWithFrame:CGRectMake(85, 5, 80, 20)];
            [order_status setText:[row_order orderStatus]];
            [order_status setBackgroundColor:[UIColor clearColor]];
            [order_status setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
            [order_status setTextColor:[UIColor redColor]];
            
            [cell.contentView addSubview:order_status_lable];
            [cell.contentView addSubview:order_status];
            break;
        }
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        OrderBean *order =[order_list objectAtIndex:indexPath.section];
        
        if ([[order product_list] count]>0)
        {
            OrderDetailsViewController *orderretailViewController = [[OrderDetailsViewController alloc] initWithOrderID:order.orderId];
            [self.navigationController pushViewController:orderretailViewController animated:YES];
        }

    }
}

//判断底部
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 下拉到最底部时显示更多数据
    if(mPageIndex<total_order_page&&!mIsLoadingMore && scrollView.contentOffset.y > ((scrollView.contentSize.height*1.0 - scrollView.frame.size.height * 1.0)))
    {
        [self performSelectorInBackground:@selector(loadMore) withObject:nil ];
    }

    
}

// 开始加载数据
- (void) loadMore
{
    if (mIsLoadingMore == NO)
    {
        NSLog(@"loading more...");        
        if (mPageIndex<total_order_page)
        {
            mIsLoadingMore = YES;
        
            [self fetchData];
        }
    }
}

// 加载数据完毕
- (void) loadDataEnd
{
    mIsLoadingMore = NO;
    
    if (mPageIndex < total_order_page)
    {
        self.tableView.tableFooterView = [self createTableFooter];
    }
    else
    {
        self.tableView.tableFooterView = nil;
    }
}

// 创建表格底部
- (UIView*) createTableFooter
{    
    for (UIView *view in [self.tableView.tableFooterView subviews])
    {
        [view removeFromSuperview];
    }
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)];
    
    //
    UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(120.0f, 10.0f, 20.0f, 20.0f)];
    [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [tableFooterActivityIndicator startAnimating];
    [tableFooterView addSubview:tableFooterActivityIndicator];
    
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(150.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    [loadMoreText setText:NSLocalizedString(@"Loading...", nil)];
    [loadMoreText setBackgroundColor:[UIColor clearColor]];
    
    [tableFooterView addSubview:loadMoreText];
    
    return tableFooterView;
}

#pragma mark -
- (void)requestFinished:(ASIHTTPRequest *)order_request
{
    NSMutableArray *tempList ;

    if (order_request
        && ![order_request error]) {
                
        if (total_order_page == 0)
        {
            total_order_page = [IOSFactory totalPageNumber:[[[[order_request responseString] JSONValue] objectForKey:@"orderCount"] integerValue] pageSize:DEFAULT_PAGE_SIZE];
        }
        
        NSArray *order_result_list =[[[order_request responseString] JSONValue] objectForKey:@"list"];
        
        tempList =[[NSMutableArray alloc] initWithCapacity:[order_result_list count]];
        
        /*   order_view_list_count = [order_result_list count];
         
         order_view_list_count =20;
         
         if (order_view_list_count<20) {
         order_view_list_count =[order_result_list count];
         }
         
         NSLog(@"%d--order_view_list_count",order_view_list_count);
         
         
         order_view_list = [[NSMutableArray alloc] initWithCapacity:20];
         */
        if ([order_result_list count]<=0) {
            
        }else{
            
            
            for (int i =0; i<[order_result_list count]; i++) {
                
                NSDictionary *order_dict  =[order_result_list objectAtIndex:i];
                //for (NSDictionary *order_dict in order_result_list) {
                
                //  ASIHTTPRequest *order_detail_request =[self loadURLToRequest:[NSString stringWithFormat:@"http://uzise.com/api/order/detail.json?appkey=%@&id=%@",user_appkey,[order_dict objectForKey:@"id"]]];
                
                NSMutableArray *request_product_list = [NSMutableArray array];
                
                NSMutableArray *request_product_imageview_list = [NSMutableArray array];
                
                for (NSDictionary *product_request_dict in [order_dict objectForKey:@"orderDetails"] ) {
                    
                    ProductBean *product =[[ProductBean alloc] init];
                    [product setProductId:[[product_request_dict objectForKey:@"productId"] integerValue]];
                    [product setProductName:[product_request_dict objectForKey:@"productName"]];
                    [product setProductNO:[product_request_dict objectForKey:@"productNo"]];
                    //销售
                    //  [product setQuantity:[[product_request_dict objectForKey:@"quantity"] integerValue]];
                    [request_product_list addObject:product];
                    
                    product =nil;
                }
                
                
                OrderBean *order = [[OrderBean alloc] init];
                
                [order setProduct_list:request_product_list];
                [order setProduct_imageview_list:request_product_imageview_list];
                [order setOrderId:[order_dict objectForKey:@"id"]];
                [order setOrderNumber:[order_dict objectForKey:@"number"]];
                [order setOrderStatus:[[order_dict objectForKey:@"orderStatus"] objectForKey:@"name"]];
                [order setPayMode:[[order_dict objectForKey:@"payMode"] objectForKey:@"name"]];
                [order setCreateTime:[NSDate dateWithTimeIntervalSinceReferenceDate:[[order_dict objectForKey:@"creatTime"] doubleValue]/1000.0]];
                
                UserBean *user =[[UserBean alloc] init];
                [user setUserid:[[[order_dict objectForKey:@"user"] objectForKey:@"id"] integerValue]];
                [user setEmail:[[order_dict objectForKey:@"user"] objectForKey:@"email"] ];
                [user setRealName:[[order_dict objectForKey:@"user"] objectForKey:@"realName"] ];
                
                [order setUser:user];
                [order setToPrice:[[order_dict objectForKey:@"totalPrice"] doubleValue]];
                
                [tempList addObject:order];
                order =nil;
                order_dict =nil;
            }
        }
    }
        
    if (!order_list)
    {
        order_list = tempList;
    }
    else
    {
        [order_list addObjectsFromArray:tempList];
    }
    
    [self hideHud];

    [self.tableView reloadData];
    [self loadDataEnd];

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideHud];
    [self loadDataEnd];
}
@end
