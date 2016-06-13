//
//  NetworkManager.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/5/31.
//  Copyright © 2016年 zjh. All rights reserved.
//

// 此类为逻辑，统一处理网络请求的回调，将json对象直接转为model使用，避免使用字典

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "RequestErrorModel.h"
#import "ZJHBaseRequest.h"

// error模型中 错误提示文字
FOUNDATION_EXTERN NSString *const kNetworkErrorDomain;
FOUNDATION_EXTERN NSString *const kNetworkParseResponseErrorMessage;

// error模型中 存放后台错误数据的key
FOUNDATION_EXTERN NSString *const kNetworkBusinessErrorDataKey;
// error模型中 http 状态码的key
FOUNDATION_EXTERN NSString *const kNetworkErrorHttpStatusCodeKey;

// error模型中 error的code类型
FOUNDATION_EXTERN const NSInteger kNetworkNilResponseErrorCode;
FOUNDATION_EXTERN const NSInteger kNetworkParseResponseErrorCode;
FOUNDATION_EXTERN const NSInteger kNetworkBusinessErrorCode;


@interface ZJHBaseRequest (ZJHNetworkManager)

@property (nonatomic, strong, readonly) id responseModel;

@property (nonatomic, strong, readonly) NSError *error;

@end

@interface ZJHNetworkManager : NSObject

// 本类为单例，只处理网络数据逻辑，不持有任何变量
+ (instancetype)sharedManager;

- (void)addRequest:(ZJHBaseRequest *)request;



@end

