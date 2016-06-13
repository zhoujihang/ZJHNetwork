//
//  HttpConnection.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/2.
//  Copyright © 2016年 zjh. All rights reserved.
//

// 此类解析BaseRequest的内容，与网络直接通讯，并返回结果，不处理业务逻辑

#import <Foundation/Foundation.h>
#import "ZJHBaseRequest.h"

@class ZJHHttpConnection;

typedef void(^ConnectionSuccessBlock)(ZJHHttpConnection *connection, id responseJsonObject);
typedef void(^ConnectionFailtureBlock)(ZJHHttpConnection *connection, NSError *error);

@interface ZJHBaseRequest (ZJHHttpConnection)

@property (nonatomic, assign, readonly) ZJHHttpConnection *connection;

@end

@interface ZJHHttpConnection : NSObject

@property (nonatomic, strong, readonly) ZJHBaseRequest *request;

@property (nonatomic, strong, readonly) NSURLSessionDataTask *task;

+ (instancetype)connection;

- (void)connectWithRequest:(ZJHBaseRequest *)request success:(ConnectionSuccessBlock)success failture:(ConnectionFailtureBlock)failture;

- (void)cancel;

@end


