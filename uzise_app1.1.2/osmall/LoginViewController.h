

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingTableView.h"
#import "BaseViewController.h"

@class UserBean;
@interface LoginViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>{

    Boolean isRemindMe;
    
    UITextField *userTextField;
    
    UITextField *passwordTextField;
    
    UIButton *button;
    
    NSString *alertName;
    
    UserBean *login_user;
    
    UINavigationController *orderNavigationController;
    
    TPKeyboardAvoidingTableView *table_view ;    
}

@property Boolean isCart;

@end
