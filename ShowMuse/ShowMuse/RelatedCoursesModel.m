//
//  RelatedCoursesModel.m
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "RelatedCoursesModel.h"

@implementation RelatedCoursesModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = [dic[@"id"] intValue];
        self.title = dic[@"title"];
        self.introduction = dic[@"introduction"];
    }
    return self;
}

@end
