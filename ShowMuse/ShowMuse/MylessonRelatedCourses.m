//
//  MylessonRelatedCourses.m
//  ShowMuse
//
//  Created by show zh on 16/5/20.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "MylessonRelatedCourses.h"

@implementation MylessonRelatedCourses

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = [dic[@"id"] intValue];
        self.title = dic[@"title"];
    }
    return self;
}



@end
