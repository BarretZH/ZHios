//
//  DetailsNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeLessonDetails)(id json, NSError* error);

@interface DetailsNetWork : NSObject

//课程详情
+(void)lessoDetailsWithLessonID:(NSString *)lessonID CompleteLessonDetails:(completeLessonDetails)complete;

//相关课程
+(void)lessonSuggestedwithLessonID:(NSString *)lessonID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails;

+(void)lessonLikeLessonID:(NSString *)lessonID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails;

+(void)lessonDelLikeLessonID:(NSString *)lessonID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails ;

//评论请求
+(void)commentsWithCommentsID:(NSString *)ID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails;

//发送评论
+(void)sendCommentsWithMessage:(NSString *)Str CommentsID:(NSString *)ID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails;

//分享回调
+(void)shareWithStatus:(NSString *)status platform:(NSString *)platform lessonID:(NSString *)lessonID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails;
@end
