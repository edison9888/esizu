//
//  UserAddressEditViewController.h
//  uzise
//
//  Created by edward on 12-10-31.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"
#import "UAModalPanel.h"
#import "SendTypeBean.h"
#import "TPKeyboardAvoidingTableView.h"
#import "BaseViewController.h"
#import "AddressSettingDelegate.h"
//@protocol AddressSettingDelegate <NSObject>
//
//- (void) changedWithModifiedAddress:(UserAddressBean*)aModifiedAddress;
//- (void) changeWithNewAddress:(UserAddressBean*)aNewAddress;
//
//@end

@interface AddressEditorController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate,UITextFieldDelegate,UAModalPanelDelegate, ASIHTTPRequestDelegate>
{
    BOOL mCreate;
}

- (id) initWithAddress:(UserAddressBean*)aAddress create:(BOOL)aIsCreate;

@property(nonatomic,copy)NSString *aid;

@property(nonatomic,copy)NSString *appkey;

@property BOOL mCreate;
@property (weak) id<AddressSettingDelegate> mDelegate;

@end
