//
//  PopupModel.m
//  ShowMuse
//
//  Created by show zh on 16/6/12.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "PopupModel.h"
@implementation PopupModel

- (instancetype)initWithDictionary:(NSDictionary* )dictionary {
    if (self = [super init]) {
        self.contentType = dictionary[@"contentType"];
        self.content = dictionary[@"content"];
    }
    return self;
    
}

+ (instancetype)PopupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

@end
