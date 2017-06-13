//
//  Banners.m
//  ShowMuse
//
//  Created by show zh on 16/6/6.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "Banners.h"

@implementation Banners
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = [dic[@"id"] intValue];
        self.url = dic[@"url"];
        self.link = dic[@"link"];
        self.showTimer = [dic[@"showTimer"] intValue];
    }
    return self;
}

@end
