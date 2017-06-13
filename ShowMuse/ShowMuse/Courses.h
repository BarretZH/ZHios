//
//  Courses.h
//  ShowMuse
//
//  Created by show zh on 16/5/10.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Courses : NSObject
/** ID */
@property (nonatomic,copy) NSString *ID;
/** 标题 */
@property (copy, nonatomic) NSString *title;
/** 介绍 */
@property (copy, nonatomic) NSString *introduction;
/** 图片 */
@property (copy, nonatomic) NSString *coverImg;
/** 是否新 */
@property (nonatomic, assign) BOOL isNew;
/** 标签的标题 */
@property (copy, nonatomic) NSString *isNewTitle;
/** 热度标签的标题 */
@property (copy, nonatomic) NSString *totalStudentsTitle;

@property (nonatomic,copy) NSMutableArray *lessonGroups;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)courseWithDict:(NSDictionary *)dict;



@end
