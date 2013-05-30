

#import "ProductListController.h"

#import "DejalActivityView.h"

#import "IOSFactory.h"

#import "ProductBean.h"

#import "OSMallTools.h"

#import "ProductViewController.h"

#import "Constant.h"

#import "UIViewController+URLData.h"

#import "ASIHTTPRequest.h"

#import "SBJson.h"

#import "UIImageView+WebCache.h"

#import "PrettyKit.h"

#import "UserBean.h"
#import "UIViewController+URLData.h"
#import "Global.h"
#import "UserManager.h"

@interface ProductListController ()

@property(nonatomic,strong) NSMutableDictionary *sortDict;

@end

@implementation ProductListController
@synthesize table,typeID,sortDict,mCurSortType;

-(void)buttonAction:(UISegmentedControl *)sender
{
    if (!dataList
        || dataList.count <= 0)
    {
        return;
    }
    
    NSInteger index = sender.selectedSegmentIndex;
  //  NSMutableDictionary *tempDict =[[NSMutableDictionary alloc]initWithCapacity:2];
    sortDict =[[NSMutableDictionary alloc]initWithCapacity:2];
    switch (index) {
        case 0:
            [sortDict setObject:@"price" forKey:@"property"] ;
            if (price_sort) {
                price_sort=NO;
               // [tempDict setObject:[NSNumber numberWithBool:NO] forKey:@"isasc"] ;
               // [self performSelector:@selector(showDefaultDejaBySort:) withObject:tempDict];
            }else {
                price_sort =YES;
       
            }
            [sortDict setObject:[NSNumber numberWithBool:price_sort] forKey:@"isasc"] ;
             [self performSelector:@selector(sortProducts) withObject:nil]; 
            break;
        case 1:
            [sortDict setObject:@"quantity" forKey:@"property"] ;
            [sortDict setObject:[NSNumber numberWithBool:NO] forKey:@"isasc"] ;
            [self performSelector:@selector(sortProducts) withObject:nil];
            break;
        case 2:
            if (date_sort) {
                date_sort=NO;
            }else {
                date_sort =YES;
                
            }
            [sortDict setObject:@"datetime" forKey:@"property"] ;
            [sortDict setObject:[NSNumber numberWithBool:date_sort] forKey:@"isasc"] ;
            [self performSelector:@selector(sortProducts) withObject:nil];
            
            break;
        default:
            break;
    }
}

-(void)sortProducts
{
    NSArray *temparray = [[NSArray arrayWithArray:dataList ]mutableCopy];
    
    dataList =  [NSArray arrayWithArray:  [IOSFactory sortObject:temparray sortName:[sortDict objectForKey:@"property"] isAsc:[[sortDict objectForKey:@"isasc"] boolValue]
                                           ]
                 ];
    temparray =nil;
    [self.table reloadData];
}

-(void)fetchDone
{
    [self hideHud];
    
    if (!dataList
        || dataList.count <= 0)
    {
        [self showNotice:NSLocalizedString(@"Network error", nil)];
    }
}

-(void)loadData
{
    
    NSString *url = [NSString stringWithFormat:@"%@?tid=%d", URL_PRODUCT_IN_CATEGORY, typeID];
    if ([[UserManager shared] getSessionAppKey].length > 0)
    {
        url = [url stringByAppendingFormat:@"&appkey=%@", [[UserManager shared] getSessionAppKey]];
    }
    
    ASIHTTPRequest* sRequest = [self asynLoadByURLStr:url withCachePolicy:E_CACHE_POLICY_USE_CACHE_IF_EXISTS_IN_SESSION];
    [self.mRequests addObject:sRequest];
    
    url =nil;
}


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
    
 
    UINavigationBar* sControlPanelBar =[[PrettyNavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    
    UINavigationItem *navigationItem=[[UINavigationItem alloc]initWithTitle:nil];
    NSArray *buttons = [NSArray arrayWithObjects:NSLocalizedString(@"Price", nil), NSLocalizedString(@"Sales", nil), NSLocalizedString(@"Shelf Time", nil), nil];
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:buttons];
    [segmentedControl setBounds:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    
    [segmentedControl setMomentary:YES];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    [segmentedControl addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setWidth:100.f forSegmentAtIndex:0];
    [segmentedControl setWidth:100.f forSegmentAtIndex:1];
    [segmentedControl setWidth:100.f forSegmentAtIndex:2];
        
    [sControlPanelBar pushNavigationItem:navigationItem animated:NO];
    
    navigationItem.titleView = segmentedControl;

    [self.view addSubview:sControlPanelBar];
    
    
	// Do any additional setup after loading the view.
    UITableView* sTableView =  [[UITableView alloc]initWithFrame:CGRectMake(0, sControlPanelBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-137) style:UITableViewStylePlain];
    sTableView.dataSource = self;
    sTableView.delegate = self;
    sTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table = sTableView;

    
    [self.view addSubview:table];
    
    UIView* sBgView = [[UIView alloc] initWithFrame:self.table.bounds];
    sBgView.backgroundColor = [UIColor whiteColor];
    [self.table setBackgroundColor:[UIColor whiteColor]];
    [self.table setBackgroundView:sBgView];
    
    [self.view setBackgroundColor:BG_COLOR];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!dataList
        || dataList.count <= 0)
    {
        [self showHud];
        [self loadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //反选 清楚已经选择的
    NSIndexPath *selectedIndexPath = [self.table indexPathForSelectedRow];
    
    [self.table deselectRowAtIndexPath:selectedIndexPath animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    sortDict =nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  /* */
  
    static NSString *CategoryCellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CategoryCellIdentifier];
    }
    
    if ([dataList count] !=0)
    {
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        ProductBean *product   =[dataList objectAtIndex:indexPath.row];
        
        UIImageView *imgview =[[UIImageView alloc]init];
       
        NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/App_Product_Image/%@/120/1.png",[product productNO]]];
        
        [imgview setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder180×180.png"]];
        
        imgview.frame = CGRectMake(10, 10, 70, 70);
        [cell.contentView addSubview:imgview];
       
        
        UILabel *product_lable = [[UILabel alloc] initWithFrame:CGRectMake(100, -10, 160, 80)];
        [product_lable setText:[product productName]];
        [product_lable setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:18.0]];
        [product_lable setNumberOfLines:2];
        [product_lable setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:product_lable];
        
        UILabel *price_lable = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 160, 30)];
        [price_lable setText:[NSString stringWithFormat:@"%@￥:%.1f", NSLocalizedString(@"Price", @"Price"),[product price]]];
        [price_lable setFont:[UIFont fontWithName:@"AmericanTypewriter" size:15.0]];
        [price_lable setBackgroundColor:[UIColor clearColor]];
        
        [cell.contentView addSubview:price_lable];
        
        
        //
        UIView* sSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 89, tableView.bounds.size.width, 1)];
        sSeperatorView.backgroundColor = RGBA_COLOR(222, 222, 222, 1);
        sSeperatorView.layer.shadowColor = [RGBA_COLOR(224, 224, 224, 1) CGColor];
        sSeperatorView.layer.shadowOffset = CGSizeMake(0, 0);
        sSeperatorView.layer.shadowOpacity = .5f;
        sSeperatorView.layer.shadowRadius = 20.0f;
        sSeperatorView.clipsToBounds = NO;
        sSeperatorView.layer.cornerRadius = 5;
        
        [cell.contentView addSubview:sSeperatorView];
        
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIView* sBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        sBackgroundView.backgroundColor = [UIColor whiteColor];
        [cell setBackgroundView:sBackgroundView];
        [cell setBackgroundColor:[UIColor whiteColor]];
          
    }    
    return cell;
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
        
        // Display the newly loaded image
    cell.imageView.image = picImage;
    picImage =nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    ProductBean *product   =[dataList objectAtIndex:indexPath.row];
    
    ProductViewController *productViewController = [[ProductViewController alloc] initWithProductName:product.productName];
    productViewController.product_id = [product productId];

    [NSThread detachNewThreadSelector:@selector(backgroundLoadingData:) toTarget:self withObject:productViewController];
}


-(void)backgroundLoadingData:(id)sender{
    @autoreleasepool {
           [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving:) withObject:sender waitUntilDone:NO];
    }
}

-(void)makeMyProgressBarMoving:(id)sender
{
    ProductViewController *productViewController =sender;
    [self.navigationController pushViewController:productViewController animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    if (![request error]) {
        
        NSDictionary *product_list =[[request responseString] JSONValue];
        
        NSMutableArray *mu = [[NSMutableArray alloc]initWithCapacity:[product_list count]];
        
        for (NSDictionary *product_dict in [product_list objectForKey:@"children"]) {
            ProductBean *product =[[ProductBean alloc] init];
            
            [product setProductId:[[product_dict objectForKey:@"productId"] integerValue]];
            
            [product setProductName:[product_dict objectForKey:@"typeName"]];
            
            [product setProductNO:[product_dict objectForKey:@"productNo"]];
            
            [product setPrice:[[product_dict objectForKey:@"price"] doubleValue]];
            
            [product setRetallPrice:[[product_dict objectForKey:@"retailPrice"] doubleValue]];
            
            [product setQuantity:[[product_dict objectForKey:@"productCount"] integerValue]];
            
            [product setDatetime:[IOSFactory NSStringToNSDate:[product_dict objectForKey:@"creatTime"]]];
            
            [product setProductTypeName:[product_list objectForKey:@"typeName"] ];
            
            [product setProductTypeId:[[product_list objectForKey:@"typeId"] integerValue]];
            
            [mu addObject:product];
            product =nil;
        }
        
        
        dataList =[NSArray arrayWithArray:mu];
        [self.table reloadData];
        //清空内存
        product_list =nil;
        mu =nil;
    }
    [self performSelectorOnMainThread:@selector(fetchDone) withObject:nil waitUntilDone:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self performSelectorOnMainThread:@selector(fetchDone) withObject:nil waitUntilDone:NO];
}

@end
