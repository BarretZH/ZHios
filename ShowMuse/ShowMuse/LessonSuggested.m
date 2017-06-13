//
//  LessonSuggested.m
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "LessonSuggested.h"

@implementation LessonSuggested

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = [dic[@"id"] intValue];
        self.title = dic[@"title"];
        self.thumb = dic[@"thumb"];
        self.premium = [dic[@"premium"] boolValue];
        self.isLockedToUser = [dic[@"isLockedToUser"] boolValue];
    }
    return self;
}

@end
