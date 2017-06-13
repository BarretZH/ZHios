//
//  LessonModel.h
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonModel : NSObject

@property (nonatomic,copy) NSString  * title, * introduction, * thumb, * videoUrl, *videoDurationTime, * shareUrl, * teacher_name, * teacher_avatar, * teacher_coverImg, * commentsThread_id, *shareImg, *videoContent;

@property (nonatomic) int viewsTotal, likesTotal, commentsTotal, videoWatchProgress, videoPlayPosition, teacher_id, ID, commentsThread_commentsTotal;

@property (nonatomic) float videoDuration;

@property (nonatomic)BOOL premium, isLockedToUser, commentsThread_isCommentable, isLikedByUser;

@property (nonatomic,strong) NSArray * relatedCourses, *relatedProducts, *relatedMaterials;

@property (nonatomic,strong) NSMutableArray * relatedCoursesArray, * relatedProductsArray, * relatedMaterialsArray;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

/** 视频的播放来源 */
@property (nonatomic,copy) NSString  *videoSource;

@end
