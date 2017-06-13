//
//  Materials.m
//  ShowMuse
//
//  Created by show zh on 16/8/18.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "Materials.h"

@implementation Materials
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.url = dic[@"url"];
        self.title = dic[@"title"];
    }
    return self;
}

@end
