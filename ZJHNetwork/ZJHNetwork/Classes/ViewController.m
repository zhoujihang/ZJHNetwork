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
    
    
    for (int i=0; i<10; i++) {
        [self testBlock];
        [self testDelegate];
    }
}
- (void)testBlock{
    // 失败回调，无访问权限
    [[[AddressListRequest alloc] init] startWithSuccess:^(BaseRequest *request, id responseObject) {
        NSLog(@"address success obj:%@",responseObject);
    } failture:^(BaseRequest *request, NSError *error) {
        RequestErrorModel *errorModel = error.userInfo[kNetworkBusinessErrorDataKey];
        if (errorModel) {
            NSLog(@"address request error:%@",errorModel.message);
        }
    }];
}
- (void)testDelegate{
    // 能得到成功回调
    CityListRequest *req = [[CityListRequest alloc] init];
    req.delegate = self;
    [req start];
}

- (void)baseRequestDidFinishSuccess:(BaseRequest *)request{
    NSLog(@"citylist success:%@",request.responseModel);
}
- (void)baseRequestDidFinishFailture:(BaseRequest *)request{
    NSLog(@"citylist failture:%@",request.error);
}

@end
