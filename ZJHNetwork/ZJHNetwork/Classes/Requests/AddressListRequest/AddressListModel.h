//
//  AddressListModel.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/2.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "BaseModel.h"


@class AddressObjectModel,AddressModel;

@interface AddressListModel : BaseModel

@property (nonatomic, strong) NSMutableArray *addressObjectMArr;

@end

// 这个类只是一层壳。。。
@interface AddressObjectModel : BaseModel

@property (nonatomic, strong) AddressModel *addressModel;

@end

@interface AddressModel : BaseModel

// 地址ID
@property (nonatomic, copy) NSString *ID;
// 用户ID
@property (nonatomic, copy) NSString *custID;
// 城市 拼音
@property (nonatomic, copy) NSString *city_pinyin;
// 城市名称 汉字
@property (nonatomic, copy) NSString *cityName;
// 地区
@property (nonatomic, copy) NSString *zone;
// 房屋面积
@property (nonatomic, assign) CGFloat sqmeter;

// 服务地点
@property (nonatomic, copy) NSString *svcAddr;
// 地址信息的name部分
@property (nonatomic, copy) NSString *nameAddr;
// 用户输入的地址信息部分
@property (nonatomic, copy) NSString *detailAddr;

// 状态
@property (nonatomic, assign) NSInteger status;
// 状态名称
@property (nonatomic, copy) NSString *statusName;
// 推荐时长
@property (nonatomic, assign) float durationSuggest;
// 几室
@property (nonatomic, assign) NSInteger bedroom;
// 几厅
@property (nonatomic, assign) NSInteger livingroom;
// 几厨
@property (nonatomic, assign) NSInteger kitchen;
// 几卫
@property (nonatomic, assign) NSInteger bathroom;
// 其他备注
@property (nonatomic, copy) NSString *comment;
// 备注
@property (nonatomic, copy) NSString *remark;



// -------------------- 默认不返回 -------------------
// 订单创建时间
@property (nonatomic, strong) NSDate *createtime;
// 订单更新时间
@property (nonatomic, strong) NSDate *updatetime;
// 经度

@property (nonatomic, assign) double lng;
// 纬度
@property (nonatomic, assign) double lat;

@end