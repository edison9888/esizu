//
//  UserAddressViewController.m
//  uzise
//
//  Created by edward on 12-10-27.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "AddressListController.h"

#import "Constant.h"

#import "SendTypeBean.h"

#import "UserBean.h"

#import "OrderLandingViewController.h"
#import "Global.h"
#import "AddressEditorController.h"
#import "UserManager.h"


@interface AddressListController ()
{
}

@property(nonatomic,strong)NSMutableArray *mAddressList;
@property(nonatomic,copy)NSString *mSelectedAddressID;

@end

@implementation AddressListController
@synthesize mAddressList;
@synthesize mSelectedAddressID;
@synthesize mDelegate;

- (id) initWithAddressList:(NSArray*)aAddressList andSelectedAddressID:(NSString*)aSelectedAddressID
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.mAddressList = [NSMutableArray arrayWithArray:aAddressList];
        self.mSelectedAddressID = aSelectedAddressID;
    }
    
    return self;
}

- (id) initWithSelectedAddressID:(NSString*)aSelectedAddressID
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.mSelectedAddressID = aSelectedAddressID;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.mAddressList
        || self.mAddressList.count <= 0)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self showHud];
        [self loadAddressList];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)loadAddressList
{
    ASIHTTPRequest *useraddress_reuqest =[self asynLoadByURLStr:[NSString stringWithFormat:@"%@?appkey=%@", URL_GET_ADDRESS_LIST,[[UserManager shared]getSessionAppKey]] withCachePolicy:E_CACHE_POLICY_NO_CACHE];
    
    [self.mRequests addObject:useraddress_reuqest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Consignee_information", @"Consignee_information");
    
//    UIBarButtonItem *newUserAddressBarItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"New_Consignee", @"New_Consignee") style:UIBarButtonItemStyleBordered target:self action:@selector(newConsignee)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newConsignee)];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    [self.view setBackgroundColor:BG_COLOR];

}

-(void)newConsignee
{    
    AddressEditorController* userAddressEditViewController =[[AddressEditorController alloc] initWithAddress:nil create:YES];
    userAddressEditViewController.mDelegate = self;
    [self.navigationController pushViewController:userAddressEditViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mAddressList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([mAddressList count]>0)
    {
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        switch (indexPath.row) {
            case 0:{
                UserAddressBean *userAddress= [mAddressList objectAtIndex:indexPath.section];
                
                UILabel *user_name_lable =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 31)];
                [user_name_lable setText:[userAddress consignee]];
                [user_name_lable setBackgroundColor:[UIColor clearColor]];
                [user_name_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
              
                UILabel *user_mobile_lable =[[UILabel alloc] initWithFrame:CGRectMake(120, 10, 200, 31)];
                [user_mobile_lable setText:[userAddress mobile]];
                [user_mobile_lable setBackgroundColor:[UIColor clearColor]];
                [user_mobile_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
              
                UILabel *user_address_lable =[[UILabel alloc] initWithFrame:CGRectMake(10, 40, 270, 50)];
                [user_address_lable setText:[NSString stringWithFormat:@"%@%@%@%@",[[userAddress provence] ProvinceName],[[userAddress city] CityName],[[userAddress area] AreaName],[userAddress address]]];
                [user_address_lable setBackgroundColor:[UIColor clearColor]];
                [user_address_lable setNumberOfLines:0];
                [user_address_lable setLineBreakMode:UILineBreakModeWordWrap];
                [user_address_lable setFont:[UIFont fontWithName:@"AppleGothic" size:13.0]];
                [cell.contentView addSubview:user_name_lable];
                [cell.contentView addSubview:user_mobile_lable];
                [cell.contentView addSubview:user_address_lable];
                
                //
                if ( (!self.mSelectedAddressID||self.mSelectedAddressID.length == 0)
                    && indexPath.section == 0)
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    if ([userAddress.addressId isEqualToString:self.mSelectedAddressID])
                    {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else
                    {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                }
                
                break;
            }
            case 1:{
                UIView *editView  =[[UIView alloc] initWithFrame:CGRectMake(190, 0, 103, 50)];
                
                UITapGestureRecognizer *single = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userAddressEdit:)];
                editView.tag = indexPath.section;
                
                [editView addGestureRecognizer:single];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"216-compose"]];
                [imageView setFrame:CGRectMake(35, 12, 23, 18)];
                [editView addSubview:imageView];
                UILabel *user_address_lable =[[UILabel alloc] initWithFrame:CGRectMake(60, -4, 80, 50)];
                [user_address_lable setText:NSLocalizedString(@"TableEditing", @"TableEditing")];
                [user_address_lable setBackgroundColor:[UIColor clearColor]];
                [user_address_lable setNumberOfLines:0];
                [user_address_lable setLineBreakMode:UILineBreakModeWordWrap];
                [user_address_lable setFont:[UIFont fontWithName:@"AppleGothic" size:15.0]];
                
                [editView addSubview:user_address_lable];
                [cell.contentView addSubview:editView];
               
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}

-(void)userAddressEdit:(UITapGestureRecognizer *)tap
{    
    UserAddressBean *address = [mAddressList objectAtIndex:tap.view.tag];
    AddressEditorController *userAddressEditViewController =[[AddressEditorController alloc] initWithAddress:address create:NO];
    userAddressEditViewController.mDelegate = self;
    
    [self.navigationController pushViewController:userAddressEditViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 100;
    }
    else
    {
        return 44;      
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sIndex = indexPath.section;
    UserAddressBean* sAddress = [self.mAddressList objectAtIndex:sIndex];
    
    if (!self.mSelectedAddressID
        || self.mSelectedAddressID.length <= 0
        || ![self.mSelectedAddressID isEqualToString:sAddress.addressId])
    {
        self.mSelectedAddressID = sAddress.addressId;
        
        [[UserManager shared] setLastAddressID:self.mSelectedAddressID];
        
        if ([self.mDelegate respondsToSelector:@selector(changeWithSelectAddress:)])
        {
            [self.mDelegate changeWithSelectAddress:sAddress];
        }
        [self.tableView reloadData];
    }
    
}

//
- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    // Use when fetching text data
    mAddressList =[[NSMutableArray alloc] initWithCapacity:[[[aRequest responseString] JSONValue] count]];
    
    if (aRequest
        && ![aRequest error])
    {
        // NSDictionary *userAddress_dict =[[[useraddress_reuqest responseString] JSONValue] objectAtIndex:0];
        
        for (NSDictionary *userAddress_dict in [[aRequest responseString] JSONValue])
        {
            UserAddressBean  *userAddressBean =[[UserAddressBean alloc] init];
            [userAddressBean setAddressId:[userAddress_dict objectForKey:@"id"]];
            [userAddressBean setConsignee:[userAddress_dict objectForKey:@"consignee"]];
            [userAddressBean setTelphone:[userAddress_dict objectForKey:@"telphone"]];
            [userAddressBean setMobile:[userAddress_dict objectForKey:@"mobile"]];
            AreaBean *area =[[AreaBean alloc] init];
            [area setAreaID:[[userAddress_dict objectForKey:@"area"] objectForKey:@"id"]];
            [area setAreaName:[[userAddress_dict objectForKey:@"area"] objectForKey:@"name"]];
            [area setCityID:[[userAddress_dict objectForKey:@"area"] objectForKey:@"cityId"]];
            
            CityBean *city =[[CityBean alloc] init];
            [city setCityID:[[userAddress_dict objectForKey:@"city"] objectForKey:@"id"]];
            [city setCityName:[[userAddress_dict objectForKey:@"city"] objectForKey:@"name"]];
            [city setProvinceId:[[userAddress_dict objectForKey:@"city"] objectForKey:@"provinceId"]];
            
            ProvinceBean *province =[[ProvinceBean alloc] init];
            [province setProvinceID:[[userAddress_dict objectForKey:@"province"] objectForKey:@"id"]];
            [province setProvinceName:[[userAddress_dict objectForKey:@"province"] objectForKey:@"name"]];
            
            [userAddressBean setArea:area];
            [userAddressBean setCity:city];
            [userAddressBean setProvence:province];
            
            [userAddressBean setPostcode:[userAddress_dict objectForKey:@"postcode"]];
            
            [userAddressBean setAddress:[userAddress_dict objectForKey:@"address"]];
            
            [mAddressList addObject:userAddressBean];
        }
    }
    
    [self hideHud];
    self.navigationItem.rightBarButtonItem.enabled = YES;

    [self.tableView reloadData];

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideHud];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - AddressSettingDelegate
- (void) changedWithModifiedAddress:(UserAddressBean*)aModifiedAddress
{
    for (UserAddressBean* sAddress in mAddressList)
    {
        if ([sAddress.addressId isEqualToString:aModifiedAddress.addressId])
        {
            [sAddress setConsignee: aModifiedAddress.consignee];
            
            [sAddress setProvence: aModifiedAddress.provence];
            
            [sAddress setCity: aModifiedAddress.city];
            
            [sAddress setArea: aModifiedAddress.area];

            [sAddress setAddress: aModifiedAddress.address];
            
            [sAddress setMobile: aModifiedAddress.mobile];
            
            [sAddress setPostcode: aModifiedAddress.postcode];
            
            self.mSelectedAddressID = aModifiedAddress.addressId;
            break;
        }
    }
    [self.tableView reloadData];
    
    if ([self.mDelegate respondsToSelector:@selector(changedWithModifiedAddress:)])
    {
        [self.mDelegate changedWithModifiedAddress:aModifiedAddress];
    }
}

- (void) changeWithNewAddress:(UserAddressBean*)aNewAddress
{
    if (!mAddressList)
    {
        mAddressList = [NSMutableArray array];
    }
    
    [mAddressList addObject:aNewAddress];
    self.mSelectedAddressID = aNewAddress.addressId;

    [self.tableView reloadData];
    
    if ([self.mDelegate respondsToSelector:@selector(changeWithNewAddress:)])
    {
        [self.mDelegate changeWithNewAddress:aNewAddress];
    }

}

- (void) changeWithSelectAddress:(UserAddressBean*)aNewAddress
{
    return;
}

@end
