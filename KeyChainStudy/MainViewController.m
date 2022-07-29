//
//  MainViewController.m
//  KeyChainStudy
//
//  Created by Dio Brand on 2022/6/24.
//

#import "MainViewController.h"
#import "CryptoUtil.h"
#import "KeychainUtil.h"

@interface MainViewController ()

@end

// TeamId 38D3676P2T
NSString *const group0 = @"38D3676P2T.cn.jobs8.keychain";
NSString *const group1 = @"38D3676P2T.cn.jobs8";
NSString *const group2 = @"38D3676P2T.cm.tencent.xin";
NSString *const groupUnknow = @"38D3676P2T.*";


//Keychain Accessibility Values
/*
 Protection Domain (pdmn)    Keychain Accessibility Values
 ck                          kSecAttrAccessibleAfterFirstUnlock
 cku                         kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
 dk                          kSecAttrAccessibleAlways
 akpu                        kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
 dku                         kSecAttrAccessibleAlwaysThisDeviceOnly
 ak                          kSecAttrAccessibleWhenUnlocked
 aku                         kSecAttrAccessibleWhenUnlockedThisDeviceOnly
 **/

//存储类型,不同的类型放在 SQLite 的不同表中
/*
 Table              kSecClass
 genp               kSecClassGenericPassword
 inet               kSecClassInternetPassword
 cert               kSecClassCertificate
 key                kSecClassKey
 **/

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Keychain";
}

- (IBAction)insertOrUpdate:(UIButton *)sender {
    //构造一个操作字典 添加数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //标签account
    NSString *acct = @"test1";
    [dict setObject:acct forKey:(__bridge id)kSecAttrAccount];
    //标签service
    NSString *svce = @"test1";
    [dict setObject:svce forKey:(__bridge id)kSecAttrService];
    
    // group keychain 钥匙串所在组
//    [queryDic setObject:group0 forKey:(__bridge id)kSecAttrAccessGroup];
    
    // pdmn
    [dict setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    //Keychain Accessibility Values
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

    //添加待保存数据
    NSString *info_str = @"bbbbb";
    NSData *info_data = [info_str dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:info_data forKey:(__bridge id)kSecValueData];
    
    NSLog(@"添加条件:\n%@", dict);

    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);                   //关键的添加API
    
    if (status == errSecSuccess){
        NSLog(@"添加成功!");
    }else if (status == errSecDuplicateItem) {
        NSLog(@"数据已经存在,无法添加,如需要改动可以用 修改改的 api!");
    }else {
        NSLog(@"status = %d ...",status);
    }
}

- (IBAction)insertOrUpdate_inet:(UIButton *)sender {
    //构造一个操作字典 添加数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //标签account
    NSString *acct = @"a test account";
    [dict setObject:acct forKey:(__bridge id)kSecAttrAccount];
    //标签service
    NSString *server = @"http://jobs8.cn";
    [dict setObject:server forKey:(__bridge id)kSecAttrServer];
    
    // group keychain 钥匙串所在组
    [dict setObject:groupUnknow forKey:(__bridge id)kSecAttrAccessGroup];
    
    // pdmn
    [dict setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    //Keychain Accessibility Values
    [dict setObject:(__bridge id)kSecClassInternetPassword forKey:(__bridge id)kSecClass];

    //添加待保存数据
    NSString *info_str = @"aaaaaaaa";
    NSData *info_data = [info_str dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:info_data forKey:(__bridge id)kSecValueData];
    
    NSLog(@"添加条件:\n%@", dict);

    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);                   //关键的添加API
    
    if (status == errSecSuccess){
        NSLog(@"添加成功!");
    }else if (status == errSecDuplicateItem) {
        NSLog(@"数据已经存在,无法添加,如需要改动可以用 修改改的 api!");
    }else {
        NSLog(@"status = %d ...",status);
    }
}

- (IBAction)updateItem:(UIButton *)sender {
    //构造一个操作字典 添加查询条件, 查询条件越多匹配的结果越少
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    //标签account
    NSString *acct = @"test1";
    [queryDic setObject:acct forKey:(__bridge id)kSecAttrAccount];
    //标签service
    NSString *svce = @"test1";
    [queryDic setObject:svce forKey:(__bridge id)kSecAttrService];
    
    // group keychain 钥匙串所在组
//    [queryDic setObject:group0 forKey:(__bridge id)kSecAttrAccessGroup];
    
    // pdmn
    [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    //Keychain Accessibility Values
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

    NSLog(@"查询条件 queryDic:\n%@",queryDic);
    
    //构造一个操作字典用于 修改数据
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:acct forKey:(__bridge id)kSecAttrAccount];
    //标签service
    [dict setObject:svce forKey:(__bridge id)kSecAttrService];
    //添加待保存数据
    NSString *info_str = @"bbbbbb";
    NSData *info_data = [info_str dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:info_data forKey:(__bridge id)kSecValueData];
    
    NSLog(@"改动条件:\n%@", dict);
    
    OSStatus status = -1;
    status = SecItemUpdate((__bridge CFDictionaryRef)queryDic, (__bridge CFDictionaryRef)dict);//关键的更新API
    if (status == errSecSuccess){
        NSLog(@"修改成功!");
    }else {
        NSLog(@"status = %d ...",status);
    }
}

- (IBAction)delete:(UIButton *)sender {
    //构造一个操作字典 添加查询条件, 查询条件越多匹配的结果越少(不添加查询条件时就是删除所有)
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    //标签account
//    NSString *acct = @"test1";
//    [queryDic setObject:acct forKey:(__bridge id)kSecAttrAccount];
    //标签service
//    NSString *svce = @"test1";
//    [queryDic setObject:svce forKey:(__bridge id)kSecAttrService];
    
    // group keychain 钥匙串所在组
//    [queryDic setObject:group0 forKey:(__bridge id)kSecAttrAccessGroup];
    
    //Keychain Accessibility Values
//    [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    //存储类型,不同的类型放在 SQLite 的不同表中
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
//    [queryDic setObject:(__bridge id)kSecClassInternetPassword forKey:(__bridge id)kSecClass];

    NSLog(@"查询条件 queryDic:\n%@",queryDic);
    
    OSStatus status = SecItemDelete((CFDictionaryRef)queryDic);
    if (status == errSecSuccess) {
        NSLog(@"删除成功!");
    }
    NSLog(@"status = %d ...",status);
}

- (IBAction)query:(UIButton *)sender {
    //构造一个操作字典 添加查询条件,查询条件越多返回的结果越少,不添加条件则是查询所有
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    //标签account
//    NSString *acct = @"wx.dat";
//    [queryDic setObject:acct forKey:(__bridge id)kSecAttrAccount];
    
    //标签service
//    NSString *svce = @"wx.dat";
//    [queryDic setObject:svce forKey:(__bridge id)kSecAttrService];
    
    // group keychain 钥匙串所在组
//    [queryDic setObject:accessUnknow forKey:(__bridge id)kSecAttrAccessGroup];
    
    //Keychain Accessibility Values
//    [queryDic setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    // 查询时这个条件必不可少
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
//    [queryDic setObject:(__bridge id)kSecClassInternetPassword forKey:(__bridge id)kSecClass];
    
    
    //返回结果包含 属性
    [queryDic setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    //返回结果包含 数据
    [queryDic setObject:(__bridge id)kCFBooleanTrue  forKey:(__bridge id)kSecReturnData];
    //返回所有数据(不限制条数)
    [queryDic setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    
    NSLog(@"查询条件 queryDic:\n%@",queryDic);
    
    OSStatus status = -1;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic,&result);//核心API查找
    if (status == errSecSuccess) { //判断状态
        CFArrayRef arrayRef = result;
        NSLog(@"arrayRef:\n%@", arrayRef);
        NSArray<NSDictionary *> *array = (__bridge_transfer NSArray *)arrayRef;
        for (NSDictionary *dict in array) {
            NSArray * allKeys = [dict allKeys];
            for (NSString *key in allKeys) {
                NSLog(@"%@:%@",key, [dict objectForKey:key]);
                if ([key isEqual:@"v_Data"]) {
                    NSString *v_Hex = [CryptoUtil DataToHexStr:[dict objectForKey:key]];
                    NSLog(@"v_Data:\n%@",v_Hex);
                }
                //            NSLog(@"%@",[[dict objectForKey:key] class]);
            }
            NSLog(@"--------- one item ----------");
        }
    }else {
        NSLog(@"没有数据 status = %d ...",status);
    }
}

- (IBAction)getAllData:(UIButton *)sender {
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    //查询时这个条件必不可少
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    //返回结果包含 属性
    [queryDic setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    //返回结果包含 数据
    [queryDic setObject:(__bridge id)kCFBooleanTrue  forKey:(__bridge id)kSecReturnData];
    //返回所有数据(不限制条数)
    [queryDic setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    
//    [queryDic setObject:groupUnknow forKey:(__bridge id)kSecAttrAccessGroup];
    
    OSStatus status = -1;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic,&result);//核心API查找
    if (status == errSecSuccess) { //判断状态
        CFArrayRef arrayRef = result;
        NSLog(@"arrayRef:\n%@", arrayRef);
        NSArray<NSDictionary *> *array = (__bridge_transfer NSArray *)arrayRef;
        for (NSDictionary *dict in array) {
            NSArray * allKeys = [dict allKeys];
            for (NSString *key in allKeys) {
                NSLog(@"%@:%@",key, [dict objectForKey:key]);
                if ([key isEqual:@"v_Data"]) {
                    NSString *v_Hex = [CryptoUtil DataToHexStr:[dict objectForKey:key]];
                    NSLog(@"v_Data:\n%@",v_Hex);
                }
                //            NSLog(@"%@",[[dict objectForKey:key] class]);
            }
            NSLog(@"--------- one item ----------");
        }
    }else {
        NSLog(@"没有数据 status = %d ...",status);
    }
}

- (IBAction)clearData:(UIButton *)sender {
    //构造一个操作字典 添加查询条件, 查询条件越多匹配的结果越少(不添加查询条件时就是删除所有)
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    
    //存储类型,不同的类型放在 SQLite 的不同表中
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
//    [queryDic setObject:(__bridge id)kSecClassInternetPassword forKey:(__bridge id)kSecClass];

//    NSLog(@"查询条件 queryDic:\n%@",queryDic);
    
    OSStatus status = SecItemDelete((CFDictionaryRef)queryDic);
    if (status == errSecSuccess) {
        NSLog(@"清除成功!");
    }else {
        NSLog(@"失败. status = %d",status);
    }
}

- (IBAction)restoreData:(UIButton *)sender {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"Keychain3" ofType:@"json"];
//    NSLog(@"filepath:\n%@",filepath);
    //2.转化为数据   创建data对象接收数据
    NSData *fileData = [NSData dataWithContentsOfFile:filepath];
    //3.使用系统提供JSON类  将需要解析的文件传入
    if (fileData == nil) {
        NSLog(@"filepath:\n%@\n为空",filepath);
        return;
    }
    NSMutableDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"\n%@", tempDict);
    NSArray * arr = [tempDict objectForKey:@"keychain"];
//    NSLog(@"arr:\n%@", arr);
    for (NSMutableDictionary *dict in arr) {
        [KeychainUtil insert:dict];
//        NSArray * allKeys = [dict allKeys];
//        for (NSString *key in allKeys) {
//            NSLog(@"%@:%@",key, [dict objectForKey:key]);
//            if ([key isEqual:@"v_Data"]) {
////                NSString *v_Data = [CryptoUtil HexStrToData:[dict objectForKey:key]];
////                NSLog(@"v_Data:\n%@",v_Data);
//            }
//        }
        NSLog(@"--------- one item ----------");
    }
}

@end
