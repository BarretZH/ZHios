//
//  UserSubscriptionsModel.m
//  ShowMuse
//
//  Created by show zh on 16/5/25.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "UserSubscriptionsModel.h"

@implementation UserSubscriptionsModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.amount = [dic[@"amount"] intValue];
        self.currency = dic[@"currency"];
        self.createdAt = dic[@"createdAt"];
        self.title = dic[@"title"];
    }
    return self;
}



@end
