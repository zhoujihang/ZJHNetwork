//
//  ViewController.m
//  ZJHNetwork
//
//  Created by 周际航 on 16/5/31.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "ViewController.h"
#import "RequestHeadTool.h"
#import "NetworkConfig.h"
#import "CityListRequest.h"
#import "AddressListRequest.h"
#import "RequestErrorModel.h"
#import "NetworkManager.h"

@interface ViewController ()<BaseRequestDelegate>

@property (nonatomic, weak) CityListRequest *req;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testBlock];
//    [self testDelegate];
}
- (void)testBlock{
    [[[AddressListRequest alloc] init] startWithSuccess:^(BaseRequest *request, id responseObject) {
        NSLog(@"zjh success obj:%@",responseObject);
    } failture:^(BaseRequest *request, NSError *error) {
        RequestErrorModel *errorModel = error.userInfo[kNetworkBusinessErrorDataKey];
        if (errorModel) {
            NSLog(@"request error:%@",errorModel.message);
        }
    }];
}
- (void)testDelegate{
    CityListRequest *req = [[CityListRequest alloc] init];
    req.delegate = self;
    [req start];
}

- (void)baseRequestSuccess:(BaseRequest *)request{
    NSLog(@"zjh success:%@",request.responseModel);
}
- (void)baseRequestFailture:(BaseRequest *)request{
    NSLog(@"zjh failture:%@",request.error);
}

@end
