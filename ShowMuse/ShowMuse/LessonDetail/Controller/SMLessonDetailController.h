//
//  SMLessonDetailController.h
//  ShowMuse
//
//  Created by 刘勇刚 on 9/12/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMLesson, SMWatchState, SMVideoQuestion, SMSuggestLessson, SMComment, SMSubtitle;

@interface SMLessonDetailController : UIViewController

@property (copy, nonatomic) NSString *lessonID;
@property (copy, nonatomic) NSString *filePath;
@property (assign, nonatomic, getter=isLocalVideo) BOOL localVideo;
/** lesson model */
@property (strong, nonatomic) SMLesson *lesson;
/** watchState model */
@property (strong, nonatomic) SMWatchState *watchState;
/** question model */
@property (strong, nonatomic) SMVideoQuestion *question;
/** comment model */
@property (strong, nonatomic) SMComment *comment;
/** save all suggestion lessons */
@property (strong, nonatomic) NSMutableArray *suggestLessonArr;

@end
