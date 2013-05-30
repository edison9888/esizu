//
//  MoreNewsViewController.m
//  uzise
//
//  Created by edward on 12-10-11.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "NewsListViewController.h"

#import "Constant.h"

#import "NewsBean.h"

#import "NewsViewController.h"
#import "Global.h"

@interface NewsListViewController ()

@property(nonatomic,strong)NSMutableArray *news_list;

@property(nonatomic,strong)NSMutableArray *temp_news_list;

@property(nonatomic,strong)NSMutableArray *temp_news_indexPath;

@property NSInteger totalPage;

@property NSInteger currentPage;

@property UIActivityIndicatorView *tableFooterActivityIndicator;

-(void)loadNewsData;

-(void)dynamicNews:(id)sender;

-(void)endsLoading;

-(void)backGroundLoadingNews:(id)sender;
@end

@implementation NewsListViewController
@synthesize news_list,temp_news_list,totalPage,currentPage,tableFooterActivityIndicator,temp_news_indexPath;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!temp_news_list
        || temp_news_list.count <= 0)
    {
        [self loadNewsData];
    }
}

-(void)loadNewsData
{
    [self showHud];
    
    ASIHTTPRequest* sRequest = [self asynLoadByURLStr:URL_NEWS_LIST withCachePolicy:E_CACHE_POLICY_NO_CACHE];
    [self.mRequests addObject:sRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentPage = 1;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 55;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [temp_news_list count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    if ([temp_news_list count]>0)
    {
        if ([temp_news_list count]==indexPath.row)
        {
            if ((currentPage<totalPage))
            {
                [cell.textLabel setText:@""];
                UILabel *loadMoreText = [[UILabel alloc] initWithFrame:cell.bounds];
                loadMoreText.textAlignment = UITextAlignmentCenter;
                [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
                [loadMoreText setText:NSLocalizedString(@"Load more", nil)];
                [cell.contentView addSubview:loadMoreText];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            NewsBean *news = [temp_news_list objectAtIndex:indexPath.row];
            [cell.textLabel setText:[news title]];
            [cell.textLabel setNumberOfLines:0];
            [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
            [cell.textLabel setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:15]];            
        }
    }

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentPage+=1;
    if ([temp_news_list count]==indexPath.row)
    {
        if ((currentPage<=totalPage)) {
     
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self performSelectorOnMainThread:@selector(dynamicNews:) withObject:nil waitUntilDone:YES ];
        }

    }
    else
    {
   // UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
    
       NewsViewController *newsController =[[NewsViewController alloc] init];
       NewsBean *news = [news_list objectAtIndex:indexPath.row];
      
       [newsController setTitle:[news title]];
       [newsController setUrl:[news contentURL]];
    
       [self.navigationController pushViewController:newsController animated:YES];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    if (![request error])
    {
        NSArray *newslist = [[[request responseString] JSONValue] objectForKey:@"newsList"];
        
       int endIndex = [newslist count];
        
        int startIndex = 0;
        
        totalPage = [IOSFactory totalPageNumber:endIndex pageSize:10];
        
        temp_news_list =[NSMutableArray arrayWithCapacity:10];
        
        temp_news_indexPath = [NSMutableArray arrayWithCapacity:endIndex];
        
        news_list = [NSMutableArray arrayWithCapacity:endIndex];
        
        for (startIndex =0; startIndex<endIndex; startIndex++) {
            
            NSDictionary *new_dict = [newslist objectAtIndex:startIndex];
            
            NewsBean *news =[[NewsBean alloc] init];
            [news setNewsid:[[new_dict objectForKey:@"id"] integerValue]];
            [news setTitle:[new_dict objectForKey:@"title"]];
            [news setContentURL:[NSString stringWithFormat:@"%@?newsid=%d", URL_NEWS_PAGE, [[new_dict objectForKey:@"id"] integerValue]]];
            
            [temp_news_list addObject:news];
            [news_list addObject:news];
            
            NSIndexPath *indexpath =[NSIndexPath indexPathForRow:startIndex inSection:0];
            
            [temp_news_indexPath addObject:indexpath];
            
            news=nil;
            
            if (startIndex==9) {
                              
                NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:startIndex],@"startIndex",[NSNumber numberWithInt:endIndex],@"endIndex",newslist,@"newlist", nil];
                
                [self performSelectorInBackground:@selector(backGroundLoadingNews:) withObject:dict];
                break;
            }
        }
        
        //
        [self.tableView reloadData];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
        
    [self endsLoading];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self endsLoading];
}

-(void)backGroundLoadingNews:(id)sender{
    
    int startIndex = [[sender valueForKey:@"startIndex"] integerValue]+1;

    int endIndex = [[sender valueForKey:@"endIndex"] integerValue];
    
    NSArray *newlist =[sender valueForKey:@"newlist"];
    

    for (; startIndex<endIndex; startIndex++) {
          
        NSIndexPath *indexpath =[NSIndexPath indexPathForRow:startIndex inSection:0];
        
        [temp_news_indexPath addObject:indexpath];
        
        NSDictionary *new_dict = [newlist objectAtIndex:startIndex];

        NewsBean *news =[[NewsBean alloc] init];
        [news setNewsid:[[new_dict objectForKey:@"id"] integerValue]];
        [news setTitle:[new_dict objectForKey:@"title"]];
        [news setContentURL:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/html/news.html?newsid=%d",[[new_dict objectForKey:@"id"] integerValue]]];
        [news_list addObject:news];
        news=nil;

    }
}

-(void)endsLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHud];
    });
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

 // 下拉到最底部时显示更多数据
 
}

-(void)dynamicNews:(id)sender{
    
    int length = 10;
    
    BOOL isdel =NO;
    
    if ([news_list count]-[temp_news_list count]<10) {
        length =[news_list count]-[temp_news_list count];

        isdel =YES;

    }
    

    NSRange range;
    range.length =length;
    range.location = [temp_news_list count];//[self.tableView numberOfRowsInSection:0];
    
    NSIndexSet *indexSet =[NSIndexSet indexSetWithIndexesInRange:range];
    
    NSArray *list_array =[NSArray arrayWithArray: [temp_news_indexPath objectsAtIndexes:indexSet]];
    
    
    [temp_news_list addObjectsFromArray:[news_list objectsAtIndexes:indexSet]];
    
     [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:list_array withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
}



@end
