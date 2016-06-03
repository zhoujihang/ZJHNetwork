//
//  NetworkManager.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/5/31.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "NetworkConfig.h"
#import "HttpConnection.h"
#import <MJExtension/MJExtension.h>

NSString * const kNetworkErrorDomain = @"com.ayibang.client.error.network";
NSString * const kNetworkParseResponseErrorMessage = @"Parse Response Error:%@.";

NSString * const kNetworkBusinessErrorDataKey = @"kNetworkBusinessErrorDataKey";
NSString * const kNetworkErrorHttpStatusCodeKey = @"kNetworkErrorHttpStatusCodeKey";

const NSInteger kNetworkNilResponseErrorCode = 1;
const NSInteger kNetworkParseResponseErrorCode = 2;
const NSInteger kNetworkBusinessErrorCode = 3;

static const NSInteger kAuthenticationFailHttpStatusCode = 401;
static const NSString *kNetworkErrorTipMessage = @"网络错误";


@implementation BaseRequest (NetworkManager)
static const char kBaseRequestResponseModelKey;
- (id)responseModel{
    return objc_getAssociatedObject(self, &kBaseRequestResponseModelKey);
}
- (void)setResponseModel:(id)responseModel{
    objc_setAssociatedObject(self, &kBaseRequestResponseModelKey, responseModel, OBJC_ASSOCIATION_RETAIN);
}
static const char kBaseRequestErrorKey;
- (NSError *)error{
    return objc_getAssociatedObject(self, &kBaseRequestErrorKey);
}
- (void)setError:(NSError *)error{
    objc_setAssociatedObject(self, &kBaseRequestErrorKey, error, OBJC_ASSOCIATION_RETAIN);
}
@end



@implementation NetworkManager

+ (instancetype)sharedManager{
    static NetworkManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (void)addRequest:(BaseRequest *)request{
    __weak typeof(self) weakSelf = self;
    [[HttpConnection connection] connectWithRequest:request completionBlock:^(HttpConnection *connection, id responseJsonObject, NSError *error) {
        if (responseJsonObject) {
            [weakSelf processConnection:connection withResponseJsonObject:responseJsonObject];
        }else{
            [weakSelf processConnection:connection withError:error];
        }
    }];
}
#pragma mark - 处理网络返回数据
- (void)processConnection:(HttpConnection *)connection withResponseJsonObject:(id)responseJsonObjet{
    BaseRequest *request = connection.request;
    
    NSError *error = [self processRequest:request withResponseJsonObject:responseJsonObjet];
    if (error) {
        request.error = error;
        [self callbackRequestFailture:request];
        return;
    }
    
    [self callbackRequestSuccess:request];
}
// 处理json对象为模型对象
- (NSError *)processRequest:(BaseRequest *)request withResponseJsonObject:(id)responseJsonObject{
    NSError *error = nil;
    id responseModel = nil;
    Class responseModelClass = request.responseModelClass;
    
    if (responseModelClass == nil) {
        request.responseModel = responseJsonObject;
        return nil;
    }
    
    if ([responseJsonObject isKindOfClass:[NSString class]]) {
        if ([responseModelClass isSubclassOfClass:[NSString class]]) {
            responseModel = responseJsonObject;
        }else{
            responseModel = [responseModelClass mj_objectWithKeyValues:responseJsonObject];
        }
    }else if ([responseJsonObject isKindOfClass:[NSDictionary class]]) {
        if ([responseModelClass isSubclassOfClass:[NSDictionary class]]) {
            responseModel = responseJsonObject;
        }else{
            responseModel = [responseModelClass mj_objectWithKeyValues:responseJsonObject];
        }
    }else if([responseJsonObject isKindOfClass:[NSArray class]]){
        if ([responseModelClass isSubclassOfClass:[NSArray class]]) {
            responseModel = responseJsonObject;
        }else{
            responseModel = [[responseModelClass mj_objectArrayWithKeyValuesArray:responseJsonObject] copy];;
        }
    }
    request.responseModel = responseModel;
    
    if (!responseModel) {
        // 解析失败
        NSMutableDictionary *userInfo = [@{
                       NSLocalizedDescriptionKey : [NSString stringWithFormat:kNetworkParseResponseErrorMessage,NSStringFromClass(responseModelClass)],
                       kNetworkErrorHttpStatusCodeKey : @(request.responseStatusCode)
                                   } mutableCopy];
        if (responseJsonObject) {
            userInfo[kNetworkBusinessErrorDataKey] = responseJsonObject;
        }
        NSError *parseError = [NSError errorWithDomain:kNetworkErrorDomain code:kNetworkParseResponseErrorCode userInfo:userInfo];
        error = parseError;
    }
    request.error = error;

    return error;
}
- (void)processConnection:(HttpConnection *)connection withError:(NSError *)error{
    BaseRequest *request = connection.request;
    
    NSInteger httpStatusCode = request.responseStatusCode;
    NSError *customError = [self createCustomErrorFromAFNError:error statusCode:httpStatusCode];
    request.error = customError;
    
    NSDictionary *userInfo = customError.userInfo;
    RequestErrorModel *errorModel = userInfo[kNetworkBusinessErrorDataKey];
    if (customError.code == kAuthenticationFailHttpStatusCode && [errorModel isKindOfClass:[RequestErrorModel class]]) {
        // 遇到401 自动刷新token
        
        
        
        
        return;
    }
    
    
    [self callbackRequestFailture:request];
}
- (NSError *)createCustomErrorFromAFNError:(NSError *)afnError statusCode:(NSInteger )statusCodes{
    NSError *error = nil;
    
    NSMutableDictionary *userInfo = [@{} mutableCopy];
    userInfo[kNetworkErrorHttpStatusCodeKey] = @(statusCodes);
    
    if (!afnError) {
        // 空返回
        userInfo[NSLocalizedDescriptionKey] = @"nil response error";
        error = [NSError errorWithDomain:kNetworkErrorDomain code:kNetworkNilResponseErrorCode userInfo:userInfo];
        return error;
    }
    
    // 后台错误
    NSData *responseErrorData = afnError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (responseErrorData && [responseErrorData isKindOfClass:[NSData class]]) {
        NSDictionary *responseErrorJsonObject = [NSJSONSerialization JSONObjectWithData:responseErrorData options:NSJSONReadingMutableContainers error:NULL];
        if (responseErrorJsonObject && [responseErrorJsonObject isKindOfClass:[NSDictionary class]]) {
            id businessErrorJsonObject = responseErrorJsonObject[@"error"];
            RequestErrorModel *errorModel = [RequestErrorModel mj_objectWithKeyValues:businessErrorJsonObject];
            if (errorModel) {
                userInfo[kNetworkBusinessErrorDataKey] = errorModel;
                userInfo[NSLocalizedDescriptionKey] = errorModel.message;
                error = [NSError errorWithDomain:kNetworkErrorDomain code:kNetworkBusinessErrorCode userInfo:userInfo];
                return error;
            }
        }
    }
    
    error = afnError;
    return error;
}
#pragma mark - 统一回调
- (void)callbackRequestSuccess:(BaseRequest *)request{
    if (request.success) {
        request.success(request,request.responseModel);
    }
    if ([request.delegate respondsToSelector:@selector(baseRequestSuccess:)]) {
        [request.delegate baseRequestSuccess:request];
    }
    [self clearRequestBlock:request];
}

- (void)callbackRequestFailture:(BaseRequest *)request{
    [self handleCommonRequestFailture:request];
    
    if (request.failture) {
        request.failture(request,request.error);
    }
    if ([request.delegate respondsToSelector:@selector(baseRequestFailture:)]) {
        [request.delegate baseRequestFailture:request];
    }
    [self clearRequestBlock:request];
}
- (void)handleCommonRequestFailture:(BaseRequest *)request{
    // 提示错误
    NSError *error = request.error;
    NSDictionary *userInfo = error.userInfo;
    RequestErrorModel *errorModel = userInfo[kNetworkBusinessErrorDataKey];
    if (![errorModel isKindOfClass:[RequestErrorModel class]]) {
        NSLog(@"%@",error);
    }
    
    
}

- (void)clearRequestBlock:(BaseRequest *)request{
    request.success = nil;
    request.failture = nil;
    request.construction = nil;
    request.uploadProgress = nil;
}

@end


