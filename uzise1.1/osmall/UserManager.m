//
//  UserManager.m
//  uzise
//
//  Created by Wen Shane on 13-4-28.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import "UserManager.h"
#import "ASIHttpWrapper.h"
#import "NSObject+SBJson.h"
#import "NSString+MD5.h"
#import "Constant.h"
#import "Keychainer.h"



#define DEFAULTS_LAST_ADDRESS_ID        @"LAST_ADDRESS_ID"


@implementation UserManager



+ (UserManager*) shared
{
    static UserManager* S_UserManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        S_UserManager = [[self alloc] init];
    });
    
    return S_UserManager;
}


- (E_REGISTER_RESULT_TYPE)registerWithAccount:(NSString*)aMailMobileStr userName:(NSString*)aName password:(NSString*)aPassword repassword:(NSString*)aRepassword returnInfo:(NSDictionary**)aReturnedInfo
{
    if ([aMailMobileStr length]==0)
    {
        return E_REGISTER_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE;
    }
    
    if (![aMailMobileStr isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"]&&![self isMobileNumber:aMailMobileStr])
    {
        return E_REGISTER_RESULT_TYPE_FAILURE_ACCOUNT_INVALID;
    }
    
    if ([aName length]==0)
    {
        return E_REGISTER_RESULT_TYPE_FAILURE_USERNAME_INCOMPLETE;
    }
    
    if (aPassword.length == 0)
    {
        return E_REGISTER_RESULT_TYPE_FAILURE_PASSWORD_INCOMPLETE;
    }
    else if ([aRepassword length]==0)
    {
        return E_REGISTER_RESULT_TYPE_FAILURE_REPASSWORD_MISSING;
    }
    else if (![aRepassword isEqualToString:aPassword])
    {
        return E_REGISTER_RESULT_TYPE_FAILURE_PASSWORD_MISMATCH;
    }
    else
    {
        //
    }
    
    //
    ASIHTTPRequest *user_register_request =[ASIHttpWrapper synLoadByURLStr:[NSString stringWithFormat:@"http://uzise.com/api/user/register.json?account=%@&userName=%@&password=%@&repassword=%@",aMailMobileStr, [aName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding  ],aPassword, aRepassword] withCachePolicy:E_CACHE_POLICY_NO_CACHE];
        
    if (!user_register_request
        || user_register_request.error)
    {
        return E_REGISTER_RESULT_TYPE_FAILURE_NETWORK_ERR;
    }
    else
    {
        if (![[[user_register_request responseString] JSONValue] objectForKey:@"success"])
        {
            *aReturnedInfo = [[user_register_request responseString] JSONValue];
            return E_REGISTER_RESULT_TYPE_FAILURE_SERVER_VALIDATION;
        }
        else
        {
            return E_REGISTER_RESULT_TYPE_SUCCESS;
        }
    }

}

//login synchronously
- (E_LOGIN_RESULT_TYPE) loginWithName:(NSString*)aName andPassword:(NSString*)aPassword
{
    if (!aName || aName.length <= 0
        || !aPassword || aPassword.length <= 0)
    {
        if ((!aName || aName.length <= 0)
            && (!aPassword || aPassword.length <= 0))
        {
            return E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_BOTH;
        }
        else if (!aName || aName.length <= 0)
        {
            return E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_NAME;
        }
        else if (!aPassword || aPassword.length <= 0)
        {
            return E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_PASSWORD;
        }
        else
        {
            //
        }
    }
    
    ASIHTTPRequest *request = [ASIHttpWrapper synLoadByURLStr:[NSString stringWithFormat:@"http://uzise.com/api/user/login.json?login_name=%@&login_pwd=%@",aName, aPassword] withCachePolicy:E_CACHE_POLICY_NO_CACHE];
    

    if (!request
        || request.error)
    {
        return E_LOGIN_RESULT_TYPE_FAILURE_NETWORK_ERR;
    }
    else
    {
        if ([[[request responseString] JSONValue] objectForKey:@"error.code"])
        {
            return E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_MISMATCH;
        }
        else
        {
            NSDictionary *user_dict =[[request responseString] JSONValue];
            
            UserBean *sUserbean =[[UserBean alloc] init];
            [sUserbean setEmail:[user_dict objectForKey:@"email"]];
            [sUserbean setUserid:[[user_dict objectForKey:@"id"] integerValue]];
            [sUserbean setMobile:[user_dict objectForKey:@"mobile"] ];
            [sUserbean setLevelName:[user_dict objectForKey:@"levelName"]];
            [sUserbean setPoints:[[user_dict objectForKey:@"points"] integerValue]];
//            [sUserbean setPassword:[aPassword stringToMD5]];
            [sUserbean setPassword:aPassword];
            [sUserbean setUserName:[user_dict objectForKey:@"userName"]];
            [sUserbean setRealName:[user_dict objectForKey:@"realName"]];
            [sUserbean setSex:[[user_dict objectForKey:@"sex"] integerValue]];
            [sUserbean setAppkey:[user_dict objectForKey:@"appkey"]];
            
            NSUserDefaults* sUserDefaults = [NSUserDefaults standardUserDefaults];
            //设置在线状态
            [sUserDefaults setValue:[NSNumber numberWithBool:YES]forKey:User_Online];
            
            [sUserDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:sUserbean]forKey:User_Session];
            
            //设置用户登录状态(是否记住)
            //            [userDefaults setValue: [NSNumber numberWithInt:button.selected] forKey:Remember_LoginUser_Button];
            
            [sUserDefaults setValue: [NSNumber numberWithInt:1] forKey:Remember_LoginUser_Button];
            
            
            //                if (button.selected)
            {
                [sUserDefaults setValue: [NSString stringWithFormat:@"%d",[sUserbean userid]] forKey:History_LoginUser_UserId];
                
                //
                [self setUserName:aName andPassword:aPassword];
            }
            
            //获取用户历史信息
            NSData *history_user_data = [sUserDefaults objectForKey:History_LoginUser_List];
            
            NSMutableArray *history_mutable_list = [NSMutableArray array];
            
            BOOL not_in_history_user_list = YES;
            
            if (history_user_data)
            {
                
                NSArray *history_list =[NSKeyedUnarchiver unarchiveObjectWithData:history_user_data];
                
                for (NSDictionary *user_dict in history_list)
                {
                    NSString *userid_str = [NSString stringWithFormat:@"%d",[sUserbean userid]];
                    
                    if ([[[user_dict allKeys] objectAtIndex:0] isEqual:userid_str] )
                    {
                        NSArray *user_history_array =[NSArray arrayWithObjects:aName, aPassword, nil];
                        
                        NSDictionary *history_user_dict = [NSDictionary dictionaryWithObject:user_history_array forKey:[NSString stringWithFormat:@"%d",[sUserbean userid]]];
                        
                        [history_mutable_list addObject:history_user_dict];
                        not_in_history_user_list =NO;
                    }
                    else
                    {
                        [history_mutable_list addObject:user_dict];
                    }
                    /* */
                }
                
            }
            
            
            if (!history_user_data||not_in_history_user_list)
            {
                
                NSArray *user_history_array =[NSArray arrayWithObjects:aName,aPassword, nil];
                
                NSDictionary *history_user_dict = [NSDictionary dictionaryWithObject:user_history_array forKey:[NSString stringWithFormat:@"%d",[sUserbean userid]]];
                
                [history_mutable_list addObject:history_user_dict];
            }
            
            [sUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:history_mutable_list] forKey:History_LoginUser_List];
            
//            [sUserDefaults setObject:[NSNumber numberWithBool:NO]forKey:App_First_Start];
            
            //hot products
            NSMutableArray *host_product_list =[NSMutableArray array];
            
            NSArray *list  =[user_dict objectForKey:@"hotproductList"];
            // NSLog(@"%@",list);
            for (NSDictionary *p_dict in list)
            {
                ProductBean * p =[[ProductBean alloc] init];
                [p setPrice:[[p_dict objectForKey:@"price"] doubleValue]];
                [p setProductId:[[p_dict objectForKey:@"productId"] integerValue]];
                [p setProductName:[p_dict objectForKey:@"productName"]];
                [p setProductNO:[p_dict objectForKey:@"productNo"]];
                [p setRetallPrice:[[p_dict objectForKey:@"retailPrice"] doubleValue]];
                [p setShopPrice:[[p_dict objectForKey:@"shopPrice"] doubleValue]];
                [p setProduct_url:[NSString stringWithFormat:@"http://www.uzise.com/app_image/iphone/App_Product_Image/%@/120/1.png",[p_dict objectForKey:@"productNo"]]];
                [host_product_list addObject:p];
                
                p=nil;
            }
            [sUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:host_product_list] forKey:User_Hot_Product_List];
            
            
            [sUserDefaults synchronize];
            
        }
    }

    return E_LOGIN_RESULT_TYPE_SUCCESS;
}

- (BOOL) logout
{
    NSUserDefaults* sUserDefaults = [NSUserDefaults standardUserDefaults];

    [sUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:User_Online];
    
//    [sUserDefaults setObject:[NSNumber numberWithBool:YES]forKey:App_First_Start];
    
    
    [sUserDefaults setValue:[NSNumber numberWithBool:NO]forKey:Remember_LoginUser_Button];
    
    [sUserDefaults setValue:nil forKey:User_Session];
    [sUserDefaults setValue:nil forKey:User_Hot_Product_List];
    [self deletePassword];

    
    [sUserDefaults synchronize];
    
    return YES;
}

- (BOOL) isInsession
{
    if ([self getSessionUserBean])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void) startNewSession
{
    //invalidate old session if any.
    NSUserDefaults* sUserDefaults = [NSUserDefaults standardUserDefaults];
    [sUserDefaults setValue:nil forKey:User_Session];
    [sUserDefaults setValue:nil forKey:User_Hot_Product_List];
    
    //
    NSString* sLastLoginUserName = [self getLastLoginUserName];
    NSString* sLastLoginUserPassword = [self getLastPassword];
    if (sLastLoginUserName.length > 0
        && sLastLoginUserPassword.length > 0)
    {
        [self loginWithName:sLastLoginUserName andPassword:sLastLoginUserPassword];
    }
}

//return nil if there is no valid session.
- (UserBean*) getSessionUserBean
{
    NSUserDefaults* sUserDefaults = [NSUserDefaults standardUserDefaults];
    NSData* sUserBeanData =[sUserDefaults objectForKey:User_Session];
    
    UserBean* sUserBean = nil;
    if (sUserBeanData)
    {
        sUserBean =[NSKeyedUnarchiver unarchiveObjectWithData:sUserBeanData];
    }
    return sUserBean;
}

- (NSArray*) getSessionHotProduts
{
    if ([self isInsession])
    {
        NSUserDefaults* sUserDefaults = [NSUserDefaults standardUserDefaults];
        NSData* sUserHotProductsData =[sUserDefaults objectForKey:User_Hot_Product_List];
        
        NSArray* sUserHotProducts = nil;
        if (sUserHotProductsData)
        {
            sUserHotProducts = [NSKeyedUnarchiver unarchiveObjectWithData:sUserHotProductsData];
        }
        
        return sUserHotProducts;
    }
    else
    {
        return nil;
    }
}

- (NSString*) getSessionAppKey
{
    if ([self isInsession])
    {
        UserBean* sUserBean = [self getSessionUserBean];
        return sUserBean.appkey;
    }
    else
    {
        return nil;
    }
}


- (void) setUserName:(NSString*)aName andPassword:(NSString*)aPassword
{
    [Keychainer save:History_LoginUser_LoginName data:aName];
    [Keychainer save:History_LoginUser_LoginPassword data:aPassword];
}

- (void) deletePassword
{
    [Keychainer delete:History_LoginUser_LoginPassword];
}

- (void) deleteNamePassword
{
    [Keychainer delete:History_LoginUser_LoginName];
    [self deletePassword];
}

- (NSString*) getLastLoginUserName
{
    NSString* sName = [Keychainer load:History_LoginUser_LoginName];
    
    if (sName.length > 0)
    {
        return sName;
    }
    else
    {
        return nil;
    }
}

- (NSString*) getLastPassword
{
    NSString* sPassword = [Keychainer load: History_LoginUser_LoginPassword];
    return sPassword;
}

//
- (NSString*) getLastAddressID
{
    NSUserDefaults* sUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* sLastAddressID =[sUserDefaults objectForKey:DEFAULTS_LAST_ADDRESS_ID];
    
    return sLastAddressID;
}

- (void) setLastAddressID:(NSString*)aAddressID
{
    NSUserDefaults* sUserDefaults = [NSUserDefaults standardUserDefaults];
    [sUserDefaults setValue:aAddressID forKey:DEFAULTS_LAST_ADDRESS_ID];
    
    return;
}



// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
