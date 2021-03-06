//
//  ZJHBaseRequest.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/5/31.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "ZJHBaseRequest.h"
#import "ZJHNetworkManager.h"
#import "ZJHHttpConnection.h"

@interface ZJHBaseRequest()



@end

@implementation ZJHBaseRequest

// request config
- (ZJHBaseRequestMethod)method{
    return ZJHBaseRequestMethodGet;
}
- (NSString *)requestBaseUrl{
    return @"";
}
- (NSString *)requestUrl{
    return @"";
}
- (NSDictionary *)headers{
    return @{};
}
- (ZJHBaseRequestSerializerType)requestSerializerType{
    return ZJHBaseRequestSerializerTypeHttp;
}
- (NSTimeInterval)timeoutInterval{
    return 25;
}
- (ZJHBaseResponseSerializerType)responseSerializerType{
    return ZJHBaseResponseSerializerTypeJson;
}
- (NSURL *)url{
    NSString *urlString = self.requestUrl;
    if (self.requestBaseUrl.length > 0) {
        urlString = [NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString:self.requestBaseUrl]].absoluteString;
    }
    
    if (self.parameters.count > 0) {
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        NSURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:self.parameters error:NULL];
        urlString = request.URL.absoluteString;
    }
    return [NSURL URLWithString:urlString];
}

// response
- (NSInteger)responseStatusCode{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.connection.task.response;
    return response.statusCode;
}
- (NSDictionary *)responseHeaders{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.connection.task.response;
    return response.allHeaderFields;
}
// function
- (void)start{
    if (self.running) {return;}
    
    self.running = YES;
    [[ZJHNetworkManager sharedManager] addRequest:self];
}
- (void)startWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure{
    self.success = [success copy];
    self.failure = [failure copy];
    
    [self start];
}
- (void)startWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure construction:(ConstructionBlock)construction uploadProgress:(UploadProgressBlock)uploadProgress{
    self.construction = construction;
    self.uploadProgress = uploadProgress;
    
    [self startWithSuccess:success failure:failure];
}

- (void)cancel{
    if (self.cancelling) {return;}
    self.cancelling = YES;
    if (self.connection) {
        [self.connection cancel];
    }
    self.cancelling = NO;
}



@end
