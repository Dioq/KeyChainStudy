//
//  CryptoUtil.h
//  ObjectiveC
//
//  Created by lzd_free on 2020/12/23.
//  Copyright © 2020 William. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CryptoUtil : NSObject

+(NSString *)base64EncodeString:(NSString *)string;
+(NSString *)base64DecodeString:(NSString *)string;
+(NSString *)md5:(NSString *)string;

// NSData 转 16 进制字符串
+ (NSString *)DataToHexStr:(NSData *)data;
// 16 进制字符串 转 NSData
+ (NSData *)HexStrToData:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
