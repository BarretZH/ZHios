//
//  SMDetailComment.m
//  ShowMuse
//
//  Created by 刘勇刚 on 9/17/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMDetailComment.h"

@interface SMDetailComment ()
{
    CGFloat _bodyLabelH;
    CGFloat _children_bodyLabelH;
}

@end

@implementation SMDetailComment

- (CGFloat)bodyLabelH
{
    if (!_bodyLabelH) {
        _bodyLabelH = [self.body boundingRectWithSize:CGSizeMake(SMScreenWidth - 64 - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0]} context:nil].size.height;
    }
    return _bodyLabelH;
}

- (CGFloat)children_bodyLabelH {
    if (!_children_bodyLabelH) {
        _children_bodyLabelH = [self.children_body boundingRectWithSize:CGSizeMake(SMScreenWidth - 64 - 15-45-15-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0]} context:nil].size.height;
    }
    return _children_bodyLabelH;
}

+ (instancetype)deltailCommentWithDict:(NSDictionary *)dict
{
    NSDictionary * commentDic = dict[@"comment"];
    NSArray * childrenArr = dict[@"children"];
    SMLog(@"---->%ld",(unsigned long)childrenArr.count);
    SMDetailComment *deltailComment = [[super alloc] init];
    deltailComment.ID = [commentDic[@"id"] integerValue];
    deltailComment.body = commentDic[@"body"];
    deltailComment.createdAt = commentDic[@"createdAt"];
    deltailComment.state = [commentDic[@"state"] integerValue];
    deltailComment.userId = [commentDic[@"user"][@"id"] integerValue];
    deltailComment.userName = commentDic[@"user"][@"name"];
    deltailComment.userAvatar = commentDic[@"user"][@"avatar"];
    if (childrenArr.count>0) {
        deltailComment.isReply = YES;
        NSDictionary * childrenDic = childrenArr[0][@"comment"];
        deltailComment.children_ID = [childrenDic[@"id"] integerValue];
        deltailComment.children_body = childrenDic[@"body"];
        deltailComment.children_createdAt = childrenDic[@"createdAt"];
        deltailComment.children_state = [childrenDic[@"state"] integerValue];
        deltailComment.children_userId = [childrenDic[@"user"][@"id"] integerValue];
        deltailComment.children_userName = childrenDic[@"user"][@"name"];
        deltailComment.children_userAvatar = childrenDic[@"user"][@"avatar"];
    }else {
        deltailComment.isReply = NO;
    }
    return deltailComment;
}

@end
