//
//  RequestErrorModel.h
//  ZJHNetwork
//
//  Created by 周际航 on 16/6/2.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "BaseModel.h"

@interface RequestErrorModel : BaseModel

@property (nonatomic) NSInteger code;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *prompt_info;
@property (nonatomic,copy) NSString *prompt_type;
@property (nonatomic) NSInteger sub_code;
@property (nonatomic,copy) NSString *type;

@end
