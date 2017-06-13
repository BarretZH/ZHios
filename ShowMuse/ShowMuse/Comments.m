//
//  Comments.m
//  ShowMuse
//
//  Created by show zh on 16/5/18.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "Comments.h"

#import "CommentsDetailsModel.h"

@implementation Comments

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        NSDictionary * threadDic = dic[@"thread"];
        self.thread_id = [threadDic[@"id"] intValue];
        self.thread_lastCommentAt = threadDic[@"lastCommentAt"];
        self.thread_permalink = threadDic[@"permalink"];
        self.thread_numComments = [threadDic[@"numComments"] intValue];
        self.thread_isCommentable = [threadDic[@"isCommentable"] boolValue];
        self.comments = dic[@"comments"];
        self.commentsArray = [[NSMutableArray alloc] initWithCapacity:0];
        if (self.comments.count > 0) {
            [self.comments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CommentsDetailsModel * commentsModel = [[CommentsDetailsModel alloc] initWithDictionary:obj];
                [self.commentsArray addObject:commentsModel];
            }];
        }
    }
    return self;
}



@end
