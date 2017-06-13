//
//  SMCourseLesson.m
//  ShowMuse
//
//  Created by liuyonggang on 8/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import "SMCourseLesson.h"

@implementation SMCourseLesson

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.commentsTotal = [dict[@"commentsTotal"] integerValue];
        self.ID = [dict[@"id"] integerValue];
        self.lockedToUser = [dict[@"isLockedToUser"] boolValue];
        self.isNew = [dict[@"isNew"] boolValue];
        self.likesTotal = [dict[@"likesTotal"] integerValue];
        self.premium = [dict[@"premium"] boolValue];
        self.thumb = dict[@"thumb"];
        self.title = dict[@"title"];
        self.videoDurationTime = dict[@"videoDurationTime"];
        self.viewsTotal = [dict[@"viewsTotal"] integerValue];
        NSArray *userWatchStat = dict[@"userWatchStat"];
        NSDictionary * userWatchStatDict = userWatchStat[0];
        self.watchProgress = [userWatchStatDict[@"watchProgress"] intValue];
    }
    return self;
}

+ (instancetype)lessonWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
