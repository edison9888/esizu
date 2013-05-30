//
//  OrderInvoiceViewController.m
//  uzise
//
//  Created by edward on 12-11-6.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "InvoiceViewController.h"

#import "Constant.h"

#import "OrderLandingViewController.h"
#import "Global.h"
#import "TPKeyboardAvoidingTableView.h"

@interface InvoiceViewController ()

@property(nonatomic,strong)NSMutableDictionary *shopping_temp_dict;

@property(nonatomic,strong)NSDictionary *invoice_dict;

@property(nonatomic,strong)NSArray *invoice_key_list;

@property(nonatomic,strong)NSArray *isinvoice_key_list;

@property(nonatomic,strong)NSDictionary *isinvoice_dict;

@property NSInteger isinvoiceIndex;

@property NSInteger invoiceIndex;

@property(nonatomic,strong)NSIndexPath *currentIsInvoiceIndexPath;

@property(nonatomic,strong)NSIndexPath *beforeIsInvoiceIndexPath;

@property(nonatomic,strong)NSIndexPath *currentInvoiceIndexPath;

@property(nonatomic,strong)NSIndexPath *beforeInvoiceIndexPath;

@property(nonatomic,strong)UITextField *invoiceTitle_textfield;

@property (nonatomic, strong) TPKeyboardAvoidingTableView* mTableView;
//-(BOOL)checkInvoiceTitle;

@end

@implementation InvoiceViewController
@synthesize shopping_dict;
@synthesize invoice_dict,isinvoice_dict;
@synthesize invoice_key_list,isinvoice_key_list;
@synthesize invoiceTitle_textfield;
@synthesize isinvoiceIndex,invoiceIndex;
@synthesize currentIsInvoiceIndexPath,beforeIsInvoiceIndexPath;
@synthesize currentInvoiceIndexPath,beforeInvoiceIndexPath;
@synthesize mTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSLog(@"%@",shopping_dict);
    
    NSString *invoice_all_path =[IOSFactory getMainPath:@"invoice" oftype:@"plist"];
    
    NSDictionary *invoice_all_dict =[NSDictionary dictionaryWithContentsOfFile:invoice_all_path];
    
    isinvoice_dict = [NSDictionary dictionaryWithDictionary:[invoice_all_dict objectForKey:@"isinvoice"]];
    
    isinvoice_key_list  =[isinvoice_dict allKeys];
    
    isinvoiceIndex  = [isinvoice_key_list indexOfObject:[shopping_dict objectForKey:@"isinvoice"]];
    
    
    currentIsInvoiceIndexPath = beforeIsInvoiceIndexPath = [NSIndexPath indexPathForRow:isinvoiceIndex inSection:0];
    
  //  [[self.tableView cellForRowAtIndexPath:currentIsInvoiceIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    
    invoice_dict  = [NSDictionary dictionaryWithDictionary:[invoice_all_dict objectForKey:@"invoicetitle"]];
    
    invoice_key_list = [invoice_dict allKeys];
    
    invoiceIndex  = [invoice_key_list indexOfObject:[shopping_dict objectForKey:@"invoicetitle"]];
    
    currentInvoiceIndexPath = beforeInvoiceIndexPath =[NSIndexPath indexPathForRow:invoiceIndex+1 inSection:2];
    
   // [[self.tableView cellForRowAtIndexPath:currentInvoiceIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    self.title =NSLocalizedString(@"Invoice", @"Invoice");
    
    self.mTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.mTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height);
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    [self.mTableView setBackgroundColor:[UIColor clearColor]];
    [self.mTableView setBackgroundView:nil];

    [self.view addSubview:self.mTableView];
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [isinvoice_dict count];
    }
    if (section==1) {
        return 2;
    }
    if (section==2) {
        return [invoice_dict count]+1;
    }
    // Return the number of rows in the section.
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSeparatorStyleNone];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    switch (indexPath.section) {
        case 0:{
            
            cell.textLabel.text= [isinvoice_dict objectForKey:[isinvoice_key_list objectAtIndex:indexPath.row]];
            [ cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15]];
           
            if (indexPath.row==isinvoiceIndex) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
           
            break;
        }
        case 1:
        {
            if (indexPath.row==0)
            {
                cell.textLabel.text=NSLocalizedString(@"Invoice_Name", @"Invoice_Name");
                [ cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15]];
            }
            else
            {
                invoiceTitle_textfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
                invoiceTitle_textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
                [invoiceTitle_textfield setDelegate:self];
                
                if ([shopping_dict objectForKey:@"invoicecontent"]==nil||[[shopping_dict objectForKey:@"invoicecontent"] length]==0) {
                     [invoiceTitle_textfield setPlaceholder:NSLocalizedString(@"Invoice_Ttile", @"Invoice_Ttile")];
                }else{
                    [invoiceTitle_textfield setText:[shopping_dict objectForKey:@"invoicecontent"]];
                }
                
                [invoiceTitle_textfield setFont:[UIFont fontWithName:@"AppleGothic" size:15]];
                [invoiceTitle_textfield setReturnKeyType:UIReturnKeyDone];
                [cell.contentView addSubview:invoiceTitle_textfield];
            }
            break;
        }
        case 2:{
            if (indexPath.row==0) {
                cell.textLabel.text=NSLocalizedString(@"Invoice_Content", @"Invoice_Content");
                [ cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15]];
            }else{
                
                 NSInteger rowindex = indexPath.row-1;
                
                if (rowindex==invoiceIndex) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
                
                cell.textLabel.text= [invoice_dict objectForKey:[invoice_key_list objectAtIndex:rowindex]];
                 [ cell.textLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15]];
                 [cell.textLabel setTextColor:[UIColor lightGrayColor]];
            }
            break;
        }
        default:
            break;
    }
    
    // Configure the cell...
    
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
    
    switch (indexPath.section) {
        case 0:{
            
            
                currentIsInvoiceIndexPath =indexPath;
                
                //     [newaddress_dict setValue:[province_list objectAtIndex:currentIndexPath.row] forKey:@"province"];
                
                if (currentIsInvoiceIndexPath.row!=beforeIsInvoiceIndexPath.row) {
                    
                    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:currentIsInvoiceIndexPath];
                    currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    
                    UITableViewCell *beforeCell = [tableView cellForRowAtIndexPath:beforeIsInvoiceIndexPath];
                    beforeCell.accessoryType = UITableViewCellAccessoryNone;
                    beforeIsInvoiceIndexPath = currentIsInvoiceIndexPath;
                    
                    [shopping_dict setValue:[isinvoice_key_list objectAtIndex:currentIsInvoiceIndexPath.row] forKey:@"isinvoice"];
                    
                }
                       
            break;
        }
        case 2:{
            
            if (indexPath.row!=0) {
                currentInvoiceIndexPath =indexPath;
                
                //     [newaddress_dict setValue:[province_list objectAtIndex:currentIndexPath.row] forKey:@"province"];
                
                if (currentInvoiceIndexPath.row!=beforeInvoiceIndexPath.row) {
                    
                    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:currentInvoiceIndexPath];
                    currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    
                    UITableViewCell *beforeCell = [tableView cellForRowAtIndexPath:beforeInvoiceIndexPath];
                    beforeCell.accessoryType = UITableViewCellAccessoryNone;
                    beforeInvoiceIndexPath = currentInvoiceIndexPath;
                    
                    [shopping_dict setValue:[invoice_key_list objectAtIndex:currentInvoiceIndexPath.row-1] forKey:@"invoicetitle"];
                    
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
    
   // [self checkInvoiceTitle];
    
 
    [super viewWillDisappear:animated];
    //传值
    
    OrderLandingViewController *order = [[self.navigationController childViewControllers] objectAtIndex:0];
    
    
    // order.select_address_index =currentIndexPath.section;
    
    order.mSelectedAddressID = nil;
    
    [shopping_dict setValue:[invoiceTitle_textfield text] forKey:@"invoicecontent"];
    
    order.shopping_dict = self.shopping_dict;
   
}
/*
-(BOOL)checkInvoiceTitle{
    if ([[invoiceTitle_textfield text] length]==0) {
        [self showAlert:NSLocalizedString(@"Invoice_Message_1", @"Invoice_Message_1") cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
        return  NO;
    }
    if ([[invoiceTitle_textfield text] length]>30) {
        [self showAlert:NSLocalizedString(@"Invoice_Message_1", @"Invoice_Message_1") cancelButtonTitle:NSLocalizedString(@"Invoice_Message_2", @"Invoice_Message_2") otherButtonTitle:nil];
        return  NO;
    }
    
return YES;
}
*/
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

@end
