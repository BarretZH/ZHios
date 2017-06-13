//
//  SMLesson.h
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YGTeacherCourse, SMRelatedCourse, SMRelatedProduct, SMRelatedMaterial, SMWatchState, SMVideoQuestion;

@interface SMLesson : NSObject

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *introduction;

@property (nonatomic,assign, getter=isPremium) BOOL premium;

@property (nonatomic,assign, getter=isLockToUser) BOOL lockedToUser;

@property (nonatomic,copy) NSString *thumb;

@property (nonatomic,assign) NSInteger viewsTotal;

@property (nonatomic,assign) NSInteger likesTotal;

@property (nonatomic,assign) NSInteger commentsTotal;

@property (nonatomic,copy) NSString *commentsThreadId;

@property (nonatomic,copy) NSString *videoType;

@property (nonatomic,copy) NSString *videoSource;

@property (nonatomic,copy) NSString *videoUrl;

@property (nonatomic,copy) NSString *videoContent;

@property (nonatomic,assign) CGFloat videoDuration;

@property (nonatomic,copy) NSString *videoDurationTime;

@property (nonatomic,copy) NSString *shareUrl;

@property (nonatomic,copy) NSString *shareImg;
/** teacher model */
@property (strong, nonatomic) YGTeacherCourse *teacherModel;
/** save all tags */
@property (strong, nonatomic) NSMutableArray *relatedCourseArr;
/** save all related products */
@property (strong, nonatomic) NSMutableArray *relatedProductArr;
/** save all related materials */
@property (strong, nonatomic) NSMutableArray *relatedMaterialArr;
/** watchState model */
@property (strong, nonatomic) SMWatchState *watchStatModel;

@property (nonatomic,assign, getter=isLikedByUser) BOOL likedByUser;
/** save all videoQuestion models */
@property (strong, nonatomic) NSMutableArray *videoQuestionArr;

@property (nonatomic,copy) NSString *subtitle;

/** calculate introduction's text height */
@property (nonatomic,assign, readonly) CGFloat introLabelH;

+ (instancetype)lessonWithDict:(NSDictionary *)dict;



@end
