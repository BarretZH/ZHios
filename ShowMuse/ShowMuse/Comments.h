//
//  Comments.h
//  ShowMuse
//
//  Created by show zh on 16/5/18.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comments : NSObject

@property (nonatomic,strong) NSArray * comments;
@property (nonatomic,strong) NSMutableArray * commentsArray;

@property (nonatomic,copy) NSString  *thread_lastCommentAt, *thread_permalink;
@property (nonatomic) BOOL thread_isCommentable;
@property (nonatomic) int thread_numComments, thread_id;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
