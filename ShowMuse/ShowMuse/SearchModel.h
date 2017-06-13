//
//  SearchModel.h
//  ShowMuse
//
//  Created by show zh on 16/5/30.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

/**
 *  课程id
 */
@property (nonatomic) int ID;
/**
 *  课程名称
 */
@property (nonatomic,copy) NSString * title;
/**
 *  图片链接
 */
@property (nonatomic,copy) NSString * thumb;
/**
 *  视频时间
 */
@property (nonatomic,copy) NSString * videoDurationTime;
/**
 *  大师名字
 */
@property (nonatomic,copy) NSString * teacher_name;
/**
 *  大师头像
 */
@property (nonatomic,copy) NSString * teacher_avatar;
/**
 *  大师id
 */
@property (nonatomic) int teacher_ID;
/**
 *  观看人数
 */
@property (nonatomic) int viewsTotal;
/**
 *  点赞人数
 */
@property (nonatomic) int likesTotal;
/**
 *  评论人数
 */
@property (nonatomic) int commentsTotal;
/**
 *  用户是否会员
 */
@property (nonatomic) BOOL premium;
/**
 *  用户是否可以观看
 */
@property (nonatomic) BOOL isLockedToUser;
/**
 *  是否是新视频
 */
@property (nonatomic) BOOL isNew;

@property (nonatomic) int watchProgress;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
