//
//  SMCommentThread.m
//  ShowMuse
//
//  Created by 刘勇刚 on 9/17/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMCommentThread.h"

@implementation SMCommentThread

+ (instancetype)threadWithDict:(NSDictionary *)dict
{
    SMCommentThread *thread = [[self alloc] init];
    thread.ID = [dict[@"id"] integerValue];
    thread.commentable = [dict[@"isCommentable"] boolValue];
    thread.numComments = [dict[@"numComments"] integerValue];
    thread.lastCommentAt = dict[@"lastCommentAt"];
    thread.permalink = dict[@"permalink"];
    return thread;
}

@end
