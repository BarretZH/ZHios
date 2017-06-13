//
//  LessonSuggested.h
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonSuggested : NSObject

@property (strong, nonatomic)NSString * title, * thumb;

@property (nonatomic) BOOL premium, isLockedToUser;

@property (nonatomic) int ID;
-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
