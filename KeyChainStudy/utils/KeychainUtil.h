//
//  KeychainUtil.h
//  KeyChainStudy
//
//  Created by Dio Brand on 2022/7/29.
//

#import <Foundation/Foundation.h>
#import "CryptoUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeychainUtil : NSObject

+(void)insert:(NSMutableDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
