//
//  MyQusetionModel.h
//  ShowMuse
//
//  Created by show zh on 16/5/20.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyQusetionModel : NSObject

@property (nonatomic,copy) NSString * title, * thumb, * videoDurationTime, * teacher_name, * teacher_avatar, *teacher_coverImg;

@property (nonatomic) int ID, viewsTotal, likesTotal, commentsTotal, videoWatchProgress, teacher_id, progress, watchProgress;

@property (nonatomic)BOOL premium, isLockedToUser, isNew;

@property (nonatomic,strong) NSArray * relatedCourses;

@property (nonatomic,strong) NSMutableArray * relatedCoursesArray;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
