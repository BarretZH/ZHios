//
//  Teachers.m
//  ShowMuse
//
//  Created by show zh on 16/5/7.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "Teachers.h"

@implementation Teachers
//编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.badgeimg forKey:@"badgeimg"];
    [aCoder encodeObject:self.introduction forKey:@"introduction"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.coverImg forKey:@"coverImg"];
    [aCoder encodeBool:self.isFavourite forKey:@"isFavourite"];
    [aCoder encodeBool:self.isBadges forKey:@"isBadges"];
}

//解码
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [[aDecoder decodeObjectForKey:@"ID"] copy];
        self.name = [[aDecoder decodeObjectForKey:@"name"] copy];
        self.badgeimg = [[aDecoder decodeObjectForKey:@"badgeimg"] copy];
        self.introduction = [[aDecoder decodeObjectForKey:@"introduction"] copy];
        self.avatar = [[aDecoder decodeObjectForKey:@"avatar"] copy];
        self.coverImg = [[aDecoder decodeObjectForKey:@"coverImg"] copy];
        self.isFavourite = [aDecoder decodeBoolForKey:@"isFavourite"];
        self.isBadges = [aDecoder decodeBoolForKey:@"isBadges"];
    }
    return self;
}



-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = dic[@"id"];
        self.name = dic[@"name"];
        self.introduction = dic[@"introduction"];
        self.avatar = dic[@"avatar"];
        self.coverImg = dic[@"coverImg"];
        self.isFavourite = [dic[@"isFavourite"] boolValue];
        NSArray * badges = dic[@"badges"];
        
        if (badges.count > 0) {
            NSDictionary * badgeDic = badges[0];
            self.badgeimg = badgeDic[@"img"];
            self.isBadges = YES;
            
        }else {
            self.isBadges = NO;
        }
//        SMLog(@"/**///***/*/%@",dic[@"badges"]);
    }
    return self;
}




@end
