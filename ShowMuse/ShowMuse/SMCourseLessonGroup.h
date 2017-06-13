//
//  SMCourseLessonGroup.h
//  ShowMuse
//
//  Created by liuyonggang on 8/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCourseLessonGroup : NSObject
/** 课程ID */
@property (assign, nonatomic) NSInteger ID;
/** 课程图片 */
@property (copy, nonatomic) NSString *thumb;
/** 课程标题 */
@property (copy, nonatomic) NSString *title;
/** 保存课程包字典 */
@property (strong, nonatomic) NSMutableArray *lessonsArr;

/** 保存转换后的模型 */
@property (strong, nonatomic) NSMutableArray *lessonModelsArr;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)groupWithDict:(NSDictionary *)dict;

@end
