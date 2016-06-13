//
//  RequestHeadTool.h
//  Ayibang
//
//  Created by 小胖的Mac on 15/12/24.
//  Copyright © 2015年 ayibang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RequestHeadTool : NSObject
/**
 *  网络请求的请求头
 *
 *  @return dic
 */
+ (NSDictionary*)getRequestHead;
@end
