//
//  UserDetaModel.m
//  ShowMuse
//
//  Created by show zh on 16/5/25.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "UserDetaModel.h"

@implementation UserDetaModel
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.avatar = dic[@"avatar"];
        self.name = dic[@"name"];
        self.education = dic[@"education"];
        self.maritalStatus = dic[@"maritalStatus"];
        self.country = dic[@"country"];
        self.dateOfBirth = dic[@"dateOfBirth"];
        self.gender = [dic[@"gender"] intValue];
    }
    return self;
}

@end
