//
//  UserAddressEditViewController.m
//  uzise
//
//  Created by edward on 12-10-31.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "AddressEditorController.h"

#import "Constant.h"

#import "SendTypeBean.h"

#import "UserBean.h"

#import <QuartzCore/QuartzCore.h>

#import "UAModalPanel.h"

#import "RegionSelectionController.h"

#import "OrderLandingViewController.h"
#import "UserManager.h"
#import "Global.h"


#define REQUEST_MODIFY_ADDRESS 1
#define REQUEST_CREATE_ADDRESS 2

@interface AddressEditorController ()
{
    TPKeyboardAvoidingTableView* mTableView;
}

-(void)modifyAddress:(id)sender;

-(BOOL)regexKitLiteCheckAddress;

@property(nonatomic,strong)UITextField *consignee_textfield;

@property(nonatomic,strong)UITextField *province_textfield;

@property(nonatomic,strong)UITextView *address_textview;

@property(nonatomic,strong)UILabel *address_textview_lable;

@property(nonatomic,strong)UITextField *mobile_textfield;

@property(nonatomic,strong)UITextField *postcode_textfield;

@property(nonatomic,strong)UserAddressBean *userAddress;

@property(nonatomic,strong)NSMutableDictionary *address_dict;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong) RegionSelectionController *modalPanel;

@property (nonatomic, strong) UITableView* mTableView;

@end

@implementation AddressEditorController
@synthesize aid,appkey;
@synthesize consignee_textfield=_consignee_textfield;
@synthesize province_textfield =_province_textfield;
@synthesize address_textview =_address_textview;
@synthesize mobile_textfield =_mobile_textfield;
@synthesize postcode_textfield =_postcode_textfield;
@synthesize userAddress = mAddress;
@synthesize address_dict =_address_dict;
@synthesize scrollView=_scrollView;
@synthesize address_textview_lable =_address_textview_lable;
@synthesize modalPanel =_modalPanel;
@synthesize mCreate;
@synthesize mTableView;

- (id) initWithAddress:(UserAddressBean*)aAddress create:(BOOL)aIsCreate
{
    self = [super init];
    if (self)
    {
        if (aAddress)
        {
            mAddress = aAddress;
            self.aid = mAddress.addressId;
        }
        else
        {
            mAddress = [[UserAddressBean alloc] init];
        }
        self.mCreate =  aIsCreate;
        self.appkey = [[UserManager shared] getSessionAppKey];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    TPKeyboardAvoidingTableView* sTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    sTableView.dataSource = self;
    sTableView.delegate = self;
    [sTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bh"]]];
    [self.view addSubview:sTableView];
    
    self.mTableView  = sTableView;
    
    if (self.mCreate)
    {
        self.title =NSLocalizedString(@"New_Consignee_Information", @"New_Consignee_Information");
//        UIBarButtonItem *completeCreateAddressBarItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Complete", @"Complete") style:UIBarButtonItemStyleBordered target:self action:@selector(createAddress:)];
//        self.navigationItem.rightBarButtonItem=completeCreateAddressBarItem;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(createAddress:)];

    }
    else
    {
        self.title =NSLocalizedString(@"Modify_Information", @"Modify_Information");
//        UIBarButtonItem *completeModifyAddressBarItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Complete", @"Complete") style:UIBarButtonItemStyleBordered target:self action:@selector(modifyAddress:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(modifyAddress:)];

//        self.navigationItem.rightBarButtonItem=completeModifyAddressBarItem;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mTableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_address_textview_lable removeFromSuperview];
    
    [_consignee_textfield setText:[mAddress consignee]];
    
    [_province_textfield setText:[NSString stringWithFormat:@"%@%@%@", ([[mAddress provence] ProvinceName]==nil?@"":[[mAddress provence] ProvinceName]),([[mAddress city] CityName]==nil?@"":[[mAddress city] CityName]),([[mAddress area] AreaName]==nil?@"":[[mAddress area] AreaName])]];
    
    if ([mAddress address].length > 0)
    {
        [_address_textview setText:[mAddress address]];

    }
    [_mobile_textfield setText:[mAddress mobile]];
    [_postcode_textfield setText:[mAddress postcode]];

}

-(BOOL)regexKitLiteCheckAddress
{
    NSString* sMsgStr = nil;
    if (!(_consignee_textfield.text.length > 0))
    {
        sMsgStr = NSLocalizedString(@"Please input consignee", nil);
    }
    else if (!(mAddress.provence.ProvinceID.length > 0))
    {
        sMsgStr = NSLocalizedString(@"Please select area", nil);
    }
    else if (!(mAddress.city.CityID.length > 0))
    {
        sMsgStr = NSLocalizedString(@"Please select city", nil);
    }
    else if (!(mAddress.area.AreaID.length > 0))
    {
        sMsgStr = NSLocalizedString(@"Please select area", nil);
    }
    else if ([[_address_textview text] length]>150||[[_address_textview text] length]<5)
    {
        sMsgStr = NSLocalizedString(@"Invalid address", nil);
    }
    else if (!(_mobile_textfield.text.length > 0))
    {
        sMsgStr = NSLocalizedString(@"Mobile is empty", nil);
    }
    else if (![IOSFactory isMobileNumber: [_mobile_textfield text ]])
    {
        sMsgStr = NSLocalizedString(@"MobileInputMessage", @"MobileInputMessage");
    }
    else if (!(_postcode_textfield.text.length > 0))
    {
        sMsgStr = NSLocalizedString(@"Postcode is empty", nil);
    }
    else if (![[_postcode_textfield text] isMatchedByRegex:@"\\b[0-9]"] )
    {
        sMsgStr = NSLocalizedString(@"Postcode must be numbers", nil);
    }
    else
    {
        //
    }
    
    if (sMsgStr.length > 0)
    {
        [self hideKeyboard];
        [self showAlert:sMsgStr  cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)createAddress:(id)sender
{
    if ([self regexKitLiteCheckAddress])
    {
        [mAddress setConsignee:[_consignee_textfield text]];
        
        [mAddress setAddress:[_address_textview text]];
        
        [mAddress setMobile:[_mobile_textfield text ]];
        
        [mAddress setPostcode:[_postcode_textfield text]];
        
        ASIFormDataRequest *address_post = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString: URL_NEW_ADDRESS]];
        
        [address_post setPostValue:appkey forKey:@"appkey"];
        [address_post setPostValue:[_consignee_textfield text] forKey:@"address.consignee"];
        [address_post setPostValue:[_mobile_textfield text] forKey:@"address.mobile"];
        [address_post setPostValue:[[mAddress provence] ProvinceID] forKey:@"address.provinceId"];
        [address_post setPostValue:[[mAddress city] CityID] forKey:@"address.cityId"];
        [address_post setPostValue:[[mAddress area] AreaID] forKey:@"address.areaId"];
        [address_post setPostValue:[_address_textview text] forKey:@"address.address"];
        [address_post setPostValue:[_postcode_textfield text] forKey:@"address.postcode"];
        
        [self showHud];
        address_post.delegate = self;
        address_post.tag = REQUEST_CREATE_ADDRESS;
        [address_post startAsynchronous];
    }
}

-(void)modifyAddress:(id)sender
{
    if ([self regexKitLiteCheckAddress])
    {
        [mAddress setConsignee:[_consignee_textfield text]];
        
        [mAddress setAddress:[_address_textview text]];
        
        [mAddress setMobile:[_mobile_textfield text ]];
        
        [mAddress setPostcode:[_postcode_textfield text]];
        
        ASIFormDataRequest *address_post = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString: URL_MODIFY_ADDRESS]];
        
        [address_post setPostValue:appkey forKey:@"appkey"];
        [address_post setPostValue:aid forKey:@"address.id"];
        [address_post setPostValue:[_consignee_textfield text] forKey:@"address.consignee"];
        [address_post setPostValue:[_mobile_textfield text] forKey:@"address.mobile"];
        [address_post setPostValue:[[mAddress provence] ProvinceID] forKey:@"address.provinceId"];
        [address_post setPostValue:[[mAddress city] CityID] forKey:@"address.cityId"];
        [address_post setPostValue:[[mAddress area] AreaID] forKey:@"address.areaId"];
        [address_post setPostValue:[_address_textview text] forKey:@"address.address"];
        [address_post setPostValue:[_postcode_textfield text] forKey:@"address.postcode"];
        
        address_post.tag = REQUEST_MODIFY_ADDRESS;
        
        [self showHud];
        address_post.delegate = self;
        [address_post startAsynchronous];
    }
}


- (void) hideKeyboard
{
    [_consignee_textfield resignFirstResponder];
    [_address_textview resignFirstResponder];
    [_mobile_textfield resignFirstResponder];
    [_postcode_textfield resignFirstResponder];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2)
    {
        return 120;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
   
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    switch (indexPath.row)
    {
        case 0:{
            UILabel *consignee_lable =[[UILabel alloc] initWithFrame:CGRectMake(25, 13, 100, 40)];
            [consignee_lable setText:[NSLocalizedString(@"Consignee_Name", @"Consignee_Name") stringByAppendingString:@"："]];
            [consignee_lable setBackgroundColor:[UIColor clearColor]];
            [consignee_lable setFont:[UIFont fontWithName:@"AppleGothic" size:16.0]];
            [consignee_lable setTextAlignment:UITextAlignmentRight];
            [cell.contentView addSubview:consignee_lable];

            if (!_consignee_textfield)
            {
                _consignee_textfield =[[UITextField alloc] initWithFrame:CGRectMake(120, 11, 180, 40)];
                [_consignee_textfield setBorderStyle:UITextBorderStyleRoundedRect];
                _consignee_textfield.backgroundColor = [UIColor whiteColor];
                _consignee_textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [_consignee_textfield setPlaceholder:NSLocalizedString(@"Input_Consignee_Name", @"Input_Consignee_Name")];
                [_consignee_textfield setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
                [_consignee_textfield.layer setCornerRadius:5.0];
//                [_consignee_textfield.layer setBorderWidth:1.0];
//                [_consignee_textfield.layer setMasksToBounds:YES];
                _consignee_textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
                [_consignee_textfield setDelegate:self];
            }
            [cell.contentView addSubview:_consignee_textfield];
            break;
            
        }
        case 1:{
            UILabel *province_lable =[[UILabel alloc] initWithFrame:CGRectMake(25, 13, 100, 40)];
            [province_lable setText:[NSLocalizedString(@"Consignee_Area", @"Consignee_Area") stringByAppendingString:@"："]];
            [province_lable setBackgroundColor:[UIColor clearColor]];
            [province_lable setFont:[UIFont fontWithName:@"AppleGothic" size:16.0]];
             [province_lable setTextAlignment:UITextAlignmentRight];
            [cell.contentView addSubview:province_lable];

            if (!_province_textfield)
            {
                _province_textfield =[[UITextField alloc] initWithFrame:CGRectMake(120, 11, 180, 40)];
                [_province_textfield setBorderStyle:UITextBorderStyleRoundedRect];
                _province_textfield.backgroundColor = [UIColor whiteColor];
                _province_textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [_province_textfield setPlaceholder:NSLocalizedString(@"Input_Consignee_Region", @"Input_Consignee_Region")];
                [_province_textfield.layer setCornerRadius:5.0];
//                [_province_textfield.layer setBorderWidth:1.0];
//                [_province_textfield.layer setMasksToBounds:YES];
                [_province_textfield setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
                [_province_textfield setDelegate:self];
            }
            [cell.contentView addSubview:_province_textfield];
            break;
            
        }
        case 2:{
            UILabel *address_lable =[[UILabel alloc] initWithFrame:CGRectMake(25, 13, 100, 40)];
            [address_lable setText:[NSLocalizedString(@"Consignee_Address", @"Consignee_Address") stringByAppendingString:@"："]];
            [address_lable setBackgroundColor:[UIColor clearColor]];
            [address_lable setFont:[UIFont fontWithName:@"AppleGothic" size:16.0]];
             [address_lable setTextAlignment:UITextAlignmentRight];
            [cell.contentView addSubview:address_lable];

            if (!_address_textview)
            {
                //make textview look like text field, by putting a uitextfield behind it.
                UITextField* sDumbTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 180, 100)];
                sDumbTextField.enabled = NO;
                [sDumbTextField.layer setCornerRadius:5.0];
                [sDumbTextField setBorderStyle:UITextBorderStyleRoundedRect];
                
                [cell.contentView addSubview:sDumbTextField];
                
                _address_textview =[[UITextView alloc] initWithFrame:CGRectMake(120, 10, 180, 100)];
                _address_textview.backgroundColor = [UIColor clearColor];
                if (!mAddress.address
                    || mAddress.address.length <= 0)
                {
                    _address_textview.text = NSLocalizedString(@"Input_Consignee_Address", nil);
                    _address_textview.textColor = [UIColor lightGrayColor];
                }
                
                [_address_textview setDelegate:self];
//                [_address_textview.layer setCornerRadius:5.0];
//                _address_textview.clipsToBounds = YES;
//                [_address_textview.layer setBorderColor: [[UIColor grayColor] CGColor]];
//                [_address_textview.layer setBorderWidth:1.0];
//                [_address_textview.layer setMasksToBounds:YES];
//                
//                [_address_textview.layer setShadowColor:[[UIColor blackColor] CGColor]];
//                [_address_textview.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
//                [_address_textview.layer setShadowOpacity:1.0];
//                [_address_textview.layer setShadowRadius:0.3];
                
                [_address_textview setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
            }
            [cell.contentView addSubview:_address_textview];
            break;
            
        }
        case 3:{
            UILabel *mobile_lable =[[UILabel alloc] initWithFrame:CGRectMake(25, 13, 100, 40)];
            [mobile_lable setText:[NSLocalizedString(@"Consignee_Mobile", @"Consignee_Mobile") stringByAppendingString:@"："]];
            [mobile_lable setBackgroundColor:[UIColor clearColor]];
            [mobile_lable setFont:[UIFont fontWithName:@"AppleGothic" size:16.0]];
             [mobile_lable setTextAlignment:UITextAlignmentRight];
            [cell.contentView addSubview:mobile_lable];

            if (!_mobile_textfield)
            {
                _mobile_textfield =[[UITextField alloc] initWithFrame:CGRectMake(120, 11, 180, 40)];
                _mobile_textfield.keyboardType = UIKeyboardTypeNumberPad;
                [_mobile_textfield setBorderStyle:UITextBorderStyleRoundedRect];
                _mobile_textfield.backgroundColor = [UIColor whiteColor];
                _mobile_textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [_mobile_textfield setPlaceholder:NSLocalizedString(@"Input_Consignee_Mobile", @"Input_Consignee_Mobile")];
                _mobile_textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
                [_mobile_textfield.layer setCornerRadius:5.0];
//                [_mobile_textfield.layer setBorderWidth:1.0];
//                [_mobile_textfield.layer setMasksToBounds:YES];
                [_mobile_textfield setDelegate:self];
                [_mobile_textfield setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
            }
            [cell.contentView addSubview:_mobile_textfield];
            break;
            
        }
        case 4:{
            UILabel *postcode_lable =[[UILabel alloc] initWithFrame:CGRectMake(25, 13, 100, 40)];
            [postcode_lable setText:[NSLocalizedString(@"Consignee_PostCode", @"Consignee_PostCode") stringByAppendingString:@"："]];
            [postcode_lable setBackgroundColor:[UIColor clearColor]];
            [postcode_lable setFont:[UIFont fontWithName:@"AppleGothic" size:16.0]];
             [postcode_lable setTextAlignment:UITextAlignmentRight];
            [cell.contentView addSubview:postcode_lable];

            if (!_postcode_textfield)
            {
                _postcode_textfield =[[UITextField alloc] initWithFrame:CGRectMake(120, 11, 180, 40)];
                [_postcode_textfield setBorderStyle:UITextBorderStyleRoundedRect];
                _postcode_textfield.backgroundColor = [UIColor whiteColor];
                _postcode_textfield.keyboardType = UIKeyboardTypeNumberPad;
                _postcode_textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [_postcode_textfield setPlaceholder:NSLocalizedString(@"Input_Consignee_PostCode", @"Input_Consignee_PostCode")];
                _postcode_textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
                [_postcode_textfield.layer setCornerRadius:5.0];
//                [_postcode_textfield.layer setBorderWidth:1.0];
//                [_postcode_textfield.layer setMasksToBounds:YES];
                [_postcode_textfield setFont:[UIFont fontWithName:@"AppleGothic" size:14.0]];
                [_postcode_textfield setDelegate:self];

            }
            [cell.contentView addSubview:_postcode_textfield];
            break;
            
        }
        
        default:
            break;
    }
    
    if (mAddress!=nil)
    {            
        [_province_textfield setText:[NSString stringWithFormat:@"%@%@%@", ([[mAddress provence] ProvinceName]==nil?@"":[[mAddress provence] ProvinceName]),([[mAddress city] CityName]==nil?@"":[[mAddress city] CityName]),([[mAddress area] AreaName]==nil?@"":[[mAddress area] AreaName])]];
    }
    
    return cell;
}

#pragma mark - textview delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:NSLocalizedString(@"Input_Consignee_Address", nil)])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; 
    }
    [textView becomeFirstResponder];
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = NSLocalizedString(@"Input_Consignee_Address", nil);
        textView.textColor = [UIColor lightGrayColor];
    }
    
     [_address_dict setValue:[_address_textview text] forKey:@"address"];
     [mAddress setAddress:[_address_textview text]];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:_province_textfield])
    {
        [self hideKeyboard];
        
        if (_modalPanel!=nil) {
            [_modalPanel removeFromSuperview];
            _modalPanel =nil;   
        }
        _modalPanel = [[RegionSelectionController alloc] initWithFrame:self.view.bounds title:NSLocalizedString(@"Please_Selet", @"Please_Selet") dict:_address_dict] ;
        _modalPanel.delegate = self;
       // _modalPanel.shop_dict = [NSMutableDictionary dictionaryWithDictionary:_address_dict];
        
        [self.view addSubview:_modalPanel];
        [_modalPanel showFromPoint:CGPointMake(textField.center.x, textField.center.y)];
        
        return NO;
    }
   
    
	
	///////////////////////////////////
	// Show the panel from the center of the button that was pressed
	return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_consignee_textfield]) {
         [_address_dict setValue:[_consignee_textfield text] forKey:@"consignee"];
        [mAddress setConsignee:[_consignee_textfield text]];
    }
    
    if ([textField isEqual:_mobile_textfield]) {
        [_address_dict setValue:[_mobile_textfield text] forKey:@"mobile"];
        [mAddress setMobile:[_mobile_textfield text]];
    }
    
    if ([textField isEqual:_postcode_textfield]) {
        [_address_dict setValue:[_postcode_textfield text] forKey:@"postcode"];
        [mAddress setPostcode:[_postcode_textfield text]];
    }

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
}

#pragma mark - UAModalDisplayPanelViewDelegate

// Optional: This is called before the open animations.
//   Only used if delegate is set.
- (void)willShowModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"willShowModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called after the open animations.
//   Only used if delegate is set.
- (void)didShowModalPanel:(RegionSelectionController *)modalPanel {
	UADebugLog(@"didShowModalPanel called with modalPanel: %@", modalPanel);
  //  UITableView *t = [modalPanel table];
    //[t selectRowAtIndexPath:[modalPanel currentIndexPath] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
}

// Optional: This is called when the close button is pressed
//   You can use it to perform validations
//   Return YES to close the panel, otherwise NO
//   Only used if delegate is set.
- (BOOL)shouldCloseModalPanel:(RegionSelectionController *)modalPanel {
	UADebugLog(@"shouldCloseModalPanel called with modalPanel: %@", modalPanel);
    
   
	return YES;
}

// Optional: This is called when the action button is pressed
//   Action button is only visible when its title is non-nil;
//   Only used if delegate is set and not using blocks.
- (void)didSelectActionButton:(UAModalPanel *)modalPanel {
	UADebugLog(@"didSelectActionButton called with modalPanel: %@", modalPanel);
}

// Optional: This is called before the close animations.
//   Only used if delegate is set.
- (void)willCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"willCloseModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called after the close animations.
//   Only used if delegate is set.
- (void)didCloseModalPanel:(RegionSelectionController *)modalPanel {
	UADebugLog(@"didCloseModalPanel called with modalPanel: %@", modalPanel);
    
    if ([[modalPanel newaddress_dict] count]>0) {
       
        _address_dict =[NSMutableDictionary dictionaryWithDictionary:[modalPanel newaddress_dict]];
        
        ProvinceBean *p = [[ProvinceBean alloc] init];
        [p setProvinceID:[[[[modalPanel newaddress_dict] objectForKey:@"province"] allKeys] objectAtIndex:0]];
        [p setProvinceName:[[[[modalPanel newaddress_dict] objectForKey:@"province"] allValues] objectAtIndex:0]];
        
        [mAddress setProvence:p];
        
        CityBean *c =[[CityBean alloc] init];
        [c setCityID:[[[[modalPanel newaddress_dict] objectForKey:@"city"] allKeys] objectAtIndex:0]];
        [c setCityName:[[[[modalPanel newaddress_dict] objectForKey:@"city"] allValues] objectAtIndex:0]];
        [c setProvinceId:[p ProvinceID]];
        
        [mAddress setCity:c];
        
        AreaBean *a = [[AreaBean alloc] init];
        [a setAreaID:[[[[modalPanel newaddress_dict] objectForKey:@"area"] allKeys] objectAtIndex:0]];
        [a setAreaName:[[[[modalPanel newaddress_dict] objectForKey:@"area"] allValues] objectAtIndex:0]];
        [a setCityID:[c CityID]];
        
        [mAddress setArea:a];
        
        [self.mTableView reloadData];
        
    }
    
     
}


#pragma mark -
- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    NSString* sNotice = nil;

    if (aRequest
        && !(aRequest.error))
    {
        if (aRequest.tag == REQUEST_MODIFY_ADDRESS)
        {
            
            NSString *responseString  =[aRequest responseString] ;
            
            if ([[[responseString JSONValue] objectForKey:@"status"] isEqual:@"success"])
            {
                if ([self.mDelegate respondsToSelector:@selector(changedWithModifiedAddress:)])
                {
                    [self.mDelegate changedWithModifiedAddress:mAddress];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                sNotice = NSLocalizedString(@"Address Modificatin succeds", nil);
            }
            else
            {
                sNotice = NSLocalizedString(@"Address Modificatin fails", nil);
                NSLog(@"address modification failure");
            }
        }
        else if (aRequest.tag == REQUEST_CREATE_ADDRESS)
        {
            NSString *responseString  =[aRequest responseString] ;
            
            if ([[[responseString JSONValue] objectForKey:@"status"] isEqual:@"success"])
            {
                NSString* sAddressID = [[responseString JSONValue] objectForKey:@"aid"];
                if ([self.mDelegate respondsToSelector:@selector(changeWithNewAddress:)])
                {
                    mAddress.addressId = sAddressID;
                    [self.mDelegate changeWithNewAddress:mAddress];
                }
                [self.navigationController popViewControllerAnimated:YES];
                sNotice = NSLocalizedString(@"Address Creation succeds", nil);
            }
            else
            {
                sNotice = NSLocalizedString(@"Address Creation fails", nil);
                NSLog(@"address creation failure");
            }
        }
        else
        {
            //
        }
    }
    [self hideHudWithNotice:sNotice afterDelay:5];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString* sNotice = nil;
    
    if (request.tag == REQUEST_MODIFY_ADDRESS)
    {
        sNotice = NSLocalizedString(@"Address Modificatin fails", nil);
    }
    else if (request.tag == REQUEST_CREATE_ADDRESS)
    {
        sNotice = NSLocalizedString(@"Address Creation fails", nil);
    }
    else
    {
        //
    }
    [self hideHudWithNotice:sNotice afterDelay:5];
}



@end
