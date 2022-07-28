//
//  MainViewController.m
//  KeyChainStudy
//
//  Created by Dio Brand on 2022/6/24.
//

#import "MainViewController.h"
#import "KeyChainItem.h"
#import "KeyChainUtil.h"

@interface MainViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *acctTF;
@property (weak, nonatomic) IBOutlet UITextField *argpTF;
@property (weak, nonatomic) IBOutlet UITextField *pdmnTF;
@property (weak, nonatomic) IBOutlet UITextField *svceTF;
@property (weak, nonatomic) IBOutlet UITextField *vDataTF;
@property (weak, nonatomic) IBOutlet UITextField *tableTF;

@property(nonatomic,strong)KeyChainUtil *keychainUtil;
@property(nonatomic,strong)KeyChainItem *criteriaItem;
@property(nonatomic,copy)NSString *table;

@end

// TeamId 38D3676P2T
NSString *const accessItem0 = @"cn.jobs8.keychain";
NSString *const accessItem1 = @"38D3676P2T.cn.jobs8";
NSString *const accessItem2 = @"38D3676P2T.cm.tencent.xin";
NSString *const accessUnknow = @"38D3676P2T.*";

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.acctTF.delegate = self;
    self.argpTF.delegate = self;
    self.pdmnTF.delegate = self;
    self.svceTF.delegate = self;
    self.vDataTF.delegate = self;
    self.tableTF.delegate = self;
    
    self.keychainUtil = [[KeyChainUtil alloc] init];
    self.criteriaItem = [[KeyChainItem alloc] init];
    
    _acctTF.text = @"test_acct4";
    _argpTF.text = accessUnknow;
    _pdmnTF.text = @"cku";
    _svceTF.text = @"test_svce4";
    _vDataTF.text = @"This is a test string.";
    _tableTF.text = @"genp";
}

-(void)initInsertCriteria {
    self.criteriaItem = [[KeyChainItem alloc] init];
    if ([_acctTF.text isEqual:@""] ||
        [_argpTF.text isEqual:@""] ||
        [_pdmnTF.text isEqual:@""] ||
        [_svceTF.text isEqual:@""] ||
        [_vDataTF.text isEqual:@""] ||
        [_tableTF.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"插入数据" message:@"插入数据时 所有数据都不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:btn];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if ([_pdmnTF.text isEqual:@"ck"] ||
        [_pdmnTF.text isEqual:@"cku"] ||
        [_pdmnTF.text isEqual:@"dk"] ||
        [_pdmnTF.text isEqual:@"akpu"] ||
        [_pdmnTF.text isEqual:@"dku"] ||
        [_pdmnTF.text isEqual:@"ak"] ||
        [_pdmnTF.text isEqual:@"aku"]) {
        self.pdmnTF.text = _pdmnTF.text;
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"pdmn" message:@"pdmn:ck cku dk akpu dku ak aku" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.pdmnTF.text = @"cku";
        }];
        [alert addAction:btn];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    self.criteriaItem.acct = _acctTF.text;
    self.criteriaItem.agrp = _argpTF.text;
    self.criteriaItem.pdmn = _pdmnTF.text;
    self.criteriaItem.svce = _svceTF.text;
    self.criteriaItem.v_Data = [_vDataTF.text dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([_tableTF.text isEqual:@"genp"] ||
        [_tableTF.text isEqual:@"inet"] ||
        [_tableTF.text isEqual:@"cert"] ||
        [_tableTF.text isEqual:@"key"]) {
        _table = _tableTF.text;
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Table" message:@"table 只能是 genp inet cert key 这4种" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tableTF.text = @"genp";
        }];
        [alert addAction:btn];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
}

- (IBAction)insertOrUpdate:(UIButton *)sender {
    [self.view endEditing:YES];
    //        KeyChainItem *item = [KeyChainItem new];
    //        item.acct = @"test_acct3";
    //        item.agrp = accessItem2;
    //        item.pdmn = @"cku";
    //        item.svce = @"test_svce3";
    //        NSString *str = @"This is a test string.";
    //        NSData *v_Data = [str dataUsingEncoding:NSUTF8StringEncoding];
    //        item.v_Data = v_Data;
    //        BOOL suc = [self.keychainUtil insertOrUpdate:item table:@"genp"];
    
    [self initInsertCriteria];
    BOOL suc = [self.keychainUtil insertOrUpdate:self.criteriaItem table:_table];
    
    if (suc) {
        NSLog(@"插入数据成功!");
    }else{
        NSLog(@"插入数据失败!");
    }
}

-(void)initDeleteCriteria {
    self.criteriaItem = [[KeyChainItem alloc] init];
    if (![_acctTF.text isEqual:@""]) {
        self.criteriaItem.acct = _acctTF.text;
    }
    if (![_argpTF.text isEqual:@""]) {
        self.criteriaItem.agrp = _argpTF.text;
    }
    if (![_pdmnTF.text isEqual:@""]) {
        if ([_pdmnTF.text isEqual:@"ck"] ||
            [_pdmnTF.text isEqual:@"cku"] ||
            [_pdmnTF.text isEqual:@"dk"] ||
            [_pdmnTF.text isEqual:@"akpu"] ||
            [_pdmnTF.text isEqual:@"dku"] ||
            [_pdmnTF.text isEqual:@"ak"] ||
            [_pdmnTF.text isEqual:@"aku"]) {
            self.criteriaItem.pdmn = _pdmnTF.text;
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"pdmn" message:@"pdmn:ck cku dk akpu dku ak aku" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *btn = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.pdmnTF.text = @"cku";
            }];
            [alert addAction:btn];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    if (![_svceTF.text isEqual:@""]) {
        self.criteriaItem.svce = _svceTF.text;
    }
    if ([_tableTF.text isEqual:@"genp"] || [_tableTF.text isEqual:@"inet"] || [_tableTF.text isEqual:@"cert"] || [_tableTF.text isEqual:@"key"]) {
        _table = _tableTF.text;
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Table" message:@"table 只能是 genp inet cert key 这4种" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tableTF.text = @"";
        }];
        [alert addAction:btn];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
}

- (IBAction)delete:(UIButton *)sender {
    [self.view endEditing:YES];
    //        KeyChainItem *item = [KeyChainItem new];
    //        item.acct = @"test_acct1";
    //        item.agrp = accessItem2;
    //        item.pdmn = @"cku";
    //        item.svce = @"test_svce1";
    
    //        BOOL suc = [self.keychainUtil deleteData:item table:@"genp"];
    
    [self initDeleteCriteria];
    BOOL suc = [self.keychainUtil deleteData:self.criteriaItem table:_table];
    if (suc) {
        NSLog(@"数据删除成功!");
    }else{
        NSLog(@"数据删除失败!");
    }
}

-(void)initQueryCriteria {
    self.criteriaItem = [[KeyChainItem alloc] init];
    if (![_acctTF.text isEqual:@""]) {
        self.criteriaItem.acct = _acctTF.text;
    }
    if (![_argpTF.text isEqual:@""]) {
        self.criteriaItem.agrp = _argpTF.text;
    }
    if (![_pdmnTF.text isEqual:@""]) {
        if ([_pdmnTF.text isEqual:@"ck"] ||
            [_pdmnTF.text isEqual:@"cku"] ||
            [_pdmnTF.text isEqual:@"dk"] ||
            [_pdmnTF.text isEqual:@"akpu"] ||
            [_pdmnTF.text isEqual:@"dku"] ||
            [_pdmnTF.text isEqual:@"ak"] ||
            [_pdmnTF.text isEqual:@"aku"]) {
            self.criteriaItem.pdmn = _pdmnTF.text;
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"pdmn" message:@"pdmn:ck cku dk akpu dku ak aku" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *btn = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.pdmnTF.text = @"cku";
            }];
            [alert addAction:btn];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    if (![_svceTF.text isEqual:@""]) {
        self.criteriaItem.svce = _svceTF.text;
    }
    
    if ([_tableTF.text isEqual:@"genp"] || [_tableTF.text isEqual:@"inet"] || [_tableTF.text isEqual:@"cert"] || [_tableTF.text isEqual:@"key"]) {
        _table = _tableTF.text;
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"查询" message:@"table 只能是 genp inet cert key 这4种" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tableTF.text = @"";
        }];
        [alert addAction:btn];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
}

- (IBAction)query:(UIButton *)sender {
    [self.view endEditing:YES];
    //    KeyChainItem *item = [KeyChainItem new];
    //    item.acct = @"test_acct1";
    //    item.agrp = accessUnknow;
    //    item.agrp = accessItem2;
    //    item.pdmn = @"cku";
    //    item.svce = @"test_svce1";
    
    //    [self.keychainUtil query:item table:@"genp"];
    
    [self initQueryCriteria];
    NSArray<NSDictionary *> * result_arr = [self.keychainUtil query:self.criteriaItem table:_table];
    for (NSDictionary *dict in result_arr) {
        NSArray * allKeys = [dict allKeys];
        for (NSString *key in allKeys) {
            NSLog(@"%@:%@",key, [dict objectForKey:key]);
        }
        NSLog(@"--------- one item ----------");
    }
}

- (IBAction)queryTest:(UIButton *)sender {
//        NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
//        NSString *account = @"Dio";
//    //    NSString *password = @"888888";
//        NSString *server = @"jobs8.cn";
//        [queryDic setObject:(__bridge id)kSecClassInternetPassword forKey:(__bridge id)kSecClass];
//        [queryDic setObject:account forKey:(__bridge id)kSecAttrAccount];
//        [queryDic setObject:server forKey:(__bridge id)kSecAttrServer];
//    //    [queryDic setObject:password forKey:(__bridge id)kSecValueData];
//
//        OSStatus status = -1;
//    //    CFTypeRef result = NULL;
//        status = SecItemAdd((__bridge CFDictionaryRef)queryDic, NULL);
//        NSLog(@"status = %d ...",status);
    
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    [queryDic setObject:(__bridge id)kSecClassInternetPassword forKey:(__bridge id)kSecClass];
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
    }else {
        NSLog(@"没有数据 status = %d ...",status);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.acctTF resignFirstResponder];
        [self.argpTF resignFirstResponder];
        [self.pdmnTF resignFirstResponder];
        [self.svceTF resignFirstResponder];
        [self.vDataTF resignFirstResponder];
        [self.tableTF resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

@end
