//
//  SMLessonGroup.m
//  ShowMuse
//
//  Created by liuyonggang on 8/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import "SMLessonGroup.h"

@implementation SMLessonGroup

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.title = dict[@"title"];
        self.totalLessons = [dict[@"totalLessons"] integerValue];
    }
    return self;
}

+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
