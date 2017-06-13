//
//  SMDetailComment.h
//  ShowMuse
//
//  Created by 刘勇刚 on 9/17/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDetailComment : NSObject

@property (assign, nonatomic) NSInteger ID;

@property (copy, nonatomic) NSString *body;

@property (copy, nonatomic) NSString *createdAt;

@property (assign, nonatomic) NSInteger state;

@property (assign, nonatomic) NSInteger userId;

@property (copy, nonatomic) NSString *userName;

@property (copy, nonatomic) NSString *userAvatar;


@property (assign, nonatomic) BOOL isReply;

@property (assign, nonatomic) NSInteger children_ID;

@property (copy, nonatomic) NSString *children_body;

@property (copy, nonatomic) NSString *children_createdAt;

@property (assign, nonatomic) NSInteger children_state;

@property (assign, nonatomic) NSInteger children_userId;

@property (copy, nonatomic) NSString *children_userName;

@property (copy, nonatomic) NSString *children_userAvatar;


/** calculate text height */
@property (nonatomic, assign, readonly) CGFloat bodyLabelH;

@property (nonatomic, assign, readonly) CGFloat children_bodyLabelH;

+ (instancetype)deltailCommentWithDict:(NSDictionary *)dict;

@end
