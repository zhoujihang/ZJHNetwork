//
//  BaseRequest.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/5/31.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "BaseRequest.h"
#import "NetworkManager.h"
#import "HttpConnection.h"

@interface BaseRequest()



@end

@implementation BaseRequest

// request config
- (BaseRequestMethod)method{
    return BaseRequestMethodGet;
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
- (BaseRequestSerializerType)requestSerializerType{
    return BaseRequestSerializerTypeHttp;
}
- (NSTimeInterval)timeoutInterval{
    return 25;
}
- (BaseResponseSerializerType)responseSerializerType{
    return BaseResponseSerializerTypeJson;
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
    [[NetworkManager sharedManager] addRequest:self];
}
- (void)startWithSuccess:(SuccessBlock)success failture:(FailtureBlock)failture{
    self.success = [success copy];
    self.failture = [failture copy];
    
    [self start];
}
- (void)startWithSuccess:(SuccessBlock)success failture:(FailtureBlock)failture construction:(ConstructionBlock)construction uploadProgress:(UploadProgressBlock)uploadProgress{
    self.construction = construction;
    self.uploadProgress = uploadProgress;
    
    [self startWithSuccess:success failture:failture];
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
