//
//  AddressListRequest.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/2.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "AddressListRequest.h"
#import "AddressListModel.h"

@implementation AddressListRequest

- (NSString *)requestUrl{
    return @"https://api-cust-demo.ayibang.com/v1/house/suggest";
}
- (Class)responseModelClass{
    return [AddressListModel class];
}
@end
