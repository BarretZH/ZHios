//
//  SMCourseLessonGroup.m
//  ShowMuse
//
//  Created by liuyonggang on 8/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import "SMCourseLessonGroup.h"

@implementation SMCourseLessonGroup

- (NSMutableArray *)lessonModelsArr
{
    if (!_lessonModelsArr) {
        _lessonModelsArr = [NSMutableArray array];
    }
    return _lessonModelsArr;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.ID = [dict[@"id"] integerValue];
        self.title = dict[@"title"];
        self.thumb = dict[@"thumb"];
        self.lessonsArr = dict[@"lessons"];
    }
    
    return self;
}

+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
