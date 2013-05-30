

#import "CategoryViewController.h"

#import "DejalActivityView.h"

#import "InCategoryListController.h"  

#import "UIViewController+URLData.h"

#import "Constant.h"
#import "Global.h"


#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xbdf0ff]

@interface CategoryViewController ()
{
    BOOL mIsUsingCache;
}
@property (nonatomic, assign) BOOL mIsUsingCache;

-(void)showDefaultDeja;

-(void)removeActivityView;

@end

@implementation CategoryViewController
@synthesize mIsUsingCache;

- (id)init
{
    self = [super init];
    if (self) {
        self.mIsUsingCache = NO;
        [self showDefaultDeja];
    }
    
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!(dataList.count>0)
        || self.mIsUsingCache)
    {
        if (!(dataList.count>0))
        {
            [self showHud];
        }

        [self showDefaultDeja];
    }

}

-(void)showDefaultDeja
{ 
    ASIHTTPRequest* sRequest = [self asynLoadByURLStr:URL_PRODUCT_CATEGORY withCachePolicy:E_CACHE_POLICY_USE_CACHE_IF_NETWORK_FAILS_X_SESSION];
    [self.mRequests addObject:sRequest];
}


-(void)removeActivityView
{
    [self hideHud];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self roundNaviationBar];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50)];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    [self.view setBackgroundColor:BG_COLOR];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CategoryCellIdentifier = @"CategoryCell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CategoryCellIdentifier] ;
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
         
    }
    
    if (indexPath.row < dataList.count)
    {
        [cell prepareForTableView:tableView indexPath:indexPath];
        cell.textLabel.text =[dataList objectAtIndex:indexPath.row];
         cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  54;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    InCategoryListController *detailsViewController = [[InCategoryListController alloc]init];
    detailsViewController.title =cell.textLabel.text;
    
    NSString *str = [dataDict valueForKey:cell.textLabel.text];
    [detailsViewController setTypeID:[str integerValue]];
   
    [self.navigationController pushViewController:detailsViewController animated:YES];
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
  
    if (request
        && ![request error]) {
        
        self.mIsUsingCache = request.didUseCachedResponse;

        NSArray *url_list =[[request responseString] JSONValue];
        
        dataDict = [[NSMutableDictionary alloc] initWithCapacity:[url_list count]];
        
        for (NSDictionary *temp_dict in url_list) {
            
            if ([[temp_dict objectForKey:@"typeId"] isEqual:[NSNumber numberWithInteger:114]]) {
                continue;
            }else
                [dataDict setValue:[temp_dict objectForKey:@"typeId"] forKey:[temp_dict objectForKey:@"typeName"]];
        }
        
        dataList =[NSArray arrayWithArray:[IOSFactory sortDictionaryValueByNumber:dataDict isAsc:YES]];
    }
    [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:0.8f];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self performSelectorOnMainThread:@selector(removeActivityView) withObject:nil waitUntilDone:NO];
}

@end
