//
//  SMSingleton.h
//  ShowMuse
//
//  Created by ygliu on 7/22/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//


#define SMSingletonH(name) + (instancetype)shared##name;


#define SMSingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _instance; \
}