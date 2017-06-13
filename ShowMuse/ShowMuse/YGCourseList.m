//
//  YGCourseList.m
//  ShowMusePlanB
//
//  Created by liuyonggang on 16/5/2016.
//  Copyright © 2016 liuyonggang. All rights reserved.
//

#import "YGCourseList.h"
#import "SMWatchState.h"

@implementation YGCourseList

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.ID = [dict[@"id"] integerValue];
        self.title = dict[@"title"];
        self.thumb = dict[@"thumb"];
        self.viewsTotal = [dict[@"viewsTotal"] integerValue];
        self.videoDurationTime = dict[@"videoDurationTime"];
        self.isLockedToUser = [dict[@"isLockedToUser"] boolValue];
        self.newCourse = [dict[@"isNew"] boolValue];
        self.premium = [dict[@"premium"] boolValue];
        self.commentsTotal = [dict[@"commentsTotal"] integerValue];
        self.likesTotal = [dict[@"likesTotal"] integerValue];
        self.videoWatchProgress = [dict[@"videoWatchProgress"] integerValue];
        self.watchState = [SMWatchState stateWithDict:dict[@"userWatchStat"][0]];
    }
    
    return self;
}

+ (instancetype)listWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
