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
@property NSInteger comment_size;

@property(nonatomic,strong) NSMutableArray *comment_list;

@property(nonatomic,strong) NSMutableArray *temp_comment_list;

@property(nonatomic,strong) NSMutableArray *temp_comment_indexpath;


@end

@implementation ProductCommentController
@synthesize comment_product_id,comment_size,product_name,temp_comment_list,comment_list,temp_comment_indexpath;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title =  NSLocalizedString(@"Product_Comment", nil);
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
    ASIHTTPRequest* sRequest = [self asynLoadByURLStr:[NSString stringWithFormat:@"%@?pid=%d", URL_PRODUCT_COMMENTS, comment_product_id] withCachePolicy:E_CACHE_POLICY_USE_CACHE_IF_EXISTS_IN_SESSION];
    
    [self.mRequests addObject:sRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchDone
{    
    [self hideHud];
    if (!temp_comment_list
        ||temp_comment_list.count <= 0)
    {
        self.tableView.tableHeaderView = [self headerViewWithNotice:NSLocalizedString(@"No comments yet", nil)];
    }
    
    [self.tableView reloadData];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    if (![request error])
    {
        
        comment_list = [[NSMutableArray alloc] initWithCapacity:[[[[request responseString] JSONValue]objectForKey:@"size" ] integerValue]];
        
        temp_comment_list = [[NSMutableArray alloc] initWithCapacity:10];
        
        NSArray *commentList = [[[request responseString] JSONValue] objectForKey:@"commentList"];
        
        int endIndex = [[[[request responseString] JSONValue]objectForKey:@"size" ] integerValue];
        
        int startIndex =0;
        
        for (; startIndex<endIndex; startIndex++) {
            
            NSDictionary *comment_dict  = [commentList objectAtIndex:startIndex];
            CommentBean *comment = [[CommentBean alloc] init];
            [comment setCommentId:[comment_dict objectForKey:@"id"]];
            [comment setComment:[comment_dict objectForKey:@"content"]];
            [comment setUserName:[comment_dict objectForKey:@"userName"]];
            [comment setDateTime:[comment_dict objectForKey:@"creatTime"]];
            [comment_list addObject:comment];
            [temp_comment_list addObject:comment];
            
            NSIndexPath *indexpath =[NSIndexPath indexPathForRow:startIndex inSection:0];
            
            [temp_comment_indexpath addObject:indexpath];
            
            comment =nil;
            if (startIndex==9) {
                
                NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:startIndex],@"startIndex",[NSNumber numberWithInt:endIndex],@"endIndex",commentList,@"commentList", nil];
                
                [self performSelectorInBackground:@selector(backGroundLoadingComments:) withObject:dict];
                break;
            }
        }
        
        [self setTitle:[NSString stringWithFormat:@"%@(%d)", NSLocalizedString(@"Product_Comment", nil),[[[[request responseString] JSONValue]objectForKey:@"size" ] integerValue]]];
    }
    [self performSelectorOnMainThread:@selector(fetchDone) withObject:nil waitUntilDone:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self performSelectorOnMainThread:@selector(fetchDone) withObject:nil waitUntilDone:NO];
}

-(void)backGroundLoadingComments:(id)sender{
    
    int startIndex = [[sender valueForKey:@"startIndex"] integerValue]+1;
    
    int endIndex = [[sender valueForKey:@"endIndex"] integerValue];
    
    NSArray *commentList =[sender valueForKey:@"commentList"];
    
    for (; startIndex<endIndex; startIndex++) {
        
        NSIndexPath *indexpath =[NSIndexPath indexPathForRow:startIndex inSection:0];
        
        [temp_comment_indexpath addObject:indexpath];
        
        NSDictionary *comment_dict = [commentList objectAtIndex:startIndex];
        
        CommentBean *comment = [[CommentBean alloc] init];
        [comment setCommentId:[comment_dict objectForKey:@"id"]];
        [comment setComment:[comment_dict objectForKey:@"content"]];
        [comment setUserName:[comment_dict objectForKey:@"userName"]];
        [comment setDateTime:[comment_dict objectForKey:@"creatTime"]];
        [comment_list addObject:comment];
        comment=nil;
        
    }
}

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

@end
