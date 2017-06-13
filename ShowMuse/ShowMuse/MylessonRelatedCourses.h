//
//  MylessonRelatedCourses.h
//  ShowMuse
//
//  Created by show zh on 16/5/20.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MylessonRelatedCourses : NSObject


@property (nonatomic,copy) NSString * title;

@property (nonatomic) int ID;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
