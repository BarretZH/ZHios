//
//  SMComment.h
//  ShowMuse
//
//  Created by 刘勇刚 on 9/17/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMCommentThread;

@interface SMComment : NSObject

@property (strong, nonatomic) SMCommentThread *thread;

@property (strong, nonatomic) NSMutableArray *commentsArr;

+ (instancetype)commentWithDict:(NSDictionary *)dict;

@end
