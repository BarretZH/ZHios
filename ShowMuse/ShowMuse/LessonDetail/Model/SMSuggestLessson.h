//
//  SMSuggestLessson.h
//  ShowMuse
//
//  Created by ygliu on 9/14/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSuggestLessson : NSObject

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign, getter=isPremium) BOOL premium;

@property (nonatomic,assign, getter=isLockedToUser) BOOL lockedToUser;

@property (nonatomic,copy) NSString *thumb;

@property (nonatomic,assign) NSInteger viewsTotal;

@property (nonatomic,assign) NSInteger likesTotal;

@property (nonatomic,assign) NSInteger commentsTotal;

@property (nonatomic,assign, getter=isNewLesson) BOOL newLesson;

@property (nonatomic,copy) NSString *videoDurationTime;

+(instancetype)sugLessonWithDict:(NSDictionary *)dict;

@end
