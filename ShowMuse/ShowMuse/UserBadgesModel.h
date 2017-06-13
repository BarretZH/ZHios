//
//  UserBadgesModel.h
//  ShowMuse
//
//  Created by show zh on 16/5/30.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBadgesModel : NSObject

/**
 *  徽章的名字
 */
@property (nonatomic,copy) NSString * name;

/**
 *  徽章ID
 */
@property (nonatomic) int ID;
/**
 *  课程ID
 */
@property (nonatomic) int courseID;
/**
 *  大师ID
 */
@property (nonatomic) int teacherID;
/**
 *  提示内容
 */
@property (nonatomic,copy) NSString * descriptionStr;
/**
 *  徽章图片地址
 */
@property (nonatomic,copy) NSString * img;
/**
 *  完成度
 */
@property (nonatomic) int progress;
/**
 *  按钮标题
 */
@property (nonatomic,copy) NSString * progressTitle;
/**
 *  是否完成
 */
@property (nonatomic)BOOL isFinished;
/**
 *  领取奖品的URL
 */
@property (nonatomic,copy) NSString * gotoUrl;
/**
 *  web的标题
 */
@property (nonatomic,copy) NSString *gotoUrlTitle;

@property (nonatomic,copy) NSString *progressDescription;
/** 弹框按钮标题 */
@property (nonatomic,copy) NSString *progressPopupBtnTitle;


-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
