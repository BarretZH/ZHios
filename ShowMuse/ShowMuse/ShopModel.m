//
//  ShopModel.m
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = dic[@"id"];
        self.price = [dic[@"price"] intValue];
        self.currency = dic[@"currency"];
        self.title = dic[@"title"];
    }
    return self;
}



@end
