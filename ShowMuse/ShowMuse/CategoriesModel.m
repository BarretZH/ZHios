//
//  CategoriesModel.m
//  ShowMuse
//
//  Created by show zh on 16/6/20.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "CategoriesModel.h"

@implementation CategoriesModel
//编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.iconImg forKey:@"iconImg"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInt:self.ID forKey:@"ID"];
    [aCoder encodeInt:self.totalNew forKey:@"totalNew"];
}

//解码
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.iconImg = [[aDecoder decodeObjectForKey:@"iconImg"] copy];
        self.title = [[aDecoder decodeObjectForKey:@"title"] copy];
        self.ID = [aDecoder decodeIntForKey:@"ID"];
        self.totalNew = [aDecoder decodeIntForKey:@"totalNew"];
    }
    return self;
}


-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = [dic[@"id"] intValue];
        self.iconImg = dic[@"iconImg"];
        self.totalNew = [dic[@"totalNew"] intValue];
        self.title = dic[@"title"];
//        self.title = @"123456";
    }
    return self;
}

@end
