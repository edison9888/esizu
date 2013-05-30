//
//  Global.h
//  uzise
//
//  Created by Wen Shane on 13-4-25.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#ifndef uzise_Global_h
#define uzise_Global_h

#define RGB_DIV_255(x)      ((CGFloat)(x/255.0))

#define RGBA_COLOR(r, g, b, a)   ([UIColor colorWithRed:RGB_DIV_255(r) green:RGB_DIV_255(g) blue:RGB_DIV_255(b) alpha:a])


#define MAIN_COLOR          [UIColor colorWithHex:0x297CB7]
//#define BG_COLOR        [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]
//#define BG_COLOR          [UIColor colorWithPatternImage:[UIImage imageNamed:@"bh"]]
#define BG_COLOR            [UIColor colorWithRed:221/255.0 green:232/255.0 blue:238/255.0 alpha:1.0]

//#define BG_COLOR            [UIColor whiteColor]

#define NOTIFICATION_CART_CHANGE    @"notification_cart_change"



//URL
#define HOST_URL_STR                    @"http://www.uzise.com"

#define URL_PRODUCT_DETAIL              ([HOST_URL_STR stringByAppendingString: @"/api/product/detail.json"])
#define URL_HOME_POSTER                 ([HOST_URL_STR stringByAppendingString: @"/admin/iphoneRollPoster.jspx"])
#define URL_HOME_NEWS                   ([HOST_URL_STR stringByAppendingString: @"/mobile/newsList.jspx"])
#define URL_NEWS_PAGE                   ([HOST_URL_STR stringByAppendingString: @"/app_image/iphone/html/news.html"])
#define URL_NEWS_LIST                   ([HOST_URL_STR stringByAppendingString: @"/mobile/newsList.jspx"])
#define URL_PRODUCT_CATEGORY            ([HOST_URL_STR stringByAppendingString: @"/api/product/category_list.json"])
#define URL_PRODUCT_IN_CATEGORY         ([HOST_URL_STR stringByAppendingString: @"/api/product/category.json"])
#define URL_PRODUCT_INFO(pid)           ([HOST_URL_STR stringByAppendingFormat:@"/app_image/iphone/html/details.html?pid=%d", pid])

#define URL_PRODUCT_PARAMETERS(pid)    ([HOST_URL_STR stringByAppendingFormat:@"/app_image/iphone/html/parameter.html?pid=%d", pid])

#define URL_PRODUCT_COMMENTS(pid, pageIndex) [HOST_URL_STR stringByAppendingFormat:@"/api/product/commentList.jspx?pid=%d&indexPage=%d",pid,pageIndex]


#define URL_LAND_ORDER                  ([HOST_URL_STR stringByAppendingString: @"/api/order/create.json"])
#define URL_GET_ADDRESS                 ([HOST_URL_STR stringByAppendingString: @"/api/user/get_address.json"])
#define URL_GET_ADDRESS_LIST            ([HOST_URL_STR stringByAppendingString: @"/api/user/get_address_list.json"])
#define URL_NEW_ADDRESS                 ([HOST_URL_STR stringByAppendingString: @"/api/user/new_address.json"])
#define URL_MODIFY_ADDRESS              ([HOST_URL_STR stringByAppendingString: @"/api/user/set_address.json"])
#define URL_GET_ORDERS                  ([HOST_URL_STR stringByAppendingString: @"/api/order/list.json"])
#define URL_GET_ORDER_DETAIL            ([HOST_URL_STR stringByAppendingString: @"/api/order/detail.json"])
#define URL_CART_SUMMARY                ([HOST_URL_STR stringByAppendingString: @"/api/order/cartView.json"])
#define URL_ALIPAY_NOTIFY_URL           ([HOST_URL_STR stringByAppendingString: @"/xxxxxxx"])

#define URL_NO_ADD_REFERENCE            ([HOST_URL_STR stringByAppendingString: @"/app_image/iphone/html/noadd.html"])
#define URL_CUSTOMER_SERVICE_PHONE      @"tel://400-716-1818"
#define URL_APP_COMMENT                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=571694288"


//
#define KEY_UMENG       @"518a0ac356240b42cc03b34a"


#define TEST

#if defined(WEI_PHONE_RELEASE)
#define CHANNELID      @"Weiphone"
#elif defined(APPSTORE_RELEASE)
#define CHANNELID      @"Appstore"
#elif defined(TONGBU_RELEASE)
#define CHANNELID      @"Tongbu"
#elif defined(_91_RELEASE)
#define CHANNELID       @"91"
#elif defined(DEBUG)||defined(TEST)
#define CHANNELID       @"test"
#else
#define CHANNELID      @"nochannel"
#endif

#endif //uzise_Global_h

