//
//  CommentViewController.m
//  uzise
//
//  Created by edward on 12-10-15.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "ProductCommentController.h"

#import "UIViewController+URLData.h"

#import "Constant.h"

#import "CommentBean.h"
#import "CommentItemView.h"
#import "MBProgressHUD.h"
#import "Global.h"


@interface ProductCommentController ()
{
    NSInteger mPageIndex;
    NSInteger mPages;
    BOOL mIsLoading;
}

@property (nonatomic, assign) NSInteger mPageIndex;
@property (nonatomic, assign) NSInteger mPages;
@property NSInteger comment_size;

@property(nonatomic,strong) NSMutableArray *comment_list;

@property(nonatomic,strong) NSMutableArray *temp_comment_list;

@property(nonatomic,strong) NSMutableArray *temp_comment_indexpath;

@property (nonatomic, assign) BOOL mIsLoading;

@end

@implementation ProductCommentController
@synthesize comment_product_id,comment_size,product_name,temp_comment_list,comment_list,temp_comment_indexpath;
@synthesize mPageIndex;
@synthesize mPages;
@synthesize mIsLoading;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        comment_list = [NSMutableArray array];
        temp_comment_list = [[NSMutableArray alloc] initWithCapacity:20];
        self.mIsLoading = NO;

        self.title =  NSLocalizedString(@"Product_Comment", nil);
        self.mPageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showHud];
    
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchData
{
    NSString* sURLStr = URL_PRODUCT_COMMENTS(comment_product_id, self.mPageIndex);
    ASIHTTPRequest* sRequest = [self asynLoadByURLStr:sURLStr withCachePolicy:E_CACHE_POLICY_USE_CACHE_IF_EXISTS_IN_SESSION];
    
    [self.mRequests addObject:sRequest];
    self.mIsLoading = YES;
}

-(void)fetchDone
{    
    [self hideHud];
    self.mIsLoading = NO;
    if (!temp_comment_list
        ||temp_comment_list.count <= 0)
    {
        self.tableView.tableHeaderView = [self headerViewWithNotice:NSLocalizedString(@"No comments yet", nil)];
    }
    
    if (self.mPageIndex < self.mPages)
    {
        self.tableView.tableFooterView = [self footerView];
    }
    else
    {
        self.tableView.tableFooterView = nil;
    }
    
    [self.tableView reloadData];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    if (![request error])
    {
        self.mPageIndex++;
        self.mPages = ((NSNumber*)[[[request responseString] JSONValue] objectForKey:@"pages"]).integerValue;
        NSArray *commentList = [[[request responseString] JSONValue] objectForKey:@"commentList"];
        
//        int endIndex = [[[[request responseString] JSONValue]objectForKey:@"size" ] integerValue];
//        
//        int startIndex =0;
        
        for (NSDictionary* comment_dict in commentList)
        {
            CommentBean *comment = [[CommentBean alloc] init];
            [comment setCommentId:[comment_dict objectForKey:@"id"]];
            [comment setComment:[comment_dict objectForKey:@"content"]];
            [comment setUserName:[comment_dict objectForKey:@"userName"]];
            [comment setDateTime:[comment_dict objectForKey:@"creatTime"]];
//            [comment_list addObject:comment];
            [temp_comment_list addObject:comment];
            
//            NSIndexPath *indexpath =[NSIndexPath indexPathForRow:startIndex inSection:0];
//            
//            [temp_comment_indexpath addObject:indexpath];
//            
//            comment =nil;
//            if (startIndex==9) {
//                
//                NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:startIndex],@"startIndex",[NSNumber numberWithInt:endIndex],@"endIndex",commentList,@"commentList", nil];
//                
//                [self performSelectorInBackground:@selector(backGroundLoadingComments:) withObject:dict];
//                break;
//            }
        }
        
        [self setTitle:[NSString stringWithFormat:@"%@(%d)", NSLocalizedString(@"Product_Comment", nil), temp_comment_list.count]];
    }
    [self performSelectorOnMainThread:@selector(fetchDone) withObject:nil waitUntilDone:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self performSelectorOnMainThread:@selector(fetchDone) withObject:nil waitUntilDone:NO];
}

//-(void)backGroundLoadingComments:(id)sender{
//    
//    int startIndex = [[sender valueForKey:@"startIndex"] integerValue]+1;
//    
//    int endIndex = [[sender valueForKey:@"endIndex"] integerValue];
//    
//    NSArray *commentList =[sender valueForKey:@"commentList"];
//    
//    for (; startIndex<endIndex; startIndex++) {
//        
//        NSIndexPath *indexpath =[NSIndexPath indexPathForRow:startIndex inSection:0];
//        
//        [temp_comment_indexpath addObject:indexpath];
//        
//        NSDictionary *comment_dict = [commentList objectAtIndex:startIndex];
//        
//        CommentBean *comment = [[CommentBean alloc] init];
//        [comment setCommentId:[comment_dict objectForKey:@"id"]];
//        [comment setComment:[comment_dict objectForKey:@"content"]];
//        [comment setUserName:[comment_dict objectForKey:@"userName"]];
//        [comment setDateTime:[comment_dict objectForKey:@"creatTime"]];
//        [comment_list addObject:comment];
//        comment=nil;
//        
//    }
//}

- (UIView*) headerViewWithNotice:(NSString*)sNotice
{
    UILabel* sNoDataNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    sNoDataNoticeLabel.textAlignment = UITextAlignmentCenter;
    sNoDataNoticeLabel.textColor = [UIColor grayColor];
    sNoDataNoticeLabel.text = sNotice;
    sNoDataNoticeLabel.font = [UIFont systemFontOfSize:15];
    
    return sNoDataNoticeLabel;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [temp_comment_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = [indexPath row];
    
    static NSString* sIdentifier = @"cell";
    CommentItemView* sCell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
    if (!sCell)
    {
        sCell =  [[CommentItemView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sIdentifier withFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.rowHeight)];
        
        sCell.selectionStyle = UITableViewCellSelectionStyleNone;
        sCell.backgroundView = nil;
    }
    
    
    
    CommentBean* sCommentItem = [temp_comment_list objectAtIndex:sRow];
    
    [sCell fillValueByCommentor:sCommentItem.userName Date:sCommentItem.dateTime Content:sCommentItem.comment];
    
    
    return sCell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* sCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (sCell)
    {
        return sCell.bounds.size.height;
    }
    else
    {
        return 0;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 下拉到最底部时显示更多数据
    if(mPageIndex<=self.mPages&&!self.mIsLoading&& scrollView.contentOffset.y > ((scrollView.contentSize.height*1.0 - scrollView.frame.size.height * 1.0)))
    {
        [self fetchData];
    }    
}

- (UIView*) footerView
{
    UIView* sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    UIActivityIndicatorView* sLoadingMoreIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    sLoadingMoreIndicator.frame = CGRectMake(100, 0, 40, 40);
    sLoadingMoreIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [sLoadingMoreIndicator startAnimating];
    [sView addSubview: sLoadingMoreIndicator];
    
    UILabel* sLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 80, 40)];
    sLabel.text = NSLocalizedString(@"Loading...", nil);
    sLabel.textColor = [UIColor grayColor];
    [sView addSubview:sLabel];
    
    return sView;
}



@end
