//
//  CityListModel.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/2.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "CityListModel.h"

@implementation CityListModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"hotCityArr" : @"hotCities",
             @"allCityArr" : @"allCities"
             
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{
             @"hotCityArr" : [CityObjectModel class],
             @"allCityArr" : [CityObjectModel class]
             };
}

- (CityModel *)cityModelWithBaiduCode:(NSString *)baiduCode{
    CityModel *cityModel = nil;
    for (CityObjectModel *cityObjModel in self.allCityArr) {
        CityModel *model = cityObjModel.cityModel;
        if ([model.baiduCode isEqualToString:baiduCode]) {
            // 要切换的城市在城市列表中
            cityModel = model;
            break;
        }
    }
    return cityModel;
}

@end

@implementation CityObjectModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"cityModel" : @"city"
             };
}


@end


@implementation CityModel

MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"
             };
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    id newValue = oldValue;
    if ([property.name isEqualToString:@"createtime"]) {
        newValue = [NSDate dateWithTimeIntervalSinceNow:[oldValue longValue]];
    }
    return newValue;
}
+ (CityModel *)defaltCityModel{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"BeijingCityModel" ofType:@"json"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    CityModel *model = [CityModel mj_objectWithKeyValues:str];
    return model;
}

@end