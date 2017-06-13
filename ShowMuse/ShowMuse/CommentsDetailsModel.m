//
//  CommentsDetailsModel.m
//  ShowMuse
//
//  Created by show zh on 16/5/18.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "CommentsDetailsModel.h"

@implementation CommentsDetailsModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = [dic[@"id"] intValue];
        self.body = dic[@"body"];
        self.createdAt = dic[@"createdAt"];
        self.state = [dic[@"state"] intValue];
        self.user_ID = [dic[@"user"][@"id"] intValue];
        self.user_name = dic[@"user"][@"name"];
        self.user_avatar = dic[@"user"][@"avatar"];
    }
    return self;
}



@end
