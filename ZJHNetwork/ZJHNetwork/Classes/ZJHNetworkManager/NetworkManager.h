//
//  NetworkManager.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/5/31.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "RequestErrorModel.h"
#import "BaseRequest.h"

FOUNDATION_EXTERN NSString *const kNetworkErrorDomain;
FOUNDATION_EXTERN NSString *const kNetworkParseResponseErrorMessage;

FOUNDATION_EXTERN NSString *const kNetworkBusinessErrorDataKey;
FOUNDATION_EXTERN NSString *const kNetworkErrorHttpStatusCodeKey;

FOUNDATION_EXTERN const NSInteger kNetworkNilResponseErrorCode;
FOUNDATION_EXTERN const NSInteger kNetworkParseResponseErrorCode;
FOUNDATION_EXTERN const NSInteger kNetworkBusinessErrorCode;
FOUNDATION_EXTERN const NSInteger kNetworkCommunitaionErrorCode;


@interface BaseRequest (NetworkManager)

@property (nonatomic, strong, readonly) id responseModel;

@property (nonatomic, strong, readonly) NSError *error;

@end

@interface NetworkManager : NSObject

+ (instancetype)sharedManager;

- (void)addRequest:(BaseRequest *)request;



@end

