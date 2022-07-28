//
//  KeyChainUtil.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/6/29.
//  Copyright © 2022 my. All rights reserved.
//

#import "KeyChainUtil.h"

@implementation KeyChainUtil
/*
 KeyChain基本的API
 添加
 OSStatus SecItemAdd(CFDictionaryRef attributes, CFTypeRef * __nullable CF_RETURNS_RETAINED result);
 查询
 OSStatus SecItemCopyMatching(CFDictionaryRef query, CFTypeRef * __nullable CF_RETURNS_RETAINED result);
 更新
 OSStatus SecItemUpdate(CFDictionaryRef query, CFDictionaryRef attributesToUpdate);
 删除
 OSStatus SecItemDelete(CFDictionaryRef query);
 **/

/*
 Keychain API
 https://gist.github.com/Dioq/adf2ff6f56be816f88a5f9dd8d9ef36b
 **/

-(BOOL)insertOrUpdate:(nonnull KeyChainItem *)item table:(nonnull NSString *)table {
    //构造一个操作 作为数据库的查找条件
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    //标签account
    if (item.acct != nil) {
        [queryDic setObject:item.acct forKey:(__bridge id)kSecAttrAccount];
    }
    // group keychain 钥匙串所在组
    if (item.agrp != nil) {
        // 允许这项数据可以共享的 group item,如果不添加就不与任何其他app共享
        [queryDic setObject:item.agrp forKey:(id)kSecAttrAccessGroup];
    }
    //Keychain Accessibility Values  (pdmn = cku)
    if ([item.pdmn isEqual:@"ck"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlock forKey:(__bridge id)kSecAttrAccessible];
    }else if([item.pdmn isEqual:@"cku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"dk"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAlways forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"akpu"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"dku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"ak"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"aku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }
    //标签service
    if (item.svce != nil) {
        [queryDic setObject:item.svce forKey:(__bridge id)kSecAttrService];
    }
    
    //存储类型,不同的类型放在 SQLite 的不同表时
    if ([table isEqual:@"genp"]) {
        [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    }else if ([table isEqual:@"inet"]) {
        [queryDic setObject:(__bridge id)kSecClassInternetPassword forKey:(__bridge id)kSecClass];
    }else if ([table isEqual:@"cert"]) {
        [queryDic setObject:(__bridge id)kSecClassCertificate forKey:(__bridge id)kSecClass];
    }else if ([table isEqual:@"key"]) {
        [queryDic setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    }
    
    
    //构造一个操作字典用于  添加或修改
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:queryDic];
    //添加待保存数据
    [dict setObject:item.v_Data forKey:(__bridge id)kSecValueData];
    
    OSStatus status = -1;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic, &result);
    if (status == errSecItemNotFound) {                                              //没有找到则添加
        NSLog(@"add ...");
        status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);                   //关键的添加API
    }else if (status == errSecSuccess){
        //成功找到，说明钥匙已经存在则进行更新
        NSLog(@"update ...");
        status = SecItemUpdate((__bridge CFDictionaryRef)queryDic, (__bridge CFDictionaryRef)dict);//关键的更新API
    }
    
    // 释放 CFTypeRef
    if (result) {
        CFRelease(result);
    }
    NSLog(@"status = %d ...",status);
    return (status == errSecSuccess) ? YES : NO;
}

-(BOOL)deleteData:(nonnull KeyChainItem *)item table:(nonnull NSString *)table {
    //构造一个操作 作为数据库的查找条件
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    //标签account
    if (item.acct != nil) {
        [queryDic setObject:item.acct forKey:(__bridge id)kSecAttrAccount];
    }
    // group keychain 钥匙串所在组
    if (item.agrp != nil) {
        // 允许这项数据可以共享的 group item,如果不添加就不与任何其他app共享
        [queryDic setObject:item.agrp forKey:(id)kSecAttrAccessGroup];
    }
    //Keychain Accessibility Values  (pdmn = cku)
    if ([item.pdmn isEqual:@"ck"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlock forKey:(__bridge id)kSecAttrAccessible];
    }else if([item.pdmn isEqual:@"cku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"dk"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAlways forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"akpu"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"dku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"ak"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"aku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }
    //标签service
    if (item.svce != nil) {
        [queryDic setObject:item.svce forKey:(__bridge id)kSecAttrService];
    }
    
    //存储类型,不同的类型放在 SQLite 的不同表时
    if ([table isEqual:@"genp"]) {
        [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    }else if ([table isEqual:@"inet"]) {
        [queryDic setObject:(__bridge id)kSecClassInternetPassword forKey:(__bridge id)kSecClass];
    }else if ([table isEqual:@"cert"]) {
        [queryDic setObject:(__bridge id)kSecClassCertificate forKey:(__bridge id)kSecClass];
    }else if ([table isEqual:@"key"]) {
        [queryDic setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    }
    
    OSStatus status = SecItemDelete((CFDictionaryRef)queryDic);
    NSLog(@"status = %d ...",status);
    return (status == errSecSuccess) ? YES : NO;
}

//用原生的API 实现查询密码
- (NSMutableArray<KeyChainItem *> *)query:(nonnull KeyChainItem *)item table:(nonnull NSString *)table {
    /*
     过程：
     1.(关键)先配置一个操作字典内容有:
     kSecAttrService(属性),kSecAttrAccount(属性) 这些属性or标签是查找的依据
     kSecReturnData(值为@YES 表明返回类型为data),kSecClass(值为kSecClassGenericPassword 表示重要数据为“一般密码”类型) 这些限制条件是返回结果类型的依据
     2.然后用查找的API 得到查找状态和返回数据(密码)
     **/
    
    //构造一个操作字典用于  查询
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    //标签account
    if (item.acct != nil) {
        [queryDic setObject:item.acct forKey:(__bridge id)kSecAttrAccount];
    }
    // group keychain 钥匙串所在组
    if (item.agrp != nil) {
        [queryDic setObject:item.agrp forKey:(id)kSecAttrAccessGroup];
    }
    //Keychain Accessibility Values  (pdmn = cku)
    if ([item.pdmn isEqual:@"ck"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlock forKey:(__bridge id)kSecAttrAccessible];
    }else if([item.pdmn isEqual:@"cku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"dk"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAlways forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"akpu"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"dku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"ak"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    }else if ([item.pdmn isEqual:@"aku"]) {
        [queryDic setObject:(__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    }
    //标签service
    if (item.svce != nil) {
        [queryDic setObject:item.svce forKey:(__bridge id)kSecAttrService];
    }
    
    //存储类型,不同的类型放在 SQLite 的不同表中
    if ([table isEqual:@"genp"]) {
        [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    }else if ([table isEqual:@"inet"]) {
        [queryDic setObject:(__bridge id)kSecClassInternetPassword forKey:(__bridge id)kSecClass];
    }else if ([table isEqual:@"cert"]) {
        [queryDic setObject:(__bridge id)kSecClassCertificate forKey:(__bridge id)kSecClass];
    }else if ([table isEqual:@"key"]) {
        [queryDic setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    }
    
    //返回结果包含 属性
    [queryDic setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    //返回结果包含 数据
    [queryDic setObject:(__bridge id)kCFBooleanTrue  forKey:(__bridge id)kSecReturnData];
    //返回所有数据(不限制条数)
    [queryDic setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    
    //查询
    OSStatus status = -1;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic,&result);//核心API 查找是否匹配 和返回密码！
    if (status == errSecSuccess) { //判断状态
        CFArrayRef arrayRef = result;
        NSLog(@"arrayRef:\n%@", arrayRef);
        NSArray<NSDictionary *> *array = (__bridge_transfer NSArray *)arrayRef;
        NSMutableArray<KeyChainItem *> *kItems = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            KeyChainItem *kItem = [[KeyChainItem alloc] init];
            kItem.accc = [dict objectForKey:@"accc"];
            kItem.acct = [dict objectForKey:@"acct"];
            kItem.agrp = [dict objectForKey:@"agrp"];
            kItem.cdat = [dict objectForKey:@"cdat"];
            kItem.mdat = [dict objectForKey:@"mdat"];
            kItem.musr = [dict objectForKey:@"musr"];
            kItem.pdmn = [dict objectForKey:@"pdmn"];
            kItem.sha1 = [dict objectForKey:@"sha1"];
            kItem.svce = [dict objectForKey:@"svce"];
            kItem.sync = (NSInteger)[dict objectForKey:@"sync"];
            kItem.tomb = (NSInteger)[dict objectForKey:@"tomb"];
            kItem.v_Data = [dict objectForKey:@"v_Data"];
            
            [kItems addObject:kItem];
        }
        return kItems;
    }else {
        NSLog(@"没有数据 status = %d ...",status);
    }
    return nil;
}

@end
