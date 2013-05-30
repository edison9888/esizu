//
//  Keychainer.m
//  uzise
//
//  Created by Wen Shane on 13-5-2.
//  Copyright (c) 2013年 COSDocument.org. All rights reserved.
//

#import "Keychainer.h"
#import <Foundation/Foundation.h>


@implementation Keychainer
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)CFBridgingRelease(kSecClassGenericPassword),(id)CFBridgingRelease(kSecClass),
            service, (id)CFBridgingRelease(kSecAttrService),
            service, (id)CFBridgingRelease(kSecAttrAccount),
            (id)CFBridgingRelease(kSecAttrAccessibleAfterFirstUnlock),(id)CFBridgingRelease(kSecAttrAccessible),
            nil];
}

+ (void)save:(NSString *)service data:(id)data
{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)CFBridgingRetain(keychainQuery));
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)CFBridgingRelease(kSecValueData)];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)CFBridgingRetain(keychainQuery), NULL);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)CFBridgingRelease(kSecReturnData)];
    [keychainQuery setObject:(id)CFBridgingRelease(kSecMatchLimitOne) forKey:(id)CFBridgingRelease(kSecMatchLimit)];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)CFBridgingRetain(keychainQuery), (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)(keyData)];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)CFBridgingRetain(keychainQuery));
}  

//
//
//+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
//{
//    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
//            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
//            service, (__bridge_transfer id)kSecAttrService,
//            service, (__bridge_transfer id)kSecAttrAccount,
//            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
//            nil];
//}
//
//+ (void)save:(NSString *)service data:(id)data
//{
//    //Get search dictionary
//    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
//    //Delete old item before add new item
//    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
//    //Add new object to search dictionary(Attention:the data format)
//    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
//    //Add item to keychain with the search dictionary
//    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
//}
//
//+ (id)load:(NSString *)service
//{
//    id ret = nil;
//    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
//    //Configure the search setting
//    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
//    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
//    CFDataRef keyData = NULL;
//    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
//        @try {
//            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
//        } @catch (NSException *e) {
//            NSLog(@"Unarchive of %@ failed: %@", service, e);
//        } @finally {
//        }
//    }
//    return ret;
//}
//
//+ (void)delete:(NSString *)service
//{
//    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
//    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
//}


@end
