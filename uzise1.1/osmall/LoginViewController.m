

#import "LoginViewController.h"

#import "UserBean.h"

#import "MyViewController.h"

#import "CartViewController.h"

#import "AddressBean.h"

#import "Constant.h"
#import "RegisterController.h"

#import "ProductBean.h"
#import "UserManager.h"
#import "Global.h"


@interface LoginViewController ()


-(void)openAPI:(id)sender;

-(void)login;

-(void)cancel;

-(void)rememberMe;

@end

@implementation LoginViewController
@synthesize isCart;

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
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Login", @"Login") style:UIBarButtonItemStyleBordered target:self action:@selector(login)];
    
    self.navigationItem.rightBarButtonItem=rightBarButton;
    
      UIBarButtonItem *loginCancelButton =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
     [self.navigationItem setLeftBarButtonItem:loginCancelButton];
    
    table_view  =[[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44) style:UITableViewStyleGrouped];
    
    [table_view setBackgroundColor:[UIColor clearColor]];
    [table_view setBackgroundView:nil];
    [table_view setDelegate:self];
    [table_view setDataSource:self];
    
   
   // [table_view addGestureRecognizer:singleTapGestureRecognizer];
    [self setTitle:NSLocalizedString(@"Login", @"Logining")];
    
    [self roundNaviationBar];
    //登录数据初始化
   // dict =[NSMutableDictionary dictionaryWithContentsOfFile:CACHE_DATA_PATH];

    
    [self.view addSubview:table_view];
    
    isCart =NO;
    
    [self.view setBackgroundColor:BG_COLOR];

}

- (void) hideKeyboard
{
    //
    [userTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

-(void)cancel
{
    [self hideKeyboard];
    
    [self dismissModalViewControllerAnimated:YES];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UITabBarController *tabBarController =(UITabBarController *)window.rootViewController;
    
    //跳转回首页
    [tabBarController setSelectedIndex:0];
    [self removeFromParentViewController];
}


-(void)login
{
    [self hideKeyboard];
  
    
    [self showHud];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        E_LOGIN_RESULT_TYPE sLoginResultType = [[UserManager shared] loginWithName:userTextField.text andPassword:passwordTextField.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            
            if (sLoginResultType == E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_BOTH)
            {
                [self showAlert:NSLocalizedString(@"Please input username and password", nil) cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                return;
            }
            else if (sLoginResultType == E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_NAME)
            {
                [self showAlert:NSLocalizedString(@"Please input username", nil) cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                return;
            }
            else if (sLoginResultType == E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_PASSWORD)
            {
                [self showAlert:NSLocalizedString(@"Please input password", nil) cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                return;
            }
            else if (sLoginResultType == E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_MISMATCH)
            {
                [self showAlert:NSLocalizedString(@"User_Password_Error", @"User_Password_Error") cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                return;
            }
            else if (sLoginResultType == E_LOGIN_RESULT_TYPE_FAILURE_NETWORK_ERR)
            {
                [self showAlert:NSLocalizedString(@"Network error", nil) cancelButtonTitle:NSLocalizedString(@"I_Know", @"I_Know") otherButtonTitle:nil];
                return;
            }
            else if (sLoginResultType == E_LOGIN_RESULT_TYPE_SUCCESS)
            {
                /*关闭窗口代码*/
                UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                UITabBarController *tabBarController =(UITabBarController *)window.rootViewController;
                
                if (self.navigationController.view.tag==1000)
                {
                    
                    CartViewController *shoppingCartViewController =[[[[tabBarController viewControllers] objectAtIndex:2] childViewControllers]objectAtIndex:0];
                    [self dismissModalViewControllerAnimated:NO];
                    
                    [shoppingCartViewController showOrderViewContoller];
                }
                else
                {
                    [self dismissModalViewControllerAnimated:YES];
                    [self removeFromParentViewController];
                }
                
            }
            else
            {
                //
            }
            

        });
        
    });
    
  }

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LoginCellIdentifier = @"LoginCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginCellIdentifier];
    if (cell==nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoginCellIdentifier];
        
    }
    
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
//    UITapGestureRecognizer *singleTapGestureRecognizer =nil;
    switch (indexPath.section) {
        case 0:{
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            switch (indexPath.row) {
                case 0:{
                    
                    UILabel* sHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 80, 31)];
                    sHeadLabel.backgroundColor = [UIColor clearColor];
                    sHeadLabel.textAlignment = UITextAlignmentCenter;
                    sHeadLabel.text = NSLocalizedString(@"UserName", "UserName");
                    [cell.contentView addSubview:sHeadLabel];
                    
//                    cell.textLabel.text=NSLocalizedString(@"UserName", "UserName");
                    userTextField =[[UITextField alloc] initWithFrame: CGRectMake(80, 10, 200.0, 31.0)];
                    [userTextField setText:@""];
                    [userTextField setKeyboardType:UIKeyboardTypeEmailAddress];
                    [userTextField setEnablesReturnKeyAutomatically:NO];
                    [userTextField setDelegate:self];
                    [userTextField setPlaceholder:NSLocalizedString(@"UserLoginInputMessage", "UserLoginInputMessage")];
                    [userTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
                    userTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    [cell.contentView addSubview:userTextField];
                    
                    if ([[UserManager shared] getLastLoginUserName].length > 0)
                    {
                        [userTextField setText:[[UserManager shared] getLastLoginUserName]];
                    }
                    break;
                }
                case 1:{
                    
                    UILabel* sHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 80, 31)];
                    sHeadLabel.backgroundColor = [UIColor clearColor];
                    sHeadLabel.textAlignment = UITextAlignmentCenter;
                    sHeadLabel.text = NSLocalizedString(@"Password", "Password");
                    [cell.contentView addSubview:sHeadLabel];
                    
                    passwordTextField =[[UITextField alloc] initWithFrame: CGRectMake(80, 10, 200.0, 31.0)];
                    [passwordTextField setSecureTextEntry:YES];
                    [passwordTextField setReturnKeyType:UIReturnKeyDone];
                    [passwordTextField setDelegate:self];
//                    [passwordTextField setPlaceholder:NSLocalizedString(@"PasswordInputMessage", "PasswordInputMessage")];
//                    cell.textLabel.text=NSLocalizedString(@"Password", "Password");
                    [passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
                    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    [cell.contentView addSubview:passwordTextField];
                    
                    break;
                }
                case 2:{
                    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(cell.center.x-30, 0, 100.0, 44.0)];
                    label.text=NSLocalizedString(@"Remember_Me", "rememberme");
                    [label setBackgroundColor:[UIColor clearColor]];
                    button =[UIButton buttonWithType:UIButtonTypeCustom];
                    [button setFrame:CGRectMake(10, 0, 30,30)];
                    [button setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateSelected];
                    [button setImage:[UIImage imageNamed:@"checkbox-pressed.png"] forState:UIControlEventTouchDown];
                    button.center=CGPointMake(cell.center.x-40, cell.bounds.size.height/2);
                    [button addTarget:self action:@selector(rememberMe) forControlEvents:UIControlEventTouchUpInside];
                   
                   ;
                    
                    [button setSelected:YES];

                    [cell.contentView addSubview:button];
                    [cell.contentView addSubview:label];
                    
                    break;
                }
                default:
                    break;
            }
            break;
            }
        case 1:{
            switch (indexPath.row) {
                case 1:{
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"32x32.png"]];
                    imageView1.frame =CGRectMake(10, 5, 32, 32.0);
                    imageView1.tag=100;
                    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAPI:)];
                    [imageView1 addGestureRecognizer:singleTap];
                    [imageView1 setUserInteractionEnabled:YES];
                    singleTap=nil;
                    
                    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weiboicon32.png"]];
                    imageView2.frame =CGRectMake(52, 5, 32, 32.0);
                    imageView2.tag=200;
                    singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAPI:)];
                    [imageView2 addGestureRecognizer:singleTap];
                    [imageView2 setUserInteractionEnabled:YES];
                    singleTap=nil;
                    
                    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Connect_logo_4.png"]];
                    imageView3.frame =CGRectMake(94, 5, 170, 32.0);
                    imageView3.tag=300;
                    singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAPI:)];
                    [imageView3 addGestureRecognizer:singleTap];
                    [imageView3 setUserInteractionEnabled:YES];
                    
                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.contentView addSubview:imageView1];
                    [cell.contentView addSubview:imageView2];
                    [cell.contentView addSubview:imageView3];
                    imageView1 =nil;
                    imageView2=nil;
                    imageView3=nil;
                    singleTap=nil;
                    
                    break;
                }
                case 0:{
                    UILabel* sHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 200, 31)];
                    sHeadLabel.backgroundColor = [UIColor clearColor];
                    sHeadLabel.textAlignment = UITextAlignmentLeft;
                    sHeadLabel.text = NSLocalizedString(@"Reg", "Reg");
                    [cell.contentView addSubview:sHeadLabel];
                    
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
    
    
    return cell;
}

-(void)rememberMe
{
    //开始未选中
    if (button.selected)
    {
        [button setSelected:NO];
    }else
    {
        [button setSelected:YES];
    }
}

-(void)openAPI:(id)sender{
    NSInteger tag = [sender view].tag;
    NSString *name =@"";
    if (tag==100) {
        name =@"新浪";
    }
    if (tag==200) {
        name =@"腾讯微博";
    }
    if (tag==300) {
        name =@"QQ";
    }
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:name message:@"是否使用外部登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
    [alert show];
    alert =nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==0) {
        
        RegisterController *reg =[[RegisterController alloc] init];
     //   RegViewController *reg =[[RegViewController alloc] initWithStyle:UITableViewStyleGrouped];
      //    RegViewController *reg =[[RegViewController alloc] init];
        reg.title=NSLocalizedString(@"New_User_Register", @"register");
        [self.navigationController pushViewController:reg animated:YES];
    }
    if (indexPath.section==1&&indexPath.row==1) {
   
        //   RegViewController *reg =[[RegViewController alloc] initWithStyle:UITableViewStyleGrouped];
        //    RegViewController *reg =[[RegViewController alloc] init];
      
          }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==userTextField)
    {
        [passwordTextField becomeFirstResponder];
    }
    else if (textField==passwordTextField)
    {
        [self login];
    }
    else
    {
        //
    }
    
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertName isEqualToString:@"notuser"]) {
        if (buttonIndex==0) {
            [self cancel];
        }
        if (buttonIndex==1) {
            [userTextField setText:@""];
            [passwordTextField setText:@""];
            RegisterController *reg =[[RegisterController alloc] init];
            reg.title=NSLocalizedString(@"New_User_Register", @"register");
            [self.navigationController pushViewController:reg animated:YES];
        }
    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if ([alertName isEqualToString:@"notuser"]) {
//        if (buttonIndex==0) {
//            [self cancel];
//        }
//        if (buttonIndex==1) {
//            [userTextField setText:@""];
//            [passwordTextField setText:@""];
//            RegisterViewController *reg =[[RegisterViewController alloc] init];
//            reg.title=NSLocalizedString(@"New_User_Register", @"register");
//            [self.navigationController pushViewController:reg animated:YES];
//        }
//    }
//}

@end
