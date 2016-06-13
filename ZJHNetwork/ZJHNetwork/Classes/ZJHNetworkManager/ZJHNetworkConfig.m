//
//  NetworkConfig.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/1.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "ZJHNetworkConfig.h"

@implementation ZJHNetworkConfig

+ (instancetype)defaultConfig{
    static ZJHNetworkConfig *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance setDefault];
    });
    return _instance;
}
- (void)setDefault{
    self.additionalHeaders = @{};
    self.defaultTimeoutInterval = 25;
    self.defaultAcceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
    self.defaultAcceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"text/json", @"text/javascript", @"image/png", @"image/jpeg", @"application/json", nil];
}

@end
