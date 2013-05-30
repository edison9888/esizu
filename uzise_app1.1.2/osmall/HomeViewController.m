

#import "HomeViewController.h"

#import "NewBaseCellCell.h"

#import "NewsBean.h"

#import "NewsViewController.h"

#import "Constant.h"

#import "UIViewController+URLData.h"

#import "HomeBean.h"

#import "UIImageView+WebCache.h"

#import "ProductViewController.h"

#import "NewsListViewController.h"
#import "Global.h"
#import "TaggedImageView.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xbdf0ff]

#define TAG_REQUEST_POSTER  1
#define TAG_REQUEST_NEWS  2


@interface HomeViewController ()
{
    BOOL mIsUsingCache;
}

@property (nonatomic, assign) BOOL mIsUsingCache;

@end


@implementation HomeViewController
@synthesize textlabel;
@synthesize mIsUsingCache;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.mIsUsingCache = NO;
        muDataList =[[NSMutableArray alloc] initWithCapacity:4];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.mIsLoading)
    {
        if (!(dataList.count>0)
            || self.mIsUsingCache)
        {
            [muDataList removeAllObjects];
            [self loadData];
        }

    }
}

-(void)createHomeBeanList:(NSArray *)list starPosition:(NSInteger)starPosition returnlist:(NSMutableArray *)return_list twoAD:(BOOL)twoAD view:(UIView *)view
{
    if ((starPosition==[list count]&&!twoAD)||starPosition>[list count])
    {
        return ;
    }
    else
    {
        NSArray *list_data;
        if (twoAD)
        {
            list_data = [list objectAtIndex:starPosition-1];
        }
        else
        {
            list_data =  [list objectAtIndex:starPosition];
        }
       
        NSURL *pic_url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.uzise.com%@",[list_data objectAtIndex:3]]];
        TaggedImageView *imageView = [[TaggedImageView alloc] init];
        [imageView setImageWithURL:pic_url placeholderImage:[UIImage imageNamed:@"placeholder640×300.png"]];
        [imageView setUserInteractionEnabled:YES];
        
        [imageView setTag:[[list_data objectAtIndex:2]integerValue]];
        imageView.mTag = [list_data objectAtIndex:1];
        
        UITapGestureRecognizer *singleTap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetected:)];
        [imageView addGestureRecognizer:singleTap];
        
      if (twoAD)
      {
        if (starPosition%2==0)
        {
           imageView.frame=CGRectMake(160, 0, 160, 98);
            
           [view addSubview:imageView];
            
            [return_list addObject:view];
            
            view =nil;
        }else{
            if (view==nil) {
                view = [[UIView alloc] init];
            }
            imageView.frame=CGRectMake(0, 0, 160, 98);
            [view addSubview:imageView];
        }
          
      }else{
       
          [return_list addObject:imageView];
      }
          
        imageView =nil;
        
        starPosition++;
       
       return  [self createHomeBeanList:list starPosition:starPosition returnlist:return_list twoAD:twoAD view:view];
        
    }

}

-(void)loadData
{
    [self showHud];
    ASIHTTPRequest *request = [self asynLoadByURLStr:URL_HOME_POSTER withCachePolicy:E_CACHE_POLICY_USE_CACHE_IF_NETWORK_FAILS_X_SESSION];
    request.tag = TAG_REQUEST_POSTER;
    [self.mRequests addObject:request];
    
    ASIHTTPRequest *newrequest = [self asynLoadByURLStr:URL_HOME_NEWS withCachePolicy:E_CACHE_POLICY_USE_CACHE_IF_NETWORK_FAILS_X_SESSION];
    newrequest.tag = TAG_REQUEST_NEWS;
    [self.mRequests addObject:newrequest];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];   
    [self roundNaviationBar];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    imageView.frame=CGRectMake(115, 5, 97, 36);
    [imageView setTag:100];
    //[navigationBar addSubview:imageView];
    [self.navigationController.navigationBar insertSubview:imageView atIndex:0];
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // [self.tableView setBackgroundColor:[UIColor grayColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setShowsHorizontalScrollIndicator:NO];

    [self.view setBackgroundColor:BG_COLOR];
    
    //
    UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Home", nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    switch (section) {
        case 0:
        case 1:
        case 2:
        {
            return 1;
            break;
        }
        case 3:
        {
            return 4;
            break;
        }
            
        default:
            return 1;
            break;
    }
}

-(void)tapDetected:(UITapGestureRecognizer *)sender
{
    TaggedImageView* sTaggedImageView = (TaggedImageView*)sender.view;
    ProductViewController *productViewController = [[ProductViewController alloc] initWithProductName:sTaggedImageView.mTag];
    [productViewController setProduct_id:sTaggedImageView.tag];
    
    for (UIImageView *imageview in navigationBar.subviews)
    {
        if (imageview.tag==100) {
           [imageview setHidden:YES];
        }
    }
    [self.navigationController pushViewController:productViewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tempsavedata = nil;
    if ([dataList count]!=0) {
     
        NSArray *temparry =nil;
        switch (indexPath.section) {
            case 0:
            {
                static NSString *timerRollADCellIdentifier = @"timerRollCell";
                NewBaseCellCell  *sCell =[tableView dequeueReusableCellWithIdentifier:timerRollADCellIdentifier];
     
                if (!sCell)
                {
                    sCell =[[NewBaseCellCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timerRollADCellIdentifier isShowPageControl:YES isLoopScrollView:NO scrollCiewDataScoure:[dataList objectAtIndex:indexPath.section] ScrollViewCellHeight:150 scrollContentY:0 pageControlPointY:140 Timing:5.0f];
                }
                
                tempsavedata =nil;
                temparry =nil;
                return sCell;
                break;
            }
            case 1:
            {
                static NSString *Section_1_LoopADCellIdentifier = @"Section_1_LoopADCell";
                NewBaseCellCell *cell =[tableView dequeueReusableCellWithIdentifier:Section_1_LoopADCellIdentifier];
                
                if (cell==nil) {
                 
        
                     cell =[[NewBaseCellCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Section_1_LoopADCellIdentifier isShowPageControl:NO isLoopScrollView:YES scrollCiewDataScoure:[dataList objectAtIndex:indexPath.section] ScrollViewCellHeight:100 scrollContentY:0 pageControlPointY:100/2+20 Timing:-3.0f];
                }
                return cell;
                break;
            }                      
            case 2:{
                static NSString *Section_2_LoopADCellIdentifier = @"Section_2_LoopADCell";
                NewBaseCellCell *cell =[tableView dequeueReusableCellWithIdentifier:Section_2_LoopADCellIdentifier];
                
                if (cell==nil)
                {
                    cell =[[NewBaseCellCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Section_2_LoopADCellIdentifier isShowPageControl:NO isLoopScrollView:YES scrollCiewDataScoure:[dataList objectAtIndex:indexPath.section] ScrollViewCellHeight:100 scrollContentY:0 pageControlPointY:100/2+20 Timing:-3.0f];
                }
                return cell;
                break;
            }
        
            case 3:{
                static NSString *CellIdentifier = @"Cell";
                PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell==nil) {
                    cell =[[PrettyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.tableViewBackgroundColor = tableView.backgroundColor;
                    cell.gradientStartColor = start_color;
                    cell.gradientEndColor = end_color;
                    [cell prepareForTableView:tableView indexPath:indexPath];
                     cell.textLabel.backgroundColor = [UIColor clearColor];
                     [cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                }
                                
                if ([[dataList objectAtIndex:indexPath.section] count]==indexPath.row) {
                    cell.textLabel.text = NSLocalizedString(@"MoreNews","news") ;
                     cell.textLabel.textAlignment =UITextAlignmentCenter;
                    
                }else {
       
                      NewsBean *news  = [[dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]; 
                    cell.textLabel.text = [news title];
                  
               }
                return cell;
            }
            default:
                break;
        }
    }
       return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}
//头部栏目
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return  nil;
            break;
        case 1:
        {
            UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 31)];
            
            UIImageView *startView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xing"]];
            startView.frame=CGRectMake(5, 0, 30, 30);
             [startView setBackgroundColor:[UIColor clearColor]];
            UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
            
            [label setBackgroundColor:[UIColor clearColor]];
            label.frame =CGRectMake(40, 2, tableView.frame.size.width-50, 31);
            
            label.text=NSLocalizedString(@"Season_hot", @"Season_hot");
            [view  setBackgroundColor:
            [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg02"]]
            ] ;
            
            [view addSubview:startView];
            [view addSubview:label];
            return view;
            break;   
        }
        case 2:{
            
            UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            UIImageView *startView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xing"]];
            startView.frame=CGRectMake(5, 0, 30, 30);
             [startView setBackgroundColor:[UIColor clearColor]];
            UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
            
            [label setBackgroundColor:[UIColor clearColor]];
            label.frame =CGRectMake(40, 2, tableView.frame.size.width-50, 31);
            label.text=NSLocalizedString(@"Month_Promotions", @"Month_Promotions");
            [view  setBackgroundColor:
             [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg02"]]
             ] ;
            [view addSubview:startView];
            [view addSubview:label];
            return view;
            break;   
        }
      
        case 3:{
            
            UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            UIImageView *startView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xing"]];
            startView.frame=CGRectMake(5, 0, 30, 30);
            [startView setBackgroundColor:[UIColor clearColor]];
            UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
            
            [label setBackgroundColor:[UIColor clearColor]];
            label.frame =CGRectMake(40, 2, tableView.frame.size.width-50, 31);
            
            label.text=NSLocalizedString(@"Home_News", @"Home_News");
            [view  setBackgroundColor:
             [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg02"]]
             ] ;
            [view addSubview:startView];
            [view addSubview:label];
            return view;
            break;   
        }
        default:
            return  nil;
            break;
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?0:31;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return 150;
        }
        case 1:
        case 2:{
            return 98;
            break;
        }
        case 3:{
            return 30;
            break;
        }
        default:
            return 20;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3)
    {
        if (indexPath.row==3)
        {
            NewsListViewController *morenews =[[NewsListViewController alloc] initWithStyle:UITableViewStylePlain];
            [morenews setTitle:NSLocalizedString(@"Home_News", @"Home_News")];
            morenews.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:morenews animated:YES];
        }
        else
        {
        
            UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
            NewsViewController *news =[[NewsViewController alloc] init];
            [news setTitle:cell.textLabel.text];
            [news setUrl:[[[dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] contentURL]];
            news.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:news animated:YES];
        }
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIImageView *imageView = (UIImageView *)[self.navigationController.navigationBar viewWithTag:100];
    if (viewController == self)
    {
        [UIView animateWithDuration:0.5 animations:^{
            imageView.alpha = 1;
        }];
    }
    else
    {        
        [UIView animateWithDuration:0.5 animations:^{
            imageView.alpha = 0;
        }];
    }
}

#pragma mark -
- (void)requestFinished:(ASIHTTPRequest *)request
{    
    self.mIsUsingCache = request.didUseCachedResponse;
    
    if (request.tag == TAG_REQUEST_POSTER)
    {

        NSArray *url_list_poster = [[[request responseString] JSONValue] objectForKey:@"list"];
        
        NSArray *url_list_month = [[[request responseString] JSONValue] objectForKey:@"month_promotions"];
        
        NSArray *url_list_season = [[[request responseString] JSONValue] objectForKey:@"left_ad"];
        
        mPosterAds = [[NSMutableArray alloc] initWithCapacity:[url_list_poster count]];
        
        mMonthAds = [[NSMutableArray alloc] initWithCapacity:[url_list_month count]];
        
        mSeasonAds = [[NSMutableArray alloc] initWithCapacity:[url_list_season count]];
        
        [self createHomeBeanList:url_list_poster starPosition:0 returnlist:mPosterAds twoAD:NO view:nil];
        
        [self createHomeBeanList:url_list_month starPosition:1 returnlist:mMonthAds twoAD:YES view:[[UIView alloc] init]];
        
        [self createHomeBeanList:url_list_season starPosition:1 returnlist:mSeasonAds twoAD:YES view:[[UIView alloc] init]];
        
        [muDataList insertObject:mMonthAds atIndex:0];
        [muDataList insertObject:mSeasonAds atIndex:0];
        [muDataList insertObject:mPosterAds atIndex:0];
    }
    else if (request.tag == TAG_REQUEST_NEWS)
    {

        NSArray *news_list_data =[[[request responseString] JSONValue] objectForKey:@"newsList"];
        news_list =[[NSMutableArray alloc] initWithCapacity:3];
        for (int i =0; i<3; i++) {
            NewsBean *news = [[NewsBean alloc]init];
            
            NSDictionary *new_dict = [news_list_data objectAtIndex:i];
            [news setAuthor:NSLocalizedString(@"Uzise", nil)];
            [news setTitle:[new_dict objectForKey:@"title"]];
            [news setNewsid:[[new_dict objectForKey:@"id"] integerValue]];
            [news setContentURL:[NSString stringWithFormat:@"%@?newsid=%d", URL_NEWS_PAGE, [[new_dict objectForKey:@"id"] integerValue]]];
            [news_list addObject:news];
        }
        
        [muDataList addObject:news_list];
    }
    else
    {
        //
    }
    
    if (muDataList.count >= 4)
    {
        dataList =[NSArray arrayWithArray:muDataList];
        [self.tableView reloadData];
        [self hideHud];
        if (self.mIsUsingCache)
        {
            [self showNotice:NSLocalizedString(@"Network error", nil)];
        }
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideHud];
    [self showNotice:NSLocalizedString(@"Network error", nil)];
}



#pragma mark - UIScrollViewDelegate, which is inherited by UITableViewDelegate.
//scroll section header
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}



@end

