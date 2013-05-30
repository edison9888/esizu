
#import "MoreViewController.h"

#import "IOSFactory.h"

#import "OSMallTools.h"

#import "Constant.h"

#import "UIViewController+URLData.h"

#import "NoAddViewController.h"

#import "Global.h"
#import "UMFeedback.h"
#import "AboutViewController.h"

@interface MoreViewController ()

@property(nonatomic,strong)NSArray *more_array;
@end

@implementation MoreViewController
@synthesize more_array;
/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/
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
    tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44-49) style:UITableViewStyleGrouped];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
//    [self setTitle:NSLocalizedString(@"MoreNavigation", @"moreNav")];
    [self roundNaviationBar];
    [self.view addSubview:tableview];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    NSArray* sFirstTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Understanding_NOAdd", nil), nil];
    NSArray *sSecondTitles = [NSArray arrayWithObjects: NSLocalizedString(@"Score", @"Score"),NSLocalizedString(@"Online_Phone", @"Online_Phone"), NSLocalizedString(@"User Feedback", nil),nil];
    NSArray* sThirdTitles = [NSArray arrayWithObjects: NSLocalizedString(@"About", nil), nil];

    
    more_array =[NSArray arrayWithObjects:sFirstTitles, sSecondTitles, sThirdTitles, nil];
    
    
    //
    [tableview setBackgroundColor:[UIColor clearColor]];
    [tableview setBackgroundView:nil];
    [self.view setBackgroundColor:BG_COLOR];

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [more_array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)[more_array objectAtIndex:section]).count;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *moreCellIdentifier = @"moreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreCellIdentifier];
    
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:moreCellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.text =[[more_array objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    // Configure the cell...
   
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:
                {
                    NoAddViewController *noadd =[[NoAddViewController alloc] init];
                    [noadd setUrl:URL_NO_ADD_REFERENCE];
                    noadd.title = NSLocalizedString(@"Understanding_NOAdd", nil);
                    noadd.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:noadd animated:YES];
                    break;
                }
                    break;
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_APP_COMMENT]];
                    break;
                }
                case 1:{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_CUSTOMER_SERVICE_PHONE]];
                    break;
                }
                case 2:
                {
                    [UMFeedback showFeedback:self withAppkey:KEY_UMENG];
                }
                    break;
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            if (indexPath.row == 0)
            {
                AboutViewController* sAboutViewController = [[AboutViewController alloc] init];
                sAboutViewController.title = NSLocalizedString(@"About", nil);
                sAboutViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sAboutViewController animated:YES];
            }
            break;
        }
            
        default:
            break;
    }
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
