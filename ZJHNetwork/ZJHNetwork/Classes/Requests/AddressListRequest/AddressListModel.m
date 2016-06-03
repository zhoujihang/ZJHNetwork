//
//  AddressListModel.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/2.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "AddressListModel.h"

@implementation AddressListModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"addressObjectMArr" : @"houses"
             };
}
+ (NSDictionary *)objectClassInArray{
    return @{
             @"addressObjectMArr" : [AddressObjectModel class],
             };
}

@end

@implementation AddressObjectModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"addressModel" : @"house"
             };
}

@end


@implementation AddressModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             @"city_pinyin" : @"city"
             };
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    id newValue = oldValue;
    
    if ([property.name isEqualToString:@"createtime"]) {
        newValue = [NSDate dateWithTimeIntervalSince1970:[oldValue longLongValue]];
    }else if ([property.name isEqualToString:@"updatetime"]){
        newValue = [NSDate dateWithTimeIntervalSince1970:[oldValue longLongValue]];
    }
    
    return newValue;
}

@end
