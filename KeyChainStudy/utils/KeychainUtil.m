//
//  KeychainUtil.m
//  KeyChainStudy
//
//  Created by Dio Brand on 2022/7/29.
//

#import "KeychainUtil.h"

@implementation KeychainUtil

+(void)insert:(NSMutableDictionary *)dict {
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    
    //标签account
    if ([dict objectForKey:@"acct"] && ![[dict objectForKey:@"acct"] isEqual:@""]) {
        [queryDic setObject:[dict objectForKey:@"acct"] forKey:(__bridge id)kSecAttrAccount];
    }
    //标签service
    if ([dict objectForKey:@"svce"] && ![[dict objectForKey:@"svce"] isEqual:@""]) {
        [queryDic setObject:[dict objectForKey:@"svce"] forKey:(__bridge id)kSecAttrService];
    }
    
    // group keychain 钥匙串所在组
    if ([dict objectForKey:@"agrp"] && ![[dict objectForKey:@"agrp"] isEqual:@""]) {
        NSLog(@"agrp:\n%@",[dict objectForKey:@"agrp"]);
        [queryDic setObject:[dict objectForKey:@"agrp"] forKey:(__bridge id)kSecAttrAccessGroup];
    }
    
    // pdmn
    if ([[dict objectForKey:@"pdmn"] isEqual:@"ck"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlock forKey:(__bridge id)kSecAttrAccessible];
    }else if([[dict objectForKey:@"pdmn"] isEqual:@"cku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([[dict objectForKey:@"pdmn"] isEqual:@"dk"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAlways forKey:(__bridge id)kSecAttrAccessible];
    }else if ([[dict objectForKey:@"pdmn"] isEqual:@"akpu"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([[dict objectForKey:@"pdmn"] isEqual:@"dku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([[dict objectForKey:@"pdmn"] isEqual:@"ak"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    }else if ([[dict objectForKey:@"pdmn"] isEqual:@"aku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }
    
    
    //Keychain Accessibility Values
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

//    NSLog(@"查询条件 queryDic:\n%@",queryDic);
    
    // 添加数据
    if ([dict objectForKey:@"v_Data"] && ![[dict objectForKey:@"v_Data"] isEqual:@""]) {
        NSData *v_Data = [CryptoUtil HexStrToData:[dict objectForKey:@"v_Data"]];
        [queryDic setObject:v_Data forKey:(__bridge id)kSecValueData];
    }
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)queryDic, NULL);
    if (status == errSecSuccess) {
        NSLog(@"添加成功!");
    }else {
        NSLog(@"添加失败. status = %d",status);
    }
}

@end
