//
//  SMLesson.m
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMLesson.h"
#import "YGTeacherCourse.h"
#import "SMRelatedCourse.h"
#import "SMRelatedMaterial.h"
#import "SMWatchState.h"
#import "SMVideoQuestion.h"
#import "SMRelatedProduct.h"

@interface SMLesson ()
{
    CGFloat _introLabelH;
}

@end

@implementation SMLesson
#pragma mark - lazy
- (NSMutableArray *)relatedCourseArr
{
    if (!_relatedCourseArr) {
        _relatedCourseArr = [NSMutableArray array];
    }
    return _relatedCourseArr;
}

- (NSMutableArray *)relatedProductArr
{
    if (!_relatedProductArr) {
        _relatedProductArr = [NSMutableArray array];
    }
    return _relatedProductArr;
}

- (NSMutableArray *)relatedMaterialArr
{
    if (!_relatedMaterialArr) {
        _relatedMaterialArr = [NSMutableArray array];
    }
    return _relatedMaterialArr;
}

- (NSMutableArray *)videoQuestionArr
{
    if (!_videoQuestionArr) {
        _videoQuestionArr = [NSMutableArray array];
    }
    return _videoQuestionArr;
}

- (CGFloat)introLabelH
{
    if (!_introLabelH) {
        _introLabelH = [self.introduction boundingRectWithSize:CGSizeMake(SMScreenWidth * 0.8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil].size.height;
    }
    return _introLabelH;
}

#pragma mark - factory method
+ (instancetype)lessonWithDict:(NSDictionary *)dict
{
    SMLesson *lesson = [[self alloc] init];
    [lesson setValuesForKeysWithDictionary:dict];
    return lesson;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"isLockedToUser"]) {
        self.lockedToUser = [value boolValue];
    } else if ([key isEqualToString:@"isLikedByUser"]) {
        self.likedByUser = [value boolValue];
    } else if ([key isEqualToString:@"teacher"]) {
        self.teacherModel = [YGTeacherCourse courseWithDict:value];
    } else if ([key isEqualToString:@"relatedCourses"]) {
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.relatedCourseArr addObject:[SMRelatedCourse relatedCourseWithDict:obj]];
        }];
    } else if ([key isEqualToString:@"relatedMaterials"]) {
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.relatedMaterialArr addObject:[SMRelatedMaterial materialWithDict:obj]];
        }];
    } else if ([key isEqualToString:@"userWatchStat"]) {
        self.watchStatModel = [SMWatchState stateWithDict:value];
    } else if ([key isEqualToString:@"videoQuestions"]) {
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.videoQuestionArr addObject:[SMVideoQuestion questionWithDict:obj]];
        }];
    } else if ([key isEqualToString:@"relatedProducts"]) {
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.relatedProductArr addObject:[SMRelatedProduct productWithDict:obj]];
        }];
    } else if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    }
}

@end
