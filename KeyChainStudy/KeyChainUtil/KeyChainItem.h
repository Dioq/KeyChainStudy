//
//  KeyChainItem.h
//  ObjectiveC
//
//  Created by Dio Brand on 2022/7/25.
//  Copyright © 2022 my. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainItem : NSObject

@property(nonatomic,strong)NSString *accc;
@property(nonatomic,copy)NSString *acct;
@property(nonatomic,copy)NSString *agrp;
@property(nonatomic,copy)NSString *cdat;
@property(nonatomic,copy)NSString *mdat;
@property(nonatomic,strong)NSData *musr;
@property(nonatomic,copy)NSString *pdmn;
@property(nonatomic,strong)NSData *persistref;
@property(nonatomic,strong)NSData *sha1;
@property(nonatomic,copy)NSString *svce;
@property(nonatomic,assign)NSInteger sync;
@property(nonatomic,assign)NSInteger tomb;
@property(nonatomic,strong)NSData *v_Data;

@end

NS_ASSUME_NONNULL_END
