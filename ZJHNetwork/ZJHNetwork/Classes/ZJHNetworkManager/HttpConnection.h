//
//  HttpConnection.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/2.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@class HttpConnection;

typedef void(^CompletionBlock)(HttpConnection *connection, id responseJsonObject, NSError *error);

@interface BaseRequest (HttpConnection)

@property (nonatomic, assign, readonly) HttpConnection *connection;

@end

@interface HttpConnection : NSObject

@property (nonatomic, strong, readonly) BaseRequest *request;

@property (nonatomic, strong, readonly) NSURLSessionDataTask *task;

+ (instancetype)connection;

- (void)connectWithRequest:(BaseRequest *)request completionBlock:(CompletionBlock)completion;

- (void)cancel;

@end


