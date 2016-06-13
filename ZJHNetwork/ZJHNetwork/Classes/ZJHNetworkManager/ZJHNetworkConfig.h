//
//  NetworkConfig.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/1.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJHNetworkConfig : NSObject

+ (instancetype)defaultConfig;

// 每个request都会加上的headers
@property (nonatomic, copy) NSDictionary *additionalHeaders;

@property (nonatomic, assign) NSTimeInterval defaultTimeoutInterval;

@property (nonatomic, strong) NSIndexSet *defaultAcceptableStatusCodes;

@property (nonatomic, strong) NSSet *defaultAcceptableContentTypes;

@end
