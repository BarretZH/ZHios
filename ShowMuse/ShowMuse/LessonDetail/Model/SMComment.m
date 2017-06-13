//
//  SMComment.m
//  ShowMuse
//
//  Created by 刘勇刚 on 9/17/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMComment.h"
#import "SMCommentThread.h"
#import "SMDetailComment.h"

@implementation SMComment

- (NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray array];
    }
    return _commentsArr;
}

+ (instancetype)commentWithDict:(NSDictionary *)dict
{
    SMComment *comment = [[super alloc] init];
    comment.thread = [SMCommentThread threadWithDict:dict[@"thread"]];
    [dict[@"comments"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [comment.commentsArr addObject:[SMDetailComment deltailCommentWithDict:obj]];
    }];
    return comment;
}

@end
