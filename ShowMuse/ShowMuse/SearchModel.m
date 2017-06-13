//
//  SearchModel.m
//  ShowMuse
//
//  Created by show zh on 16/5/30.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = [dic[@"id"] intValue];
        self.title = dic[@"title"];
        self.premium = [dic[@"premium"] boolValue];
        self.isLockedToUser = [dic[@"isLockedToUser"] boolValue];
        self.isNew = [dic[@"isNew"] boolValue];
        self.thumb = dic[@"thumb"];
        self.viewsTotal = [dic[@"viewsTotal"] intValue];
        self.likesTotal = [dic[@"likesTotal"] intValue];
        self.commentsTotal = [dic[@"commentsTotal"] intValue];
        self.videoDurationTime = dic[@"videoDurationTime"];
        NSDictionary * teacher = dic[@"teacher"];
        self.teacher_ID = [teacher[@"id"] intValue];
        self.teacher_name = teacher[@"name"];
        self.teacher_avatar = teacher[@"avatar"];
        NSArray * userWatchStatArr = dic[@"userWatchStat"];
        NSDictionary *userWatchStatDic = userWatchStatArr[0];
        self.watchProgress = [userWatchStatDic[@"watchProgress"] intValue];
    }
    return self;
}



@end
