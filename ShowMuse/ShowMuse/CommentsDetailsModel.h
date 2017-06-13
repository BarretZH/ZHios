//
//  CommentsDetailsModel.h
//  ShowMuse
//
//  Created by show zh on 16/5/18.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsDetailsModel : NSObject


@property (nonatomic,copy) NSString   * body, * createdAt, * user_name, * user_avatar;
@property (nonatomic) int state, ID, user_ID;


-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
