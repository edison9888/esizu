//
//  OrderSendTypeViewController.m
//  uzise
//
//  Created by edward on 12-11-6.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "ShippingTypeViewController.h"

#import "Constant.h"

#import "OrderLandingViewController.h"
#import "Global.h"

@interface ShippingTypeViewController ()

@property(nonatomic,strong)NSMutableDictionary *shopping_temp_dict;

@property(nonatomic,strong)NSDictionary *sendType_dict;

@property(nonatomic,strong)NSArray *sendType_key_list;

@property(nonatomic,strong)NSArray *sendTime_key_list;

@property(nonatomic,strong)NSDictionary *sendTime_dict;

@property NSInteger sendTypeIndex;

@property NSInteger sendTimeIndex;

@property(nonatomic,strong)NSIndexPath *currentSendTypeIndexPath;

@property(nonatomic,strong)NSIndexPath *beforeSendTypeIndexPath;

@property(nonatomic,strong)NSIndexPath *currentSendTimeIndexPath;

@property(nonatomic,strong)NSIndexPath *beforeSendTimeIndexPath;

@end

@implementation ShippingTypeViewController
@synthesize sendType_dict,sendTime_dict;
@synthesize shopping_dict,shopping_temp_dict;
@synthesize sendType_key_list,sendTime_key_list;
@synthesize sendTypeIndex,sendTimeIndex;
@synthesize currentSendTypeIndexPath,beforeSendTypeIndexPath;
@synthesize currentSendTimeIndexPath,beforeSendTimeIndexPath;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 /**
  配送物流
  */
    NSString *sendType_path = [IOSFactory getMainPath:@"sendtype" oftype:@"plist"];
    
    sendType_dict =[NSDictionary dictionaryWithContentsOfFile:sendType_path];
       
    sendType_key_list =[NSArray arrayWithArray:[sendType_dict allKeys]];
    
    sendTypeIndex =[sendType_key_list indexOfObject:[shopping_dict objectForKey:@"sendType"]];
    
    currentSendTypeIndexPath = beforeSendTypeIndexPath =[NSIndexPath indexPathForRow:sendTypeIndex+1 inSection:0];
    
    UITableViewCell *sendTypeCell = [self.tableView cellForRowAtIndexPath:currentSendTypeIndexPath];
    [sendTypeCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    
    /**
     送货时间
     */
    
    
    NSString *sendTime_path = [IOSFactory getMainPath:@"sendtime"  oftype:@"plist"];
    
    sendTime_dict =[NSDictionary dictionaryWithContentsOfFile:sendTime_path];
    
    sendTime_key_list =[NSArray arrayWithArray:[sendTime_dict allKeys]];
    
    sendTimeIndex =[sendTime_key_list indexOfObject:[shopping_dict objectForKey:@"sendTime"]];
    
        
    currentSendTimeIndexPath = beforeSendTimeIndexPath =[NSIndexPath indexPathForRow:sendTimeIndex+1 inSection:1];
    
    UITableViewCell *sendTimeCell = [self.tableView cellForRowAtIndexPath:currentSendTimeIndexPath];
    [sendTimeCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    self.title=NSLocalizedString(@"Selet_Distribution_way", @"Selet_Distribution_way");

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    [self.view setBackgroundColor: BG_COLOR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [sendType_key_list count]+1;
    }else
    // Return the number of rows in the section.
    return [sendTime_key_list count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row==0) {
                cell.textLabel.text=NSLocalizedString(@"Logistics", @"Logistics");
                [ cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15]];
            }else{
                
                NSInteger rowindex = indexPath.row-1;
                
                cell.textLabel.text =[sendType_dict objectForKey: [sendType_key_list objectAtIndex:rowindex]];
                [ cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15]];
                [cell.textLabel setTextColor:[UIColor lightGrayColor]];
                [cell.textLabel setNumberOfLines:0];
                [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
                if (rowindex==sendTypeIndex) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
                
            }
            break;
        }
        case 1:{
            if (indexPath.row==0) {
                cell.textLabel.text=NSLocalizedString(@"DeliverTime", @"DeliverTime");
                 [ cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15]];
            }else{
                
                NSInteger rowindex = indexPath.row-1;
      
                cell.textLabel.text =[sendTime_dict objectForKey: [sendTime_key_list objectAtIndex:rowindex]];
                [ cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15]];
                [cell.textLabel setTextColor:[UIColor lightGrayColor]];
                [cell.textLabel setNumberOfLines:0];
                [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
                if (rowindex==sendTimeIndex) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }
            break;
        }
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 35;
    }else{
        return 70;
    }
    
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
    switch (indexPath.section) {
        case 0:{
            
            if (indexPath.row!=0) {
                currentSendTypeIndexPath =indexPath;
                
                //     [newaddress_dict setValue:[province_list objectAtIndex:currentIndexPath.row] forKey:@"province"];
                
                if (currentSendTypeIndexPath.row!=beforeSendTypeIndexPath.row) {
                    
                    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:currentSendTypeIndexPath];
                    currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    
                    UITableViewCell *beforeCell = [tableView cellForRowAtIndexPath:beforeSendTypeIndexPath];
                    beforeCell.accessoryType = UITableViewCellAccessoryNone;
                    beforeSendTypeIndexPath = currentSendTypeIndexPath;
            
                    [shopping_dict setValue:[sendType_key_list objectAtIndex:currentSendTypeIndexPath.row-1] forKey:@"sendType"];
                    
                }
            }
            
            
            break;
        }
        case 1:{
            
            if (indexPath.row!=0) {
                currentSendTimeIndexPath =indexPath;
                
                //     [newaddress_dict setValue:[province_list objectAtIndex:currentIndexPath.row] forKey:@"province"];
                
                if (currentSendTimeIndexPath.row!=beforeSendTimeIndexPath.row) {
                    
                    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:currentSendTimeIndexPath];
                    currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    
                    UITableViewCell *beforeCell = [tableView cellForRowAtIndexPath:beforeSendTimeIndexPath];
                    beforeCell.accessoryType = UITableViewCellAccessoryNone;
                    beforeSendTimeIndexPath = currentSendTimeIndexPath;
                                      
                    [shopping_dict setValue:[sendTime_key_list objectAtIndex:currentSendTimeIndexPath.row-1] forKey:@"sendTime"];
                    
                }
            }
            
            
            break;
        }
        default:
            break;
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //传值
       
        OrderLandingViewController *order = [[self.navigationController childViewControllers] objectAtIndex:0];
        
        
        // order.select_address_index =currentIndexPath.section;
        
        order.mSelectedAddressID = nil;
    
        order.shopping_dict = self.shopping_dict;
    
}

@end
