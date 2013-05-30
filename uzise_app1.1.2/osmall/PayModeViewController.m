//
//  OrderPayModeViewController.m
//  uzise
//
//  Created by edward on 12-11-6.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//
#import "Constant.h"
#import "PayModeViewController.h"
#define BLACK_BAR_COMPONENTS				{ 0.23, 0.77, 0.92, 1.0, 0.07, 0.56, 0.70, 1.0 }
@implementation PayModeViewController
@synthesize payModeKey;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title dict:(NSMutableDictionary *)dict{
	if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
		[self.headerLabel setFont:[UIFont fontWithName:@"AppleGothic" size:16.0]];
		
        self.margin =UIEdgeInsetsMake(30, 30, 30, 30);
        self.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        
        paymode_temp_dict  =[NSMutableDictionary dictionaryWithDictionary:dict];
		
        
        NSString *paymode_path =  [IOSFactory getMainPath:@"paymode" oftype:@"plist"];
        
   
        paymode_dict  = [[NSDictionary alloc] initWithContentsOfFile:paymode_path];
        
        paymode_list  =[NSArray arrayWithArray:[paymode_dict allKeys]];
        
         
        paymodeIndex  = [paymode_list indexOfObject:[paymode_temp_dict objectForKey:@"payMode"]];
        
        currentIndexPath =beforeIndexPath =[NSIndexPath indexPathForRow:paymodeIndex inSection:0];
        
        
      
        
		view  = [[UIView alloc] initWithFrame:CGRectZero];
        table =[[UITableView alloc] initWithFrame:CGRectZero ];
        
       
        [table setDelegate:self];
        [table setDataSource:self];
        [view addSubview:table];
        // [view addSubview:toolbar];
		[self.contentView addSubview:view];
		
	}
	return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [paymode_list count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
        cell.textLabel.text = [paymode_dict objectForKey:[paymode_list objectAtIndex:indexPath.row]];
        if (paymodeIndex ==indexPath.row) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            currentIndexPath =beforeIndexPath= indexPath;
            
        }
        
   
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath =indexPath;
//     [newaddress_dict setValue:[province_list objectAtIndex:currentIndexPath.row] forKey:@"province"];
    
    if (currentIndexPath.row!=beforeIndexPath.row)
    {
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:currentIndexPath];
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *beforeCell = [tableView cellForRowAtIndexPath:beforeIndexPath];
        beforeCell.accessoryType = UITableViewCellAccessoryNone;
        beforeIndexPath = currentIndexPath;
        
        payModeKey =[paymode_list objectAtIndex:currentIndexPath.row];
        [self hide];
    }
}
/**/


- (void)layoutSubviews {
	[super layoutSubviews];
	
    [view setFrame:self.contentView.bounds];
    [table setFrame:CGRectMake(0, 0, view.bounds.size.width, self.contentView.bounds.size.height)];
   
    //[nextButton setFrame:CGRectMake(toolbar.center.x, toolbar.center.y, 80, 30)];
    [table scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    UITableViewCell *cell = [table cellForRowAtIndexPath:currentIndexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
