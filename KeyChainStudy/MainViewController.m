//
//  MainViewController.m
//  KeyChainStudy
//
//  Created by Dio Brand on 2022/6/24.
//

#import "MainViewController.h"
#import "KeyChain.h"
#import "AlertController.h"

NSString * const KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
NSString * const KEY_USERNAME = @"com.company.app.username";
NSString * const KEY_PASSWORD = @"com.company.app.password";

@interface MainViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *myUser;
@property (weak, nonatomic) IBOutlet UITextField *myPassword;
@property (weak, nonatomic) IBOutlet UITextField *mykey;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myUser.delegate = self;
    self.myPassword.delegate = self;
    self.mykey.delegate = self;
}

- (IBAction)readAction:(id)sender {
    // B、从keychain中读取用户名和密码
    if (self.mykey.text.length) {
        NSMutableDictionary *readUsernamePassword = (NSMutableDictionary *)[KeyChain readForKey:self.mykey.text];
        NSString *userName = [readUsernamePassword objectForKey:KEY_USERNAME];
        NSString *password = [readUsernamePassword objectForKey:KEY_PASSWORD];
        self.myUser.text = userName;
        self.myPassword.text = password;
        NSLog(@"username = %@", userName);
        NSLog(@"password = %@", password);
    }else{
        [AlertController alertControllerWithController:self title:@"提示" message:@"请填入key值" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelAction:nil otherAction:nil];
    }
    
    [self.view endEditing:YES];
}


- (IBAction)writeAction:(id)sender {
    NSMutableDictionary *userNamePasswordKVPairs = [NSMutableDictionary dictionary];
    [userNamePasswordKVPairs setObject:self.myUser.text forKey:KEY_USERNAME];
    [userNamePasswordKVPairs setObject:self.myPassword.text forKey:KEY_PASSWORD];
    
    // A、将用户名和密码写入keychain
    //    [KeyChain save:KEY_USERNAME_PASSWORD data:userNamePasswordKVPairs];
    
    if (self.mykey.text.length) {
        [KeyChain addKeychainData:userNamePasswordKVPairs forKey:self.mykey.text];
    }else{
        [AlertController alertControllerWithController:self title:@"提示" message:@"请填入key值" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelAction:nil otherAction:nil];
    }
    
    [self.view endEditing:YES];
}

- (IBAction)writeSahreAction:(id)sender {
    NSMutableDictionary *userNamePasswordKVPairs = [NSMutableDictionary dictionary];
    [userNamePasswordKVPairs setObject:self.myUser.text forKey:KEY_USERNAME];
    [userNamePasswordKVPairs setObject:self.myPassword.text forKey:KEY_PASSWORD];
    
    // A、将用户名和密码写入keychain
    //    [KeyChain save:KEY_USERNAME_PASSWORD data:userNamePasswordKVPairs];
    
    if (self.mykey.text.length) {
        [KeyChain addShareKeyChainData:userNamePasswordKVPairs forKey:self.mykey.text];
    }else{
        [AlertController alertControllerWithController:self title:@"提示" message:@"请填入key值" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelAction:nil otherAction:nil];
    }
    
    [self.view endEditing:YES];
}

- (IBAction)deleteAction:(id)sender {
    // C、将用户名和密码从keychain中删除
    if (self.mykey.text.length) {
        [KeyChain deleteWithService:self.mykey.text];
    }else{
        [AlertController alertControllerWithController:self title:@"提示" message:@"请填入key值" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelAction:nil otherAction:nil];
    }
    
    [self.view endEditing:YES];
}


- (IBAction)clearKeyChainAction:(UIButton *)sender {
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnAttributes,
                                  (__bridge id)kSecMatchLimitAll, (__bridge id)kSecMatchLimit,
                                  nil];
    NSArray *secItemClasses = [NSArray arrayWithObjects:
                               (__bridge id)kSecClassGenericPassword,
                               (__bridge id)kSecClassInternetPassword,
                               (__bridge id)kSecClassCertificate,
                               (__bridge id)kSecClassKey,
                               (__bridge id)kSecClassIdentity,
                               nil];
    for (id secItemClass in secItemClasses) {
        [query setObject:secItemClass forKey:(__bridge id)kSecClass];
        
        CFTypeRef result = NULL;
        SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
        if (result != NULL) {
            CFRelease(result);
        }
        NSDictionary *spec = @{(__bridge id)kSecClass: secItemClass};
        // 将所有的key取出放入数组arr中
        NSArray *arr = [spec allKeys];
        // 遍历arr 取出对应的key以及key对应的value
        for (NSInteger i = 0; i < arr.count; i++) {
            NSLog(@"%@ : %@", arr[i], [spec objectForKey:arr[i]]); // dic[arr[i]]
        }
        SecItemDelete((__bridge CFDictionaryRef)spec);
    }
    
    NSLog(@"清空KeyChain");
    [self.view endEditing:YES];
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
        [self.mykey resignFirstResponder];
        [self.myUser resignFirstResponder];
        [self.myPassword resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


@end
