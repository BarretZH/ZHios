//
//  SMCourseTeacher.m
//  ShowMuse
//
//  Created by liuyonggang on 8/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import "SMCourseTeacher.h"

@implementation SMCourseTeacher

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.avatar = dict[@"avatar"];
        self.name = dict[@"name"];
    }
    
    return self;
}

+ (instancetype)teacherWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
