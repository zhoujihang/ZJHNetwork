//
//  CityListRequest.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/1.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "CityListRequest.h"
#import "CityListModel.h"

@implementation CityListRequest

- (NSString *)requestUrl{
    return @"https://api-cust-demo.ayibang.com/v2/city/lists";
}

- (Class)responseModelClass{
    return [CityListModel class];
}
@end
