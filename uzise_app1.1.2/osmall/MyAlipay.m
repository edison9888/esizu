//
//  MyAlipay.m
//  uzise
//
//  Created by Wen Shane on 13-5-29.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import "MyAlipay.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"

#import "Global.h"

#define TAG_ALERTVIEW_OPEN_APPSTORE_FOR_ALIPAY  101

@implementation MyAlipay


+ (MyAlipay*) shared
{
    static MyAlipay* S_MyAliPay = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        S_MyAliPay = [[self alloc] init];
    });
    
    return S_MyAliPay;
}

- (void) startPayWithOrderNo:(NSString*)aOrderNo productName:(NSString*)aProductName productDesp:(NSString*)aProductDesp amount:(double)aAmount
{
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
    
	//partner和seller获取失败,提示
	if ([partner length] == 0 || [seller length] == 0)
	{
		UIAlertView* sAlertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"缺少partner或者seller。"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
		[sAlertView show];
		return;
	}
	
	/*
	 *生成订单信息及签名
	 *由于demo的局限性，本demo中的公私钥存放在AlixPayDemo-Info.plist中,外部商户可以存放在服务端或本地其他地方。
	 */
	//将商品信息赋予AlixPayOrder的成员变量
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = partner;
	order.seller = seller;
	order.tradeNO = aOrderNo; //订单ID（由商家自行制定）
	order.productName = aProductName; //商品标题
	order.productDescription = aProductDesp; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",aAmount]; //商品价格
	order.notifyURL =  URL_ALIPAY_NOTIFY_URL; //回调URL
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
	NSString *appScheme = @"uzise";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            alertView.tag = TAG_ALERTVIEW_OPEN_APPSTORE_FOR_ALIPAY;
            [alertView show];
        }
        else if (ret == kSPErrorSignError)
        {
            NSLog(@"签名错误！");
        }
	}

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TAG_ALERTVIEW_OPEN_APPSTORE_FOR_ALIPAY)
    {
        NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}

@end
