//
//  YGVideoCell.h
//  ShowMusePlanB
//
//  Created by liuyonggang on 16/5/2016.
//  Copyright © 2016 liuyonggang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YGCourseList;

@interface YGVideoCell : UICollectionViewCell

/** 课程列表模型 */
@property (strong, nonatomic) YGCourseList *course;

@end
