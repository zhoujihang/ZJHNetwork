//
//  HttpConnection.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/2.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "HttpConnection.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>
#import "NetworkConfig.h"


@implementation BaseRequest (HttpConnection)
static const char kBaseRequestConnectionKey;
- (HttpConnection *)connection
{
    return objc_getAssociatedObject(self, &kBaseRequestConnectionKey);
}

- (void)setConnection:(HttpConnection *)connection
{
    objc_setAssociatedObject(self, &kBaseRequestConnectionKey, connection, OBJC_ASSOCIATION_ASSIGN);
}

@end


@interface HttpConnection()

@property (nonatomic, strong, readwrite) BaseRequest *request;

@property (nonatomic, strong, readwrite) NSURLSessionDataTask *task;

@property (nonatomic, copy) CompletionBlock completion;

@end

@implementation HttpConnection

+ (instancetype)connection{
    return [[self alloc] init];
}

- (NSDictionary *)headersWithRequest:(BaseRequest *)request{
    NetworkConfig *config = [NetworkConfig defaultConfig];
    
    NSMutableDictionary *headers = [@{} mutableCopy];
    [config.fixedHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [headers setObject:obj forKey:key];
    }];
    [request.headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [headers setObject:obj forKey:key];
    }];
    return headers;
}

- (void)connectWithRequest:(BaseRequest *)request completionBlock:(CompletionBlock)completion{
    self.request = request;
    self.completion = completion;
    
    NetworkConfig *defaultConfig = [NetworkConfig defaultConfig];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    // request
    if (request.requestSerializerType == BaseRequestSerializerTypeHttp) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }else if(request.requestSerializerType == BaseRequestSerializerTypeJson){
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    manager.requestSerializer.timeoutInterval = request.timeoutInterval ?: defaultConfig.defaultTimeoutInterval ?: 30;
    NSDictionary *headers = [self headersWithRequest:request];
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && [obj isKindOfClass:[NSString class]]) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }else{
            NSLog(@"error request header");
        }
    }];
    
    // response
    if (request.responseSerializerType == BaseResponseSerializerTypeHttp) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }else if(request.responseSerializerType == BaseResponseSerializerTypeJson){
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    NSIndexSet *acceptableStatusCodes = request.acceptableStatusCodes ?: defaultConfig.defaultAcceptableStatusCodes;
    if (acceptableStatusCodes) {
        manager.responseSerializer.acceptableStatusCodes = acceptableStatusCodes;
    }
    NSSet *acceptableContentTypes = request.acceptableContentTypes ?: defaultConfig.defaultAcceptableContentTypes;
    if (acceptableContentTypes) {
        manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    }
    
    NSString *urlString = [NSURL URLWithString:request.requestUrl relativeToURL:[NSURL URLWithString:request.requestBaseUrl]].absoluteString;
    NSDictionary *parameters = request.parameters;
    NSURLSessionDataTask *task = nil;
    switch (request.method) {
        case BaseRequestMethodGet:{
            task = [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestHandleSuccess:request responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestHandleFailture:request error:error];
            }];
        } break;
        case BaseRequestMethodPost:{
            if (request.construction) {
                task = [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    request.construction(formData);
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    if (request.uploadProgress) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            request.uploadProgress(uploadProgress);
                        });
                    }
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self requestHandleSuccess:request responseObject:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self requestHandleFailture:request error:error];
                }];
            }else{
                task = [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self requestHandleSuccess:request responseObject:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self requestHandleFailture:request error:error];
                }];
            }
        } break;
        default:{
            NSLog(@"unsupport request method");
        } break;
    }
    self.task = task;
    request.connection = self;
}

- (void)requestHandleSuccess:(BaseRequest *)request responseObject:(id)object{
    if (self.completion) {
        self.completion(self, object, nil);
    }
}
- (void)requestHandleFailture:(BaseRequest *)request error:(NSError *)error{
    if (self.completion) {
        self.completion(self, nil, error);
    }
}

- (void)cancel{
    if (self.task) {
        [self.task cancel];
        self.task = nil;
    }
}

@end



