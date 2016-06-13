//
//  ZJHHttpConnection.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/2.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "ZJHHttpConnection.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>
#import "ZJHNetworkConfig.h"


@implementation ZJHBaseRequest (ZJHHttpConnection)
static const char kBaseRequestConnectionKey;
- (ZJHHttpConnection *)connection
{
    return objc_getAssociatedObject(self, &kBaseRequestConnectionKey);
}

- (void)setConnection:(ZJHHttpConnection *)connection
{
    objc_setAssociatedObject(self, &kBaseRequestConnectionKey, connection, OBJC_ASSOCIATION_ASSIGN);
}

@end


@interface ZJHHttpConnection()

@property (nonatomic, strong, readwrite) ZJHBaseRequest *request;

@property (nonatomic, strong, readwrite) NSURLSessionDataTask *task;

@property (nonatomic, copy) ConnectionSuccessBlock success;

@property (nonatomic, copy) ConnectionFailtureBlock failture;

@end

@implementation ZJHHttpConnection

+ (instancetype)connection{
    return [[self alloc] init];
}

- (NSDictionary *)headersWithRequest:(ZJHBaseRequest *)request{
    ZJHNetworkConfig *config = [ZJHNetworkConfig defaultConfig];
    
    NSMutableDictionary *headers = [@{} mutableCopy];
    [config.additionalHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [headers setObject:obj forKey:key];
    }];
    [request.headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [headers setObject:obj forKey:key];
    }];
    return headers;
}

- (void)connectWithRequest:(ZJHBaseRequest *)request success:(ConnectionSuccessBlock)success failture:(ConnectionFailtureBlock)failture{
    self.request = request;
    self.success = success;
    self.failture = failture;
    
    ZJHNetworkConfig *defaultConfig = [ZJHNetworkConfig defaultConfig];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    // request
    if (request.requestSerializerType == ZJHBaseRequestSerializerTypeHttp) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }else if(request.requestSerializerType == ZJHBaseRequestSerializerTypeJson){
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
    if (request.responseSerializerType == ZJHBaseResponseSerializerTypeHttp) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }else if(request.responseSerializerType == ZJHBaseResponseSerializerTypeJson){
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
        case ZJHBaseRequestMethodGet:{
            task = [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestHandleSuccess:request responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestHandleFailture:request error:error];
            }];
        } break;
        case ZJHBaseRequestMethodPost:{
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

- (void)requestHandleSuccess:(ZJHBaseRequest *)request responseObject:(id)object{
    if (self.success) {
        self.success(self, object);
    }
}
- (void)requestHandleFailture:(ZJHBaseRequest *)request error:(NSError *)error{
    if (self.failture) {
        self.failture(self, error);
    }
}

- (void)cancel{
    if (self.task) {
        [self.task cancel];
        self.task = nil;
    }
}

@end



