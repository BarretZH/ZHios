//
//  Courses.m
//  ShowMuse
//
//  Created by show zh on 16/5/10.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "Courses.h"

@implementation Courses

- (NSMutableArray *)lessonGroups
{
    if (!_lessonGroups) {
        _lessonGroups = [NSMutableArray array];
    }
    return _lessonGroups;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self=[super init];
    if (self) {
        self.ID = dict[@"id"];
        self.title = dict[@"title"];
        self.introduction = dict[@"introduction"];
        self.coverImg = dict[@"coverImg"];
        self.isNew = [dict[@"isNew"] boolValue];
        self.isNewTitle = dict[@"isNewTitle"];
        self.totalStudentsTitle = dict[@"totalStudentsTitle"];
    }
    return self;
}

+ (instancetype)courseWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

@end
