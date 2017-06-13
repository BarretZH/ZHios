//
//  UserBadgesModel.m
//  ShowMuse
//
//  Created by show zh on 16/5/30.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "UserBadgesModel.h"

@implementation UserBadgesModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = [dic[@"id"] intValue];
        self.courseID = [dic[@"courseId"] intValue];
        self.name = dic[@"name"];
        self.descriptionStr = dic[@"description"];
        self.img = dic[@"img"];
        self.progress = [dic[@"progress"] intValue];
        self.progressTitle = dic[@"progressTitle"];
        self.isFinished = [dic[@"isFinished"] boolValue];
        self.gotoUrl = dic[@"gotoUrl"];
        self.gotoUrlTitle = dic[@"gotoUrlTitle"];
        self.progressDescription = dic[@"progressDescription"];
        self.teacherID = [dic[@"teacherId"] intValue];
        self.progressPopupBtnTitle = dic[@"progressPopupBtnTitle"];
    }
    return self;
}

@end
