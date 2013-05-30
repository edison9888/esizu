//
//  UserManager.h
//  uzise
//
//  Created by Wen Shane on 13-4-28.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserBean.h"
#import "ProductBean.h"

typedef enum _E_LOGIN_RESULT_TYPE
{
    E_LOGIN_RESULT_TYPE_SUCCESS,
    E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_BOTH,
    E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_NAME,
    E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE_PASSWORD,
    E_LOGIN_RESULT_TYPE_FAILURE_ACCOUNT_MISMATCH,
    E_LOGIN_RESULT_TYPE_FAILURE_NETWORK_ERR,
}E_LOGIN_RESULT_TYPE;

typedef enum _E_REGISTER_RESULT_TYPE
{
    E_REGISTER_RESULT_TYPE_SUCCESS,
    E_REGISTER_RESULT_TYPE_FAILURE_ACCOUNT_INCOMPLETE,
    E_REGISTER_RESULT_TYPE_FAILURE_ACCOUNT_INVALID,
    E_REGISTER_RESULT_TYPE_FAILURE_USERNAME_INCOMPLETE,
    E_REGISTER_RESULT_TYPE_FAILURE_PASSWORD_INCOMPLETE,
    E_REGISTER_RESULT_TYPE_FAILURE_REPASSWORD_MISSING,
    E_REGISTER_RESULT_TYPE_FAILURE_PASSWORD_MISMATCH,
    E_REGISTER_RESULT_TYPE_FAILURE_NETWORK_ERR,
    E_REGISTER_RESULT_TYPE_FAILURE_SERVER_VALIDATION,
}E_REGISTER_RESULT_TYPE;



@interface UserManager : NSObject

+ (UserManager*) shared;


//register synchronously
- (E_REGISTER_RESULT_TYPE)registerWithAccount:(NSString*)aMailMobileStr userName:(NSString*)aName password:(NSString*)aPassword repassword:(NSString*)aRepassword returnInfo:(NSDictionary**)aReturnedInfo;

//log in synchronously
- (E_LOGIN_RESULT_TYPE) loginWithName:(NSString*)aName andPassword:(NSString*)aPassword;

//log out
- (BOOL) logout;

- (BOOL) isInsession;
- (void) startNewSession;

//return nil if there is no valid session.
- (UserBean*) getSessionUserBean;
- (NSArray*) getSessionHotProduts;
- (NSString*) getSessionAppKey;

- (NSString*) getLastLoginUserName;
- (NSString*) getLastPassword;

- (NSString*) getLastAddressID;
- (void) setLastAddressID:(NSString*)aAddressID;

- (NSString*) getLastPaymodeID;
- (void) setLastPaymodeID:(NSString*)aPaymodeID;


@end
