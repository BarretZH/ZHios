//
//  MyQusetionModel.m
//  ShowMuse
//
//  Created by show zh on 16/5/20.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "MyQusetionModel.h"

#import "MylessonRelatedCourses.h"

@implementation MyQusetionModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        NSDictionary * lessonDIC = dic[@"lesson"];
        self.progress = [dic[@"progress"] intValue];
        self.ID = [lessonDIC[@"id"] intValue];
        self.title = lessonDIC[@"title"];
        self.premium = [lessonDIC[@"premium"] boolValue];
        self.isLockedToUser = [lessonDIC[@"isLockedToUser"] boolValue];
        self.thumb = lessonDIC[@"thumb"];
        self.viewsTotal = [lessonDIC[@"viewsTotal"] intValue];
        self.likesTotal = [lessonDIC[@"likesTotal"] intValue];
        self.commentsTotal = [lessonDIC[@"commentsTotal"] intValue];
        self.isNew = [lessonDIC[@"isNew"] boolValue];
        self.videoWatchProgress = [lessonDIC[@"videoWatchProgress"] intValue];
        self.videoDurationTime = lessonDIC[@"videoDurationTime"];
        self.teacher_name = lessonDIC[@"teacher"][@"name"];
        self.teacher_avatar = lessonDIC[@"teacher"][@"avatar"];
        self.teacher_coverImg = lessonDIC[@"teacher"][@"coverImg"];
        self.teacher_id = [lessonDIC[@"teacher"][@"id"] intValue];
        self.relatedCourses = lessonDIC[@"relatedCourses"];
        self.relatedCoursesArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self.relatedCourses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MylessonRelatedCourses * model = [[MylessonRelatedCourses alloc] initWithDictionary:obj];
            [self.relatedCoursesArray addObject:model];
        }];
        NSArray * userWatchStatArr = lessonDIC[@"userWatchStat"];
        NSDictionary *userWatchStatDic = userWatchStatArr[0];
        self.watchProgress = [userWatchStatDic[@"watchProgress"] intValue];
    }
    return self;
}




@end
