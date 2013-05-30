//
//  MoreCategoriesController.m
//  uzise
//
//  Created by Wen Shane on 13-5-20.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import "CategoriesViewController.h"
#import "PrettyKit.h"
#import "UIViewController+URLData.h"
#import "PPRevealSideViewController.h"
#import "Global.h"

@interface CategoriesViewController ()
{
    NSMutableArray* mCategories;
}

@property (nonatomic, strong) NSMutableArray* mCategories;
@end

@implementation CategoriesViewController
@synthesize mCategories;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
//        self.title = NSLocalizedString(@"All Categories", nil);
        
        UILabel* sTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        sTitleLabel.text = NSLocalizedString(@"All Categories", nil);
        sTitleLabel.backgroundColor = [UIColor clearColor];
        sTitleLabel.textColor = [UIColor whiteColor];
        sTitleLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sTitleLabel];
        
        NSArray* sArray = @[@"肌肤类型", @"肌肤问题", @"品类", @"功效", @"价格"];
        self.mCategories = [NSMutableArray arrayWithArray:sArray];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self roundNaviationBar];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view setBackgroundColor:BG_COLOR];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

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
    return self.mCategories.count;
}

//- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return NSLocalizedString(@"All Categories", nil);
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIView* sSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 1)];
        sSeperatorView.backgroundColor = RGBA_COLOR(222, 222, 222, 1);
        sSeperatorView.layer.shadowColor = [RGBA_COLOR(224, 224, 224, 1) CGColor];
        sSeperatorView.layer.shadowOffset = CGSizeMake(0, 0);
        sSeperatorView.layer.shadowOpacity = .5f;
        sSeperatorView.layer.shadowRadius = 20.0f;
        sSeperatorView.clipsToBounds = NO;
        sSeperatorView.layer.cornerRadius = 5;
        
        [cell.contentView addSubview:sSeperatorView];

    }
    
    cell.textLabel.text = [self.mCategories objectAtIndex:indexPath.row];
    if (cell.selected)
    {
        cell.textLabel.textColor = [UIColor blueColor];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    for (NSIndexPath* algoPath in [tableView indexPathsForVisibleRows])
//    {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:algoPath];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.textLabel.textColor = [UIColor blackColor];
//        
//        if(algoPath.row == indexPath.row)
//        {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            cell.textLabel.textColor = [UIColor blueColor];
//        }
//    }
    
        
    if ([self.mDelegate respondsToSelector:@selector(didSelectCategory:)])
    {
        [self.mDelegate didSelectCategory: [self.mCategories objectAtIndex:indexPath.row]];
    }
    [self.revealSideViewController popViewControllerAnimated:YES];
}

@end
