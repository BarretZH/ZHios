//
//  SMVideoQuestion.m
//  ShowMuse
//
//  Created by liuyonggang on 6/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import "SMVideoQuestion.h"

@implementation SMVideoQuestion

//- (instancetype)initWithDict:(NSDictionary *)dict
//{
//    if (self = [super init]) {
//        self.url = dict[@"url"];
//        self.time = [dict[@"time"] integerValue];
//    }
//    
//    return self;
//}

+ (instancetype)questionWithDict:(NSDictionary *)dict
{
//    return [[self alloc] initWithDict:dict];
    SMVideoQuestion *question = [[SMVideoQuestion alloc] init];
    [question setValuesForKeysWithDictionary:dict];
    return question;
}

@end
