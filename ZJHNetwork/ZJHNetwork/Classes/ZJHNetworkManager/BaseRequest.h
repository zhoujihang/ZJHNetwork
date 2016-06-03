//
//  BaseRequest.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/5/31.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class BaseRequest;

typedef NS_ENUM(NSUInteger, BaseRequestMethod) {
    BaseRequestMethodGet,
    BaseRequestMethodPost,
    BaseRequestMethodHead,
    BaseRequestMethodDelete,
    BaseRequestMethodPut,
    BaseRequestMethodPatch,
};

typedef NS_ENUM(NSUInteger, BaseRequestSerializerType) {
    BaseRequestSerializerTypeHttp,
    BaseRequestSerializerTypeJson,
};

typedef NS_ENUM(NSUInteger, BaseResponseSerializerType) {
    BaseResponseSerializerTypeHttp,
    BaseResponseSerializerTypeJson,
};

typedef void(^SuccessBlock)(BaseRequest *request,id responseObject);
typedef void(^FailtureBlock)(BaseRequest *request,NSError *error);
typedef void(^ConstructionBlock)(id<AFMultipartFormData> formData);
typedef void(^UploadProgressBlock)(NSProgress *progress);

@protocol BaseRequestDelegate <NSObject>

- (void)baseRequestSuccess:(BaseRequest *)request;
- (void)baseRequestFailture:(BaseRequest *)request;

@end

@interface BaseRequest : NSObject

// status
@property (nonatomic, assign, getter=isRunning) BOOL running;
@property (nonatomic, assign, getter=isCancelling) BOOL cancelling;
// request config
@property (nonatomic, assign) BaseRequestMethod method;

@property (nonatomic, copy) NSString *requestBaseUrl;

@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, copy) NSDictionary *parameters;

@property (nonatomic, copy) NSDictionary *headers;

@property (nonatomic, assign) BaseRequestSerializerType requestSerializerType;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, strong) NSURL *url;

// response
@property (nonatomic, assign) BaseResponseSerializerType responseSerializerType;

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
- (void)cancel;
- (void)startWithSuccess:(SuccessBlock)success failture:(FailtureBlock)failture construction:(ConstructionBlock)construction uploadProgress:(UploadProgressBlock)uploadProgress;
@end
