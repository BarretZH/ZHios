//
//  LessonModel.m
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "LessonModel.h"

#import "RelatedCoursesModel.h"

#import "RelatedProductsModel.h"

#import "Materials.h"

@implementation LessonModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.ID = [dic[@"id"] intValue];
        self.title = dic[@"title"];
        self.introduction = dic[@"introduction"];
        self.premium = [dic[@"premium"] boolValue];
        self.isLockedToUser = [dic[@"isLockedToUser"] boolValue];
        self.thumb = dic[@"thumb"];
        self.shareImg = dic[@"shareImg"];
        self.viewsTotal = [dic[@"viewsTotal"] intValue];
        self.likesTotal = [dic[@"likesTotal"] intValue];
        self.commentsTotal = [dic[@"commentsTotal"] intValue];
        self.videoWatchProgress = [dic[@"videoWatchProgress"] intValue];
        self.videoPlayPosition = [dic[@"videoPlayPosition"] intValue];
        self.videoUrl = dic[@"videoUrl"];
        self.videoSource = dic[@"videoSource"];
        self.videoContent = dic[@"videoContent"];
        if (![dic[@"videoDuration"] isEqual:[NSNull null]]) {
            self.videoDuration = [dic[@"videoDuration"] floatValue];
        }
        
        self.videoDurationTime = dic[@"videoDurationTime"];
        self.shareUrl = dic[@"shareUrl"];
        if (![dic[@"teacher"] isEqual:[NSNull null]]) {
            self.teacher_id = [dic[@"teacher"][@"id"] intValue];
            self.teacher_name = dic[@"teacher"][@"name"];
            self.teacher_avatar = dic[@"teacher"][@"avatar"];
            self.teacher_coverImg = dic[@"teacher"][@"coverImg"];
        }
        self.relatedCourses = dic[@"relatedCourses"];
        self.relatedCoursesArray = [[NSMutableArray alloc] initWithCapacity:0];
        if (self.relatedCourses.count > 0) {
            [self.relatedCourses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                RelatedCoursesModel * RCmodel = [[RelatedCoursesModel alloc] initWithDictionary:obj];
                [self.relatedCoursesArray addObject:RCmodel];
            }];
        }
        self.relatedProducts = dic[@"relatedProducts"];
        self.relatedProductsArray = [[NSMutableArray alloc] initWithCapacity:0];
        if (self.relatedProducts.count > 0) {
            [self.relatedProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                RelatedProductsModel * RPmodel = [[RelatedProductsModel alloc] initWithDictionary:obj];
                [self.relatedProductsArray addObject:RPmodel];
            }];
            
        }
        self.relatedMaterials = dic[@"relatedMaterials"];
        self.relatedMaterialsArray = [[NSMutableArray alloc] initWithCapacity:0];
        if (self.relatedMaterials.count > 0) {
            [self.relatedMaterials enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Materials * materials = [[Materials alloc] initWithDictionary:obj];
                [self.relatedMaterialsArray addObject:materials];
            }];
        }
        self.isLikedByUser = [dic[@"isLikedByUser"] boolValue];
        self.commentsThread_id = dic[@"commentsThreadId"];
//        self.commentsThread_isCommentable = [dic[@"commentsThread"][@"isCommentable"] boolValue];
        self.commentsThread_commentsTotal = [dic[@"commentsTotal"] intValue];
    }
    return self;
}




@end
