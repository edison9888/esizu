//
//  OrderDetailsViewController.m
//  uzise
//
//  Created by edward on 12-10-18.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "OrderDetailsViewController.h"

#import "Constant.h"

#import "OrderBean.h"

#import "SendTypeBean.h"

#import "UserBean.h"

#import "IOSFactory.h"

#import "ProductViewController.h"
#import "UserManager.h"
#import "Global.h"

@interface OrderDetailsViewController ()
   
@end

@implementation OrderDetailsViewController
@synthesize order_id,user_appkey;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithOrderID:(NSString*)aOrderID
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.order_id = aOrderID;
        self.user_appkey = [[UserManager shared] getSessionAppKey];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:NSLocalizedString(@"Order_Details", @"Order_Details")];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,5,1)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    [self.view setBackgroundColor:BG_COLOR];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!order)
    {
        [self showHud];
        ASIHTTPRequest *order_detail_request =[self asynLoadByURLStr:[NSString stringWithFormat:@"%@?appkey=%@&id=%@", URL_GET_ORDER_DETAIL, user_appkey, order_id] withCachePolicy:E_CACHE_POLICY_NO_CACHE];
        [self.mRequests addObject:order_detail_request];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 6;
            break;
        case 1:
            return [order.orderDetails count]==0?1:[order.orderDetails count];
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 2;
            break;
        case 5:
            return [order isInvoice]?2:1;
            break;
        default:
            break;
    }
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
 
    
    switch (indexPath.section) {
        case 0:{
       
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            switch (indexPath.row) {
                case 0:{
                    
                    UILabel *order_carsh_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_carsh_lable setText:NSLocalizedString(@"Order_Cash", @"Order_Cash")];
                    [order_carsh_lable setBackgroundColor:[UIColor clearColor]];
                    [order_carsh_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_carsh_lable setTextColor:[UIColor whiteColor]];
                    
                    UILabel *order_carsh = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_carsh setText:[NSString stringWithFormat:@"￥%.1lf",[order needPayMoney]]];
                    [order_carsh setBackgroundColor:[UIColor clearColor]];
                    [order_carsh setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_carsh setTextColor:[UIColor whiteColor]];
                    [order_carsh setTextAlignment:UITextAlignmentRight];
                    [cell.contentView addSubview:order_carsh_lable];
                    [cell.contentView addSubview:order_carsh];
                                   
                    [cell setBackgroundColor:[UIColor redColor]];
                    
                   
                    break;
                }
                case 1:{
                    
                    UIView* hideSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20, 20)];
                    hideSeparatorView.backgroundColor = [UIColor whiteColor];
                    
                    
                    
                    UILabel *order_shopping_cash_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_shopping_cash_lable setText:NSLocalizedString(@"Order_Shopping_Cash", @"Order_Shopping_Cash")];
                    [order_shopping_cash_lable setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_cash_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_shopping_cash_lable setTextColor:[UIColor grayColor]];
                    
                                        
                    UILabel *order_shopping_cash = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_shopping_cash setText:[NSString stringWithFormat:@"￥%.1lf",[order toPrice]]];
                    [order_shopping_cash setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_cash setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_shopping_cash setTextColor:[UIColor redColor]];
                    [order_shopping_cash setTextAlignment:UITextAlignmentRight];
                    
                    //[hideSeparatorView addSubview:order_carsh_lable];
                    [cell.contentView addSubview:hideSeparatorView];
                    [cell.contentView addSubview:order_shopping_cash_lable];
                    [cell.contentView addSubview:order_shopping_cash];
                    break;
                }
                case 2:{
                    UIView* hideSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20, 20)];
                    hideSeparatorView.backgroundColor = [UIColor whiteColor];
                   
                    UILabel *order_shopping_freight_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_shopping_freight_lable setText:NSLocalizedString(@"Order_Shopping_Freight", @"Order_Shopping_Freight")];
                    [order_shopping_freight_lable setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_freight_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_shopping_freight_lable setTextColor:[UIColor grayColor]];
                    
                     
                    
                    UILabel *order_shopping_freight = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
   
                    [order_shopping_freight setText:[NSString stringWithFormat:@"￥%.1lf",fabs([order freight])]];
                    [order_shopping_freight setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_freight setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_shopping_freight setTextColor:[UIColor redColor]];
                    [order_shopping_freight setTextAlignment:UITextAlignmentRight];
                    
                    [cell.contentView addSubview:hideSeparatorView];
                    [cell.contentView addSubview:order_shopping_freight_lable];
                    [cell.contentView addSubview:order_shopping_freight];
                    [cell setBackgroundColor:[UIColor whiteColor]];
                    
                    break;
                }
                case 3:{
                    UIView* hideSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20, 20)];
                    hideSeparatorView.backgroundColor = [UIColor whiteColor];
                    
                    
                    UILabel *order_shopping_preferential_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_shopping_preferential_lable setText:NSLocalizedString(@"Order_Shopping_Preferential", @"Order_Shopping_Preferential")];
                    [order_shopping_preferential_lable setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_preferential_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_shopping_preferential_lable setTextColor:[UIColor grayColor]];
                    
                                      
                    UILabel *order_shopping_preferential = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_shopping_preferential setText:[NSString stringWithFormat:@"-￥%.1f",fabs([order preferentialMoney])]];
                    [order_shopping_preferential setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_preferential setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_shopping_preferential setTextColor:[UIColor redColor]];
                    [order_shopping_preferential setTextAlignment:UITextAlignmentRight];
                    
                    
                    [cell.contentView addSubview:hideSeparatorView];
                    [cell.contentView addSubview:order_shopping_preferential_lable];
                    [cell.contentView addSubview:order_shopping_preferential];
                    [cell setBackgroundColor:[UIColor whiteColor]];
                    break;
                }
                case 4:{
                    UIView* hideSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20, 20)];
                    hideSeparatorView.backgroundColor = [UIColor whiteColor];
                    [cell.contentView addSubview:hideSeparatorView];
                    
                    UILabel *order_shopping_payed_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_shopping_payed_lable setText:NSLocalizedString(@"Order_Shopping_payedMoney", @"Order_Shopping_payedMoney")];
                    [order_shopping_payed_lable setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_payed_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_shopping_payed_lable setTextColor:[UIColor grayColor]];
                    
                
                    
                    UILabel *order_shopping_payed = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_shopping_payed setText:[NSString stringWithFormat:@"-￥%.1f",fabs([order payedMoney])]];
                    [order_shopping_payed setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_payed setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_shopping_payed setTextColor:[UIColor redColor]];
                    [order_shopping_payed setTextAlignment:UITextAlignmentRight];
                    
                    [cell.contentView addSubview:hideSeparatorView];
                    [cell.contentView addSubview:order_shopping_payed_lable];
                    [cell.contentView addSubview:order_shopping_payed];
                    [cell setBackgroundColor:[UIColor whiteColor]];
                    break;
                }
                case 5:{
                    
                    UILabel *order_shopping_balance_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
                    
                    [order_shopping_balance_lable setText:NSLocalizedString(@"Balance", @"Balance")];
                    [order_shopping_balance_lable setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_balance_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_shopping_balance_lable setTextColor:[UIColor grayColor]];
                    
                                 
                    UILabel *order_shopping_balance = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
                    
                    [order_shopping_balance setText:[NSString stringWithFormat:@"-￥%.1f",fabs(0.0)]];
                    [order_shopping_balance setBackgroundColor:[UIColor clearColor]];
                    [order_shopping_balance setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
                    [order_shopping_balance setTextColor:[UIColor redColor]];
                    [order_shopping_balance setTextAlignment:UITextAlignmentRight];
                    
                    [cell.contentView addSubview:order_shopping_balance_lable];
                    [cell.contentView addSubview:order_shopping_balance];
                    [cell setBackgroundColor:[UIColor whiteColor]];
                    break;
                }
                default:
                    break;
            }
          /*  UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18, 300, 2)];
            [line setTag:100];
            line.backgroundColor = [UIColor whiteColor];
            [cell addSubview:line];
          */  
            break;
        }
        case 1:{
            
            UIImageView *imageview =[[order.orderDetails objectAtIndex:indexPath.row] product_pic];
            imageview.frame =CGRectMake(6, 10, 60, 60);
            [cell.contentView addSubview:imageview];
            
            
            
            UILabel *single_productName_lable =[[UILabel alloc] initWithFrame:CGRectMake(75, 30, 220, 20)];
            [single_productName_lable setText:[[order.orderDetails objectAtIndex:0] productName]];
            [single_productName_lable setBackgroundColor:[UIColor clearColor]];
            [single_productName_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
            //   [order_number_lable setTextColor:[UIColor grayColor]];
            
            UILabel *orderDatails_quantity_lable =[[UILabel alloc] initWithFrame:CGRectMake(190, 60, 100, 20)];
            [orderDatails_quantity_lable setTextAlignment:UITextAlignmentRight];
            [orderDatails_quantity_lable setBackgroundColor:[UIColor clearColor]];
            [orderDatails_quantity_lable setText:[NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"Quantity", @"Quantity"),[[order.orderDetails objectAtIndex:0] quantity]]];
            [orderDatails_quantity_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
            
            [cell.contentView addSubview:imageview];
            [cell.contentView addSubview:single_productName_lable];
            [cell.contentView addSubview:orderDatails_quantity_lable];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setBackgroundColor:[UIColor whiteColor]];
            break;
        }        
        case 2:{
             [cell setAccessoryType:UITableViewCellAccessoryNone];
             [cell setBackgroundColor:[UIColor whiteColor]];
            switch (indexPath.row) {
                case 0:{
                    UILabel *user_realname_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 30)];
                    [user_realname_lable setText:[[order user] realName]];
                    [user_realname_lable setBackgroundColor:[UIColor clearColor]];
                    NSString *mobile = [[order userAddress] mobile]==nil?[[order userAddress] telphone]:[[order userAddress] mobile];
                    
                    UILabel *user_mobile_lable = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 150, 30)];
                    [user_mobile_lable setText:mobile];
                    [user_mobile_lable setTextAlignment:UITextAlignmentRight];
                    [user_mobile_lable setBackgroundColor:[UIColor clearColor]];
                    [cell.contentView addSubview:user_realname_lable];
                    [cell.contentView addSubview:user_mobile_lable];
                   // [cell setBackgroundColor:[UIColor whiteColor]];
                    break;
                }
                case 1:{
                    NSString *address =[NSString stringWithFormat:@"%@%@%@%@",[[[order userAddress] provence]ProvinceName ],[[[order userAddress] city]CityName ],[[[order userAddress] area]AreaName ],[[order userAddress] address ]];
                     UILabel *user_address_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 290, 50)];
                    [user_address_lable setNumberOfLines:0];
                    [user_address_lable setLineBreakMode:UILineBreakModeWordWrap];
                    [user_address_lable setText:address];
                    [user_address_lable setBackgroundColor:[UIColor clearColor]];
                    [user_address_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [user_address_lable setTextColor:[UIColor grayColor]];
                    [cell.contentView addSubview:user_address_lable];
                    
                    break;
                }
                default:
                    break;
                   
            }
            
            break;
        }
        case 3:{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            UILabel *user_payment_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 30)];
            [user_payment_lable setText:NSLocalizedString(@"Payment", @"Payment")];
            [user_payment_lable setBackgroundColor:[UIColor clearColor]];
            [user_payment_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
            
            UILabel *user_payment = [[UILabel alloc] initWithFrame:CGRectMake(70, 3, 230, 30)];
            [user_payment setText:[[order pay_Mode] PayModeName]];
            [user_payment setBackgroundColor:[UIColor clearColor]];
            [user_payment setTextColor:[UIColor grayColor]];
            [user_payment setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
            [user_payment setNumberOfLines:0];
            [user_payment setLineBreakMode:UILineBreakModeWordWrap];
            
            [cell.contentView addSubview:user_payment_lable];
            [cell.contentView addSubview:user_payment];
            break;
        }
        case 4:{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            switch (indexPath.row) {
                case 0:{
                    UILabel *user_payment_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 30)];
                    [user_payment_lable setText:NSLocalizedString(@"Distribution_way", @"Distribution_way")];
                    [user_payment_lable setBackgroundColor:[UIColor clearColor]];
                    [user_payment_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
                    [cell.contentView addSubview:user_payment_lable];
                    break;
                }
                case 1:{
                                    
                    UILabel *order_sendtype_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 30)];
                    [order_sendtype_lable setText:[NSLocalizedString(@"Logistics", @"Logistics") stringByAppendingString:@"："]];
                    [order_sendtype_lable setBackgroundColor:[UIColor clearColor]];
                    [order_sendtype_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_sendtype_lable setTextColor:[UIColor grayColor]];
                    
                    UILabel *order_deliverTime_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 100, 30)];
                    [order_deliverTime_lable setText:[NSLocalizedString(@"DeliverTime", @"DeliverTime") stringByAppendingString:@"："]];
                    
                    [order_deliverTime_lable setBackgroundColor:[UIColor clearColor]];
                    [order_deliverTime_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_deliverTime_lable setTextColor:[UIColor grayColor]];
                    
                    
                    UILabel *order_sendtype = [[UILabel alloc] initWithFrame:CGRectMake(70, 4, 230, 30)];
                    [order_sendtype setText:[[order sendType] SendTypeName]];
                    [order_sendtype setBackgroundColor:[UIColor clearColor]];
                    [order_sendtype setTextColor:[UIColor grayColor]];
                    [order_sendtype setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_sendtype setNumberOfLines:0];
                    [order_sendtype setLineBreakMode:UILineBreakModeWordWrap];
                    
                    UILabel *order_deliverTime = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 230, 30)];
                    [order_deliverTime setText:[order deliverTime]];
                    [order_deliverTime setBackgroundColor:[UIColor clearColor]];
                    [order_deliverTime setTextColor:[UIColor grayColor]];
                    [order_deliverTime setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_deliverTime setNumberOfLines:0];
                    [order_deliverTime setLineBreakMode:UILineBreakModeWordWrap];
                    
                    
                    [cell.contentView addSubview:order_sendtype_lable];
                    [cell.contentView addSubview:order_sendtype];
                    [cell.contentView addSubview:order_deliverTime_lable];
                    [cell.contentView addSubview:order_deliverTime];
                    break;
                }
                default:
                    break;
            }
          
            break;
        }
            
        case 5:{
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            switch (indexPath.row) {
                case 0:{
                    UILabel *user_nvoice_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 30)];
                    [user_nvoice_lable setText:NSLocalizedString(@"Invoice", @"Invoice")];
                    [user_nvoice_lable setBackgroundColor:[UIColor clearColor]];
                    [user_nvoice_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
                    
                    UILabel *user_nvoice = [[UILabel alloc] initWithFrame:CGRectMake(70, 2, 230, 30)];
                    
                    NSString *invoice_name = [order isInvoice]?NSLocalizedString(@"Ordinary_invoices",@"Ordinary_invoices"):NSLocalizedString(@"Not_Invoice",@"Not_Invoice");
                    
                    [user_nvoice setText:invoice_name];
                    [user_nvoice setBackgroundColor:[UIColor clearColor]];
                    [user_nvoice setTextColor:[UIColor grayColor]];
                    [user_nvoice setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [user_nvoice setNumberOfLines:0];
                    [user_nvoice setLineBreakMode:UILineBreakModeWordWrap];
                    
                    [cell.contentView addSubview:user_nvoice_lable];
                    [cell.contentView addSubview:user_nvoice];

                    break;
                }
                case 1:{
                    
                 
                    
                    UILabel *order_invoice_name_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 30)];
                    [order_invoice_name_lable setText:[NSLocalizedString(@"Invoice_Name", @"Invoice_Name") stringByAppendingString:@"："]];
                    [order_invoice_name_lable setBackgroundColor:[UIColor clearColor]];
                    [order_invoice_name_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_invoice_name_lable setTextColor:[UIColor grayColor]];
                    
                    UILabel *order_invoice_content_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 100, 30)];
                    [order_invoice_content_lable setText:[NSLocalizedString(@"Invoice_Content", @"Invoice_Content") stringByAppendingString:@"："]];
                    
                    [order_invoice_content_lable setBackgroundColor:[UIColor clearColor]];
                    [order_invoice_content_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_invoice_content_lable setTextColor:[UIColor grayColor]];
                    
                    
                    UILabel *order_invoice_name = [[UILabel alloc] initWithFrame:CGRectMake(70, 2, 230, 30)];
                    
                    NSString *invoiceName =([[order invoiceName]isEqual:[NSNull null]])?@"":[order invoiceName];
                    
 
                    [order_invoice_name setText:invoiceName];
                    [order_invoice_name setBackgroundColor:[UIColor clearColor]];
                    [order_invoice_name setTextColor:[UIColor grayColor]];
                    [order_invoice_name setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_invoice_name setNumberOfLines:0];
                    [order_invoice_name setLineBreakMode:UILineBreakModeWordWrap];
                    
                    UILabel *order_invoice_Content = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 230, 30)];
                    
                    
                     NSString *invoiceContent =([[order invoiceContent]isEqual:[NSNull null]])?@"":[order invoiceContent];
                    
                    [order_invoice_Content setText:invoiceContent];
                    [order_invoice_Content setBackgroundColor:[UIColor clearColor]];
                    [order_invoice_Content setTextColor:[UIColor grayColor]];
                    [order_invoice_Content setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                    [order_invoice_Content setNumberOfLines:0];
                    [order_invoice_Content setLineBreakMode:UILineBreakModeWordWrap];
                    
                    
                    [cell.contentView addSubview:order_invoice_name_lable];
                    [cell.contentView addSubview:order_invoice_name];
                    [cell.contentView addSubview:order_invoice_content_lable];
                    [cell.contentView addSubview:order_invoice_Content];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *title_view =[[UIView alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
        
        UILabel *order_status_lable =[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
        [order_status_lable setText:[NSLocalizedString(@"Order_Status", @"Order_Status") stringByAppendingString:@"："]];
        [order_status_lable setBackgroundColor:[UIColor clearColor]];
        [order_status_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
        [order_status_lable setTextColor:[UIColor grayColor]];
        
        UILabel *order_status =[[UILabel alloc] initWithFrame:CGRectMake(70, 5, 80, 20)];
        [order_status setText:[[order order_Status] orderStatusName]];
        [order_status setBackgroundColor:[UIColor clearColor]];
        [order_status setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
        [order_status setTextColor:[UIColor redColor]];
        
        UILabel *order_number_lable =[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 80, 20)];
        [order_number_lable setText:[NSLocalizedString(@"Order_Number", @"Order_Number") stringByAppendingString:@"："]];
        [order_number_lable setBackgroundColor:[UIColor clearColor]];
        [order_number_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
        [order_number_lable setTextColor:[UIColor grayColor]];
        
        
        UILabel *order_number =[[UILabel alloc] initWithFrame:CGRectMake(70, 30, 150, 20)];
        [order_number setText:[order orderNumber] ];
        [order_number setBackgroundColor:[UIColor clearColor]];
        [order_number setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];

        [title_view addSubview:order_status_lable];
        [title_view addSubview:order_status];
        [title_view addSubview:order_number_lable];
        [title_view addSubview:order_number];
        return title_view;
    }else
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 50;
    }
    else return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section)
    {
        case 0:
            return 20;
            break;
        case 1:
            return 80;
            break;
        case 2:{
            if (indexPath.row==1) {
                return 50;
            }else
            return 30;
            break;
        }
        case 3:
            return 40;
            break;
        case 4:{
            if (indexPath.row==0) {
                return 30;
            }else
                return 60;
            break;
        }
        case 5:{
            if (indexPath.row==0) {
                return 30;
            }else
                return 80;
            break;
        }
        default:
            return 30;
            break;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {        
        ProductViewController *productViewController = [[ProductViewController alloc] initWithProductName:[[[order orderDetails] objectAtIndex:indexPath.row] productName]];

        [productViewController  setProduct_id:[[[order orderDetails] objectAtIndex:indexPath.row] productId]];
  
        [self.navigationController pushViewController:productViewController animated:YES];
    }
}

#pragma mark -
- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    if (![ aRequest error])
    {
        NSDictionary *order_dict =[[aRequest responseString]JSONValue];
        // NSLog(@"%@",order_dict);
        order =[[OrderBean alloc]init];
        //订单状态
        OrderStatusBean *orderStatus =[[OrderStatusBean alloc] init];
        
        [orderStatus setOrderStatusID:[[[order_dict objectForKey:@"orderStatus"] objectForKey:@"id"] integerValue]];
        [orderStatus setOrderStatusName:[[order_dict objectForKey:@"orderStatus"] objectForKey:@"name"]];
        [order setOrder_Status:orderStatus];
        //支付方式
        PayModeBean *paymode = [[PayModeBean alloc] init];
        [paymode setPayModeID:[[[order_dict objectForKey:@"payMode"] objectForKey:@"id"] integerValue]];
        [paymode setPayModeName:[[order_dict objectForKey:@"payMode"] objectForKey:@"name"]];
        [order setPay_Mode:paymode];
        //收货地址
        UserAddressBean *userAddress =[[UserAddressBean alloc] init];
        [userAddress setAddress:[[order_dict objectForKey:@"orderAddress"] objectForKey:@"address"]];
        [userAddress setConsignee:[[order_dict objectForKey:@"orderAddress"] objectForKey:@"consignee"]];
        [userAddress setTelphone:[[order_dict objectForKey:@"orderAddress"] objectForKey:@"telphone"]];
        [userAddress setMobile:[[order_dict objectForKey:@"orderAddress"] objectForKey:@"mobile"]];
        [userAddress setPostcode:[[order_dict objectForKey:@"orderAddress"] objectForKey:@"postcode"]];
        
        
        ProvinceBean *province =[[ProvinceBean alloc] init];
        //升级采用这种方式读取数据
        //  [province setProvinceID: [[[[order_dict objectForKey:@"orderAddress"] objectForKey:@"province"]objectForKey:@"id"]integerValue]];
        // [province setProvinceName: [[[order_dict objectForKey:@"orderAddress"] objectForKey:@"province"]objectForKey:@"name"]];
        [province setProvinceID: [[[order_dict objectForKey:@"orderAddress"] objectForKey:@"province"] objectForKey:@"id"]];
        [province setProvinceName: [[[order_dict objectForKey:@"orderAddress"] objectForKey:@"province"] objectForKey:@"name"]];
        
        [userAddress setProvence:province];
        
        CityBean *city =[[CityBean alloc] init];
        
        [city setCityID: [[[order_dict objectForKey:@"orderAddress"] objectForKey:@"city"] objectForKey:@"id"]];
        [city setCityName: [[[order_dict objectForKey:@"orderAddress"] objectForKey:@"city"] objectForKey:@"name"]];
        [city setProvinceId: [[[order_dict objectForKey:@"orderAddress"] objectForKey:@"city"] objectForKey:@"provinceId"]];
        
        [userAddress setCity:city];
        
        AreaBean *area = [[AreaBean alloc] init];
        
        [area setAreaID: [[[order_dict objectForKey:@"orderAddress"] objectForKey:@"area"] objectForKey:@"id"]];
        [area setAreaName: [[[order_dict objectForKey:@"orderAddress"] objectForKey:@"area"] objectForKey:@"name"]];
        [area setCityID: [[[order_dict objectForKey:@"orderAddress"] objectForKey:@"area"] objectForKey:@"cityId"]];
        
        [userAddress setArea:area];
        
        //配送方式
        SendTypeBean *sendType = [[SendTypeBean alloc] init];
        [sendType setSendTypeID:[[[order_dict objectForKey:@"sendType"] objectForKey:@"id"] integerValue]];
        [sendType setSendTypeName:[[order_dict objectForKey:@"sendType"] objectForKey:@"name"]];
        [order setSendType:sendType];
        
        //产品明细
        NSMutableArray *orderdetails_list = [[NSMutableArray alloc] initWithCapacity:[[order_dict objectForKey:@""] count]];
        
        for (NSDictionary *orderDetail_dict in [order_dict objectForKey:@"orderDetails"]) {
            OrderDetailsBean *orderDatail= [[OrderDetailsBean alloc] init];
            [orderDatail setProductId:[[orderDetail_dict objectForKey:@"productId"] integerValue]];
            [orderDatail setProductName:[orderDetail_dict objectForKey:@"productName"] ];
            [orderDatail setProductNo:[orderDetail_dict objectForKey:@"productNo"] ];
            [orderDatail setQuantity:[[orderDetail_dict objectForKey:@"quantity"] integerValue] ];
            [orderDatail setTransactionPrice:[[orderDetail_dict objectForKey:@"transactionPrice"] doubleValue] ];
            [orderDatail setTransactionTotalPrice:[[orderDetail_dict objectForKey:@"transactionTotalPrice"] doubleValue] ];
            
            UIImageView *imageView =[[UIImageView alloc] init];
            [imageView setImageWithURL:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/App_Product_Image/%@/120/1.png",[orderDetail_dict objectForKey:@"productNo"]]placeholderImage:nil];
            
            [orderDatail setProduct_pic:imageView];
            
            imageView= nil;
            
            [orderdetails_list addObject:orderDatail];
            
            orderDatail =nil;
        }
        [order setOrderDetails:orderdetails_list];
        
        orderdetails_list =nil;
        //用户信息
        UserBean *user =[[UserBean alloc] init];
        [user setUserid:[[[order_dict objectForKey:@"user"] objectForKey:@"id" ] integerValue]];
        [user setRealName:[[order_dict objectForKey:@"user"] objectForKey:@"realName" ]];
        [user setEmail:[[order_dict objectForKey:@"user"] objectForKey:@"email" ]];
        [order setUser:user];
        
        
        [order setUserAddress:userAddress];
        [order setOrderId:[order_dict objectForKey:@"id"]];
        [order setOrderNumber:[order_dict objectForKey:@"number"]];
        [order setToPrice:[[order_dict objectForKey:@"totalPrice"] doubleValue]];
        [order setNeedPayMoney:[[order_dict objectForKey:@"needPayMoney"] doubleValue]];
        [order setPreferentialMoney:[[order_dict objectForKey:@"preferentialMoney"] doubleValue]];
        [order setPayedMoney:[[order_dict objectForKey:@"payedMoney"] doubleValue]];
        [order setFreight:[[order_dict objectForKey:@"freight"] doubleValue]];
        [order setTransactionTotalPrice:[[order_dict objectForKey:@"transactionTotalPrice"] doubleValue]];
        [order setDeliverTime:[order_dict objectForKey:@"deliverTime"] ];
        [order setIsInvoice:[[NSNumber numberWithInteger:[[order_dict objectForKey:@"isInvoice"] integerValue]] boolValue]];
        
        [order setInvoiceName:[order_dict objectForKey:@"invoiceName"] ];
        
        [order setInvoiceContent:[order_dict objectForKey:@"invoiceContent"] ];
        
        [order setNote:[order_dict objectForKey:@"note"] ];
        
        [order setCreateTime:[IOSFactory changeSecondToNSDate:[[order_dict objectForKey:@"createTime"] doubleValue]]  ];
        
        [order setUseBonus:[[order_dict objectForKey:@"createTime"] integerValue]  ];
    }
    [self.tableView reloadData];
    [self hideHud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideHud];
}


@end
