//
//  RequestHeadTool.m
//  Ayibang
//
//  Created by 小胖的Mac on 15/12/24.
//  Copyright © 2015年 ayibang. All rights reserved.
//

#import "RequestHeadTool.h"
#import "MJExtension/MJExtension.h"
#import <UIKit/UIKit.h>

static NSString *const kStringUnknow = @"UnKnown";
@interface RequestHeadTool ()

@property (nonatomic,copy,readwrite) NSString * userAgent;

@end
@implementation RequestHeadTool

+ (NSString *)userAgent{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:10];
    //客户端类型
    [dic setValue:@"iOS" forKey:@"type"];
    //版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [dic setValue:version forKey:@"version-Name"];
    //数字版本号
    [dic setValue:kStringUnknow forKey:@"version-Code"];
    //build版本号
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [dic setValue:buildVersion forKey:@"build-Version"];
    // 系统版本
    [dic setValue:[[UIDevice currentDevice] systemVersion] forKey:@"os"];
    // MAC 地址
    [dic setValue:kStringUnknow forKey:@"mac"];
    // 运用商
    [dic setValue:kStringUnknow forKey:@"sim-Operator"];
    // 渠道
    [dic setValue:@"AppStore" forKey:@"channel"];
    
    NSString *userAgent = [dic mj_JSONString];
    return userAgent;
}

+ (NSDictionary *)getRequestHead{
    NSDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:10];
    // userAgent
    NSString * userAgent = [RequestHeadTool userAgent];
    [dic setValue:userAgent forKey:@"User-Agent"];
    
    return dic;
}


@end
