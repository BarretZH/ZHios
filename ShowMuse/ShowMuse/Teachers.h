//
//  Teachers.h
//  ShowMuse
//
//  Created by show zh on 16/5/7.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Teachers : NSObject<NSCoding>

@property (nonatomic,copy) NSString * ID, * name, * introduction ,* avatar ,* coverImg ,* badgeimg;

@property (nonatomic) BOOL isFavourite, isBadges;


-(instancetype)initWithDictionary:(NSDictionary *)dic;


@end
