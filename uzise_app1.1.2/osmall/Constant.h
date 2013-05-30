

#ifndef osmall_Constant_h
#define osmall_Constant_h


#define Path_Plist @"/org.lxh.osmall.plist"

//产品数据
#define Product_Data @"prdocutdata"

#define User_Data @"userdata"
//更多
#define More_List @"morelist"

#define News_List @"newlist"

#define New_URL @"http://www.uzise.com/news/show_%d.html"

#define Product_List @"productList"

#define Home_List @"homeAD"

#define Section_0 @"secetion0"

#define Section_1 @"secetion1"

#define Section_2 @"secetion2"

#define Section_3 @"secetion3"

#define Section_4 @"secetion4"

#define Shopping_Cart @"cartProduct"
//是否记住登录
#define Remember_LoginUser_Button @"Remember_LoginUser_Button"
//上次登录用户的id
#define Remember_LoginUser_UserId @"Remember_LoginUser_UserId"
//历史用户信息
#define History_LoginUser_List @"History_LoginUser_List"

#define User_Hot_Product_List @"User_Hot_Product_List"
//历史字典表用户名
#define History_LoginUser_LoginName @"History_User_LoginName"

#define History_LoginUser_LoginPassword @"History_User_LoginPassword"

//历史字典表用户密码
#define History_LoginUser_Password @"History_User_Password"
//历史字典表用户id
#define History_LoginUser_UserId @"History_User_UserId"

#define User_Address @"User_Address"

#define User_Session @"user_Session"

#define User_Online @"User_Online"

//#define App_First_Start @"App_First_Start"

#define Cart_First_Init @"Cart_First_Init"

#define mainScreenWidth [[UIScreen mainScreen] bounds].size.width
#define mainScreenHeight [[UIScreen mainScreen] bounds].size.height

/**sinaweibo**/
#define kAppKey             @"940882232"
#define kAppSecret          @"b3dc6ccdbeba31994d7bd1dfb3d85256"
#define kAppRedirectURI     @"http://www.uzise.com/"

#ifndef kAppKey
#error
#endif

#ifndef kAppSecret
#error
#endif

#ifndef kAppRedirectURI
#error
#endif

#endif
/**sinaweibo**/
#import "AppDelegate.h"

#import "DejalActivityView.h"

#import "FTAnimation.h"

#import "NSString+MD5.h"

#import "IOSFactory.h"

#import "UIViewController+URLData.h"

#import "UIImageView+WebCache.h"

#import "ASIHTTPRequest.h"

#import "ASIFormDataRequest.h"

#import "SBJson.h"

#import "PrettyKit.h"

#import "RegexKitLite.h"


#import <CoreText/CoreText.h>
