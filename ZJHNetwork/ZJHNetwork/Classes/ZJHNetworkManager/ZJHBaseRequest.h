//
//  ZJHBaseRequest.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/5/31.
//  Copyright © 2016年 zjh. All rights reserved.
//

// 此类封装请求参数与返回结果，结果可转为model，也可直接使用字典

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class ZJHBaseRequest;

typedef NS_ENUM(NSUInteger, ZJHBaseRequestMethod) {
    ZJHBaseRequestMethodGet,
    ZJHBaseRequestMethodPost
};

typedef NS_ENUM(NSUInteger, ZJHBaseRequestSerializerType) {
    ZJHBaseRequestSerializerTypeHttp,
    ZJHBaseRequestSerializerTypeJson,
};

typedef NS_ENUM(NSUInteger, ZJHBaseResponseSerializerType) {
    ZJHBaseResponseSerializerTypeHttp,
    ZJHBaseResponseSerializerTypeJson,
};

typedef void(^SuccessBlock)(ZJHBaseRequest *request,id responseObject);
typedef void(^FailtureBlock)(ZJHBaseRequest *request,NSError *error);
typedef void(^ConstructionBlock)(id<AFMultipartFormData> formData);
typedef void(^UploadProgressBlock)(NSProgress *progress);

@protocol BaseRequestDelegate <NSObject>

- (void)baseRequestDidFinishSuccess:(ZJHBaseRequest *)request;
- (void)baseRequestDidFinishFailture:(ZJHBaseRequest *)request;

@end

@interface ZJHBaseRequest : NSObject

// status
@property (nonatomic, assign, getter=isRunning) BOOL running;
@property (nonatomic, assign, getter=isCancelling) BOOL cancelling;
// request config
@property (nonatomic, assign) ZJHBaseRequestMethod method;

@property (nonatomic, copy) NSString *requestBaseUrl;

@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, copy) NSDictionary *parameters;

@property (nonatomic, copy) NSDictionary *headers;

@property (nonatomic, assign) ZJHBaseRequestSerializerType requestSerializerType;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, strong, readonly) NSURL *url;

// response
@property (nonatomic, assign) ZJHBaseResponseSerializerType responseSerializerType;

@property (nonatomic, copy) NSIndexSet *acceptableStatusCodes;

@property (nonatomic, copy) NSSet<NSString *> *acceptableContentTypes;

@property (nonatomic, assign, readonly) NSInteger responseStatusCode;

@property (nonatomic, copy, readonly) NSDictionary *responseHeaders;

@property (nonatomic, strong) Class responseModelClass;

// callback
@property (nonatomic, copy) SuccessBlock success;
@property (nonatomic, copy) FailtureBlock failture;
@property (nonatomic, copy) ConstructionBlock construction;
@property (nonatomic, copy) UploadProgressBlock uploadProgress;
@property (nonatomic, weak) id<BaseRequestDelegate> delegate;

// function
- (void)start;
- (void)startWithSuccess:(SuccessBlock)success failture:(FailtureBlock)failture;
- (void)startWithSuccess:(SuccessBlock)success failture:(FailtureBlock)failture construction:(ConstructionBlock)construction uploadProgress:(UploadProgressBlock)uploadProgress;
- (void)cancel;
@end
