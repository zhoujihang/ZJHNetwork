//
//  NetworkConfig.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/1.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkConfig : NSObject

+ (instancetype)defaultConfig;

@property (nonatomic, copy) NSDictionary *fixedHeaders;

@property (nonatomic, assign) NSTimeInterval defaultTimeoutInterval;

@property (nonatomic, strong) NSIndexSet *defaultAcceptableStatusCodes;

@property (nonatomic, strong) NSSet *defaultAcceptableContentTypes;

@end
