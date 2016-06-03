//
//  CityListModel.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/2.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "BaseModel.h"

@class CityObjectModel,CityModel;
@interface CityListModel : BaseModel
// 热门城市
@property (nonatomic,strong) NSArray<CityObjectModel *> *hotCityArr;
// 全部城市
@property (nonatomic,strong) NSArray<CityObjectModel *> *allCityArr;

- (CityModel *)cityModelWithBaiduCode:(NSString *)baiduCode;

@end

@interface CityObjectModel : BaseModel

@property (nonatomic, strong) CityModel *cityModel;

@end

typedef enum : NSUInteger {
    CityStatus_Validate = 1,         // 城市开通的状态，服务器返回
    CityStatus_Invalidate = -99,     // 未开通的城市或者和城市列表里的城市信息未能对应，自定义的
} CityStatusType;

@interface CityModel : BaseModel <NSCoding>
// 城市ID
@property (nonatomic, copy) NSString *ID;
// 城市的中文名
@property (nonatomic, copy) NSString *name;
// 和百度对应的城市编码
@property (nonatomic, copy) NSString *baiduCode;
// 城市的拼音
@property (nonatomic, copy) NSString *pinyin;
// 第一个字母
@property (nonatomic, copy) NSString *firstLetter;
// 城市状态
@property (nonatomic, assign) NSInteger status;

// ------------------------ 用不到的属性 -------------------
// 后台的城市代号
@property (nonatomic, copy) NSString *code;
// 创建时间
@property (nonatomic, strong) NSDate *createtime;
// 默认城市配置 北京
+ (CityModel*)defaltCityModel;
@end