//
//  SMRelatedLessonCell.h
//  ShowMuse
//
//  Created by ygliu on 9/15/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMSuggestLessson;

@interface SMRelatedLessonCell : UICollectionViewCell

@property (strong, nonatomic) SMSuggestLessson *sugLesson;

@end

@interface SMRelatedLessonButton : UIButton

@end