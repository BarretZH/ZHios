//
//  SearchTeacherModel.m
//  ShowMuse
//
//  Created by show zh on 16/7/12.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "SearchTeacherModel.h"

@implementation SearchTeacherModel
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = [dic[@"id"] intValue];
        self.name = dic[@"name"];
        self.introduction = dic[@"introduction"];
        self.avatar = dic[@"avatar"];
        self.coverImg = dic[@"coverImg"];
        self.isFavourite = [dic[@"isFavourite"] boolValue];
    }
    return self;
}

@end
