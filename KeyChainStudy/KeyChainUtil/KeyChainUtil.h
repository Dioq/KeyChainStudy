//
//  KeyChainUtil.h
//  ObjectiveC
//
//  Created by Dio Brand on 2022/6/29.
//  Copyright © 2022 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyChainItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainUtil : NSObject

// 添加或修改
-(BOOL)insertOrUpdate:(nonnull KeyChainItem *)item table:(nonnull NSString *)table;

// 查找
-(NSArray<NSDictionary *> *)query:(nonnull KeyChainItem *)item table:(nonnull NSString *)table;

// 删除数据
-(BOOL)deleteData:(nonnull KeyChainItem *)item table:(nonnull NSString *)table;

@end

NS_ASSUME_NONNULL_END
