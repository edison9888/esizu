//
//  RegisterController.m
//  uzise
//
//  Created by Wen Shane on 13-4-29.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import "RegisterController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "UIViewController+URLData.h"
#import "RegexKitLite.h"
#import "NSObject+SBJson.h"
#import "UserManager.h"
#import "Global.h"
#import "MobClick.h"
#import "UIButtonLarge.h"


@interface RegisterController ()


@property(nonatomic,copy) NSString *login_name;

@property(nonatomic,copy) NSString *login_password;

@property(nonatomic,copy) NSString *login_user_name;

@property(nonatomic,copy) NSString *login_repassword;


@property(nonatomic,strong) UITableView *mTableView;
@property(nonatomic, strong) NSMutableArray* emailTitle;

@property(nonatomic,strong) UITextField *login_user_name_email_textfield;

@property(nonatomic,strong) UITextField *login_name_email_textfield;

@property(nonatomic,strong) UITextField *login_password_email_textfield;

@property(nonatomic,strong) UITextField *login_repassword_email_textfield;
@property(nonatomic,strong) UIButtonLarge *email_showpassword_button;
@property(nonatomic,strong)NSMutableDictionary *tableview_in_password_dict;

@property(nonatomic,copy)NSString  *alertName;

@end

@implementation RegisterController

@synthesize mTableView;
@synthesize emailTitle;
@synthesize login_user_name_email_textfield;
@synthesize login_name_email_textfield;
@synthesize login_password_email_textfield;
@synthesize login_repassword_email_textfield;
@synthesize email_showpassword_button;
@synthesize tableview_in_password_dict;
@synthesize alertName;
@synthesize login_name;
@synthesize login_password;
@synthesize login_repassword;
@synthesize login_user_name;

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
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelRegister)];
    [self.navigationItem setLeftBarButtonItem:leftBarItem];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Confirm", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(userRegister)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    
    self.mTableView =[[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,  self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStyleGrouped];
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    [mTableView setBackgroundColor:[UIColor clearColor]];
    [mTableView setBackgroundView:nil];
    mTableView.rowHeight = 41;
    [mTableView setTag:1];
    [self.view addSubview:mTableView];

    emailTitle =[NSMutableArray arrayWithObjects:NSLocalizedString(@"Mail/Mobile", nil),NSLocalizedString(@"Input_UserName", "Input_UserName"),NSLocalizedString(@"Input_Password", "Input_Password"),NSLocalizedString(@"Input_Confirm_Password", "Input_Confirm_Password"),NSLocalizedString(@"Show_Password", "Show_Password") ,nil];

    [tableview_in_password_dict setValue:nil forKey:@"emailTableView"];

    [self.view setBackgroundColor:BG_COLOR];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)userRegister
{
    [self hideKeyboard];
    [self showHud];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        login_name =[login_name_email_textfield text];
        
        login_password =[login_password_email_textfield text];
        
        login_repassword =[login_repassword_email_textfield text];
        
        login_user_name =[login_user_name_email_textfield text];
        
        
        NSDictionary* sReturnedDict = nil;
        E_REGISTER_RESULT_TYPE sResultType = [[UserManager shared] registerWithAccount:login_name userName:login_user_name password:login_password repassword:login_repassword returnInfo:&sReturnedDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            
            switch (sResultType)
            {
                case E_REGISTER_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE:
                    [self showAlert:NSLocalizedString(@"Please input your EMail or Mobile no.", nil)  cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                    
                    break;
                case E_REGISTER_RESULT_TYPE_FAILURE_ACCOUNT_INVALID:
                    [self showAlert:NSLocalizedString(@"Your Email or Mobile No. is invalid", nil)  cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                    
                    break;
                case E_REGISTER_RESULT_TYPE_FAILURE_USERNAME_INCOMPLETE:
                    [self showAlert:NSLocalizedString(@"Please input your user name", nil)  cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                    
                    break;
                case E_REGISTER_RESULT_TYPE_FAILURE_PASSWORD_INCOMPLETE:
                    [self showAlert:NSLocalizedString(@"Please input your password", nil)  cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                    
                    break;
                case E_REGISTER_RESULT_TYPE_FAILURE_REPASSWORD_MISSING:
                    [self showAlert:NSLocalizedString(@"Please confirm your password", nil)  cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                    
                    break;
                case E_REGISTER_RESULT_TYPE_FAILURE_PASSWORD_MISMATCH:
                    [self showAlert:NSLocalizedString(@"Passwords input twice differ", nil)  cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                    
                    break;
                case E_REGISTER_RESULT_TYPE_FAILURE_NETWORK_ERR:
                    [self showAlert:NSLocalizedString(@"Network error", nil)  cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                    break;
                case E_REGISTER_RESULT_TYPE_FAILURE_SERVER_VALIDATION:
                {
                    NSString* sFailureNotice = NSLocalizedString(@"Registeration fails, please adjust your info and retry", nil);
                    if (sReturnedDict)
                    {
                        NSString* sAccountNotice = [sReturnedDict objectForKey:@"account"];
                        NSString* sPasswordNotice = [sReturnedDict objectForKey:@"password"];
                        NSString* sRePasswordNotice = [sReturnedDict objectForKey:@"repassword"];
                        
                        if (sAccountNotice.length > 0)
                        {
                            sFailureNotice = sAccountNotice;
                        }
                        else if (sPasswordNotice.length > 0)
                        {
                            sFailureNotice = sPasswordNotice;
                        }
                        else if (sRePasswordNotice.length > 0)
                        {
                            sFailureNotice = sRePasswordNotice;
                        }
                    }
                    
                    UIAlertView   *alert = [[UIAlertView alloc] initWithTitle:nil message: sFailureNotice delegate:self cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitles: nil];
                    [alert setDelegate:self];
                    alertName =@"createUserFail";
                    [alert show];
                    alert =nil;
                }
                    break;
                case E_REGISTER_RESULT_TYPE_SUCCESS:
                {
                    UIAlertView   *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Success_Register", @"Success_Register") delegate:self cancelButtonTitle:NSLocalizedString(@"Login_Later", @"Login_Later") otherButtonTitles:NSLocalizedString(@"Login_Mall", @"Login_Mall"), nil];
                    [alert setDelegate:self];
                    [alert show];
                    alertName =@"createUser";
                    
                }
                    break;
                default:
                    break;
            }
            

        });
        
        //log the result status of registeration.
        NSString* sResultTypeName = nil;
        switch (sResultType) {
            case E_REGISTER_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE:
                sResultTypeName = @"Account Incomplete";
                break;
            case E_REGISTER_RESULT_TYPE_FAILURE_ACCOUNT_INVALID:
                sResultTypeName = @"Account Invalid";
                break;
            case E_REGISTER_RESULT_TYPE_FAILURE_USERNAME_INCOMPLETE:
                sResultTypeName = @"Username Incomplete";
                break;
            case E_REGISTER_RESULT_TYPE_FAILURE_PASSWORD_INCOMPLETE:
                sResultTypeName = @"Password Incomplete";
                break;
            case E_REGISTER_RESULT_TYPE_FAILURE_REPASSWORD_MISSING:
                sResultTypeName = @"Repassword Missing";
                break;
            case E_REGISTER_RESULT_TYPE_FAILURE_PASSWORD_MISMATCH:
                sResultTypeName = @"Password Mismatch";
                break;
            case E_REGISTER_RESULT_TYPE_FAILURE_NETWORK_ERR:
                sResultTypeName = @"Network Error";
                break;
            case E_REGISTER_RESULT_TYPE_FAILURE_SERVER_VALIDATION:
                sResultTypeName = @"Server Deny";
                break;
            case E_REGISTER_RESULT_TYPE_SUCCESS:
                sResultTypeName = @"Success";
                break;
            default:
                sResultTypeName = @"Other errors";
                break;
        }
        NSDictionary* sDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               sResultTypeName, @"result", nil];
        [MobClick event:@"UEID_REGISTER" attributes: sDict];

        
    });    
}

-(void)cancelRegister
{
    [self hideKeyboard];

    //获取当前代理的window    
    [self.tabBarController setSelectedIndex:0];
    
    [self dismissModalViewControllerAnimated:YES];
    
    //先移除自己
    [self removeFromParentViewController];
    //再移除父亲
    [self.parentViewController removeFromParentViewController];
}

-(void)loginAfterRegisteration
{
    [self showHud];
    
    E_LOGIN_RESULT_TYPE sLoginResultType = [[UserManager shared] loginWithName:login_name andPassword: login_password];
    
    [self hideHud];
    
    switch (sLoginResultType) {
        case E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_BOTH:
        case E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_NAME:
        case E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_PASSWORD:
        case E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_MISMATCH:
        {
            [self showAlert:NSLocalizedString(@"Login failure", nil) cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
        }
            break;
        case E_LOGIN_RESULT_TYPE_FAILURE_NETWORK_ERR:
        {
            [self showAlert:NSLocalizedString(@"Network error", nil) cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
        }
            break;
        case E_LOGIN_RESULT_TYPE_SUCCESS:
        {
            [self dismissModalViewControllerAnimated:YES];
            
            //可选
            [self.navigationController popViewControllerAnimated:YES];
            //先移除自己
            [self removeFromParentViewController];
            //再移除父亲
            [self.parentViewController removeFromParentViewController];
        }
            
        default:
            break;
    }
    
}

- (void) hideKeyboard
{
    [login_name_email_textfield resignFirstResponder];
    [login_password_email_textfield resignFirstResponder];
    [login_repassword_email_textfield resignFirstResponder];
    [login_user_name_email_textfield resignFirstResponder];
}

-(void)showInputPassword:(UIButton *)sender
{
    BOOL sToBeSelected = !sender.selected;
    [sender setSelected:sToBeSelected];
    
    BOOL wasFirstResponder = [login_password_email_textfield isFirstResponder];
    if (wasFirstResponder) {
        [login_password_email_textfield resignFirstResponder];
    }
    [login_password_email_textfield setSecureTextEntry:!sToBeSelected];
    if (wasFirstResponder)
    {
        [login_password_email_textfield becomeFirstResponder];
    }
        
    wasFirstResponder = [login_repassword_email_textfield isFirstResponder];
    if (wasFirstResponder)
    {
        [login_repassword_email_textfield resignFirstResponder];
    }
    [login_repassword_email_textfield setSecureTextEntry:!sToBeSelected];
    if (wasFirstResponder)
    {
        [login_repassword_email_textfield becomeFirstResponder];
    }    
}


#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *RegisterEmailCellIdentifier = @"RegisterEmailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegisterEmailCellIdentifier];
    
    if (cell==nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RegisterEmailCellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    /* */   for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSDictionary   *tablieViewDict = [tableview_in_password_dict objectForKey:@"emailTableView"];
    switch (indexPath.row) {
        case 0:{
            login_name_email_textfield =[[UITextField alloc] initWithFrame: CGRectMake(5, 10, 280.0, 31.0)];
            [login_name_email_textfield setKeyboardType:UIKeyboardTypeEmailAddress];
            [login_name_email_textfield setEnablesReturnKeyAutomatically:NO];
            [login_name_email_textfield setDelegate:self];
            [login_name_email_textfield setTag:indexPath.row];
            [login_name_email_textfield setPlaceholder:[emailTitle objectAtIndex:indexPath.row]];
            [login_name_email_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
            
            if ([tablieViewDict objectForKey:@"loginname"]!=nil||[tablieViewDict objectForKey:@"loginname"]!=[NSNull null]) {
                [login_name_email_textfield setText:[tablieViewDict objectForKey:@"loginname"]];
            }
            [cell.contentView addSubview:login_name_email_textfield];
            break;
        }
        case 1:{
            login_user_name_email_textfield =[[UITextField alloc] initWithFrame: CGRectMake(5, 10, 280.0, 31.0)];
            [login_user_name_email_textfield setKeyboardType:UIKeyboardTypeDefault];
            [login_user_name_email_textfield setEnablesReturnKeyAutomatically:NO];
            [login_user_name_email_textfield setDelegate:self];
            [login_user_name_email_textfield setTag:indexPath.row];
            [login_user_name_email_textfield setPlaceholder:[emailTitle objectAtIndex:indexPath.row]];
            [login_user_name_email_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
            
            if ([tablieViewDict objectForKey:@"username"]!=nil||[tablieViewDict objectForKey:@"username"]!=[NSNull null]) {
                [login_user_name_email_textfield setText:[tablieViewDict objectForKey:@"username"]];
            }
            
            [cell.contentView addSubview:login_user_name_email_textfield];
            break;
        }
        case 2:{
            login_password_email_textfield =[[UITextField alloc] initWithFrame: CGRectMake(5, 10, 280.0, 31.0)];
            [login_password_email_textfield setKeyboardType:UIKeyboardTypeEmailAddress];
            [login_password_email_textfield setEnablesReturnKeyAutomatically:NO];
            [login_password_email_textfield setDelegate:self];
            [login_password_email_textfield setTag:indexPath.row];
            [login_password_email_textfield setSecureTextEntry:YES];
            [login_password_email_textfield setPlaceholder:[emailTitle objectAtIndex:indexPath.row]];
            [login_password_email_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
            
            
            if ([tablieViewDict objectForKey:@"password"]!=nil||[tablieViewDict objectForKey:@"password"]!=[NSNull null]) {
                [login_password_email_textfield setText:[tablieViewDict objectForKey:@"password"]];
            }
            [cell.contentView addSubview:login_password_email_textfield];
            break;
        }
        case 3:{
            login_repassword_email_textfield =[[UITextField alloc] initWithFrame: CGRectMake(5, 10, 280.0, 31.0)];
            [login_repassword_email_textfield setKeyboardType:UIKeyboardTypeEmailAddress];
            [login_repassword_email_textfield setEnablesReturnKeyAutomatically:NO];
            [login_repassword_email_textfield setDelegate:self];
            [login_repassword_email_textfield setTag:indexPath.row];
            [login_repassword_email_textfield setSecureTextEntry:YES];
            [login_repassword_email_textfield setPlaceholder:[emailTitle objectAtIndex:indexPath.row]];
            [login_repassword_email_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
            
            
            
            if ([tablieViewDict objectForKey:@"confirm"]==nil||[[tablieViewDict objectForKey:@"confirm"] length]==0 ||[[tablieViewDict objectForKey:@"confirm"] isEqual:[NSNull null]]) {
                
                [login_repassword_email_textfield setPlaceholder:NSLocalizedString(@"Input_Confirm_Password", "Input_Confirm_Password")];
            }else{
                
                [login_repassword_email_textfield setText:[tablieViewDict objectForKey:@"confirm"]];
            }
            
            
            [cell.contentView addSubview:login_repassword_email_textfield];
            break;
        }
        case 4:{
            UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(35, 3, 100.0, 31)];
            label.text=[emailTitle objectAtIndex:indexPath.row];
            [label setBackgroundColor:[UIColor clearColor]];
            email_showpassword_button =[UIButtonLarge buttonWithType:UIButtonTypeCustom];
            email_showpassword_button.tintColor = [UIColor blueColor];
            [email_showpassword_button setFrame:CGRectMake(10,10,16,16)];
            [email_showpassword_button setMMarginInsets:UIEdgeInsetsMake(10, 10, 10, 150)];
            [email_showpassword_button setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
            [email_showpassword_button setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateSelected];
            [email_showpassword_button setImage:[UIImage imageNamed:@"checkbox-pressed.png"] forState:UIControlStateHighlighted];
            
            [email_showpassword_button addTarget:self action:@selector(showInputPassword:) forControlEvents:UIControlEventTouchDown];
            [email_showpassword_button setTag:0];
            [cell.contentView addSubview:email_showpassword_button];
            [cell.contentView addSubview:label];
            
            break;
        }
        default:
            break;
    }
    tablieViewDict =nil;
    return cell;
}

#pragma mark textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==login_name_email_textfield)
    {
        [login_user_name_email_textfield becomeFirstResponder];
    }
    else if (textField==login_user_name_email_textfield)
    {
        [login_password_email_textfield becomeFirstResponder];
    }
    else if (textField == login_password_email_textfield)
    {
        [login_repassword_email_textfield becomeFirstResponder];
    }
    else if (textField == login_repassword_email_textfield)
    {
        [self userRegister];
    }
    else
    {
        //
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return  YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSDictionary *email_dict =  [tableview_in_password_dict objectForKey:@"emailTableView"];
    NSMutableDictionary *email_mutable_dict =[NSMutableDictionary dictionaryWithDictionary:email_dict];
    
    
    if ([textField isEqual:login_name_email_textfield]) {
        [email_mutable_dict setValue:[textField text] forKey:@"loginname"];
    }
    if ([textField isEqual:login_password_email_textfield]) {
        [email_mutable_dict setValue:[textField text] forKey:@"password"];
    }
    if ([textField isEqual:login_repassword_email_textfield]) {
        [email_mutable_dict setValue:[textField text] forKey:@"confirm"];
    }
    if ([textField isEqual:login_user_name_email_textfield]) {
        [email_mutable_dict setValue:[textField text] forKey:@"username"];
    }
    
    [tableview_in_password_dict setValue:email_mutable_dict forKey:@"emailTableView"];
    
    email_dict =nil;
    email_mutable_dict =nil;
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *) [[textField superview] superview];
    
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:cell];
    
    [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark - alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertName isEqualToString:@"createUser" ]) {
        
        if (buttonIndex==0) {
            [self cancelRegister];
        }
        if (buttonIndex==1) {
            //userId
            [self loginAfterRegisteration];
        }
        
    }
}

@end
