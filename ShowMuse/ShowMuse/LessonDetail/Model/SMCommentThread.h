//
//  SMCommentThread.h
//  ShowMuse
//
//  Created by 刘勇刚 on 9/17/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCommentThread : NSObject

@property (assign, nonatomic) NSInteger ID;

@property (assign, nonatomic, getter=isCommentable) BOOL commentable;

@property (assign, nonatomic) NSInteger numComments;

@property (copy, nonatomic) NSString *lastCommentAt;

@property (copy, nonatomic) NSString *permalink;

+ (instancetype)threadWithDict:(NSDictionary *)dict;

@end
